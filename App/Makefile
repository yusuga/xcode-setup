APP_NAME := App

DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFILE_PATH := ${DIR}/Makefile
MINTFILE_PATH := ${DIR}/Mintfile
GEMFILE_PATH := ${DIR}/../Gemfile

make := make -f ${MAKEFILE_PATH}
mint-run := mint run -m ${MINTFILE_PATH}

USES_CACHE := false

.PHONY: setup setup-uses-cache 
.PHONY: setup-tools setup-carthage setup-cocoapods 
.PHONY: generate-asset-files generate-xcodeproj open 
.PHONY: clean

#default: setup

setup:
	${make} setup-tools
	${make} generate-asset-files
	${make} setup-carthage
	${make} generate-xcodeproj
	${make} open

setup-uses-cache:
	${make} setup USES_CACHE=true

setup-tools:
	brew bundle --no-upgrade --no-lock --file ${DIR}/Brewfile
	mint bootstrap -m ${MINTFILE_PATH}
	bundle install --gemfile ${GEMFILE_PATH}

setup-carthage:
ifeq ($(USES_CACHE),true)
	${mint-run} carthage bootstrap --platform iOS --no-use-binaries --cache-builds
else
	${mint-run} carthage bootstrap --platform iOS --no-use-binaries
endif

setup-cocoapods:
	bundle exec --gemfile ${GEMFILE_PATH} \
      pod install --project-directory=${DIR}

generate-asset-files:
	${mint-run} swiftgen config run --config ${DIR}/swiftgen.yml

generate-xcodeproj:
	${mint-run} xcodegen -s ${DIR}/project.yml
	${make} setup-cocoapods # Xcodeプロジェクトが生成された後に実行する必要がある

open:
	open ${DIR}/${APP_NAME}.xcworkspace

clean:
	rm -rf ${DIR}/../vendor
	rm -rf ${DIR}/${APP_NAME}.xcodeproj	
	rm -rf ${DIR}/${APP_NAME}.xcworkspace
	rm -rf ${DIR}/Carthage
	rm -rf ${DIR}/Pods