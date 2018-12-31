%%%-------------------------------------------------------------------
%%% @author lukasz
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. gru 2018 01:04
%%%-------------------------------------------------------------------
-module('MainApplication').
-author("lukasz").


%% API
-export([initMenu/0]).


initMenu() ->
  'GuiMenu':init().

manulBarrierUp() ->
  'GuiMenu':barrierUp(Frame).

manulBarrierDown() ->
  'GuiMenu':barrierDown(Frame).

randomTrainComming() ->
  manulBarrierDown(),
  timer:sleep(3000), %% Sleep for 3s.
  manulBarrierUp().

