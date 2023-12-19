

lint-shell:
	shellcheck .bin/prepare-dev.sh .bin/release-pr.sh
lint: lint-shell
	composer lint

test-prepare-dev:
	bash test/test-prepare-dev.sh

test-pdev: test-prepare-dev

test:
	composer test