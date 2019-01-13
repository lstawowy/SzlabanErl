%%%-------------------------------------------------------------------
%%% @author lukasz
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. gru 2018 01:30
%%%-------------------------------------------------------------------
-module(manager).
-author("lukasz").

%% API
-export([initManager/1, handleBarrierStates/1]).

initManager(WxEnv) ->
  PID = spawn(?MODULE, handleBarrierStates, [WxEnv]),
  PID.

handleBarrierStates(WxEnv) ->
  io:format("DEBUG: Manager PID = <~p> ~n", [self()]),
  wx:set_env(WxEnv),
  receive
    {_, new} ->
      ets:new(my_table, [named_table, set]),
      ets:insert(my_table, {state, 'Up'}),
      handleBarrierStates(WxEnv);
    {SenderID, get} ->
      io:format("Manager received get barrier state request ~n"),
      CurrentState = getBarrierState(),
      SenderID ! {get, CurrentState},
      handleBarrierStates(WxEnv);
    {SenderID, set, Frame, 'Up'} ->
      io:format("Manager received set barrier state request with state: Up ~n"),
      ets:delete_all_objects(my_table),
      ets:insert(my_table, {state, 'RunningUp'}),
      io:format("Barrier changing state ~n"),
      barrierView:drawBarrier(Frame, 'RunningUp'),
      timer:sleep(5000),
      ets:insert(my_table, {state, 'Up'}),
      SenderID ! {set, Frame, ok},
      handleBarrierStates(WxEnv);
    {SenderID, set, Frame, 'Down'} ->
      io:format("Manager received set barrier state request with state: Down ~n"),
      ets:insert(my_table, {state, 'RunningDown'}),
      io:format("Barrier changing state ~n"),
      barrierView:drawBarrier(Frame, 'RunningDown'),
      timer:sleep(5000),
      ets:insert(my_table, {state, 'Down'}),
      SenderID ! {set, Frame, ok},
      handleBarrierStates(WxEnv);
    {SenderID, keep, Time} ->
      io:format("Manager received keep barrier state request ~n"),
      timer:sleep(Time),
      SenderID ! {keep, ok},
      handleBarrierStates(WxEnv)
  end.

getBarrierState() ->
  [{_, CurrentState}] = ets:lookup(my_table, state),
  io:format("Barrier currently in state ~s ~n", [CurrentState]),
  CurrentState.



