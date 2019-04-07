-module(request).

-export([
    remote_addr/1
]).

remote_addr(#{ peer := {{A, B, C, D}, _} }) ->
    io_lib:format("~B.~B.~B.~B", [A, B, C, D]).
