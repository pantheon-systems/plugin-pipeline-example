

lint-shell:
	shellcheck .bin/prepare-dev.sh .bin/release-pr.sh
lint: lint-shell
	composer lint

test:
	composer test