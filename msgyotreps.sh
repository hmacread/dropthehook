#!/bin/bash
# Script to message family
#take in all variables and output a position / weather report to yotreps via Airmail
# 

#static
callsign="VJN4218"
addrfile="$HOME/dev/yotreps_addresses.txt"

if [[ -z $1 ]] || [[ -z $2 ]]; then
  echo "Error: Usage msgyotreps.sh <lat> <lon> [comment] [course] [speed] [wind_speed] [wind_dir] [wave_ht] [swell_ht]"
  exit 1
fi


#mandatory input variables
lat=$1
lon=$2

#Optional input variables
comment=$3
course=$4
speed=$5
wind_speed=$6
wind_dir=$7
wave_ht=$8
swell_ht=$9

# create date strings
longdate=`date -u "+%Y/%m/%d %H:%M:%S"`
shortdate=`date -u "+%Y/%m/%d %H:%M"`

#convert lat and lon
deglat=$( echo $lat | awk -F '.' '{print $1}' )
deglon=$( echo $lon | awk -F '.' '{print $1}' )

#add leading zeros to degrees
if ( echo $deglat | egrep '^.$' >/dev/null ); then
  deglat=0$deglat
fi 
#TODO check string length before this loop
while ( ! echo $deglon | egrep '^...$' >/dev/null ); do
  deglon=0$deglon
done

#truncate the minutes to 2 decimal places -> TODO change to rounding rather than truncating
minlat=$( echo $lat | sed 's/.$//g' | sed -E 's/^[0-9]{1,3}\.//' ) 
minlat=$( echo "scale=2; $minlat / 1" | bc )

minlon=$( echo $lon | sed 's/.$//g' | sed -E 's/^[0-9]{1,3}\.//' )                 
minlon=$( echo "scale=2; $minlon / 1" | bc )

#add leading zeros to minutes
if ( echo $minlat | egrep '^.\.' >/dev/null ); then
  minlat=0$minlat
elif ( echo $minlat | egrep '^\.' >/dev/null ); then
  minlat=00$minlat
fi
if ( echo $minlon | egrep '^.\.' >/dev/null ); then 
  minlon=0$minlon
elif ( echo $minlon | egrep '^\.' >/dev/null ); then
  minlon=00$minlon
fi


#change direction to caps
if ( echo $lat | grep -i 'n' >/dev/null ); then
  dirlat='N'
elif ( echo $lat | grep -i 's' >/dev/null ); then
  dirlat='S'
else
  echo "Error: No direction in latitude."
  exit 1
fi

if ( echo $lon | grep -i 'w' >/dev/null ); then
  dirlon='W'
elif ( echo $lon | grep -i 'e' >/dev/null ); then
  dirlon='E'
else
  echo "Error: No direction in longitude."
  exit 1
fi

lat=$deglat-$minlat$dirlat
lon=$deglon-$minlon$dirlon

#truncate description to 79 chars (to be on the safe side)
#comment=`echo $comment | awk {'print substr($0,0,79)'}`

#compile message field strings

msgtoaddr=`cat $addrfile`

msgsubj="YotReps: $longdate"

msgtxt=`printf "AIRMAIL YOTREPS\r
IDENT: $callsign\r
TIME: $shortdate\r
LATITUDE: $lat\r
LONGITUDE: $lon"`

if [ -n "$course" ]; then
 msgtxt=`printf "$msgtxt\rCOURSE: $course"`T
fi
if [ -n "$speed" ]; then
 msgtxt=`printf "$msgtxt\r\nSPEED: $speed"`
fi
if [ -n "$wind_speed" ] || [ -n "$wind_dir" ] || [ -n "$wave_ht" ] || [ -n "$swell_ht" ] ; then
 msgtxt=`printf "$msgtxt\rMARINE: YES"`
fi
if [ -n "$wind_speed" ]; then
 msgtxt=`printf "$msgtxt\r\nWIND_SPEED: $wind_speed"`
fi
if [ -n "$wind_dir" ]; then
 msgtxt=`printf "$msgtxt\r\nWIND_DIR: $wind_dir"`
fi
if [ -n "$wave_ht" ]; then
 msgtxt=`printf "$msgtxt\r\nWAVE_HT: $wave_ht"`M
fi
if [ -n "$swell_ht" ]; then
 msgtxt=`printf "$msgtxt\r\nSWELL_HT: $swell_ht"`M
fi
#print trucated comment
if [ -n "$comment" ]; then
 msgtxt=`printf "$msgtxt\r\nCOMMENT: $comment"`
fi

/Users/hmacread/dev/dropthehook/injectmsg.sh "$msgtoaddr" "$msgsubj" "$msgtxt"

#echo "To: $msgtoaddr"
#echo "Subj: $msgsubj"
#echo "Message: $msgtxt"

