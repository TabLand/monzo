#!/bin/bash

private="/opt/monzo/private"

#fetch the received auth code
cat "$private/received_link" | egrep -o "\?code=.*&state=" | sed 's/?code=//g' | sed 's/&state=//g' > "$private/authorization_code"

authorization_code=$(cat "$private/authorization_code")
client_id=$(cat "$private/client_id")
client_secret=$(cat "$private/client_secret")
redirect_uri=$(cat "$private/redirect_uri")

post="grant_type=authorization_code&client_id=$client_id&client_secret=$client_secret&redirect_uri=$redirect_uri&code=$authorization_code"

cp "$private/auth" "$private/old/auth_$(date +%s)"

echo "Post data is $post"
echo ""

curl -s --data "$post" "https://api.monzo.com/oauth2/token" > "$private/auth"

mv "$private/access_token"   "$private/old/access_token_$(date +%s)"
mv "$private/refresh_token" "$private/old/refresh_token_$(date +%s)"

cat "$private/auth" | jq '.access_token'  | sed 's/"//g' > "$private/access_token"
cat "$private/auth" | jq '.refresh_token' | sed 's/"//g' > "$private/refresh_token"
