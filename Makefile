# SmerpGO Flutter app — common developer tasks
#
# Usage:
#   make help
#   make get
#   make test
#   make run
#   make apk / make aab / make ios

FLUTTER ?= flutter
DART ?= dart

.DEFAULT_GOAL := help

.PHONY: help get deps clean doctor format analyze test test-core \
	run run-release apk apk-debug aab ios pods signing

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*##"; printf "\nTargets:\n"} \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

get: ## Install Flutter/Dart dependencies
	$(FLUTTER) pub get

deps: get ## Alias for get

clean: ## Remove build artifacts and regenerated files
	$(FLUTTER) clean
	$(FLUTTER) pub get

doctor: ## Run Flutter doctor
	$(FLUTTER) doctor -v

format: ## Format Dart sources under lib/ and test/
	$(DART) format lib test

analyze: ## Static analysis
	$(FLUTTER) analyze

test: ## Run all unit/widget tests
	$(FLUTTER) test

test-core: ## Run core modernization tests only
	$(FLUTTER) test test/core

run: ## Run debug build on a connected device/emulator
	$(FLUTTER) run

run-release: ## Run a release build on a connected device/emulator
	$(FLUTTER) run --release

apk: ## Build release APK
	$(FLUTTER) build apk --release

apk-debug: ## Build debug APK
	$(FLUTTER) build apk --debug

aab: ## Build release Android App Bundle (Play Store)
	$(FLUTTER) build appbundle --release

ios: ## Build release iOS (no codesign; use Xcode for distribution)
	$(FLUTTER) build ios --release --no-codesign

pods: ## Reinstall iOS CocoaPods
	cd ios && pod install --repo-update

signing: ## Interactive Android release signing setup
	./android/setup_release_signing.sh
