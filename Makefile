CONFIG := config.json
APP    := $(shell jq -r .name $(CONFIG))
VER    := $(shell jq -r .version $(CONFIG))

C_COMPILER   ?= cc
COMMON_FLAGS ?= -Wall -Wextra -O2
DEFINES      := -DNAME='"$(APP)"' -DVERSION='"$(VER)"'

MAIN := src/wordcount.c
OUT  := build/$(APP)

TEST_SRCS := $(wildcard test/*.txt)

.PHONY: all check clean execute_tests

all: $(OUT)

$(OUT): $(MAIN) $(CONFIG)
	@mkdir -p build
	$(C_COMPILER) $(DEFINES) $(COMMON_FLAGS) -o $@ $(MAIN)


check: $(OUT)
	@$(MAKE) -s execute_tests

execute_tests: $(OUT)
	@$(foreach f,$(TEST_SRCS),./$(OUT) "$(f)" | diff - "$(f:.txt=.expected)" || exit 1;)

clean:
	rm -rf build


