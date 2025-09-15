SHELL := bash

.PHONY: help log-clipboard log-file

help:
	@echo "Logging shortcuts:"
	@echo "  make log-clipboard              # Log clipboard (title = today)"
	@echo "  make log-file FILE=chat.txt     # Log from file (title = today)"

# Variables
# Defaults
SOURCE ?= claude
FILE   ?=
TODAY  := $(shell date +%F)

# Log clipboard contents as an AI chat entry
log-clipboard:
	@pbpaste | ./scripts/log-ai-chat.sh --source=$(SOURCE) --title="$(TODAY)"

# Log a file as an AI chat entry
log-file:
	@if [ -z "$(FILE)" ]; then echo "FILE is required: make log-file FILE=path/to.txt"; exit 1; fi
	@./scripts/log-ai-chat.sh --source=$(SOURCE) --file="$(FILE)" --title="$(TODAY)"
