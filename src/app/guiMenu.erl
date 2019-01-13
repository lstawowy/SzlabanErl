%%%-------------------------------------------------------------------
%%% @author lukasz
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. gru 2018 00:04
%%%-------------------------------------------------------------------
-module(guiMenu).
-author("lukasz").

-include_lib("wx/include/wx.hrl").

%% API
-export([initGui/0, handleEvents/2]).

initGui() ->
  Wx = wx:new(),
  Frame = wxFrame:new(Wx, ?wxID_ANY, "Szlaban"),

  initStatusBar(Frame),
  createMenu(Frame),

  wxFrame:connect(Frame, close_window),
  wxFrame:connect(Frame, command_menu_selected),

  barrierView:drawBarrier(Frame, 'Initial'),
  WxEnv = wx:get_env(),
  ManagerPID = manager:initManager(WxEnv),
  ManagerPID ! {self(), new},
  try
    handleEvents(ManagerPID, Frame)
  catch
    throw -> "Thrown exception";
    exit -> "Exit encountered";
    error -> "Error encountered"
  end.

handleEvents(ManagerPID, Frame) ->
  receive
    #wx{event = #wxClose{type = close_window}} ->
      io:format("quit icon ~n"),
      wxFrame:destroy(Frame);
    #wx{id = 101, event = #wxCommand{type = command_menu_selected}} ->
      PID = spawn(barrierView, handleBarrierChange, [ManagerPID, Frame, 'Up']),
      io:format("PID of new process handle barrier change up <~p> ~n", [PID]),
      handleEvents(ManagerPID, Frame);
    #wx{id = 102, event = #wxCommand{type = command_menu_selected}} ->
      PID = spawn(barrierView, handleBarrierChange, [ManagerPID, Frame, 'Down']),
      io:format("PID of new process handle barrier change down <~p> ~n", [PID]),
      handleEvents(ManagerPID, Frame);
    #wx{id = 103, event = #wxCommand{type = command_menu_selected}} ->
      PID = spawn(barrierView, handleRandomTrain, [ManagerPID, Frame]),
      io:format("PID of new process handle random train <~p> ~n", [PID]),
      handleEvents(ManagerPID, Frame);
    #wx{id = 104, event = #wxCommand{type = command_menu_selected}} ->
      io:format("quit file menu ~n"),
      wxFrame:destroy(Frame);
    #wx{id = 200, event = #wxCommand{type = command_menu_selected}} ->
      io:format("about menu ~n"),
      handleAboutMenu(),
      handleEvents(ManagerPID, Frame)
  end.

initStatusBar(Frame) ->
  wxFrame:createStatusBar(Frame),
  wxFrame:setStatusText(Frame, "Projekt: Szlaban na przejezdzie kolejowym.").

createMenu(Frame) ->
  MenuBar = initMenu(),
  createFileMenu(MenuBar),
  createHelpMenu(MenuBar),
  wxFrame:setMenuBar(Frame, MenuBar).

initMenu() ->
  wxMenuBar:new().

createFileMenu(MenuBar) ->
  BarrierMenu = wxMenu:new([]),
  wxMenuBar:append(MenuBar, BarrierMenu, "&Barrier"),

  BarrierUp = wxMenuItem:new([{id, 101}, {text, "&Barrier Up"}]),
  BarrierDown = wxMenuItem:new([{id, 102}, {text, "&Barrier Down"}]),
  RandomTrain = wxMenuItem:new([{id, 103}, {text, "&RandomTrain"}]),
  Close = wxMenuItem:new([{id, 104}, {text, "&Close"}]),
  wxMenu:append(BarrierMenu, BarrierUp),
  wxMenu:append(BarrierMenu, BarrierDown),
  wxMenu:append(BarrierMenu, RandomTrain),
  wxMenu:append(BarrierMenu, Close).

createHelpMenu(MenuBar) ->
  HelpMn = wxMenu:new(),
  wxMenuBar:append(MenuBar, HelpMn, "&Help"),
  About = wxMenuItem:new([{id, 200}, {text, "About"}]),
  wxMenu:append(HelpMn, About).

handleAboutMenu() ->
  io:format("Program na zaliczenie przedmiotu 'Programowanie współbieżne i rozproszone' wykonany przez Lukasza Stawowego. ~n"),
  io:format("Dostepne sa funkcje: ~n"),
  io:format(" - barrier up = podniesienie bariery do gory ~n"),
  io:format(" - barrier down = opuszczenie bariery ~n"),
  io:format(" - random train comming = przyjazd pociagu po 10 sekundach, zablokowanie zasobu do momentu przejazdu pociągu, czyli kolejne 3 sekundy ~n"),
  io:format(" - about = wyswietlenie tego opisu ~n"),
  io:format(" - close = wylaczenie okna ~n"),
  io:format("Dodatkowo program zawiera podstawowa obsługę bledow. ~n").