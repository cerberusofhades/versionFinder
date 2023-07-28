#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Input validation
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <local_file> <repo_name> <repo_file_path> [-r]" >&2
    exit 1
fi

LOCAL_FILE_PATH=$1
REPO_NAME=$2
REPO_FILE_PATH=$3
GIT_REPO_URL="https://github.com/${REPO_NAME}.git"
GITHUB_REPO_BASE_URL="https://raw.githubusercontent.com/${REPO_NAME}"
CHECKSUM_LOCAL=$(md5sum ${LOCAL_FILE_PATH} | awk '{ print $1 }')

# Extract the file name from the local file path
FILE_NAME=$(basename ${LOCAL_FILE_PATH})

function check_version() {
    VERSION=$1
    printf "Version ${VERSION} => "
    FILE_URL="${GITHUB_REPO_BASE_URL}/${VERSION}${REPO_FILE_PATH}/${FILE_NAME}"
    CHECKSUM_REMOTE=$(curl -s ${FILE_URL} | md5sum | awk '{ print $1 }')
    if [[ "$CHECKSUM_REMOTE" == "$CHECKSUM_LOCAL" ]]; then
        printf "${GREEN}match${NC}\n"
        exit 0
    else
        printf "${RED}not match${NC}\n"
    fi
}

# Check for reverse order
REVERSE=""
if [[ $4 == "-r" ]]; then
    REVERSE="-r"
fi

# Set GIT_TERMINAL_PROMPT to 0 to avoid prompt for authentication in the terminal
export GIT_TERMINAL_PROMPT=0

VERSIONS=$(git ls-remote --tags ${GIT_REPO_URL} 2>/dev/null | awk -F/ '{ print $3 }' | grep -v {} | sort -V ${REVERSE})

# Check if the repo was accessible
if [ -z "$VERSIONS" ]; then
    echo "Repository ${REPO_NAME} does not exist or is not accessible."
    exit 1
fi

for VERSION in $VERSIONS; do
    check_version $VERSION
done
