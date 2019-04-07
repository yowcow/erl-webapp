-module(hello_handler).

-export([
    init/2
]).

init(#{ bindings := Bindings } = Req0, State) ->
    RemoteAddr = list_to_binary(request:remote_addr(Req0)),
    Format = maps:get(format, Bindings),
    case Format of
        <<"json">> ->
            response:json(Req0, State, #{ remote_addr => RemoteAddr });
        _ ->
            response:html(Req0, State, {"hello.html", #{ "remote_addr" => RemoteAddr }})
    end.
