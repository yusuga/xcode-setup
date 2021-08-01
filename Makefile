MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
GEMFILE_PATH := ${MAKEFILE_DIR}/Gemfile

.PHONY: gem check-gem
.PHONY: clean
.PHONY: _update-gem

gem:
	bundle install --gemfile ${GEMFILE_PATH}

check-gem:
	bundle check --gemfile ${GEMFILE_PATH}
	
clean:
	rm -rf ${MAKEFILE_DIR}/vendor

_update-gem:
	bundle update --gemfile ${GEMFILE_PATH}