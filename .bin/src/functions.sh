#!/bin/bash
# no flags here, always source this file


##
# Expected Global Variables:
# - BASE_DIR
##
# echo to stderr with info tag
echo_info(){
	echo  "[Info] $*" >&2
}

# echo to stderr with info tag
echo_error(){
	echo  "[Error] $*" >&2
}

new_dev_version_from_current(){
    local CURRENT_VERSION="${1:-}"
    if [[ -z "$CURRENT_VERSION" ]]; then
		echo_error "No version passed to new_dev_version_from_current()"
    	return 1
    fi

    IFS='.' read -ra parts <<< "$CURRENT_VERSION"
    local patch="${parts[2]}"
    patch=$((patch + 1))
    local INCREMENTED="${parts[0]}.${parts[1]}.${patch}-dev"
    echo "$INCREMENTED"
}

git_config(){
    git config user.email "${GIT_USER}"
    git config user.name "${GIT_NAME}"
}

update_readme(){
    local FILE_PATH="${1:-}"
    local OLD_VERSION="${2:-}"
    local NEW_VERSION="${3:-}"
    if [[ -z "${FILE_PATH}" || -z "${OLD_VERSION}" || -z "${NEW_VERSION}" ]]; then
        echo_error "usage: update_readme FILE_PATH OLD_VERSION NEW_VERSION"
        return 1
    fi

    local EXTENSION=${FILE_PATH#"$BASE_DIR/readme."}
    
    echo_info "adding new heading to readme.${EXTENSION}"
    shopt -s nocasematch # make the "if" case insensitive
    if [[ "$EXTENSION" == "md" ]]; then # there's gotta be a better way but whatever
        echo_info "markdown search-replace"
        local new_heading="### ${NEW_VERSION}"
        local awk_with_target='/## Changelog/ { print; print ""; print heading; print ""; next } 1'
    else
        echo_info "wp.org txt search-replace"
        local new_heading="= ${NEW_VERSION} ="
        local awk_with_target='/== Changelog ==/ { print; print ""; print heading; print ""; next } 1'
    fi
    shopt -u nocasematch

    awk -v heading="$new_heading" "$awk_with_target" "$FILE_PATH" > tmp.md
    mv tmp.md "$FILE_PATH"

    sed -i.tmp -e "s/Tested up to: ${OLD_VERSION}/Tested up to: ${NEW_VERSION}/g" "$FILE_PATH" && rm "$FILE_PATH.tmp"

    git add "$FILE_PATH"
}