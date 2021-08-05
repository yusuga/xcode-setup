MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
GEMFILE_PATH := ${MAKEFILE_DIR}/Gemfile

.PHONY: gem check-gem
.PHONY: clean
.PHONY: _update-gem
.PHONY: _fastlane-init 
.PHONY: _fastlane-match-init _fastlane-match

gem:
	bundle install --gemfile ${GEMFILE_PATH}

check-gem:
	bundle check --gemfile ${GEMFILE_PATH}
	
clean:
	rm -rf ${MAKEFILE_DIR}/vendor

_update-gem:
	bundle update --gemfile ${GEMFILE_PATH}

_fastlane-init:
	bundle exec --gemfile ${GEMFILE_PATH} fastlane init

_fastlane-match-init:
	bundle exec --gemfile ${GEMFILE_PATH} fastlane match init

_fastlane-match:
	bundle exec --gemfile ${GEMFILE_PATH} fastlane match appstore

_fastlane-build-release:
	bundle exec --gemfile ${GEMFILE_PATH} fastlane build configuration:release