.PHONY: help install link brew update lint

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

install: link brew ## Full setup (symlinks + brew)
	bash ./mac/init-npm.sh
	bash ./mac/init-pip.sh
	bash ./mac/init-custom-stuff.sh

link: ## Create symlinks from home/ to ~/
	@DOTFILES_DIR="$$(pwd)"; \
	for item in "$$DOTFILES_DIR"/home/.* "$$DOTFILES_DIR"/home/*; do \
		name="$$(basename "$$item")"; \
		[ "$$name" = "." ] || [ "$$name" = ".." ] && continue; \
		ln -sfn "$$item" "$$HOME/$$name"; \
	done
	@echo "Symlinks created."

brew: ## Install packages via Brewfile
	command -v brew >/dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle --file=Brewfile

update: ## Update brew, npm, and system packages
	bash ~/scripts/update-stuff

lint: ## Run shellcheck on all shell scripts
	shellcheck init-mac.sh mac/*.sh mac/brew/*.sh home/scripts/*.sh home/shell.alias.sh
