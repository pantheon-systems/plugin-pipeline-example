lint-shell:
	shellcheck .bin/release-pr.sh

lint: lint-shell
	composer lint

test:
	composer test