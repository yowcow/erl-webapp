-module(default_handler).

-export([
    init/2
]).

init(Req, #{ module := Mod, action := Action } = State) ->
    Cookies = session:get_session(Req),
    {Code, RespCookies, RespHeaders, RespBody} = Mod:Action(Req, State#{ cookies => Cookies }),
    Resp = cowboy_req:reply(Code, RespHeaders, RespBody, session:set_session(Req, RespCookies)),
    {ok, Resp, State}.
