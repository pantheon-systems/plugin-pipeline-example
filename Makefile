lint:
	shellcheck .bin/prepare-dev.sh .bin/release-pr.sh
	composer lint