#!/usr/bin/env bash
#
# +------------------+----------------------+----------------------+
# |       x          | no tags in repo      | repo has tags        |
# |------------------|----------------------|----------------------|
# | run without args | generate_first_tag() | increment_last_tag() |
# | run with args    | create_new_tag()     | create_new_tag()     |
# +------------------+----------------------+----------------------+
#
# There are 4 use cases:
# 1) If the program is executed without any arguments and
#    no tags have been created yet, the program will initially
#    set the first tag as "v0.0.1".
# 2) If the program is run without any arguments and there are
#    existing tags in the repository, it will automatically
#    increase the third part of the version (patch).
# 3) If you run the program with arguments and no tags have been
#    created yet, the programm will check if the argument is in the
#    correct semantic versioning format. If the argument is valid,
#    the program will add a new tag that you specified using those
#    arguments.
# 4) When running the program with arguments and there are already
#    tags in the repository, it will verify if the argument follows
#    the correct semantic versioning format. If the argument is deemed
#    valid, the program will proceed to add a new tag as per
#    the arguments you specified.

set -eo pipefail

TAG_PREFIX="v"
#TAG="$1"

usage() {
  echo
  echo "Usage:   $0 ${TAG_PREFIX}<tag>"
  echo "Example: $0 ${TAG_PREFIX}0.1.2"
}

are_there_any_tags() {
  num_of_tags() {
    git tag -l | wc -l | awk '{print $1}'
  }
  if [ "$(num_of_tags)" -eq "0" ]; then
    echo "There are no tags yet."
    false
  else
    echo "Found $(num_of_tags) tags."
    true
  fi
}

increment_last_tag() {
  echo "Incrementing last tag..."
  get_last_tag() {
    git tag -l --sort=version:refname "$TAG_PREFIX"* | \
      tail -n 1 | tr -d 'v'
  }
  MAJOR=$(get_last_tag | cut -d '.' -f1)
  MINOR=$(get_last_tag | cut -d '.' -f2)
  PATCH=$(get_last_tag | cut -d '.' -f3)
  echo "Current tag: ${TAG_PREFIX}${MAJOR}.${MINOR}.${PATCH}."
  let "PATCH++"
  NEW_TAG="${TAG_PREFIX}${MAJOR}.${MINOR}.${PATCH}"
  echo "New tag:     ${NEW_TAG}."
  git tag "$NEW_TAG"
}

generate_first_tag() {
  echo "Generating first tag..."
  echo New tag: "${TAG_PREFIX}0.0.1"
  git tag "${TAG_PREFIX}0.0.1"
}

# Check number of arguments
case "$#" in
  # No tags passed
  0)
    are_there_any_tags && increment_last_tag || generate_first_tag
    ;;
  # Tag is defined via argument
  1)
    # Validate the tag has semver format
    if [[ "$1" =~ ^${TAG_PREFIX}[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "Creating new tag..."
      echo "New tag: ${1}"
      git tag "$1"
    else
      echo "Invalid tag format!"
      usage
      exit 1
    fi
    ;;
  # Fail if more than 1 argument passed
  *)
    echo "Wrong number of arguments!"
    usage
    exit 1
esac
