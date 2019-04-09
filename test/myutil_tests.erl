-module(myutil_tests).

-include_lib("eunit/include/eunit.hrl").

to_binary_test_() ->
    Cases = [
        {"binary -> binary", <<"hoge">>, <<"hoge">>},
        {"list -> binary", "hoge", <<"hoge">>},
        {"atom -> binary", hoge, <<"hoge">>}
    ],
    F = fun({Name, Input, Expected}) ->
        Actual = myutil:to_binary(Input),
        {Name, ?_assertEqual(Expected, Actual)}
    end,
    lists:map(F, Cases).

to_list_test_() ->
    Cases = [
        {"binary -> list", <<"hoge">>, "hoge"},
        {"list -> list", "hoge", "hoge"},
        {"atom -> list", hoge, "hoge"}
    ],
    F = fun({Name, Input, Expected}) ->
        Actual = myutil:to_list(Input),
        {Name, ?_assertEqual(Expected, Actual)}
    end,
    lists:map(F, Cases).

binary_key_map_test() ->
    Input = #{
        hoge1 => <<"hoge1">>,
        <<"hoge2">> => <<"hoge2">>,
        "hoge3" => <<"hoge3">>
    },
    Expected = #{
        <<"hoge1">> => <<"hoge1">>,
        <<"hoge2">> => <<"hoge2">>,
        <<"hoge3">> => <<"hoge3">>
    },
    Actual = myutil:binary_key_map(Input),
    ?assertEqual(Expected, Actual).

list_key_map_test() ->
    Input = #{
        hoge1 => <<"hoge1">>,
        <<"hoge2">> => <<"hoge2">>,
        "hoge3" => <<"hoge3">>
    },
    Expected = #{
        "hoge1" => <<"hoge1">>,
        "hoge2" => <<"hoge2">>,
        "hoge3" => <<"hoge3">>
    },
    Actual = myutil:list_key_map(Input),
    ?assertEqual(Expected, Actual).
