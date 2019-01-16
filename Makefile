VERSION := $(shell cat VERSION.txt)
PREFIX?=$(shell pwd)
EXAMPLES_DIR := examples

all: init fmt validate

.PHONY: init
init: ## Initialize a Terraform working directory
	@echo "+ $@"
	@terraform init

.PHONY: fmt
fmt: ## Rewrites config files to canonical format
	@echo "+ $@"
	@terraform fmt -check=true

.PHONY: validate
validate: ## Validates the Terraform files
	@echo "+ $@"
	@AWS_REGION=eu-west-1 terraform validate \
	-var function_name=test_function \
	-var handler=handler \
	-var s3_bucket=bucket \
	-var s3_key=key

.PHONY: test
test: ## Validates and generates execution plan for all examples.
	@echo "+ $@"	
	@for dir in `ls $(EXAMPLES_DIR)`; do \
		cd $(PREFIX)/$(EXAMPLES_DIR)/$$dir; \
		terraform init > /dev/null; \
		terraform validate; \
		terraform plan > /dev/null; \
		echo "√ $$dir"; \
		rm -rf $(PREFIX)/$(EXAMPLES_DIR)/$$dir/.terraform; \
	done

.PHONY: tag
tag: ## Create a new git tag to prepare to build a release
	git tag -a $(VERSION) -m "$(VERSION)"
	@echo "Run git push origin $(VERSION) to push your new tag to GitHub and trigger a build."


.PHONY: bump-version
BUMP := patch
bump-version: ## Bump the version in the version file. Set BUMP to [ patch | major | minor ].
	@GO111MODULE=off go get -u github.com/jessfraz/junk/sembump
	$(eval NEW_VERSION = $(shell sembump --kind $(BUMP) $(VERSION)))
	@echo "Bumping VERSION.txt from $(VERSION) to $(NEW_VERSION)"
	echo $(NEW_VERSION) > VERSION.txt
	@echo "Updating links in README.md"
	sed -i s/$(subst v,,$(VERSION))/$(subst v,,$(NEW_VERSION))/g README.md
	git add VERSION.txt README.md
	git commit -vsam "Bump version to $(NEW_VERSION)"
	@echo "Run make tag to create and push the tag for new version $(NEW_VERSION)"

.PHONY: help
help: ## Display this help screen
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'	