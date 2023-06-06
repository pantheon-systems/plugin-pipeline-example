#!/bin/bash
set -eou pipefail
IFS=$'\n\t'

# shellcheck disable=SC2155
readonly SELF_DIRNAME="$(dirname -- "$0")"
readonly BASE_DIR="${SELF_DIRNAME}/.."

main() {
    local CANONICAL_VERSION_WITH_FLAG
    CANONICAL_VERSION_WITH_FLAG="$(cat README.MD| grep 'Stable tag:' | awk '{print $3}')"
    local NEW_VERSION="${CANONICAL_VERSION_WITH_FLAG%-dev}"
    local RELEASE_BRANCH="release-${NEW_VERSION}"
    
    # if local release branch exists, delete it
    if git show-ref --quiet --verify "refs/heads/$RELEASE_BRANCH"; then
        echo "> git branch -D ${RELEASE_BRANCH}"
        git branch -D "${RELEASE_BRANCH}"
    fi

    git checkout -b "${RELEASE_BRANCH}"
    echo "Updating ${CANONICAL_VERSION_WITH_FLAG} to ${NEW_VERSION}"
    # Iterate through each file in the top-level directory
    for file in "$BASE_DIR"/*; do
        if [ -f "$file" ]; then
            echo "${file}"
            if [[ "$file" = "$BASE_DIR/package-lock.json" ]];then
                # skip package-lock and let `npm i` do it.
                echo "skipping sed of package lock"
                continue
            fi
            # Use `sed` to perform the search and replace operation in each file
            sed -i "" -e "s/${CANONICAL_VERSION_WITH_FLAG}/${NEW_VERSION}/g" "$file"
            if [[ "$file" == "$BASE_DIR/package.json" ]];then
                # TODO: This seems unsafe as we might update dependencies as well.
                #       Is it safe to just sed package-lock instead? That also seems wrong.
                echo "running 'npm i --package-lock-only' to update package-lock.json"
                npm i --package-lock-only
                git add "$BASE_DIR/package-lock.json"
            fi

            # i.e. '5 June 2023'
            # TODO: Need to think about this workflow if the PR might remain drafted for some time
            TODAYS_DATE=$(date +"%e %B %Y" | sed -e 's/^[[:space:]]*//')
            (
                shopt -s nocasematch # make the "if readme" case insensitive
                if [[ "${file}" == "$BASE_DIR/readme.txt"  ]]; then
                    echo "README FOUND!"
                    sed -i "" -e "s/= ${NEW_VERSION}/= ${NEW_VERSION} (${TODAYS_DATE})/g" "$file"
                elif [[ "${file}" == "$BASE_DIR/readme.md"  ]]; then
                    sed -i "" -e "s/# ${NEW_VERSION}/# ${NEW_VERSION} (${TODAYS_DATE})/g" "$file"
                fi
            )
            git add "$file"
        fi
    done
    RELEASE_MESSAGE="Release ${NEW_VERSION}"
    git commit -m "${RELEASE_MESSAGE}"
    git push origin "${RELEASE_BRANCH}" --force

    # Create a draft PR
    if ! gh pr view "${RELEASE_BRANCH}"; then
        gh pr create --draft --base "release" \
            --title "${RELEASE_MESSAGE}" --body "${RELEASE_MESSAGE}." \
            --label "automation" 
    fi
}

main "$@"