-module(response).

-export([
    render/3,
    json/1,
    html/1,
    html/2
]).

-define(JSON, <<"application/json; charset=utf-8">>).
-define(HTML, <<"text/html; charset=utf-8">>).

render(#{ bindings := Bindings }, Data, File) ->
    render_format(maps:get(format, Bindings), Data, File).

render_format(<<"json">>, Data, _)    -> json(Data);
render_format(_,          Data, File) -> html(Data, File).

json(Data) ->
    {?JSON, jsone:encode(myutil:binary_key_map(Data))}.

html(Data, File) ->
    {?HTML, template:render(File, myutil:list_key_map(Data))}.

html(File) ->
    {?HTML, template:render(File)}.
