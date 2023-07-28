#!/bin/bash

LOCAL_FILE_PATH="/path_to_file"
GITHUB_REPO_BASE_URL="https://raw.githubusercontent.com/<username/repository>"
TEMP_COMPARE_FILE="temp"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Fetch all tags from the GitHub repository
TAGS=$(git ls-remote --tags https://github.com/<username>/repository.git | awk -F/ '{ print $3 }' | grep -v '\^{}')
# echo "Found tags: ${TAGS}"

for TAG in $TAGS; do
  # Print the version being tested
  echo -n "Version ${TAG} => "

  # Download the specific version based on the tag
  curl -sL "${GITHUB_REPO_BASE_URL}/${TAG}/lib/<file_name>" -o $TEMP_COMPARE_FILE
  
  # Compare the downloaded file to the local version
  if diff -q $LOCAL_FILE_PATH $TEMP_COMPARE_FILE > /dev/null; then
    echo -e "${GREEN}match${NC}"
    rm $TEMP_COMPARE_FILE
    exit 0
  else
    echo -e "${RED}not match${NC}"
  fi
done

echo "No match found"
rm $TEMP_COMPARE_FILE
