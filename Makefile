SHELL := bash
.ONESHELL:
.SHELLFLAGS := -euc
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

VERSION := $(shell cat VERSION)
IMAGE := pauloferrazoliveira/dogstatsd-2-statsd

all:
	echo "Current version (file VERSION) is ${VERSION}"
	echo "Options:"
	echo "  - make version-check"
	echo "  - make configure-multiarch"
	echo "  - make build-push"
.PHONY: all

version-check:
ifndef ENV_VAR
	@echo Version is ${VERSION}. Continue? [Y/n]
	@read line; if [ $$line != "Y" ]; then echo "Aborting..."; exit 1 ; fi
endif
.PHONY: version-check

configure-multiarch:
	@echo "An error like 'ERROR: existing instance for \"multi-arch-builder\"...' is Ok, in the next line"
	@docker buildx create --name multi-arch-builder --use || true
.PHONY: configure-multiarch

build-push: version-check
	@$(MAKE) configure-multiarch
	@echo "Building ${VERSION} (also as latest) and pushing..."
	@docker buildx build --platform linux/amd64,linux/arm64 . --tag ${IMAGE}:${VERSION} --push
	@docker buildx build --platform linux/amd64,linux/arm64 . --tag ${IMAGE}:latest --push
	@echo "... built and pushed!"
.PHONY: build-push

run:
	@docker build . --tag dogstatsd-2-statsd:local --load
	@docker rm --force dogstatsd-2-statsd
	@docker run --detach --name dogstatsd-2-statsd --publish 8125:8125/udp --publish 8080:80 dogstatsd-2-statsd:local
	@echo "🕥 Giving it some time to boot..." && sleep 4 && echo "✅ Opening http://127.0.0.1:8080..." && open http://127.0.0.1:8080
.PHONY: run
