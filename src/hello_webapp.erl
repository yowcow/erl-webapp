-module(hello_webapp).

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
            },
            {   "/ws",
                websocket_handler,
                #{ module => hellows_actions }
            }
        ]}
    ]),
    {ok, Port} = application:get_env(hello_webapp, port),
    {ok, _} = cowboy:start_clear(
        my_http_listener,
        [{port, Port}],
        #{env => #{dispatch => Dispatch}}
    ),
    hello_webapp_sup:start_link().

stop(_State) ->
    ok.
