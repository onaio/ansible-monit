#!/bin/sh
/usr/bin/curl \
    -X POST \
    -s \
    --data-urlencode "payload={ \
        \"channel\": \"#devops-logs\", \
        \"username\": \"Monit\", \
        \"icon_emoji\": \":ghost:\", \
        \"attachments\": [{\
             \"color\": \"warning\", \
             \"pretext\": \"{{ nginx_server_name }} - {{ ansible_ssh_host }} | $MONIT_DATE\", \
             \"text\": \"$MONIT_SERVICE - $MONIT_DESCRIPTION\" \
        }], \
        \"link_names\": 1 \
    }" \
     https://hooks.slack.com/services/{{ slack_monit_endpoint }}
