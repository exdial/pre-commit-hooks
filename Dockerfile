# syntax=docker/dockerfile:1
ARG ALPINE_VERSION=${ALPINE_VERSION:-3.18.0}

# STAGE 1: builder
FROM alpine:${ALPINE_VERSION} as builder

ARG PACKER_VERSION=${PACKER_VERSION:-latest}
ARG TERRAFORM_VERSION=${TERRAFORM_VERSION:-latest}
ARG TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION:-latest}

ARG HASHICORP_URL="https://releases.hashicorp.com"
ARG GRUNTWORK_URL="https://github.com/gruntwork-io"
ARG HASHICORP_API="https://api.github.com/repos/hashicorp"
ARG GRUNTWORK_API="https://api.github.com/repos/gruntwork-io"

WORKDIR /build

RUN apk add --no-cache --update curl unzip jq

# Packer
RUN : && \
 if [ "${PACKER_VERSION}" = "latest" ]; then \
   PACKER_VERSION="$(curl -s ${HASHICORP_API}/packer/releases/latest | jq -r .tag_name | tr -d 'v')" \
 ; fi \
 && curl -Lo packer.zip \
  ${HASHICORP_URL}/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
 && unzip packer.zip && rm packer.zip

# Terraform
RUN : && \
 if [ "${TERRAFORM_VERSION}" = "latest" ]; then \
   TERRAFORM_VERSION="$(curl -s ${HASHICORP_API}/terraform/releases/latest | jq -r .tag_name | tr -d 'v')" \
 ; fi \
 && curl -Lo terraform.zip \
  ${HASHICORP_URL}/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && unzip terraform.zip && rm terraform.zip

# Terragrunt
RUN : && \
 if [ "${TERRAGRUNT_VERSION}" = "latest" ]; then \
   TERRAGRUNT_VERSION="$(curl -s ${GRUNTWORK_API}/terragrunt/releases/latest | jq -r .tag_name | tr -d 'v')" \
 ; fi \
 && curl -Lo terragrunt \
  ${GRUNTWORK_URL}/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64

RUN chmod +x packer terraform terragrunt


# STAGE 2: final
FROM alpine:3.18.3

ARG IMAGE_CREATE_DATE
ARG IMAGE_VERSION

# Metadata as defined in OCI image spec annotations
# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.title="infra tools" \
      org.opencontainers.image.description="infra tools" \
      org.opencontainers.image.authors="github.com/exdial" \
      org.opencontainers.image.created=$IMAGE_CREATE_DATE \
      org.opencontainers.image.version=$IMAGE_VERSION

WORKDIR /usr/local/bin

COPY --from=builder /build/* /usr/local/bin/

CMD ["exec", "$@"]
