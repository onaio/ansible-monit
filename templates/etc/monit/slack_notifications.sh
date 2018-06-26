#!/bin/sh
/usr/bin/curl \
    -X POST \
    -s \
    --data-urlencode "payload={ \
        \"channel\": \"{{ monit_slack_channel }}\", \
        \"username\": \"{{ monit_slack_username }}\", \
        \"icon_emoji\": \":ghost:\", \
        \"attachments\": [{\
             \"color\": \"warning\", \
             \"pretext\": \"{{ ansible_hostname }} - {{ ansible_ssh_host }} | $MONIT_DATE\", \
             \"text\": \"$MONIT_SERVICE - $MONIT_DESCRIPTION\" \
        }], \
        \"link_names\": 1 \
    }" \
     https://hooks.slack.com/services/{{ slack_monit_endpoint }}
