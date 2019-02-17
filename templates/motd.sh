#!/bin/bash

# Technical contact
CONTACT="{{ MOTD_CONTACT }}"

# Disk percentage warning threshold
DISK_WARN_THRESHOLD=90

# Text color settings
COLOR_WARNING="\e[91m"
COLOR_ACCENT="\e[94m"
COLOR_ACCENT="\e[38;5;202m"
COLOR_RESET="\e[0m"

# System date
DATE=`date`

# System uptime
uptime=`cat /proc/uptime | cut -f1 -d.`
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))
UPTIME="${upDays}d ${upHours}h ${upMins}m ${upSecs}s"

# Basic info
HOSTNAME_UC=`echo $HOSTNAME | awk '{print toupper($0)}'`
RELEASE=`cat /etc/issue`
KERNEL=`uname -r`

# System info
MEMORY_USED=`free -t -m | grep Total | awk '{print $3" MB";}'`
MEMORY_TOTAL=`free -t -m | grep "Mem" | awk '{print $2" MB";}'`
LOAD_1=`cat /proc/loadavg | awk '{print $1}'`
LOAD_5=`cat /proc/loadavg | awk '{print $2}'`
LOAD_15=`cat /proc/loadavg | awk '{print $3}'`
SWAP_USED=`free -m | tail -n 1 | awk '{print $3" MB"}'`

# Interfaces info
PRIVATE_INTERFACE="{{ PRIVATE_INTERFACE }}"
PUBLIC_INTERFACE="{{ PUBLIC_INTERFACE }}"

if [ ! "x$PUBLIC_INTERFACE" == "x" ]; then
  PUBLIC_IP=`sudo ifconfig $PUBLIC_INTERFACE | grep "inet " | awk '{print $2" / "$4}'`
fi

if [ ! "x$PRIVATE_INTERFACE" == "x" ]; then
  PRIVATE_IP=`sudo ifconfig $PRIVATE_INTERFACE | grep "inet " | awk '{print $2" / "$4}'`
fi

# Disk over threshold
DISK_OT=`df -P | awk '0+$5 >= '$DISK_WARN_THRESHOLD' {print}'`

echo
echo -e "Welcome to ${COLOR_ACCENT}${HOSTNAME_UC}${COLOR_RESET} managed by $CONTACT"
echo
echo -e "Running on ${RELEASE}with kernel ${KERNEL}"
echo

echo -e " ${COLOR_ACCENT}█${COLOR_RESET} System date.........: $DATE"
echo -e " ${COLOR_ACCENT}█${COLOR_RESET} Uptime..............: $UPTIME"
echo -e " ${COLOR_ACCENT}█${COLOR_RESET} CPU usage...........: $LOAD_1, $LOAD_5, $LOAD_15"
echo -e " ${COLOR_ACCENT}█${COLOR_RESET} Memory used.........: $MEMORY_USED / $MEMORY_TOTAL"
echo -e " ${COLOR_ACCENT}█${COLOR_RESET} Swap in use.........: $SWAP_USED"
echo -e " ${COLOR_ACCENT}█${COLOR_RESET} Private IP..........: $PRIVATE_IP"
echo -e " ${COLOR_ACCENT}█${COLOR_RESET} Public IP...........: $PUBLIC_IP"