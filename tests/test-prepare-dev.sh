#!/bin/bash
set -eou pipefail

# shellcheck disable=SC2155
readonly SELF_DIRNAME="$(dirname -- "$0")"
readonly BASE_DIR="${SELF_DIRNAME}/.."

# shellcheck disable=SC1091
source "${BASE_DIR}.bin/src/functions.sh"

update_readme "${SELF_DIRNAME}/fixtures/readme-needs-dev-tag.md" 0.3.0 0.3.1-dev
