CONFIG := config.json
APP    := $(shell jq -r .name $(CONFIG))
VER    := $(shell jq -r .version $(CONFIG))

C_COMPILER   ?= cc
COMMON_FLAGS ?= -Wall -Wextra -O2
DEFINES      := -DNAME='"$(APP)"' -DVERSION='"$(VER)"'

MAIN := src/wordcount.c
OUT  := build/$(APP)

TXT_TEST_SRCS := $(wildcard test/*.txt)
TESTS := $(patsubst test/%.txt,test/%.test,$(TXT_TEST_SRCS))

.PHONY: all check clean $(TESTS)

all: $(OUT)

$(OUT): $(MAIN) $(CONFIG)
	@mkdir -p build
	@$(C_COMPILER) $(DEFINES) $(COMMON_FLAGS) -o $@ $(MAIN)

check: $(TESTS)

$(TESTS): test/%.test: test/%.txt test/%.expected $(OUT)
	@"$(OUT)" "$<" | diff -u "test/$*.expected" -
	
clean:
	rm -rf build

