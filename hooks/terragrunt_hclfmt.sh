#!/usr/bin/env bash
set -x
set -eo pipefail

IMAGE_URL=exdial/infra-tools

if command -v terragrunt &>/dev/null; then
  TERRAGRUNT_EXEC="terragrunt"
elif command -v docker &>/dev/null; then
  docker pull $IMAGE_URL
  TERRAGRUNT_EXEC="docker run --rm \
                   -v $(pwd):/data \
                   ${IMAGE_URL} terragrunt"
else
  echo "Terragrunt not found"
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "No files provided 👌"
  exit 0
else
  for i in "$@"; do
    echo "Formatting $i ..."
    $TERRAGRUNT_EXEC hclfmt --terragrunt-hclfmt-file "$i"
  done
fi
