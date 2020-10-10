#!/usr/bin/env bash

set -u -e -o pipefail

# Call the script with argument "pack" or "publish"
readonly NPM_COMMAND=${1:-publish}
# Don't rely on $PATH to have the right version
readonly BAZEL_BIN=./node_modules/.bin/bazel
# Use a new output_base so we get a clean build
# Bazel can't know if the git metadata changed
readonly TMP=$(mktemp -d -t bazel-release.XXXXXXX)
readonly BAZEL="$BAZEL_BIN --output_base=$TMP"
# Find all the npm packages in the repo
readonly PKG_NPM_LABELS=`$BAZEL query --output=label 'kind("pkg_npm", //...)'`

# Version packages using changeset
./node_modules/.bin/changeset version

# Build them in one command to maximize parallelism
$BAZEL build $PKG_NPM_LABELS

# publish one package at a time to make it easier to spot any errors or warnings
for pkg in $PKG_NPM_LABELS ; do
  echo "ECHO $pkg.$NPM_COMMAND"
  $BAZEL run -- ${pkg}.${NPM_COMMAND} --access public --tag latest
done
