CONFIG := config.json
APP := $(shell jq -r .name $(CONFIG))
VER := $(shell jq -r .version $(CONFIG))

C_COMPILER ?= cc
COMMON_FLAGS ?= -Wall -Wextra -O2
DEFINES := -DNAME='"$(APP)"' -DVERSION='"$(VER)"'

MAIN := src/wordcount.c
OUT := build/$(APP)

.PHONY: all check clean

all: $(OUT)

$(OUT): $(MAIN) $(CONFIG)
	@mkdir -p build
	$(C_COMPILER) $(DEFINES) $(COMMON_FLAGS) -o $@ $(MAIN)

check: $(OUT)
	@bash -c 'set -e; for f in test/*.txt; do \
		./$(OUT) "$$f" | diff -u "$${f%.txt}.expected" - || \
		{ echo "*** $$f failed"; exit 1; }; \
	done'

clean:
	rm -rf build