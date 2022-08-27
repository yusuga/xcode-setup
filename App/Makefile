PRODUCT_NAME := App
SCHEME_NAME := $(PRODUCT_NAME)

MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFILE_PATH := $(MAKEFILE_DIR)/Makefile
MINTFILE_PATH := $(MAKEFILE_DIR)/Mintfile
MINT_DIR := $(MAKEFILE_DIR)/.mint
MINT_LIBRARY_DIR := $(MINT_DIR)/lib
SWIFT_PACKAGES_PATH := $(MAKEFILE_DIR)/SwiftPackages
SWIFT_PACKAGES_BUILD_PATH := $(SWIFT_PACKAGES_PATH)/.build
MINT_EXECUTABLE := xcrun -sdk macosx swift run --package-path $(SWIFT_PACKAGES_PATH) mint
XCODEPROJ_PATH := $(MAKEFILE_DIR)/$(PRODUCT_NAME).xcodeproj
XCWORKSPACE_PATH := $(MAKEFILE_DIR)/$(PRODUCT_NAME).xcworkspace
USE_CACHE := false

make := make -f $(MAKEFILE_PATH)
mint := MINT_PATH=$(MINT_LIBRARY_DIR) $(MINT_EXECUTABLE)
mint_run := $(mint) run --mintfile $(MINTFILE_PATH)

# https://hub.docker.com/r/renovate/cocoapods
COCOAPODS_IMAGE_TAG := 1.11.2
UID := $(shell id -u root)
GID := $(shell id -g root)
pod := docker run \
	--rm \
	-v $(MAKEFILE_DIR):/local \
	-w /local \
	-u $(UID):$(GID) \
	renovate/cocoapods:$(COCOAPODS_IMAGE_TAG) \
		pod --allow-root

.PHONY: app app_using_cache
.PHONY: mint mint_which mint_run mint_execute
.PHONY: carthage cocoapods 
.PHONY: asset_files xcodeproj spm xcworkspace open 
.PHONY: clean clean_tools clean_app clean_app_caches
.PHONY: _update_carthage _update_cocoapods

default: app

app:
	$(make) mint
	$(make) carthage
	$(make) asset_files
	$(make) xcodeproj
	$(make) cocoapods
	$(make) spm
	$(make) xcworkspace
	$(make) open

app_using_cache:
	$(make) app USE_CACHE=true

mint:
	$(mint) bootstrap --mintfile $(MINTFILE_PATH)

mint_which:
	$(make) mint_execute COMMAND='which'

mint_run:
	$(make) mint_execute COMMAND='run'

mint_execute:
ifndef COMMAND
	@echo "make mint_execute COMMAND=<コマンドを指定してください>\n例: make mint_execute COMMAND=run"
	@exit 1
endif
ifndef OPTIONS
	@echo "make mint_execute $(COMMAND) OPTIONS=<オプションを指定してください>\n例: make mint_execute COMMAND=run OPTIONS=xcodegen"
	@exit 1
endif
	$(mint) $(COMMAND) --mintfile $(MINTFILE_PATH) $(OPTIONS)

carthage:
ifeq ($(USE_CACHE),true)
	$(mint_run) carthage bootstrap --platform iOS --no-use-binaries --use-xcframeworks --cache-builds
else
	$(mint_run) carthage bootstrap --platform iOS --no-use-binaries --use-xcframeworks
endif

cocoapods:
	$(pod) install

asset_files:
	$(mint_run) swiftgen config run --config $(MAKEFILE_DIR)/swiftgen.yml

xcodeproj:
	$(mint_run) xcodegen -s $(MAKEFILE_DIR)/project.yml

spm:
	xcodebuild -project $(XCODEPROJ_PATH) -scheme $(SCHEME_NAME) -resolvePackageDependencies

xcworkspace:
	$(make) cocoapods # Xcodeプロジェクトが生成された後に実行する必要がある

open:
	xed $(MAKEFILE_DIR)

clean:
	$(make) clean_tools
	$(make) clean_app
	$(make) clean_app_caches

clean_tools:
	rm -rf $(SWIFT_PACKAGES_BUILD_PATH)
	rm -rf $(MINT_DIR)

clean_app:
	rm -rf $(XCODEPROJ_PATH)
	rm -rf $(XCWORKSPACE_PATH)
	rm -rf $(MAKEFILE_DIR)/Carthage
	rm -rf $(MAKEFILE_DIR)/Pods

clean_app_caches:
	find $(HOME)/Library/Developer/Xcode/DerivedData \
		-name $(PRODUCT_NAME)"*" \
		-maxdepth 1 \
		-print \
		-type d \
		-exec \
			rm -rf {} \;

_update_carthage:
ifndef L
	@echo "make _update_carthage L=<LIBRARY_NAME>"
	@exit 1
endif
	$(mint_run) carthage update --use-ssh --no-build $(L)
	$(make) app_using_cache

_update_cocoapods:
ifndef L
	@echo "make _update_cocoapods L=<LIBRARY_NAME>"
	@exit 1
endif
	$(pod) update $(L)