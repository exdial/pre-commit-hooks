#!/usr/bin/env bash

set -eo pipefail

IMAGE_URL=exdial/infra-tools

if command -v terraform &>/dev/null; then
  TERRAFORM_EXEC="terraform"
elif command -v docker &>/dev/null; then
  docker pull $IMAGE_URL
  TERRAFORM_EXEC="docker run --rm -it ${IMAGE_URL} terraform"
else
  echo "Terraform not found"
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "No files provided 👌"
  exit 0
else
  for i in "$@"; do
    pushd "$(dirname "$i")" &>/dev/null
    echo "Formatting $i ..."
    $TERRAFORM_EXEC fmt -diff -check "$(basename "$i")"
    popd &>/dev/null
  done
fi
