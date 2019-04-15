-module(websocket_handler).

-export([
    init/2,
    websocket_init/1,
    websocket_handle/2,
    websocket_info/2
]).

init(Req, State) ->
    {cowboy_websocket, Req, State}.

websocket_init(#{ module := M } = State) ->
    M:websocket_init(State).

websocket_handle(Frame, #{ module := M } = State) ->
    M:websocket_handle(Frame, State).

websocket_info(Info, #{ module := M } = State) ->
    M:websocket_info(Info, State).
