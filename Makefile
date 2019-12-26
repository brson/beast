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
OFFLINE=


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


# Master rules

all: \
configure-toolchains
> false
.PHONY: all


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
> rustc -V | grep "${RUST_VERSION}" > /dev/null
.PHONY: verify-rust

verify-go: \
install-go
> go version | grep "${GO_VERSION}" > /dev/null
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
> @echo "$(rustc -V)"
.PHONY: print-rust-version

print-go-version: \
install-go
> @echo "$(go version)"
.PHONY: print-go-version


# TODO

# - check compiler versions
# - go package sets
# - why doesn't .go-version work?
