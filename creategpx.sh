#!/bin/bash
# Takes arguements and creates single entry gpx file to stdout for anchorages

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]] || [[ -z $5 ]]; then
  echo "Error: Usage creategpx.sh <name> <lat> <lon> <desc> <type>"
  exit 1
fi

name=$1
lat=$2
lon=$3
desc=$4
type=$5

# Validate lat and long
if !( echo $lat | egrep '^\-?[0-9]{1,2}\.[0-9]{9}$' >/dev/null ); then
  echo "Invalid latitude. Usage +-DD.DDDDDDDDD"
  exit 1  
fi

if !( echo $lon | egrep '^\-?[0-9]{1,3}\.[0-9]{9}$' >/dev/null ); then
  echo "Invalid longitude. Usage +-DDD.DDDDDDDDD"
  exit 1
fi

cat ~/dev/dropthehook/gpxhead.txt
echo "    <wpt lat=\"$lat\" lon=\"$lon\">" 
echo "        <name>$name</name>" 
echo "        <desc>$desc</desc>"
echo "        <sym>$type</sym>"  
echo "        <type>WPT</type>" 
echo "    </wpt>" 
cat ~/dev/dropthehook/gpxfoot.txt 
