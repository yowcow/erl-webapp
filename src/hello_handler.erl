-module(hello_handler).

-export([
    init/2
]).

init(#{ bindings := Bindings } = Req0, State) ->
    Cookies0 = session:get_session(Req0),
    Cookies = next_state(Cookies0),
    lager:info("Cookies: ~p~n", [Cookies]),
    RemoteAddr = list_to_binary(request:remote_addr(Req0)),
    Format = maps:get(format, Bindings),
    case Format of
        <<"json">> ->
            response:json(
                {Req0, State},
                Cookies,
                #{ remote_addr => RemoteAddr }
            );
        _ ->
            response:html(
                {Req0, State},
                Cookies,
                {"hello.html", #{ "remote_addr" => RemoteAddr }}
            )
    end.

next_state(#{ <<"count">> := Count } = Cookies) ->
    Cookies#{ <<"count">> => Count + 1 };
next_state(Cookies) ->
    Cookies#{ <<"count">> => 1 }.
