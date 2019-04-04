all:
	rebar3 compile

release:
	rebar3 release

shell:
	rebar3 shell

test:
	rebar3 eunit

clean:
	rm -rf _build log

.PHONY: all release shell test clean
