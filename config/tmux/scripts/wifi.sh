#!/bin/bash

wifi_name=`networksetup -getairportnetwork en0 | awk '{print $4}'`


echo $wifi_name
