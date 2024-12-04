#!/bin/bash

LOG="/var/log/monitoring.log"
URL="https://test.com/monitoring/test/api"
PREV_PID="/tmp/test.pid"

while true; do
    CURRENT_PID=$(pgrep "test")

    if [ "$CURRENT_PID" != "" ]; then
        if [ -f "$PREV_PID" ]; then
            PREV_PID_CONTENT=$(cat "$PREV_PID")
            if [ "$PREV_PID_CONTENT" != "$CURRENT_PID" ]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') Процесс был перезапущен." >> "$LOG"
            fi
        fi

        echo "$CURRENT_PID" > "$PREV_PID"

        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
        
        if [ "$HTTP_CODE" != "200" ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Код ошибки: $HTTP_CODE" >> "$LOG"
        fi
    else
        rm -f "$PREV_PID"
    fi

    sleep 60
done
