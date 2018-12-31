%%%-------------------------------------------------------------------
%%% @author lukasz
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. gru 2018 01:30
%%%-------------------------------------------------------------------
-module('Manager').
-author("lukasz").

%% API
-export([]).

getBarrierState() ->
  'Up'.

%%States: Up, Down, Running?

setBarrierState(State) ->
  State.

