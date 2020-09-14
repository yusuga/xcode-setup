PRODUCT_NAME := App
# https://stackoverflow.com/a/23324703
DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
GEMFILE_PATH := ${DIR}/../Gemfile
USES_CACHE := false

.PHONY: setup
setup:
	make setup-tools
	make generate-asset-files
	make setup-carthage
	make generate-xcodeproj
	make open-xcode

.PHONY: setup-uses-cache
setup-uses-cache:
	make setup USES_CACHE=true

.PHONY: setup-tools
setup-tools:
	brew bundle --no-upgrade --no-lock
	mint bootstrap
	bundle install --gemfile ${GEMFILE_PATH}

.PHONY: setup-carthage
setup-carthage:
ifeq ($(USES_CACHE),true)
	mint run carthage bootstrap --platform iOS --no-use-binaries --cache-builds
else
	mint run carthage bootstrap --platform iOS --no-use-binaries
endif

.PHONY: setup-cocoapods
setup-cocoapods:
	bundle exec --gemfile ${GEMFILE_PATH} pod install

.PHONY: generate-asset-files
generate-asset-files:
	mint run swiftgen

.PHONY: generate-xcodeproj
generate-xcodeproj:
	mint run xcodegen
	make setup-cocoapods # Xcodeプロジェクトが生成された後に実行する必要がある

.PHONY: open-xcode
open-xcode:
	open ${DIR}/${PRODUCT_NAME}.xcworkspace

.PHONY: reset
reset:
	rm -rf ${DIR}/../vendor
	rm -rf ${DIR}/${PRODUCT_NAME}.xcodeproj	
	rm -rf ${DIR}/${PRODUCT_NAME}.xcworkspace
	rm -rf ${DIR}/Carthage
	rm -rf ${DIR}/Pods