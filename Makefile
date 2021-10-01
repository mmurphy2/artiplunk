HELP := $(shell find src/help -type f | sort)
LIBRARY := $(shell find src/library -name '*.sh' | sort)
PACK := $(shell find src/pack -type f | sort)
SECTION := $(shell find src/section -name '*.sh' | sort)
STEP := $(shell find src/step -name '*.sh' | sort)

all: artiplunk

artiplunk: src/*.sh Makefile $(HELP) $(LIBRARY) $(PACK) $(STEP) $(SECTION)
	cat src/header.sh $(LIBRARY) $(STEP) $(SECTION) src/main.sh > artiplunk
	chmod 755 artiplunk
	cat $(HELP) | ./artiplunk --pack help
	$(foreach item,$(PACK),cat $(item) | ./artiplunk --pack $(subst src/pack/,,$(item));)

clean:
	rm -f artiplunk

serve: artiplunk
	python -m http.server 8042

unittest:
	bats -p -r src

.PHONY: all clean serve unittest

