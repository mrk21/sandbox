srcs := $(shell find config pkg -type f)
cmds := $(shell find cmd -mindepth 1 -maxdepth 1 -type d)
bins := $(patsubst cmd/%,bin/%,$(cmds))

.DEFAULT_GOAL := all

.PHONY: all
all: build

.PHONY: build
build: ${bins}

.PHONY: clean
clean:
	@echo "#### Clean"
	rm -rf bin
	@echo ""

.PHONY: rebuild
rebuild: clean build

bin/%: cmd/% $(srcs)
	$(eval cmdfiles := $(shell find $<  -mindepth 1 -maxdepth 1 -name *.go))
	@echo "#### Building $@"
	go build -tags osusergo,netgo -ldflags -extldflags="static" -o $@ ${cmdfiles}
	ldd $@ || :
	du -hs $@
	@echo ""
