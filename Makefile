# ====================================================================================
# Setup Project

# remove default suffixes as we don't use them
.SUFFIXES:

# set the shell to bash always
SHELL := /bin/bash

ROOT := $(shell pwd)
PROJECT_NAME := $(shell basename `git -C $(ROOT) rev-parse --show-toplevel`)

# ====================================================================================
# Common Actions

.DEFAULT_GOAL := all

.PHONY: all
all: clean start

.PHONY: start
start: ## Run the homepage application
	@docker run --name=$(PROJECT_NAME) -d \
    	--restart unless-stopped \
    	-p 3001:3000 \
        -e LOG_TARGETS=stdout \
        -e HOMEPAGE_ALLOWED_HOSTS=localhost:3001,127.0.0.1:3001 \
    	--mount type=bind,src=$(ROOT)/config,dst=/app/config \
        --mount type=bind,src=$(ROOT)/img,dst=/app/public/images \
    	ghcr.io/gethomepage/homepage:v1.2.0

.PHONY: test
test: ## Run all the unit test.
	@:

.PHONY: clean
clean: ## Stop and remove the container
	-@docker kill $(PROJECT_NAME)
	-@docker rm $(PROJECT_NAME)

# ====================================================================================
# Utils Actions

# https://stackoverflow.com/a/47107132
.PHONY: help
help: ## Show the basic command help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

.PHONY: help.all
help.all: ## Show the advanced command help.
	@sed -ne '/@sed/!s/#! //p' $(MAKEFILE_LIST)
