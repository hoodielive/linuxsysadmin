#!/bin/bash 

if [ "$1" != do ] ; then
  echo "Server or Desktop?"
  read ht
  export htrim="$(echo $ht | tr '[:upper:]' '[:lower:]' | cut -c 1)"

  case $htrim in
    s) 
      export HOSTTYPE="server"
      ;;
    w) 
      export HOSTTYPE="desktop"
      ;;
    d)
      export HOSTTYPE="desktop"
      ;;
    *)
      echo "Not a valid selection. Must be server or desktop."
      exit 1
      ;;
  esac
  
  echo "
  To properly determine what Active Directory realm to join, we need to know what kind of network the host will live on.

  Internal Networks would be any workstation network, as well as most server networks that don't provide publicly available services. 

  Does this host reside on an 'external' or 'internal' network? 
  "

  read network

  export networktrim="$(echo $network | tr '[:upper:]' '[:lower:]' | cut -c 1)"

  case $networktrim in
    e) 
      export REALM="ipaserver.rhce.lab" # external
      ;;
    i) 
      export REALM="ipaserver.rhce.lab" # internal
      ;;
    *)
      echo "This is not a valid network. Please specify 'internal' or 'external'"
      exit 1
      ;;
  esac

  echo "Please enter the admin who has join rights to Active Directory"
  read username

  echo "Please enter the admin's AD password"
  read -s password

  if [ $HOSTTYPE == desktop ] ; then
    default_oustring="OU=Clients,OU=LinuxClients"
  else
    default_oustring="OU=Linux,OU=Servers"
  fi
    
  echo "Please enter the LDAP base to subordinate AD to." 
  echo "[default: $default_oustring]:"
  read oustring

  fi

  if [ "$1" != ask ] ; then
    $(yum_or_apt:-apt) -y install msktutil

    echo -n $password | kinit $username
    unset password

    klist && echo "Successfully obtained a valid Ticket Granting Ticket, proceeding to Join."

    msktutil create \
      --site "${REALM}" \
      --base "${oustring:$default_oustring}" \
      --computer-name $(echo "${HOSTNAME}" | sed -e 's/\..*$//g' | tr '[:lower:]' '[:upper:]') \
      --hostname "${HOSTNAME}" \
      --upn "host/${HOSTNAME}" \
      --enctypes 0x18 \
      --verbose

   sleep 30
   kinit -k
   sleep 5

   msktutil update \
    --dont-change-password \
    --site "${REALM}" \
    --computer-name $(echo "${HOSTNAME}" | sed -e 's/\..*$//g' | tr '[:lower:]' '[:upper:]') \
    --hostname "${HOSTNAME}" \
    --service nfs \
    --enctypes 0x18 \
    --verbose

fi