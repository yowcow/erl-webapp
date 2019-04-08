-module(response).

-export([
    json/1,
    html/2,
    html/1
]).

-define(JSON, <<"application/json; charset=utf-8">>).
-define(HTML, <<"text/html; charset=utf-8">>).

json(Data) ->
    {?JSON, jsone:encode(Data)}.

html(Data, File) ->
    {?HTML, template:render(File, Data)}.

html(File) ->
    {?HTML, template:render(File)}.
