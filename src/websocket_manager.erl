-module(websocket_manager).

-behavior(gen_server).

-export([
    init/1,
    terminate/2,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    code_change/3
]).
-export([
    start/0,
    stop/0,
    join/0,
    broadcast/1
]).

init([]) ->
    {ok, []}.

terminate(_Reason, _State) ->
    ok.

handle_call(all, _From, State) ->
    {reply, State, State};
handle_call(join, {Pid, _Tag}, State) ->
    erlang:monitor(process, Pid),
    Next = [Pid | State],
    lager:info("got a new conn. total count: ~p", [length(Next)]),
    {reply, ok, Next}.

handle_cast(Req, State) ->
    lager:info("handle_cast: ~p", [Req]),
    {noreply, State}.

handle_info({'DOWN', _Tag, process, Pid, _}, State) ->
    Next = [P || P <- State, P =/= Pid],
    lager:info("conn disconnected. total count: ~p", [length(Next)]),
    {noreply, Next};
handle_info(Msg, State) ->
    lager:info("handle_info: ~p", [Msg]),
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

start() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:stop(?MODULE).

join() ->
    gen_server:call(?MODULE, join).

broadcast(Msg) ->
    Pid = self(),
    State = gen_server:call(?MODULE, all),
    [P ! Msg || P <- State, P =/= Pid].
