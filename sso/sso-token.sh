#!/bin/bash
#
# Description: Get SSO token.
#

request_token() {
  token_url="$1"
  client_id="$2"
  sso_username="$3"
  sso_password="$4"
  mfa_token="$5"

  headers="Content-Type: application/x-www-form-urlencoded"

  data="username=${sso_username}&password=${sso_password}&grant_type=password&client_id=${client_id}"
  [[ -n "${mfa_token}" ]] && data="${data}&totp=${mfa_token}"

  opts="--silent"
  [[ -n "${secure}" ]] && opts="$opts --insecure"

  response=$(curl $opts -H "$headers" -d "$data" -X POST "$token_url" -w "%{http_code}")
  response_data=$(echo $response | sed -E 's/(\{.*\})([0-9]+)/\1/')
  http_status=$(echo $response | cut -d'}' -f2)
  
  if [[ "$http_status" == 2* ]]; then
    echo -n "$response_data"
  else
    echo "[ERROR]: Bad response from the server." >&2
    echo -e "\tHTTP Status Code: $http_status" >&2
    echo -e "\tResponse: $response_data" >&2
    exit 1
  fi
}

extract_token() {
  token_key='.access_token'

  read -r response
  token=$(echo $response | jq -r $token_key)

  if [[ $? -ne 0 ]]; then
    echo "Error: Property $token_key not found in the JSON."
    exit 2
  fi

  echo $token
}

[[ -n "${DEBUG}" ]] && set -x

token_url="$1"
client_id="$2"
sso_username="$3"
sso_password="$4"
mfa_token="$5"
secured="$6"

request_token "$token_url" "$client_id" "$sso_username" "$sso_password" "$mfa_token" "$secured" \
  | extract_token

[[ -n "${DEBUG}" ]] && set +x

