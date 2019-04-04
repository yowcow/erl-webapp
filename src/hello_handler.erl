-module(hello_handler).

-export([
    init/2
]).

init(Req0, State) ->
    lager:warning("Got a request for greetings"),
    Req = cowboy_req:reply(
        200,
        #{
            <<"content-type">> => <<"text/plain">>,
            <<"x-hoge-fuga">>  => <<"HOGE/FUGA">>
        },
        <<"Hello from Erlang">>,
        Req0
    ),
    {ok, Req, State}.
