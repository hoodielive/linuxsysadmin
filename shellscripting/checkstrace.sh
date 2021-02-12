#!/usr/bin/env bash
set -x

sudo strace ls -ltr > /dev/null
