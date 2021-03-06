#!/bin/bash -x

private="/opt/monzo/bin/private"

client_id=$(cat "$private/client_id")
client_secret=$(cat "$private/client_secret")
refresh_token=$(cat "$private/refresh_token")

post="grant_type=refresh_token&client_id=$client_id&client_secret=$client_secret&refresh_token=$refresh_token"

#backup json result
cp "$private/refresh" "$private/old/refresh_$(date +%s)"

echo "post data is $post"
echo ""

curl -v -s --data "$post" "https://api.monzo.com/oauth2/token" &> "$private/refresh"

success=$(cat $private/refresh | grep "HTTP/1.1 200 OK" | wc -l)

if [ "$success" == "1" ]; then 

    #backup access / refresh tokens
    cp "$private/access_token"  "$private/old/access_token_$(date +%s)"
    cp "$private/refresh_token" "$private/old/refresh_token_$(date +%s)"

    cat "$private/refresh" | grep '{"access_token":' | jq '.access_token'  | sed 's/"//g' > "$private/access_token"
    cat "$private/refresh" | grep '{"access_token":' | jq '.refresh_token' | sed 's/"//g' > "$private/refresh_token"
    expires_in=$(cat "$private/refresh" | grep '{"access_token":' | jq '.expires_in')

    echo "$(date) Expires in $expires_in seconds" >> /var/log/monzo/refresh.log

fi
