#!/bin/bash

getent passwd $USERNAME > /dev/null 2> /dev/null 

# 6 lines of code to ensure that a user doesn't exist before attempting to create
if [ $? -ne 0 ]; then 
	useradd -u $UID -g $GID -c "$COMMENT" -s $SHELL -m $USERNAME
else
	useradd -u $UID -g $GID -c "$COMMENT" -s $SHELL -m $USERNAME
fi
