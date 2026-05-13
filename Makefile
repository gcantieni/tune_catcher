.PHONY: format analyze test coverage lcov bump publish-ios publish-macos publish-android

format:
	dart format lib/

analyze:
	flutter analyze

test:
	flutter test

lcov:
	flutter test --coverage

coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

bump:
	@bash scripts/bump_version.sh $(if $(MAJOR),major,$(if $(MINOR),minor,patch))

publish-ios:
	@bash scripts/publish.sh ios

publish-macos:
	@bash scripts/publish.sh macos

publish-android:
	@bash scripts/publish.sh android
