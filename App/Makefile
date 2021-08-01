APP_NAME := App

DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFILE_PATH := ${DIR}/Makefile
MINTFILE_PATH := ${DIR}/Mintfile
MINT_PATH := ${DIR}/.mint/lib
MINT_EXECUTABLE_FILE_PATH := ${DIR}/Mint/.build/apple/Products/Release/mint
USE_CACHE := false

make := make -f ${MAKEFILE_PATH}
make-mint := make -f ${DIR}/Mint/Makefile -C ${DIR}/Mint
mint := MINT_PATH=${MINT_PATH} ${MINT_EXECUTABLE_FILE_PATH}
mint-run := ${mint} run --mintfile ${MINTFILE_PATH}

# https://hub.docker.com/r/renovate/cocoapods
COCOAPODS_IMAGE_TAG := 1.10.1
UID := $(shell id -u root)
GID := $(shell id -g root)
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
.PHONY: clean clean-tools clean-app clean-app-caches
.PHONY: _update-carthage _update-cocoapods

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
	${make} clean-app
	${make} clean-app-caches

clean-tools:
	rm -rf ${MAKEFILE_DIR}/.mint

clean-app:
	rm -rf ${MAKEFILE_DIR}/${PRODUCT_NAME}.xcodeproj
	rm -rf ${MAKEFILE_DIR}/${PRODUCT_NAME}.xcworkspace
	rm -rf ${MAKEFILE_DIR}/Carthage
	rm -rf ${MAKEFILE_DIR}/Pods

clean-app-caches:
	find ${HOME}/Library/Developer/Xcode/DerivedData \
		-name ${APP_NAME}"*" \
		-maxdepth 1 \
		-print \
		-type d \
		-exec \
			rm -rf {} \;

_update-carthage:
ifndef L
	@echo "make _update-carthage L=<LIBRARY_NAME>"
	@exit 1
endif
	${mint-run} carthage update --use-ssh --no-build $(L)
	${make} app-using-cache

_update-cocoapods:
ifndef L
	@echo "make _update-cocoapods L=<LIBRARY_NAME>"
	@exit 1
endif
	${pod} update $(L)