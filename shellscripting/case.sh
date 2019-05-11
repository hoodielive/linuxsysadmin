#!/bin/bash 

function noncompliance()
{
  echo "Usage: $0 file"
  exit
}

if [[ $1 -eq 0 ]] ; then 
  noncompliance
fi 

case $@ in 
  file) 
      for users in $(cat $1); do 
        useradd -s /bin/false $users 
      done
      ;;
  *) 
    echo "You have specified an incorrect option"
    ;; 
esac
