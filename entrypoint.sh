#!/bin/sh

echo "Configuring cron jobs..."

echo "$CRON python3 /usr/src/app/main.py >> /var/log/cron.log 2>&1" > /etc/cron.d/cron_execution

chmod 0644 /etc/cron.d/cron_execution

cat /etc/cron.d/cron_execution

echo "Starting cron..."
crond -l 2 && tail -f /var/log/cron.log
