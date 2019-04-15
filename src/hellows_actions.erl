-module(hellows_actions).

-export([
    websocket_init/1,
    websocket_handle/2,
    websocket_info/2
]).

-define(INTERVAL, 5 * 1000).

websocket_init(State) ->
    erlang:send_after(?INTERVAL, self(), ping),
    {ok, State}.

websocket_handle(Frame, State) ->
    lager:info("websocket_handle: ~p ~p ~n", [Frame, State]),
    {ok, State}.

websocket_info(ping, State) ->
    erlang:send_after(?INTERVAL, self(), ping),
    {reply, {text, <<"Ping!">>}, State};
websocket_info(Info, State) ->
    lager:info("websocket_info: ~p ~p ~n", [Info, State]),
    {ok, State}.
