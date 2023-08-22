#!/usr/bin/env bash

set -eo pipefail

IMAGE_URL=exdial/infra-tools

if command -v packer &>/dev/null; then
  PACKER_EXEC="packer"
elif command -v docker &>/dev/null; then
  docker pull $IMAGE_URL
  PACKER_EXEC="docker run --rm ${IMAGE_URL} packer"
else
  echo "Packer not found"
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "No files provided 👌"
  exit 0
else
  for i in "$@"; do
    pushd "$(dirname "$i")" &>/dev/null
    echo "Formatting $i ..."
    $PACKER_EXEC fmt -write=false "$(basename "$i")"
    popd &>/dev/null
  done
fi
