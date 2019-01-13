%%%-------------------------------------------------------------------
%%% @author lukasz
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. gru 2018 00:04
%%%-------------------------------------------------------------------
-module('GuiMenu').
-author("lukasz").

-include_lib("wx/include/wx.hrl").

%% API
-export([init/0, barrierUp/1, barrierDown/1]).

init() ->
  Wx = wx:new(),

  Frame = wxFrame:new(Wx, ?wxID_ANY, "Szlaban"),
  wxFrame:connect(Frame, paint),

  % Generate whatever state the process represents

  initStatusBar(Frame),
  createMenu(Frame),

  wxFrame:connect(Frame, close_window),
  wxFrame:connect(Frame, command_menu_selected),
  createDialog(Frame, "Let's talk."),
  wxFrame:show(Frame),

  barrierUp(Frame),
  barrierDown(Frame),

  handleEvents(Frame),
  Frame.

createDialog(Frame, X) ->
  D = wxMessageDialog:new(Frame, X),
  wxMessageDialog:showModal(D).

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
  Close = wxMenuItem:new([{id, 103}, {text, "&Close"}]),
  wxMenu:append(BarrierMenu, BarrierUp),
  wxMenu:append(BarrierMenu, BarrierDown),
  wxMenu:append(BarrierMenu, Close).

createHelpMenu(MenuBar) ->
  HelpMn = wxMenu:new(),
  wxMenuBar:append(MenuBar, HelpMn, "&Help"),
  About = wxMenuItem:new([{id, 500}, {text, "About"}]),
  wxMenu:append(HelpMn, About).

barrierUp(Frame) ->
  D = wxMessageDialog:new(Frame, "Barrier is going up"),

  DC = wxWindowDC:new(Frame),
  Pen = wxPen:new({255,0,0}, [{width, 3}, {style, 104}]),
  wxDC:setPen(DC, Pen),

  wxDC:drawLine(DC, {50, 70}, {150, 70}),
  wxDC:drawLine(DC, {150, 70}, {150, 100}),
  wxWindowDC:drawLine()
  wxMessageDialog:showModal(D).

barrierDown(Frame) ->
  D = wxMessageDialog:new(Frame, "Barrier is going down"),

  DC = wxWindowDC:new(Frame),
  Pen = wxPen:new({255,0,0}, [{width, 3}, {style, 104}]),
  wxDC:setPen(DC, Pen),

  wxDC:drawLine(DC, {150, 10}, {150, 70}),
  wxDC:drawLine(DC, {150, 70}, {150, 100}),
  wxMessageDialog:showModal(D).

handle_event(#wx{} = Event, State) ->
  io:format("got ~p~n", [Event]),
  {noreply, State}.

handleEvents(Frame) ->
  receive
    #wx{event = #wxClose{type = close_window}} ->
      io:format("quit icon"),
      wxFrame:destroy(Frame);
    #wx{id = 101, event = #wxCommand{type = command_menu_selected}} ->
      io:format("barrier up menu"),
      barrierUp(Frame);
    #wx{id = 102, event = #wxCommand{type = command_menu_selected}} ->
      io:format("barrier down menu"),
      barrierDown(Frame);
    #wx{id = 103, event = #wxCommand{type = command_menu_selected}} ->
      io:format("quit file menu"),
      wxFrame:destroy(Frame)
  end.