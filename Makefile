CONFIG := config.json
APP    := $(shell jq -r .name $(CONFIG))
VER    := $(shell jq -r .version $(CONFIG))

C_COMPILER   ?= cc
COMMON_FLAGS ?= -Wall -Wextra -O2
DEFINES      := -DNAME='"$(APP)"' -DVERSION='"$(VER)"'

MAIN := src/wordcount.c
OUT  := build/$(APP)

TEST_SRCS := $(wildcard test/*.txt)

TEST_PASS := $(patsubst test/%.txt,build/%.passed,$(TEST_SRCS))

.PHONY: all check clean

all: $(OUT)

$(OUT): $(MAIN) $(CONFIG)
	@mkdir -p build
	$(C_COMPILER) $(DEFINES) $(COMMON_FLAGS) -o $@ $(MAIN)

check: $(OUT) $(TEST_PASS)

build/%.passed: test/%.txt test/%.expected $(OUT)
	@./$(OUT) $< | diff - test/$*.expected
	@touch $@

clean:
	rm -rf build

