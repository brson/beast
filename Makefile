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

RUST_TOOLCHAIN=nightly-2019-06-14
RUST_VERSION=1.37.0-nightly
GO_TOOLCHAIN=go1.13
GO_VERSION=go1.13
GVM_PKGSET=global


# Environment configuration

export gvm_go_name=${GO_TOOLCHAIN}
export gvm_pkgset_name=${GVM_PKGSET}
export RUSTUP_TOOLCHAIN=${RUST_TOOLCHAIN}
export GO111MODULE=on




# Source files

BEASTDB_FILES=$(shell find src/beastdb)
DRIVER_GO_FILES=$(shell find src/driver_go)
DRIVER_TIKV_SERVER_FILES=$(shell find src/driver_tikv_server)
DRIVER_BEASTDB_FILES=$(shell find src/driver_beastdb)
TIKV_FILES=$(shell find src/tikv)
PD_FILES=$(shell find src/pd)
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
> @gvm version | grep "Go Version Manager" > /dev/null
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
golib \
beastdb
.PHONY: beast

golib: \
out/libgolib.a
.PHONY: golib

beastdb: \
out/beastdb
.PHONY: driver




# Actual build rules

out/libgolib.a: \
$(GOLIB_FILES) \
$(PD_FILES) \
$(TIDB_FILES)
> export GO111MODULE=on
> export CGO_ENABLED=1
> go build -gcflags '$(GCFLAGS)' -ldflags '$(LDFLAGS)' \
  -buildmode=c-archive -o out/libgolib.a \
  src/golib/golib.go

out/beastdb: \
$(DRIVER_FILES) \
$(DRIVER_BEASTDB_FILES) \
$(DRIVER_GO_FILES) \
$(DRIVER_TIKV_SERVER_FILES) \
$(TIKV_FILES) \
out/libgolib.a
#out/tidb.a
> export RUSTFLAGS="-L native=`pwd`/out"
> cargo build -p beastdb
> cp target/debug/beastdb out/



# Misc

echovars:
> echo $(PD_FILES)


# TODO

# - check compiler versions
# - go package sets
# - why doesn't .go-version work?
