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
  Time_train_come = 10000,
  Time_train_rest = 1000,
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
    {SenderID, set, Frame, 'Initial'} ->
      io:format("Manager received set barrier state request with state: Initial(Up) ~n"),
      ets:delete_all_objects(my_table),
      ets:insert(my_table, {state, 'Up'}),
      barrierView:drawBarrier(Frame, 'Initial'),
      SenderID ! {set, Frame, ok},
      handleBarrierStates(WxEnv);
    {SenderID, set, Frame, 'Up'} ->
      io:format("Manager received set barrier state request with state: Up ~n"),
      CurrentState = getBarrierState(),
      if
        CurrentState == 'Up' -> io:format("Barrier already in state: Up ~n"),
          handleBarrierStates(WxEnv);
        true -> Frame = handleRequest(Frame, 'RunningUp', 'Up'),
          SenderID ! {set, Frame, ok},
          handleBarrierStates(WxEnv)
      end;
    {SenderID, set, Frame, 'Down'} ->
      io:format("Manager received set barrier state request with state: Down ~n"),
      CurrentState = getBarrierState(),
      if
        CurrentState == 'Down' -> io:format("Barrier already in state: Down ~n"),
          handleBarrierStates(WxEnv);
        true -> Frame = handleRequest(Frame, 'RunningDown', 'Down'),
          SenderID ! {set, Frame, ok},
          handleBarrierStates(WxEnv)
      end;
    {SenderID, random_train, Frame} ->
      io:format("Manager received random train request ~n"),
      Frame = handleRequest(Frame, 'RunningDown', 'Down'),
      timer:sleep(Time_train_come),
      barrierView:drawBarrier(Frame, 'TrainComming'),
      timer:sleep(Time_train_rest),
      Frame = handleRequest(Frame, 'RunningUp', 'Up'),
      SenderID ! {random_train, ok},
      handleBarrierStates(WxEnv)
  end.

handleRequest(Frame, RunningState, State) ->
  ets:delete_all_objects(my_table),
  ets:insert(my_table, {state, RunningState}),
  io:format("Barrier changing state ~n"),
  barrierView:drawBarrier(Frame, RunningState),
  ets:delete_all_objects(my_table),
  ets:insert(my_table, {state, State}),
  barrierView:drawBarrier(Frame, State),
  Frame.

getBarrierState() ->
  [{_, CurrentState}] = ets:lookup(my_table, state),
  io:format("Barrier currently in state ~s ~n", [CurrentState]),
  CurrentState.



