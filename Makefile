# Build orchestration for The Beijing Beast
#
# This Makefile is following guidelines from
#
#     https://tech.davis-hansson.com/p/make/
#     https://tech.davis-hansson.com/p/make/




# Configure make to behave more reliably and predictably.
# This is Davis Hansson's preamble.

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >




# Configuration options for this makefile
OFFLINE:=$(OFFLINE)
GCFLAGS:=$(GCFLAGS)
LDFLAGS:=$(LDFLAGS)




# Toolchain definitions
# NB: Keep in sync with rust-toolchain and .gvm-version

RUST_TOOLCHAIN=nightly-2019-09-05
RUST_VERSION=1.39.0-nightly
GO_TOOLCHAIN=go1.13
GO_VERSION=go1.13
GVM_PKGSET=global


# Environment configuration

export gvm_go_name=${GO_TOOLCHAIN}
export gvm_pkgset_name=${GVM_PKGSET}
export RUSTUP_TOOLCHAIN=${RUST_TOOLCHAIN}
export GO111MODULE=on




# Source files

DRIVER_FILES=$(shell find src/driver)
DRIVER_GO_FILES=$(shell find src/driver_go)
TIKV_FILES=$(shell find src/tikv)
PD_FILES=$(shell find src/tikv)
TIDB_FILES=$(shell find src/tidb)
GOLIB_FILES=$(shell find src/golib)




# Master rules

all: \
configure-toolchains
> false
.PHONY: all

run:
> @echo running out/beastdb
> @out/beastdb
.PHONY: run




# Toolchain installation

configure-toolchains: \
verify-toolchain-managers \
print-toolchain-manager-versions \
install-toolchains \
verify-toolchains \
print-toolchain-versions
.PHONY: configure-toolchains

verify-toolchains: \
verify-rust \
verify-go
.PHONY: verify-toolchains

verify-rust: \
install-rust
> @rustc -V | grep "${RUST_VERSION}" > /dev/null
.PHONY: verify-rust

verify-go: \
install-go
> @go version | grep "${GO_VERSION}" > /dev/null
.PHONY: verify-go

verify-toolchain-managers: \
verify-rustup \
verify-gvm
.PHONY: verify-toolchain-managers

verify-rustup:
> @rustup -V > /dev/null
.PHONY: verify-rustup

verify-gvm:
> @gvm version | grep "GVM2" > /dev/null
.PHONY: verify-gvm

install-toolchains: \
install-rust \
install-go
.PHONY: install-toolchains

install-rust: \
verify-rustup
# FIXME: rustup shouldn't hit the network if it doesn't need to
# For now this is commented out since rustup will automatically
# install the toolchain before use.
#> if [[ -z "${OFFLINE}" ]]; then
#>     rustup install "${RUST_TOOLCHAIN}" --no-self-update
#> fi
.PHONY: install-rust

install-go: \
verify-gvm
> gvm install "${GO_TOOLCHAIN}" --binary
.PHONY: install-go

print-toolchain-manager-versions: \
print-rustup-version \
print-gvm-version
.PHONY: print-toolchain-manager-versions

print-rustup-version: \
verify-rustup
> @rustup -V
.PHONY: print-rustup-version

print-gvm-version: \
verify-gvm
> @gvm version
.PHONY: print-gvm-version

print-toolchain-versions: \
print-rust-version \
print-go-version
.PHONY: print-toolchain-versions

print-rust-version: \
install-rust
> @echo "$(shell rustc -V)"
.PHONY: print-rust-version

print-go-version: \
install-go
> @echo "$(shell go version)"
.PHONY: print-go-version




# Convenient-named build rules

allbeast: \
pd-server \
tidb \
golib \
driver
.PHONY: beast

pd-server: \
out/pd-server.a
.PHONY: pd

tidb: \
out/tidb.a
.PHONY: tidb

golib: \
out/libgolib.a
.PHONY: golib

driver: \
out/beastdb
.PHONY: driver




# Actual build rules

out/pd-server.a:
> export GO111MODULE=on
> export CGO_ENABLED=0
> cd src/pd
> go build -gcflags '$(GCFLAGS)' -ldflags '$(LDFLAGS)' \
  -buildmode=c-archive -o ../../out/pd-server.a \
  cmd/pd-server/main.go

out/tidb.a:
> false

out/libgolib.a: \
$(GOLIB_FILES) \
$(PD_FILES) \
$(TIDB_FILES)
> export GO111MODULE=on
> export CGO_ENABLED=1
> cd src/golib
> go build -gcflags '$(GCFLAGS)' -ldflags '$(LDFLAGS)' \
  -buildmode=c-archive -o ../../out/libgolib.a \
  golib.go

out/beastdb: \
$(DRIVER_FILES) \
$(DRIVER_GO_FILES) \
$(TIKV_FILES) \
out/pd-server.a \
out/libgolib.a
#out/tidb.a
> export RUSTFLAGS="-L native=`pwd`/out"
> cargo build -p beastdb
> cp target/debug/beastdb out/




# TODO

# - check compiler versions
# - go package sets
# - why doesn't .go-version work?
