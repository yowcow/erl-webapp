-module(session).

-export([
    set_session/2,
    get_session/1
]).

-define(COOKIE_NAME, <<"sess">>).
-define(STRETCHES, 10).
-define(PRIVATE_TOKEN, <<"HOGEHOGE-hogehoge">>). % should not be present.

bin2hex(Bin) ->
    List = lists:flatten([io_lib:format("~2.16.0B", [X]) || X <- binary_to_list(Bin)]),
    list_to_binary(string:to_lower(List)).

sign(Data) ->
    S = sign(Data, ?PRIVATE_TOKEN, ?STRETCHES),
    bin2hex(S).

sign(Data, _, 0)   -> Data;
sign(Data, Salt, N) ->
    Digest = crypto:hash(sha, << Data/binary, Salt/binary >>),
    sign(Digest, Salt, N - 1).

set_timestamp(Cookies) ->
    {MegaSecs, Secs, MicroSecs} = os:timestamp(),
    Timestamp = MegaSecs * math:pow(10, 6) + Secs + MicroSecs * math:pow(10, -6),
    Cookies#{ t => Timestamp }.

set_session(Req0, Cookies) ->
    RawMsg = jsone:encode(set_timestamp(Cookies)),
    Signature = sign(RawMsg),
    Msg = b64_urlsafe:encode(RawMsg),
    CookieData = <<Msg/binary, <<".">>/binary, Signature/binary>>,
    cowboy_req:set_resp_cookie(?COOKIE_NAME, CookieData, Req0, #{
        http_only => true,
        domain => "",
        path => "/"
    }).

get_session(Req) ->
    Cookies = cowboy_req:parse_cookies(Req),
    Verified = case proplists:get_value(?COOKIE_NAME, Cookies) of
        undefined  -> #{};
        CookieData -> verified_session(binary:split(CookieData, [<<".">>]))
    end,
    Verified.

verified_session([Msg, Signature]) ->
    RawMsg = b64_urlsafe:decode(Msg),
    ToMatch = sign(RawMsg),
    case Signature =:= ToMatch of
        true ->
            case jsone:try_decode(RawMsg) of
                {error, Err} ->
                    lager:error("failed decoding session: ~p~n", [Err]),
                    #{};
                {ok, Data, _} ->
                    Data
            end;
        _    -> #{}
    end;
verified_session(_) -> #{}.
