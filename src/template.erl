-module(template).

-export([
    render/1,
    render/2
]).

path_to(File) ->
    list_to_binary([hello_webapp:priv_dir(), "/", File]).

render(File) ->
    render(File, #{}).

render(File, Data) ->
    Tmpl = bbmustache:parse_file(path_to(File)),
    bbmustache:compile(Tmpl, Data).
