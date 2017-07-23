#!/bin/bash
# Monitoring to alert when access / refresh tokens have lapsed and Monzo integration is broken
# This exception will require manual reauth

balance_check_failure=$(/opt/monzo/bin/balance.sh | grep "????" | wc -l)
unexpected_balance_output=$(/opt/monzo/bin/balance.sh | egrep -v '^[0-9]+\.[0-9]{2}$' | wc -l)
refresh_json_error=$(egrep -i "invalid|bad|error" /opt/monzo/bin/private/refresh | wc -l)
refresh_token_lost=$(grep -i null /opt/monzo/bin/private/refresh_token | wc -l)
access_token_lost=$(grep -i null /opt/monzo/bin/private/access_token | wc -l)

function error_mail(){
    error="$1"
    echo "$(date) $error"
    php /opt/monzo/bin/monitor_mail.php "$error"
}

if [ "$balance_check_failure" != "0" ]; then
    error_mail "Balance Check Failure"
elif [ "$unexpected_balance_output" != "0" ]; then
    error_mail "Unexpected output from balance check"
elif [ "$refresh_json_error" != "0" ]; then
    error_mail "Errors detected in the latest refresh token json response"
elif [ "$refresh_token_lost" != "0" ]; then
    error_mail "Lost Refresh Token"
elif [ "$refresh_token_lost" != "0" ]; then
    error_mail "Lost Access Token"
else
    echo "$(date) No problems detected"
fi
