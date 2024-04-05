#!/bin/bash

set -eu
# set -x

# Get top level of git repo
git --version > /dev/null
if [ $? -ne 0 ]
then
  echo "Could not find git executable"
  exit 1
fi

top_level=$(git rev-parse --show-toplevel)

if [ -z "$top_level" ]
then
  echo "This is not a git repository"
  exit 1
fi

testbase="$(mktemp -d)"

testrepo="$testbase/repo"
mkdir -p "$testrepo"

testoutput="$testbase/output"
mkdir -p "$testoutput"

testfile="somefile"

# Setup
PATH="$top_level:$PATH"

cd  "$testrepo"

git -C "$testrepo" -c init.templatedir="I_DONT_EXIST" init
git -C "$testrepo" annex init
git -C "$testrepo" annex initremote myremote type=external encryption=none externaltype=compress-directory directory="$testoutput"

# Run default git-annex tests for remotes
git annex testremote myremote

# Check that the stored file is really zstd compressed
echo abc > "$testfile"
git annex add "$testfile"
git commit -m "Add file" "$testfile"
git annex push

file_type=$(LC_ALL=C find "$testoutput" -type f | xargs file --brief)

echo "Check that we only have compressed files in the remote's output directory"
test "$file_type" == "Zstandard compressed data (v0.8+), Dictionary ID: None" && echo "success" || echo "fail"
