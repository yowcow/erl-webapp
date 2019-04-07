-module(response).

-export([
    json/3,
    html/3
]).

json(Req0, State, Data) ->
    Json = jsone:encode(Data),
    Req = cowboy_req:reply(
        200,
        #{
            <<"content-type">> => <<"application/json; charset=utf-8">>
        },
        Json,
        Req0
    ),
    {ok, Req, State}.

html(Req0, State, {File, Data}) ->
    Html = template:render(File, Data),
    Req = cowboy_req:reply(
        200,
        #{
            <<"content-type">> => <<"text/html; charset=utf-8">>
        },
        Html,
        Req0
    ),
    {ok, Req, State}.