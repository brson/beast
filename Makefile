# Build orchestration for The Beijing Beast
#
# This Makefile is following guidelines from
#
#     https://tech.davis-hansson.com/p/make/


# Configure make to behave more reliably and predictably.

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


# Recipes



# TODO

# - check compiler versions
