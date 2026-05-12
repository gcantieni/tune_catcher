.PHONY: format analyze test coverage lcov

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
