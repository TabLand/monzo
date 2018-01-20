#!/bin/bash
private="/opt/monzo/bin/private"

access_token=$(cat "$private/access_token")
account_id=$(cat   "$private/account_id")

auth_header="Authorization: Bearer $access_token"
account_header="account_id==$account_id"

curl -s -H "$auth_header" "https://api.monzo.com/transactions?account_id=$account_id" 
