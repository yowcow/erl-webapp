-module(myutil).

-export([
    to_binary/1,
    to_list/1,
    binary_key_map/1,
    list_key_map/1
]).

to_binary(V) when is_binary(V) -> V;
to_binary(V) when is_list(V) -> list_to_binary(V);
to_binary(V) when is_atom(V) -> atom_to_binary(V, utf8).

to_list(V) when is_binary(V) -> binary_to_list(V);
to_list(V) when is_list(V) -> V;
to_list(V) when is_atom(V) -> atom_to_list(V).

binary_key_map(Map0) ->
    binary_key_map(maps:iterator(Map0), #{}).

binary_key_map(none, Map) ->
    Map;
binary_key_map(I, Map) ->
    {K1, V1, I1} = maps:next(I),
    binary_key_map(I1, Map#{ to_binary(K1) => V1 }).

list_key_map(Map0) ->
    list_key_map(maps:iterator(Map0), #{}).

list_key_map(none, Map) ->
    Map;
list_key_map(I, Map) ->
    {K1, V1, I1} = maps:next(I),
    list_key_map(I1, Map#{ to_list(K1) => V1 }).
