#!/usr/bin/env bash

set -eo pipefail

if [ $# -lt 1 ]; then
  echo "No files provided 👌"
  exit 0
fi

if command -v packer &>/dev/null; then
  for i in "$@"; do
    pushd "$(dirname "$i")" &>/dev/null
    echo "Formatting $i ..."
    packer fmt -write=false "$(basename "$i")"
    popd &>/dev/null
  done
else
  echo "Packer not found"
fi
