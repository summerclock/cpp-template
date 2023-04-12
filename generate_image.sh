#!/bin/bash

VERSION_REGEX='(?<=project\(cpp-template VERSION[ \\t]).+(?=\))'
BASEDIR=$(dirname "$0")

CMD_GETVER_STR="cat $BASEDIR"/CMakeLists.txt" | grep -P "\'$VERSION_REGEX\'" -o"
echo "- Execute command: ""$CMD_GETVER_STR"
ALGO_VERSION=$(eval "$CMD_GETVER_STR")
echo "$ALGO_VERSION"
CMD_BUILD_STR="cd $BASEDIR && DOCKER_BUILDKIT=1 docker build --target release -t=cpp-template:v$ALGO_VERSION ."
echo "- Execute command: ""$CMD_BUILD_STR"
eval "$CMD_BUILD_STR"

unset VERSION_REGEX BASEDIR CMD_BUILD_STR ALGO_VERSION