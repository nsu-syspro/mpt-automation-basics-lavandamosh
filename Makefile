CONFIG := config.json
APP    := $(shell jq -r .name $(CONFIG))
VER    := $(shell jq -r .version $(CONFIG))

C_COMPILER   ?= cc
COMMON_FLAGS ?= -Wall -Wextra -O2
DEFINES      := -DNAME='"$(APP)"' -DVERSION='"$(VER)"'

MAIN := src/wordcount.c
OUT  := build/$(APP)

TEST_SRCS    := $(wildcard test/*.txt)
TEST_TARGETS := $(TEST_SRCS:.txt=.test)

.PHONY: all check clean $(TEST_TARGETS)

all: $(OUT)

$(OUT): $(MAIN) $(CONFIG)
	@mkdir -p build
	$(C_COMPILER) $(DEFINES) $(COMMON_FLAGS) -o $@ $(MAIN)

check: $(OUT)
	@$(MAKE) -s execute_tests

.PHONY: execute_tests
execute_tests: $(TEST_TARGETS)

test/%.test: test/%.txt $(OUT)
	@./$(OUT) $< | diff - $*.expected

clean:
	rm -rf build
