-module(hello_actions).

-export([
    hello/2,
    bye/2
]).

-define(COOKIE_KEY, <<"count">>).

hello(#{ bindings := Bindings } = Req, #{ cookies := Cookies }) ->
    RemoteAddr = list_to_binary(request:remote_addr(Req)),
    #{ ?COOKIE_KEY := Count } = RespCookies = incr_count(Cookies),
    {ContentType, Body} = case maps:get(format, Bindings) of
        <<"json">> ->
            response:json(#{
                remote_addr => RemoteAddr,
                count => Count
            });
        _ ->
            response:html(#{
                "remote_addr" => RemoteAddr,
                "count" => Count
            }, "hello.html")
    end,
    {200, RespCookies, #{ <<"content-type">> => ContentType }, Body}.

incr_count(#{ ?COOKIE_KEY := Count } = Cookies) ->
    Cookies#{ ?COOKIE_KEY => Count + 1 };
incr_count(Cookies) ->
    Cookies#{ ?COOKIE_KEY => 1 }.

bye(_, _) ->
    {ContentType, Body} = response:html("bye.html"),
    {200, #{}, #{ <<"content-type">> => ContentType }, Body}.
