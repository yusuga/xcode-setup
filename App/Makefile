APP_NAME := App

DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFILE_PATH := ${DIR}/Makefile
MINTFILE_PATH := ${DIR}/Mintfile
MINT_PATH := ${DIR}/.mint/lib
MINT_EXECUTABLE_FILE_PATH := ${DIR}/tools/Mint/.build/apple/Products/Release/mint
USE_CACHE := false

UID := $(shell id -u root)
GID := $(shell id -g root)

# https://hub.docker.com/r/renovate/cocoapods
COCOAPODS_IMAGE_TAG := 1.10.1

make := make -f ${MAKEFILE_PATH}
make-mint := make -f ${DIR}/tools/Mint/Makefile -C ${DIR}/tools/Mint
mint := MINT_PATH=${MINT_PATH} ${MINT_EXECUTABLE_FILE_PATH}
mint-run := ${mint} run --mintfile ${MINTFILE_PATH}
pod := docker run \
		--rm \
		-v ${DIR}:/local \
		-w /local \
		-u $(UID):$(GID) \
		renovate/cocoapods:${COCOAPODS_IMAGE_TAG} \
			pod --allow-root

.PHONY: app app-using-cache 
.PHONY: git-submodule mint carthage cocoapods 
.PHONY: asset-files xcodeproj xcworkspace open 
.PHONY: clean clean-tools clean-client clean-client-caches
.PHONY: _update-carthage _update-cocoapods
.PHONY: _init-fastlane

default: app

app:
	${make} git-submodule
	${make} mint
	${make} asset-files
	${make} carthage
	${make} xcworkspace
	${make} open

app-using-cache:
	${make} app USE_CACHE=true

git-submodule:
	git submodule update --init --recursive

mint:
	if [ ! -f "${MINT_EXECUTABLE_FILE_PATH}" ]; then ${make-mint} build; fi;
	${mint} bootstrap --mintfile ${MINTFILE_PATH}

carthage:
ifeq ($(USE_CACHE),true)
	${mint-run} carthage bootstrap --platform iOS --no-use-binaries --use-xcframeworks --cache-builds
else
	${mint-run} carthage bootstrap --platform iOS --no-use-binaries --use-xcframeworks
endif

cocoapods:
	${pod} install

asset-files:
	${mint-run} swiftgen config run --config ${DIR}/swiftgen.yml

xcodeproj:
	${mint-run} xcodegen -s ${DIR}/project.yml

xcworkspace:
	${make} xcodeproj
	${make} cocoapods # Xcodeプロジェクトが生成された後に実行する必要がある

open:
	open ${DIR}/${APP_NAME}.xcworkspace

clean:
	${make} clean-tools
	${make} clean-client
	${make} clean-client-caches

clean-tools:
	rm -rf ${MAKEFILE_DIR}/.mint

clean-client:
	rm -rf ${MAKEFILE_DIR}/${PRODUCT_NAME}.xcodeproj
	rm -rf ${MAKEFILE_DIR}/${PRODUCT_NAME}.xcworkspace
	rm -rf ${MAKEFILE_DIR}/Carthage
	rm -rf ${MAKEFILE_DIR}/Pods

clean-client-caches:
	find ${HOME}/Library/Developer/Xcode/DerivedData \
		-name ${APP_NAME}"*" \
		-maxdepth 1 \
		-print \
		-type d \
		-exec \
			rm -rf {} \;

_update-carthage:
ifndef L
	@echo "make _update-carthage L=<ライブラリ名を指定してください>"
	@exit 1
endif
	${mint-run} carthage update --use-ssh --no-build $(L)
	${make} app-using-cache

_update-cocoapods:
ifndef L
	@echo "make _update-cocoapods L=<ライブラリ名を指定してください>"
	@exit 1
endif
	${pod} update

_init-fastlane:
	bundle exec --gemfile ${DIR}/../Gemfile fastlane init