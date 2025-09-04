ENV_FILE=.env

include .env

export PROJECT_DIR

include make/k8s/base.mk

.PHONY: 