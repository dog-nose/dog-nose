#!/bin/bash

battery_info=$(ioreg -rn AppleSmartBattery)

current_charge=$(echo "$battery_info" | grep '^\s*"CurrentCapacity"' | awk '{print $3}')

max_capacity=$(echo "$battery_info" | grep '^\s*"MaxCapacity' | awk '{print $3}')

# 小数点の切り捨てが発生していたので100分率の計算を先にした
my_battery=$(echo "scale=0; $current_charge * 100 / $max_capacity" | bc)

# echo -e "\033[32mVPN\033[m"
battery_icon=' '
if [ $my_battery -gt 80 ]; then
    battery_icon=' '
elif [ $my_battery -gt 60 ]; then
    battery_icon=' '
elif [ $my_battery -gt 40 ]; then
    battery_icon=' '
elif [ $my_battery -gt 20 ]; then
    battery_icon=' '
fi

echo -e "${my_battery}% ${battery_icon}"

