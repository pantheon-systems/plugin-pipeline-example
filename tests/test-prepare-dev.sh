#!/bin/bash
set -eou pipefail


main(){
	# shellcheck disable=SC2155
	local TEST_WORKSPACE
	TEST_WORKSPACE=$(mktemp -d /tmp/workspace_XXXXXXX)

	# Trap any exit and print the temporary workspace path back to the terminal
	trap 'echo "

	Working Directory: ${TEST_WORKSPACE}"' EXIT

	local SELF_DIRNAME
	SELF_DIRNAME="$(dirname -- "$0")"

	local REMOTE_URL
	REMOTE_URL=$(git remote get-url origin)

	local CURRENT_BRANCH
	CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

	export DRY_RUN=1
	(
		cd "$TEST_WORKSPACE"
		git clone "$REMOTE_URL" workurl
		cd workurl
		git fetch origin
		git checkout "$CURRENT_BRANCH"
		bash .bin/prepare-dev.sh
	)
}

main "$@"
