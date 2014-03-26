#!/bin/bash
# Update airmail position
# Usage: updatepos.sh <deglat> <minlat> <dirlat> <deglon> <minlon> <dirlat> [desc]
# Note: vmconnect.sh must have been run

inifile="/Volumes/Airmail/Airmail.ini"

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]] || [[ -z $4 ]] || [[ -z $5 ]] || [[ -z $6 ]]; then
  echo "Error: updatepos.sh <deglat> <minlat> <dirlat> <deglon> <minlon> <dirlat> [desc]"
  exit 1
fi

echo `cat $inifile | sed -E s/Current?[:space:]Latitude=*°*'?/Current[:space:]Latitude=$deglat°$minlat'$dirlat/g`
