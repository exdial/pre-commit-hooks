# README

[Pre-commit](http://pre-commit.com) hooks for projects using [Packer](https://packer.io)

## Available hooks

| **Hook name**        | **Description**                                           |
|----------------------|-----------------------------------------------------------|
| `packer-validate`    | Checks packer template is valid.                          |
| `packer-fmt`         | Rewrites packer template files to canonical format.       |
| `terraform-validate` | Checks terraform configuration is valid.                  |
| `terraform-fmt`      | Reformat terraform configuration in the standard style.   |
| `terragrunt-hclfmt`  | Rewrite terragrunt configuration into a canonical format. |

## Usage

```yaml
repos:
  - repo: https://github.com/exdial/pre-commit-hooks
    rev: <VERSION> # Get the latest from: https://github.com/exdial/pre-commit-hooks/releases
    hooks:
      - id: packer-validate
      - id: packer-fmt
      - id: terraform-validate
      - id: terraform-fmt
      - id: terragrunt-hclfmt
```

### Usage options

This repository provides Docker image `exdial/infra-tools`, which
contains all the tools required by pre-commit hooks. So you don't need
to install these tools locally. Pull the Docker image in advance to
speed up pre-commit checks. `docker pull exdial/infra-tools`
