-module(response).

-export([
    json/3,
    html/3
]).

json({Req0, State}, Cookies, Data) ->
    Json = jsone:encode(Data),
    Req = cowboy_req:reply(
        200,
        #{
            <<"content-type">> => <<"application/json; charset=utf-8">>
        },
        Json,
        session:set_session(Req0, Cookies)
    ),
    {ok, Req, State}.

html({Req0, State}, Cookies, {File, Data}) ->
    Html = template:render(File, Data),
    Req = cowboy_req:reply(
        200,
        #{
            <<"content-type">> => <<"text/html; charset=utf-8">>
        },
        Html,
        session:set_session(Req0, Cookies)
    ),
    {ok, Req, State}.
