%%%-------------------------------------------------------------------
%%% @author lukasz
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. sty 2019 11:51
%%%-------------------------------------------------------------------
-module(barrierView).
-author("lukasz").

%% API
-export([drawBarrier/2, handleBarrierChange/3, handleRandomTrain/2]).

drawBarrier(Frame, State) ->
  DC = wxWindowDC:new(Frame),
  Pen = wxPen:new({255, 0, 0}, [{width, 3}, {style, 104}]),
  wxDC:setPen(DC, Pen),
  case (State) of
    'Initial' ->
      wxDC:drawLine(DC, {50, 70}, {150, 70}),
      wxDC:drawLine(DC, {150, 70}, {150, 100}),
      wxFrame:show(Frame);
    'Up' ->
      wxDC:drawLine(DC, {111, 70}, {150, 70}),
      wxDC:drawLine(DC, {150, 70}, {150, 100}),
      wxFrame:show(Frame);
    'Down' ->
      wxDC:drawLine(DC, {222, 70}, {150, 150}),
      wxDC:drawLine(DC, {150, 70}, {150, 100}),
      wxFrame:show(Frame);
    'RunningUp' ->
      wxDC:drawLine(DC, {333, 70}, {110, 110}),
      wxDC:drawLine(DC, {150, 70}, {150, 100}),
      wxFrame:show(Frame),
      timer:sleep(2000);
    'RunningDown' ->
      wxDC:drawLine(DC, {444, 70}, {110, 110}),
      wxDC:drawLine(DC, {150, 70}, {150, 100}),
      wxFrame:show(Frame),
      timer:sleep(2000)
  end,
  Frame.

handleBarrierChange(ManagerPID, Frame, State) ->
  io:format("called function handle barrier change ~n"),
  try
    case (State) of
      'Up' -> io:format("barrier up menu ~n"),
        Frame = managerSetBarrier(ManagerPID, Frame, 'Up');
      'Down' -> io:format("barrier down menu ~n"),
        Frame = managerSetBarrier(ManagerPID, Frame, 'Down')
    end
  catch
    throw -> "Received timeout - probably train is comming."
  end.

handleRandomTrain(ManagerPID, Frame) ->
  io:format("Everyone watchout train is coming. ~n"),
  try
    Frame = managerSetBarrier(ManagerPID, Frame, 'Down'),
    managerKeepBarrier(ManagerPID, 3000),
    Frame = managerSetBarrier(ManagerPID, Frame, 'Up')
  catch
    throw -> "Received timeout - probably train is comming."
  end.

managerSetBarrier(ManagerPID, Frame, State) ->
  ManagerPID ! {self(), set, Frame, State},
  receive
    {set, Frame, ok} ->
      io:format("DEBUG: Manager succesfully comunicated with barrierView. ~n")
  after 10000 -> throw(timeout)
  end,
  Frame.

managerKeepBarrier(ManagerPID, Time) ->
  ManagerPID ! {self(), keep, Time},
  receive
    {keep, ok} ->
      io:format("DEBUG: Manager succesfully comunicated with barrierView. ~n")
  after (Time + 10000) -> throw(timeout)
  end.