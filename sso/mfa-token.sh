#!/bin/bash
#
# Description: Get Aviatar MFA token
#

mfa_token() {
  mfa_secret="$1"

  if [[ -z "${mfa_secret}" ]]; then
    echo "[ERROR]: MFA secreat can NOT be empty..." >&2
    exit 1
  fi

  oathtool -b --totp "${mfa_secret}"
}

[[ -n "${DEBUG}" ]] && set -x

mfa_secret="$1"

mfa_token "${mfa_secret}"

[[ -n "${DEBUG}" ]] && set +x
