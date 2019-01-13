%%%-------------------------------------------------------------------
%%% @author lukasz
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. gru 2018 01:04
%%%-------------------------------------------------------------------

-module(mainApplication).
-author("lukasz").

%% API
-export([init/0, compileModules/0]).

init() ->
  compileModules(),
  guiMenu:initGui().

compileModules() ->
  io:format("Compile all the project modules to search for compilator problems ~n"),
  spawn(compile, file, [manager]),
  spawn(compile, file, [guiMenu]),
  spawn(compile, file, [barrierView]),
  spawn(compile, file, [mainApplication]).

