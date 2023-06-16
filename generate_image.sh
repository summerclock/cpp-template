#!/bin/bash

prefix=""
target="release"
options=""
buildkit=1

usage() {
  echo "Usage: $0 [-p|--prefix[=]PREFIX] [-t|--target[=]TARGET]"
  echo "  -p, --prefix[=]PREFIX  Set the prefix (default: "")"
  echo "  -b, --buildkit[=]BUILDKIT  Set the buildkit (default: 1)"
  echo "  -o, --options[=]OPTIONS  Set the options (default: "")"
  echo "  -t, --target[=]TARGET  Set the target (default: release)"
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case $1 in
    -p | --prefix | --prefix=*)
      prefix="${1#*=}"
      [ "$prefix" = "$1" ] && {
        shift
        prefix="$1"
      }
      ;;
    -b | --buildkit | --buildkit=*)
      buildkit="${1#*=}"
      [ "$buildkit" = "$1" ] && {
        shift
        buildkit="$1"
      }
      ;;
    -t | --target | --target=*)
      target="${1#*=}"
      [ "$target" = "$1" ] && {
        shift
        target="$1"
      }
      ;;
    -o | --options | --options=*)
      options="${1#*=}"
      [ "$options" = "$1" ] && {
        shift
        options="$1"
      }
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    esac
    shift
  done
}

parse_args "$@"

# Check if the variables have been set
if [ -z "$target" ]; then
  echo "target required"
  exit 1
fi

VERSION_REGEX='(?<=project\(cpp-template VERSION[ \\t]).+(?=\))'
BASEDIR=$(dirname "$0")

CMD_GETVER_STR="cat $BASEDIR"/CMakeLists.txt" | grep -P "\'$VERSION_REGEX\'" -o"
echo "- Execute command: ""$CMD_GETVER_STR"
ALGO_VERSION=$(eval "$CMD_GETVER_STR")
echo "$ALGO_VERSION"
CMD_BUILD_STR="cd $BASEDIR && DOCKER_BUILDKIT=$buildkit docker build $options --target $target -t="$prefix"cpp-template:v$ALGO_VERSION ."
echo "- Execute command: ""$CMD_BUILD_STR"
eval "$CMD_BUILD_STR"

unset VERSION_REGEX BASEDIR CMD_BUILD_STR ALGO_VERSION
