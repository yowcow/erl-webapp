-module(hello_webapp_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    lager:start(),
    Dispatch = cowboy_router:compile([
        {'_', [
            {   "/hello/:format",
                default_handler,
                #{ module => hello_actions, action => hello }
            },
            {   "/bye",
                default_handler,
                #{ module => hello_actions, action => bye }
            }
        ]}
    ]),
    {ok, _} = cowboy:start_clear(
        my_http_listener,
        [{port, 8800}],
        #{env => #{dispatch => Dispatch}}
    ),
    hello_webapp_sup:start_link().

stop(_State) ->
    ok.
