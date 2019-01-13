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
  {DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush} = setUpDC(Frame),
  drawEnvironment(DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush),
  case (State) of
    'Initial' ->
      {DC, Frame} = drawBarrierUp(DC, RedBrush, WhiteBrush, Frame);
    'Up' ->
      {DC, Frame} = drawBarrierUp(DC, RedBrush, WhiteBrush, Frame);
    'Down' ->
      {DC, Frame} = drawBarrierDown(DC, RedBrush, WhiteBrush, Frame);
    'RunningUp' ->
      RedStripedPen = wxPen:new({255, 0, 0}, [{width, 10}, {style, 105}]),
      wxDC:setPen(DC, RedStripedPen),
      wxDC:drawLine(DC, {340, 190}, {615, 315}),
      timer:sleep(1333),
      drawEnvironment(DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush),
      wxDC:setPen(DC, RedStripedPen),
      wxDC:drawLine(DC, {460, 90}, {615, 315}),
      timer:sleep(1333),
      drawEnvironment(DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush),
      wxDC:setPen(DC, BlackSolidPen),
      wxFrame:show(Frame),
      timer:sleep(100);
    'RunningDown' ->
      RedStripedPen = wxPen:new({255, 0, 0}, [{width, 10}, {style, 105}]),
      wxDC:setPen(DC, RedStripedPen),
      wxDC:drawLine(DC, {460, 90}, {615, 315}),
      timer:sleep(1333),
      drawEnvironment(DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush),
      wxDC:setPen(DC, RedStripedPen),
      wxDC:drawLine(DC, {340, 190}, {615, 315}),
      timer:sleep(1333),
      drawEnvironment(DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush),
      wxDC:setPen(DC, BlackSolidPen),
      wxFrame:show(Frame),
      timer:sleep(100);
    'TrainComming' ->
      {DC, Frame} = drawBarrierDown(DC, RedBrush, WhiteBrush, Frame),
      BlueBrush = wxBrush:new({0, 0, 255}, [{style, 100}]),
      wxDC:setBrush(DC, BlueBrush),
      wxDC:drawRectangle(DC, {20, 40}, {180, 120}),
      wxFrame:show(Frame),
      timer:sleep(1333),

      drawEnvironment(DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush),
      {DC, Frame} = drawBarrierDown(DC, RedBrush, WhiteBrush, Frame),
      wxDC:setBrush(DC, BlueBrush),
      wxDC:drawRectangle(DC, {200, 40}, {180, 120}),
      wxFrame:show(Frame),
      timer:sleep(1333),

      drawEnvironment(DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush),
      {DC, Frame} = drawBarrierDown(DC, RedBrush, WhiteBrush, Frame),
      wxDC:setBrush(DC, BlueBrush),
      wxDC:drawRectangle(DC, {380, 40}, {180, 120}),
      wxFrame:show(Frame),
      timer:sleep(1333),

      drawEnvironment(DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush),
      {DC, Frame} = drawBarrierDown(DC, RedBrush, WhiteBrush, Frame),
      wxDC:setBrush(DC, BlueBrush),
      wxDC:drawRectangle(DC, {560, 40}, {180, 120}),
      wxFrame:show(Frame),
      timer:sleep(1333)
  end,
  Frame.

drawBarrierDown(DC, RedBrush, WhiteBrush, Frame) ->
  wxDC:setBrush(DC, RedBrush),
  wxDC:drawRectangle(DC, {520, 300, 100, 15}),
  wxDC:drawRectangle(DC, {320, 300, 100, 15}),
  wxDC:setBrush(DC, WhiteBrush),
  wxDC:drawRectangle(DC, {420, 300, 100, 15}),
  wxFrame:show(Frame),
  timer:sleep(100),
  {DC, Frame}.

drawBarrierUp(DC, RedBrush, WhiteBrush, Frame) ->
  wxDC:setBrush(DC, RedBrush),
  wxDC:drawRectangle(DC, {605, 20, 15, 100}),
  wxDC:drawRectangle(DC, {605, 220, 15, 100}),
  wxDC:setBrush(DC, WhiteBrush),
  wxDC:drawRectangle(DC, {605, 120, 15, 100}),
  wxFrame:show(Frame),
  timer:sleep(100),
  {DC, Frame}.

setUpDC(Frame) ->
  DC = wxWindowDC:new(Frame),
  BlackSolidPen = wxPen:new({0, 0, 0}, [{width, 3}, {style, 100}]),
  wxDC:setPen(DC, BlackSolidPen),
  GrayBrush = wxBrush:new({192, 192, 192}, [{style, 100}]),
  RedBrush = wxBrush:new({255, 0, 0}, [{style, 100}]),
  WhiteBrush = wxBrush:new({255, 255, 255}, [{style, 100}]),
  BlackBrush = wxBrush:new({0, 0, 0}, [{style, 100}]),
  {DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush}.

drawEnvironment(DC, GrayBrush, RedBrush, BlackSolidPen, WhiteBrush, BlackBrush) ->
  wxWindowDC:clear(DC),
  wxDC:setPen(DC, BlackSolidPen),
  wxDC:setBrush(DC, GrayBrush),
  wxDC:drawRectangle(DC, {220, 20, 250, 480}),
  wxDC:setBrush(DC, BlackBrush),
  wxDC:drawRectangle(DC, {20, 40, 760, 4}),
  wxDC:drawRectangle(DC, {20, 160, 760, 4}),
  wxDC:setBrush(DC, RedBrush),
  wxDC:drawRectangle(DC, {600, 200, 70, 70}),
  wxDC:drawRectangle(DC, {620, 330, 30, 80}),
  wxDC:setBrush(DC, WhiteBrush),
  wxDC:drawRectangle(DC, {620, 270, 30, 60}),
  wxDC:drawRectangle(DC, {620, 410, 30, 80}),
  WhiteStripedPen = wxPen:new({255, 255, 255}, [{width, 3}, {style, 102}]),
  wxDC:setPen(DC, WhiteStripedPen),
  wxDC:drawLine(DC, {345, 30}, {345, 490}),
  wxDC:setPen(DC, BlackSolidPen).

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
    throw -> io:fwrite("Received timeout - probably train is comming.")
  end.

handleRandomTrain(ManagerPID, Frame) ->
  io:format("Everyone watchout train is coming. ~n"),
  try
    managerHandleTrain(ManagerPID, Frame)
  catch
    throw -> io:fwrite("Received timeout - probably train is comming.")
  end.

managerSetBarrier(ManagerPID, Frame, State) ->
  ManagerPID ! {self(), set, Frame, State},
  receive
    {set, Frame, ok} ->
      io:format("DEBUG: Manager succesfully comunicated with barrierView. ~n")
  after 10000 -> throw(timeout)
  end,
  Frame.

managerHandleTrain(ManagerPID, Frame) ->
  ManagerPID ! {self(), random_train, Frame},
  receive
    {random_train, ok} ->
      io:format("DEBUG: Manager succesfully comunicated with barrierView. ~n")
  after 30000 -> throw(timeout)
  end.