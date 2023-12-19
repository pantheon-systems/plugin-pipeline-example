#!/bin/bash
set -eou pipefail
set -x
IFS=$'\n\t'

if [[ "${DRY_RUN:-}" == 1 ]]; then
    echo "Dry Run. Will not Push."
fi

# shellcheck disable=SC2155
readonly SELF_DIRNAME="$(dirname -- "$0")"
readonly BASE_DIR="${SELF_DIRNAME}/.."

# TODO: Parameterize or make case-insensitive when this is an action
readonly CANONICAL_FILE="README.MD"
readonly GIT_USER="bot@getpantheon.com"
readonly GIT_NAME="Pantheon Automation"

readonly RELEASE_BRANCH="release"
readonly DEVELOP_BRANCH="main"

new_dev_version_from_current(){
    local CURRENT_VERSION="$1"
    IFS='.' read -ra parts <<< "$CURRENT_VERSION"
    patch="${parts[2]}"
    patch=$((patch + 1))
    INCREMENTED="${parts[0]}.${parts[1]}.${patch}-dev"
    echo "$INCREMENTED"
}

process_file(){
    local file="$1"
    if [ ! -f "$file" ]; then
        return
    fi
    echo "Checking file '${file}'..."
    if [[ "$file" == "$BASE_DIR/package-lock.json" ]];then
        # skip package-lock and let `npm i` do it when package.json is processed.
        echo "package and package-lock will be handled later."
        return
    fi



    shopt -s nocasematch # make the "if readme" case insensitive
    local file_name=${file#"$BASE_DIR/"}
    if [[ "$file_name" == "readme.txt" || "$file_name" == "readme.md"  ]]; then
        echo "adding new heading"
        if [[ "$file_name" == "readme.txt" ]]; then # there's gotta be a better way but whatever
            local new_heading="### ${NEW_DEV_VERSION}"
            local awk_with_target='/## Changelog/ { print; print ""; print heading; print ""; next } 1'
        else
            local new_heading="= ${NEW_DEV_VERSION} ="
            local awk_with_target='/== Changelog ==/ { print; print ""; print heading; print ""; next } 1'
        fi
        shopt -u nocasematch
        awk -v heading="$new_heading" "$awk_with_target" "$file" > tmp.md
        mv tmp.md "$file"
        git add "$file"
        return
    fi

    echo "search-and-replace with sed"
    sed -i.tmp -e "s/${CANONICAL_VERSION}/${NEW_DEV_VERSION}/g" "$file" && rm "$file.tmp"

    git add "$file"
}

git_config(){
    git config user.email "${GIT_USER}"
    git config user.name "${GIT_NAME}"
}

main() {
    local CANONICAL_VERSION
    CANONICAL_VERSION="$(grep 'Stable tag:' < "${CANONICAL_FILE}"  | awk '{print $3}')"
    
    # fetch all tags and history:
    if ! git rev-parse --is-shallow-repository > /dev/null; then
        git fetch --tags --unshallow --prune
    fi

    if ! git show-ref --quiet refs/heads/main && [[ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]]; then
      git branch --track main origin/main
    fi

    git checkout "${RELEASE_BRANCH}"
    git pull origin "${RELEASE_BRANCH}"
    git checkout "${DEVELOP_BRANCH}"
    git pull origin "${DEVELOP_BRANCH}"
    git rebase "${RELEASE_BRANCH}"

    local NEW_DEV_VERSION
    NEW_DEV_VERSION=$(new_dev_version_from_current "$CANONICAL_VERSION")

    echo "Updating ${CANONICAL_VERSION} to ${NEW_DEV_VERSION}"
    # Iterate through each file in the top-level directory
    for file in "$BASE_DIR"/*; do
        process_file "$file"
    done

    git_config

    git commit -m "Prepare ${NEW_DEV_VERSION}"

    if [[ -f "$BASE_DIR/package.json" ]]; then
        npm version "${NEW_DEV_VERSION}" --no-git-tag-version
    fi

    if [[ "${DRY_RUN:-}" == 1 ]]; then
        return
    fi
    git push origin "${DEVELOP_BRANCH}"
}

main "$@"