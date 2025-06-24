#!/bin/bash
connected_vpn_name=`scutil --nc list | grep '^\*\s(Connected)' | sed -E 's/^.*"([^"]+)".*$/\1/'`

if [ "$connected_vpn_name" == "" ]; then
    printf "%7s\n" ""
else
    printf "%7s\n" "󰌆 $connected_vpn_name"
fi
