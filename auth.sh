#!/bin/bash
private="/opt/monzo/bin/private"

state_token=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
client_id=$(cat "$private/client_id")
redirect_uri=$(cat "$private/redirect_uri")

echo "Please visit https://auth.getmondo.co.uk/?client_id=$client_id&redirect_uri=$redirect_uri&response_type=code&state=$state_token"
echo "And copy link into $private/received_link and then run fetch_new_access_code.sh"
