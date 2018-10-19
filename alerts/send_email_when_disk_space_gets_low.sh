#!/bin/sh 

CURRENT=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
THRESHOLD=80

if [ "$CURRENT" -gt "$THRESHOLD" ]; then 
  mail -s 'Disk Space Alert' maildomain@$domain.com << EOF
  Your disk quota partition is critically low. Used: $CURRENT%
  EOF 
fi

# @daily ~/send_email_when_disk_space_gets_low.sh - put this in /etc/crontab daily
