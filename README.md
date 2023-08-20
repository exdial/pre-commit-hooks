# README

[Pre-commit](http://pre-commit.com) hooks for projects using [Packer](https://packer.io)

## Available hooks

| **Hook name**     | **Description**                                 |
|-------------------|-------------------------------------------------|
| `packer-validate` | Checks packer template is valid.                |
| `packer-fmt`      | Rewrites HCL2 config files to canonical format. |

## Usage

```yaml
repos:
  - repo: https://github.com/exdial/pre-commit-hooks
    rev: <VERSION> # Get the latest from: https://github.com/exdial/pre-commit-hooks/releases
    hooks:
      - id: packer-validate
      - id: packer-fmt
```
