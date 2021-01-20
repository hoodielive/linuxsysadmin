#!/usr/bin/env bash

[[ ! -a $(which nmap) ]] && echo "This script uses Nmap, which was not found on this system." && exit
