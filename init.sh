#!/bin/bash

new_name="ab-c"

usage() {
  echo "Usage: $0 [-n|--new_name[=]NEW_NAME]"
  echo "  -n, --new_name[=]NEW_NAME  Set the new project name (default: ab-c)"
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case $1 in
    -n | --new_name | --new_name=*)
      new_name="${1#*=}"
      [ "$new_name" = "$1" ] && {
        shift
        new_name="$1"
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

short_new_name=$(echo $new_name | sed 's/-//g')

find . -depth -name "*cpptemplate*" -execdir rename "s/cpptemplate/$short_new_name/g" {} +
find . -type f -exec sed -i "s/cpptemplate/$short_new_name/g" {} +
find . -type f -exec sed -i "s/cpp-template/$new_name/g" {} +
