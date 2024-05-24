#!/bin/bash
#
# Description: Get attributes from keepasxc db and print them each in a new line.
#

read_password() {
  db_path="$1"
  db_password="$2"
  entry_name="$3"
  shift 3
  attributes=($(echo -n "$@" | sed 's/[^ ]*/--attributes &/g'))

  echo "$db_password" \
    | keepassxc-cli show "${db_path}" "${entry_name}" "${attributes[@]}" 2> /dev/null

  if [[ "$?" -ne 0 ]]; then
    echo "[ERROR]: Failed to open keepassxc db" >&2
    exit 1
  fi
}

[[ -n "${DEBUG}" ]] && set -x

db_path="$1"
db_password="$2"
entry_name="$3"
shift 3
attributes="$@"

read_password "${db_path}" "$db_password" "${entry_name}" "${attributes}"

[[ -n "${DEBUG}" ]] && set +x
