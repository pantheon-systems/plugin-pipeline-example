

lint-shell:
	shellcheck .bin/prepare-dev.sh .bin/release-pr.sh .bin/src/*
lint: lint-shell
	composer lint

test:
	composer test