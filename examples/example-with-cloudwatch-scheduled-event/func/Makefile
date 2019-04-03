NAME := example-lambda-func

VERSION ?= $(shell cat VERSION.txt)
REGION ?= eu-west-1
ENVIRONMENT ?= production
S3_BUCKET := tf-$(NAME)-deployment-$(REGION)

all: package

.PHONY: build
build: ## Builds cross-compiled function
	@echo "+ $@"
	@GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build .

.PHONY: package
package: build ## Creates and uploads deployment package to S3
	@echo "+ $@"
	@echo "Uploading release $(VERSION)"
	@zip -j $(NAME).zip $(NAME)
	@aws s3 cp $(NAME).zip s3://$(S3_BUCKET)/$(VERSION)/$(NAME).zip --region=$(REGION)

.PHONY: s3-init
s3-init: ## Creates AWS S3 bucket for deployments
	@echo "+ $@"
	@aws s3api create-bucket \
	--bucket=$(S3_BUCKET) \
	--create-bucket-configuration LocationConstraint=$(REGION) \
	--region=$(REGION)

.PHONY: s3-destroy
s3-destroy: ## Removes AWS S3 bucket including all deployments
	@echo "+ $@"
	@echo s3://$(S3_BUCKET)
	@aws s3 rb s3://$(S3_BUCKET) --force

.PHONY: clean
clean: ## Cleanup any build binaries or packages
	@echo "+ $@"
	$(RM) $(NAME)*

.PHONY: help
help: ## Display this help screen
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'		
