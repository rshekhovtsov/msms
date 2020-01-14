#!/bin/bash

#################################################################
# multi-service monitoring script:
# generic scipt for web service monitoring
# check service with curl, report alerts to telegram
# (!) current directory should be "services"
#################################################################

# telegram endpoint
TG_API_URL="https://api.telegram.org/bot$(cat ../telegram-api-key.txt)/sendMessage"

#################################################################
# send message to telegram
# parameter: message text
# recipients chat id list should be in "recipients.txt" file
#################################################################
function send_message {
    for chat_id  in $(cat $MSMS_RECIPIENTS); do
	curl -s -X POST --connect-timeout 10 $TG_API_URL -d chat_id=$chat_id -d parse_mode="Markdown" -d text="$1"  # > /dev/null
	echo
    done
}

#################################################################
# perform service check
#################################################################
echo $(date '+%Y-%m-%d %H:%M:%S')

# load variables from .ini file:
. $2

# bash ./$2
# echo service name: "$MSMS_SERVICE_NAME"
# cd $(dirname "$0")
if [ -n "$MSMS_EXPECTED_FILE" ]; then
 MSMS_EXPECTED="$(cat "$MSMS_EXPECTED_FILE")"
fi
# echo expected: "$MSMS_EXPECTED"

RESPONSE="$(eval curl $MSMS_CURL_PARAMS \"$MSMS_SERVICE_ENDPOINT\")"
EXIT_CODE=$?
if [[ $EXIT_CODE != 0 ]]; then
    echo health-check \"$MSMS_SERVICE_NAME\" FAILED: CURL EXIT WITH $EXIT_CODE
    MESSAGE="$(cat ../templates/curl-fail.txt)"
    MESSAGE=$(eval echo $MESSAGE)
    send_message "$MESSAGE"
elif [[ "$RESPONSE" != "$MSMS_EXPECTED" ]]; then
    echo health-check \"$MSMS_SERVICE_NAME\" FAILED: "$RESPONSE"
    MESSAGE="$(cat ../templates/service-fail.txt)"
    MESSAGE=$(eval echo $MESSAGE)
    send_message "$MESSAGE"
else
    echo health-check \"$MSMS_SERVICE_NAME\": OK
fi

#################################################################
# daily alert for confirmation that monitoring itself is working
#################################################################
if test "$1" = "DAILY"; then
    echo health-check \"$MSMS_SERVICE_NAME\" DAILY
    MESSAGE="$(cat ../templates/daily.txt)"
    MESSAGE=$(eval echo $MESSAGE)
    send_message "$MESSAGE"
fi