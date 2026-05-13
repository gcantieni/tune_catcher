.PHONY: format analyze test coverage lcov bump publish-ios publish-macos publish-android deps run-macos run-ios

format:
	dart format lib/

analyze:
	flutter analyze

run-macos:
	flutter run -d macos --no-pub --dart-define=MOCK_MUSICKIT=true

run-ios:
	flutter run -d iPhone --no-pub

deps:
	flutter pub get

test:
	flutter test --no-pub

lcov:
	flutter test --coverage --no-pub

coverage:
	flutter test --coverage --no-pub
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
