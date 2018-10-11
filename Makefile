VERSION := $(shell cat VERSION.txt)

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
	-var name=test \
	-var function_name=test_function \
	-var s3_bucket=bucket \
	-var s3_key=key

.PHONY: tag
tag: ## Create a new git tag to prepare to build a release
	git tag -a $(VERSION) -m "$(VERSION)"
	@echo "Run git push origin $(VERSION) to push your new tag to GitHub and trigger a build."

.PHONY: help
help: ## Display this help screen
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'	