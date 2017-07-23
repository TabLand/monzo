#!/bin/bash
private="/opt/monzo/private"

access_token=$(cat "$private/access_token")
account_id=$(cat   "$private/account_id")

auth_header="Authorization: Bearer $access_token"
account_header="account_id==$account_id"

cp "$private/balance" "$private/old/balance_$(date +%s)"

curl -s -H "$auth_header" "https://api.monzo.com/balance?account_id=$account_id" > "$private/balance"

balance=$(cat "$private/balance" | jq '.balance / 100')
echo "$(date) I had £$balance left..." >> /var/log/monzo/balance.log
echo "$balance"
