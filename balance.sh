#!/bin/bash
private="/opt/monzo/bin/private"

access_token=$(cat "$private/access_token")
account_id=$(cat   "$private/account_id")

auth_header="Authorization: Bearer $access_token"
account_header="account_id==$account_id"

cp "$private/balance" "$private/old/balance_$(date +%s)"

curl -s -H "$auth_header" "https://api.monzo.com/balance?account_id=$account_id" > "$private/balance"

error=$(cat "$private/balance" | egrep -i "unauthorized|bad|error" | wc -l)

if [ "$error" == "0" ]; then
    balance=$(cat "$private/balance" | jq '.balance / 100')
    printf "%0.2f" $balance
    echo "$(date) I had £$balance left..." >> /var/log/monzo/balance.log
else
    echo "????"
    echo "$(date) Balance Check failure..." >> /var/log/monzo/balance.log
fi
