# Copyright 2015-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
# 	http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

ROOT := $(shell pwd)

all: build

SOURCEDIR := .
SOURCES := $(shell find $(SOURCEDIR) -name '*.go')
VERSION := $(shell cat VERSION)
LOCAL_BINARY := bin/local/ecs-cli
LINUX_AMD_DIR := bin/linux-amd64
LINUX_AMD_BINARY := $(LINUX_AMD_DIR)/ecs-cli
LINUX_AMD_ARCHIVE := ecs-cli-linux-amd64-$(VERSION).tgz
LINUX_ARM_DIR := bin/linux-arm64
LINUX_ARM_BINARY := $(LINUX_ARM_DIR)/ecs-cli
LINUX_ARM_ARCHIVE := ecs-cli-linux-arm64-$(VERSION).tgz
DARWIN_AMD_DIR := bin/darwin-amd64
DARWIN_AMD_BINARY := $(DARWIN_AMD_DIR)/ecs-cli
DARWIN_AMD_ARCHIVE := ecs-cli-darwin-amd64-$(VERSION).tgz
WINDOWS_DIR := windows-amd64
WINDOWS_BINARY := $(WINDOWS_DIR)/ecs-cli.exe
LOCAL_PATH := $(ROOT)/scripts:${PATH}
GO_RELEASE_TAG := 1.13

.PHONY: build
build: $(LOCAL_BINARY)

$(LOCAL_BINARY): $(SOURCES) VERSION
	./scripts/build_binary.sh ./bin/local
	@echo "Built ecs-cli"

.PHONY: test
test:
	go mod vendor
	env -i PATH=$$PATH GOPATH=$$(go env GOPATH) GOROOT=$$(go env GOROOT) GOCACHE=$$(go env GOCACHE) \
	go test -race -timeout=120s -cover ./ecs-cli/modules/...

.PHONY: integ-test
integ-test: integ-test-build integ-test-run-with-coverage

# Builds the ecs-cli.test binary.
# This binary is the same as regular ecs-cli but it additionally gives coverage stats to stdout after each execution.
.PHONY: integ-test-build
integ-test-build:
	@echo "Installing dependencies..."
	go get github.com/wadey/gocovmerge
	@echo "Building ecs-cli.test..."
	env -i PATH=$$PATH GOPATH=$$(go env GOPATH) GOROOT=$$(go env GOROOT) GOCACHE=$$(go env GOCACHE) \
	go test -coverpkg ./ecs-cli/modules/... -c -tags testrunmain -o ./bin/local/ecs-cli.test ./ecs-cli

# Run our integration tests using the ecs-cli.test binary.
.PHONY: integ-test-run
integ-test-run:
	@echo "Running integration tests..."
	go test -timeout 60m -tags integ -v ./ecs-cli/integ/e2e/...

# Run `integ-test-run` and merge each coverage file from our e2e tests to one file and calculate the total coverage.
.PHONY: integ-test-run-with-coverage
integ-test-run-with-coverage: integ-test-run
	@echo "Code coverage"
	gocovmerge $$TMPDIR/coverage* > $$TMPDIR/all.out
	go tool cover -func=$$TMPDIR/all.out
	rm $$TMPDIR/coverage* $$TMPDIR/all.out

.PHONY: generate
generate: $(SOURCES)
	GO111MODULE=on go get github.com/golang/mock/mockgen@v1.4.4
	GO111MODULE=on go get golang.org/x/tools/cmd/goimports@release-branch.go1.13
	PATH=$(LOCAL_PATH) go mod vendor
	PATH=$(LOCAL_PATH) go generate ./ecs-cli/modules/...

.PHONY: windows-build
windows-build: $(WINDOWS_BINARY)

