#!/usr/bin/env bash

set -eo pipefail

IMAGE_URL=exdial/infra-tools

if command -v terraform &>/dev/null; then
  TERRAFORM_EXEC="terraform"
elif command -v docker &>/dev/null; then
  docker pull $IMAGE_URL
  TERRAFORM_EXEC="docker run --rm \
                  -v $(pwd):/data \
                  -e TF_DATA_DIR=/data/.terraform \
                  -e TF_PLUGIN_CACHE_DIR=/data/.terraform \
                  ${IMAGE_URL} terraform"
else
  echo "Terraform not found"
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "No files provided 👌"
  exit 0
else
  for i in "$@"; do
    echo "Validating $i ..."
    $TERRAFORM_EXEC -chdir="$(dirname "$i")" init
    $TERRAFORM_EXEC -chdir="$(dirname "$i")" validate
  done
fi
