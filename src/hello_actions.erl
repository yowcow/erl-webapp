-module(hello_actions).

-export([
    hello/2
]).

-define(COOKIE_KEY, <<"count">>).

hello(#{ bindings := Bindings } = Req, #{ cookies := Cookies }) ->
    RemoteAddr = list_to_binary(request:remote_addr(Req)),
    {ContentType, Body} = case maps:get(format, Bindings) of
        <<"json">> ->
            response:json(#{ remote_addr => RemoteAddr });
        _ ->
            response:html(#{ "remote_addr" => RemoteAddr }, "hello.html")
    end,
    RespCookies = incr_count(Cookies),
    lager:info("cookie state before: ~p, after: ~p", [Cookies, RespCookies]),
    {200, RespCookies, #{ <<"content-type">> => ContentType }, Body}.

incr_count(#{ ?COOKIE_KEY := Count } = Cookies) ->
    Cookies#{ ?COOKIE_KEY => Count + 1 };
incr_count(Cookies) ->
    Cookies#{ ?COOKIE_KEY => 1 }.