.PHONY: docker-build
docker-build:
	docker run -v $(shell pwd):/usr/src/app/src/github.com/aws/amazon-ecs-cli \
		--workdir=/usr/src/app/src/github.com/aws/amazon-ecs-cli \
		--env GOPATH=/usr/src/app \
		--env ECS_RELEASE=$(ECS_RELEASE) \
		golang:$(GO_RELEASE_TAG) make $(LINUX_AMD_BINARY)
	docker run -v $(shell pwd):/usr/src/app/src/github.com/aws/amazon-ecs-cli \
		--workdir=/usr/src/app/src/github.com/aws/amazon-ecs-cli \
		--env GOPATH=/usr/src/app \
		--env ECS_RELEASE=$(ECS_RELEASE) \
		golang:$(GO_RELEASE_TAG) make $(DARWIN_AMD_BINARY)
	docker run -v $(shell pwd):/usr/src/app/src/github.com/aws/amazon-ecs-cli \
		--workdir=/usr/src/app/src/github.com/aws/amazon-ecs-cli \
		--env GOPATH=/usr/src/app \
		--env ECS_RELEASE=$(ECS_RELEASE) \
		golang:$(GO_RELEASE_TAG) make $(WINDOWS_BINARY)

.PHONY: docker-test
docker-test:
	docker run -v $(shell pwd):/usr/src/app/src/github.com/aws/amazon-ecs-cli \
		--workdir=/usr/src/app/src/github.com/aws/amazon-ecs-cli \
		--env GOPATH=/usr/src/app \
		--env ECS_RELEASE=$(ECS_RELEASE) \
		golang:$(GO_RELEASE_TAG) make test

.PHONY: supported-platforms
supported-platforms: $(DARWIN_AMD_BINARY) $(LINUX_AMD_BINARY) $(LINUX_ARM_BINARY) #$(WINDOWS_BINARY)

.PHONY: release
release: $(LINUX_AMD_ARCHIVE) $(LINUX_ARM_ARCHIVE) $(DARWIN_AMD_ARCHIVE)

# $(WINDOWS_BINARY): $(SOURCES)
# 	@mkdir -p ./bin/windows-amd64
# 	TARGET_GOOS=windows GOARCH=amd64 ./scripts/build_binary.sh ./bin/windows-amd64
# 	mv ./bin/windows-amd64/ecs-cli ./bin/windows-amd64/ecs-cli.exe
# 	@echo "Built ecs-cli.exe for windows"

$(LINUX_AMD_BINARY): $(SOURCES) generate
	@mkdir -p $(LINUX_AMD_DIR)
	TARGET_GOOS=linux GOARCH=amd64 ./scripts/build_binary.sh ./bin/linux-amd64
	@echo "Built ecs-cli for linux (amd64)"

$(LINUX_ARM_BINARY): $(SOURCES) generate
	@mkdir -p $(LINUX_ARM_DIR)
	TARGET_GOOS=linux GOARCH=arm64 ./scripts/build_binary.sh ./bin/linux-arm64
	@echo "Built ecs-cli for linux (arm64)"

$(DARWIN_AMD_BINARY): $(SOURCES) generate
	@mkdir -p ./bin/$(DARWIN_AMD_DIR)
	TARGET_GOOS=darwin GOARCH=amd64 ./scripts/build_binary.sh ./bin/darwin-amd64
	@echo "Built ecs-cli for darwin (amd64)"

$(LINUX_AMD_ARCHIVE): $(LINUX_AMD_BINARY)
	tar zcv -C $(LINUX_AMD_DIR) -f $(LINUX_AMD_ARCHIVE) ecs-cli

$(LINUX_ARM_ARCHIVE): $(LINUX_ARM_BINARY)
	tar zcv -C $(LINUX_ARM_DIR) -f $(LINUX_ARM_ARCHIVE) ecs-cli

$(DARWIN_AMD_ARCHIVE): $(DARWIN_AMD_BINARY)
	cd $(DARWIN_AMD_DIR)
	tar zcv -C $(DARWIN_AMD_DIR) -f $(DARWIN_AMD_ARCHIVE) ecs-cli

.PHONY: clean
clean:
	rm -rf ./bin/ ./vendor||:
