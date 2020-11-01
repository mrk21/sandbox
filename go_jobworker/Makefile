SRCS := $(shell find cmd -name main.go)
BINS := $(shell echo ${SRCS} | xargs dirname | sed -e 's/^cmd/bin/')
GOFILES := $(shell find . -name '*.go')
BUILD_FLAGS := -a -tags "netgo" -installsuffix netgo -ldflags="-s -w -extldflags \"-static\""

.PHONY: build
build: ${BINS}

.PHONY: rebuild
rebuild: clean build

.PHONY: clean
clean:
	${RM} -rf ${BINS}

bin/%: cmd/%/main.go ${GOFILES}
	go build ${BUILD_FLAGS} -o $@ $<
