#!/bin/bash
#check if volume is mounted and connect

vol=/Volumes/Airmail

if [[ -a "$vol/mid.txt" ]]; then
  exit 0
else
 if [[ ! -d $vol ]] ; then 
   mkdir $vol 
 fi
 if mount -t smbfs //guest@hugh-32269a3cca/Airmail $vol >/dev/null 2>&1; then
   exit 0
 else
   exit 1
 fi
fi

