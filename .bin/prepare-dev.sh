#!/bin/bash
set -eou pipefail
IFS=$'\n\t'

# shellcheck disable=SC2155
readonly SELF_DIRNAME="$(dirname -- "$0")"
readonly BASE_DIR="${SELF_DIRNAME}/.."

# TODO: Parameterize or make case-insensitive when this is an action
readonly CANONICAL_FILE="README.MD"
readonly GIT_USER="bot@getpantheon.com"
readonly GIT_NAME="Pantheon Automation"

readonly RELEASE_BRANCH="release"
readonly DEVELOP_BRANCH="alt-main"

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
    if [[ "$file" = "$BASE_DIR/package-lock.json" ]];then
        # skip package-lock and let `npm i` do it when package.json is processed.
        echo "skipping sed of package lock"
        return
    fi

    (
        shopt -s nocasematch # make the "if readme" case insensitive
        if [[ "${file}" == "$BASE_DIR/readme.txt"  ]]; then
            echo "adding new heading"
            new_heading="### ${NEW_DEV_VERSION}"
            awk -v heading="$new_heading" '/## Changelog/ { print; print ""; print heading; print ""; next } 1' "$file" > tmp.md
            mv tmp.md "$file"
            git add "$file"
            return
        elif [[ "${file}" == "$BASE_DIR/readme.md"  ]]; then
            echo "adding new heading"
            new_heading="= ${NEW_DEV_VERSION} ="
            awk -v heading="$new_heading" '/== Changelog ==/ { print; print ""; print heading; print ""; next } 1' "$file" > tmp.md
            mv tmp.md "$file"
            git add "$file"
            return
        fi
    )

    echo "search-and-replace with sed"
    # Use `sed` to perform the search and replace operation in each file
    sed -i.tmp -e "s/${CANONICAL_VERSION}/${NEW_DEV_VERSION}/g" "$file" && rm "$file.tmp"
    if [[ "$file" == "$BASE_DIR/package.json" ]];then
        # TODO: This seems unsafe as we might update dependencies as well.
        #       Is it safe to just sed package-lock instead? That also seems wrong.
        echo "running 'npm i --package-lock-only' to update package-lock.json"
        npm i --package-lock-only
        git add "$BASE_DIR/package-lock.json"
    fi

    git add "$file"
}

main() {
    local CANONICAL_VERSION
    CANONICAL_VERSION="$(grep 'Stable tag:' < "${CANONICAL_FILE}"  | awk '{print $3}')"
    
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
    # Who am I?
    git config user.email "${GIT_USER}"
    git config user.name "${GIT_NAME}"

    git commit -m "Prepare ${NEW_DEV_VERSION}"
    git push origin "${DEVELOP_BRANCH}"
}

main "$@"