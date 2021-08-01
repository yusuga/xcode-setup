APP_NAME := App

DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFILE_PATH := ${DIR}/Makefile
MINTFILE_PATH := ${DIR}/Mintfile
GEMFILE_PATH := ${DIR}/../Gemfile

make := make -f ${MAKEFILE_PATH}
mint-run := mint run -m ${MINTFILE_PATH}
bundle-exec := bundle exec --gemfile ${GEMFILE_PATH}

USE_CACHE := false

.PHONY: app app-using-cache 
.PHONY: tools carthage cocoapods 
.PHONY: asset-files xcodeproj open 
.PHONY: clean

default: app

app:
	${make} tools
	${make} asset-files
	${make} carthage
	${make} xcodeproj
	${make} open

app-using-cache:
	${make} app USE_CACHE=true

tools:
	brew bundle --no-upgrade --no-lock --file ${DIR}/Brewfile
	mint bootstrap -m ${MINTFILE_PATH}
	bundle install --gemfile ${GEMFILE_PATH}

carthage:
ifeq ($(USE_CACHE),true)
	${mint-run} carthage bootstrap --platform iOS --no-use-binaries --use-xcframeworks --cache-builds
else
	${mint-run} carthage bootstrap --platform iOS --no-use-binaries --use-xcframeworks
endif

cocoapods:
	${bundle-exec} pod install --project-directory=${DIR}

asset-files:
	${mint-run} swiftgen config run --config ${DIR}/swiftgen.yml

xcodeproj:
	${mint-run} xcodegen -s ${DIR}/project.yml
	${make} cocoapods # Xcodeプロジェクトが生成された後に実行する必要がある

open:
	open ${DIR}/${APP_NAME}.xcworkspace

clean:
	rm -rf ${DIR}/../vendor
	rm -rf ${DIR}/${APP_NAME}.xcodeproj	
	rm -rf ${DIR}/${APP_NAME}.xcworkspace
	rm -rf ${DIR}/Carthage
	rm -rf ${DIR}/Pods

_update-carthage:
ifndef L
	@echo "make _update-carthage L=<ライブラリ名を指定してください>"
	@exit 1
endif
	${mint_run} carthage update --use-ssh --no-build $(L)
	${make} app-using-cache

_update-cocoapods:
ifndef L
	@echo "make _update-cocoapods L=<ライブラリ名を指定してください>"
	@exit 1
endif
	${pod} update ${L}