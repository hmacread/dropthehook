#!/bin/bash
# Script to message family
#take in all variables and output a friends message for family
# 

#static
boatname="Elizabeth Jane II"
addrfile="$HOME/dev/family_addresses.txt"

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]] || [[ -z $4 ]] || [[ -z $5 ]] | [[ -z $6 ]] || [[ -z $7 ]]; then
  echo "Error: Usage msgfamily.sh <name> <lat> <lon> <latdec> <latdec> <desc> <status>"
  exit 1
fi


#input variables
name=$1
lat=$2
lon=$3
latdec=$4
londec=$5
desc=$6
status=$7

#date strings
shortdate=`date -u +%d/%m/%Y`
longdate=`date -u`

#compile message field strings

msgtoaddr=`cat $addrfile`
msgsubj="$boatname position report $shortdate"
msgtxt=`printf "Hi All!\r
\r
Our location details as of $longdate are:\r
\r
Name: $name\r
Latitude: $lat\r
Longitude: $lon\r
Description: $desc\r
\r
View in Google Maps: https://maps.google.com.au/maps?q=$latdec,$londec&num=1&t=h&z=5\r
\r
This is an automated message, but feel free to respond!\r
\r
Love\r
H&K"`

injectmsg.sh "$msgtoaddr" "$msgsubj" "$msgtxt"

