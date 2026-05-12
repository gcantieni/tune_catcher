.PHONY: format analyze test coverage

format:
	dart format lib/

analyze:
	flutter analyze

test:
	flutter test

coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html
