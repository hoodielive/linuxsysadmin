#!/bin/sh 

ADMIN=$USER
ALERT=80
EXCLUDE_LIST="/auto/ripper"

main_prog() {
  while read output; 
  do
    usep=$(echo $output | awk '{ print $1 }' | cut -d'%' -f1)
    partition=$(echo $output | awk '{ print $2 }')
    if [ $usep -ge $ALERT ]; then 
      echo "Running out of space \"$partition ($usep%)\" on server %(hostname), $(date)" | \
        mail -s "Alert: Almost out of disk space $usep%" $ADMIN
    fi
  done
}

if [ "$EXCLUDE_LIST" != "" ]; then 
  df -H | grep -vE "^Filesystem|tmpfs|cdrom|${EXCLUDE_LIST}" | awk '{ print $5 " " $6 }' | main_prog
else
  df -H | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{ print $5 " " $6 }' | main_prog
fi
