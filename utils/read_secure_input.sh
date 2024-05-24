#!/bin/bash
#
# Description: read secret password from user.
#

read_password() {
  msg="${1:-Password:}"

  echo -n "${msg} " >&2
  read -s password

  printf "\n" >&2

  if [[ -z "$password" ]]; then
      echo "[ERROR] Password can NOT be empty..." >&2
      exit 1
  fi

  printf "$password"
}

[[ -n "${DEBUG}" ]] && set -x

msg="$1"

read_password "${msg}"

[[ -n "${DEBUG}" ]] && set +x
