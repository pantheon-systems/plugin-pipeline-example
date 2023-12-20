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
    if [[ "$file" == "$BASE_DIR/package-lock.json" || "$file" == "$BASE_DIR/package.json" ]];then
        echo "package and package-lock will be handled later."
        return
    fi
    if [[ "$file" == "$BASE_DIR/composer.json" || "$file" == "$BASE_DIR/composer.lock" ]];then
        echo "skip composer."
        return
    fi

    shopt -s nocasematch # make the "if readme" case insensitive
    for readme_extension in "txt" "md"; do
        if [[ "$file" == "${BASE_DIR}/readme.${readme_extension}" ]]; then
            echo "skip readmes"
            continue
        fi
    done
    shopt -u nocasematch

    echo "search-and-replace with sed"
    sed -i.tmp -e '/^\s*\* @since/!s/'"${CANONICAL_VERSION}"'/'"${NEW_DEV_VERSION}"'/g' "$file" && rm "$file.tmp"

    git add "$file"
}

git_config(){
    git config user.email "${GIT_USER}"
    git config user.name "${GIT_NAME}"
}

update_readme(){
    FILE_PATH="${1:-}"
    if [[ -z "${FILE_PATH}" ]]; then
        echo "missing file path"
        return 1
    fi

    local EXTENSION=${file#"$BASE_DIR/readme."}
    
    echo "adding new heading to readme.${EXTENSION}"

    if [[ "$EXTENSION" == "md" ]]; then # there's gotta be a better way but whatever
        local new_heading="### ${NEW_DEV_VERSION}"
        local awk_with_target='/## Changelog/ { print; print ""; print heading; print ""; next } 1'
    else
        local new_heading="= ${NEW_DEV_VERSION} ="
        local awk_with_target='/== Changelog ==/ { print; print ""; print heading; print ""; next } 1'
    fi
    awk -v heading="$new_heading" "$awk_with_target" "$FILE_PATH" > tmp.md
    mv tmp.md "$file"

    sed -i.tmp -e "s/Tested up to: ${CANONICAL_VERSION}/Tested up to: ${NEW_DEV_VERSION}/g" "$file" && rm "$file.tmp"

    git add "$file"
}

main() {
    local CANONICAL_VERSION
    CANONICAL_VERSION="$(grep 'Stable tag:' < "${CANONICAL_FILE}"  | awk '{print $3}')"

    # fetch all tags and history:
    git fetch --tags --unshallow --prune
    git branch --track main origin/main

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

    shopt -s nocasematch # make the "if readme" case insensitive
    for readme_extension in "txt" "md"; do
        if [[ -f "${BASE_DIR}/readme.${readme_extension}" ]]; then
            update_readme readme.${readme_extension}
        fi
    done
    shopt -u nocasematch

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