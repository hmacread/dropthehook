#!/bin/bash
# Simple script for generating gpx file for OpenCPN based on user input

#Set default file output
gpxOutputDir="$HOME/Desktop"

while ( true ); do

echo
echo "Enter waypoint attributes"
echo "-------------------------"
echo
echo -n "Name: "
read name

#Checks basic coordinate format (not completely valid lat/longs)
echo -n "Latitude: "
while read lat; do
  if ( echo $lat | egrep -i '^[0-9]{1,2}\.[0-9]{1,2}\.[0-9]+[ns]' >/dev/null ); then 
    break;
  else
    echo "Invalid latitude. Usage DD.MM.MMMn (I.e. 33.23.755n )"
    echo -n "Latitude: "
  fi;
done

echo -n "Longitude: "
while read lon; do
  if ( echo $lon | egrep -i '^[0-9]{1,3}\.[0-9]{1,2}\.[0-9]+[ew]' >/dev/null ); then
    break;
  else
    echo "Invalid longitude. Usage DDD.MM.MMMn (I.e. 133.23.755e )"
    echo -n "Longitude: "
  fi;
done

echo -n "Description (press Enter when finished): "
read desc

#TODO
type="anchorage"

declat=`deg2dec.sh $lat`
declon=`deg2dec.sh $lon`

echo
echo "Please confirm this data is correct"
echo "-----------------------------------"
echo 
echo "Name: $name"
echo "Latitude: $lat (Decimal: $declat)"
echo "Longitude: $lon (Decimal: $declon)"
echo "Description: $desc"
echo "Waypoint type: $type"
echo 

echo "Create GPX file? (y/n)"
read sub
if [[ $sub == 'y' ]]; then

  # remove special characters from file name
  gpxPrefix=`echo $name | sed 's/[><\.,"/|?*:[:space:]]//g'`
  gpxFile=$gpxOutputDir/$gpxPrefix.gpx

  if ( creategpx.sh "$name" $declat $declon "$desc" "$type" >> $gpxFile ); then
    echo "Created $gpxPrefix.gpx successfully"
  fi
fi

echo "Create another waypoint? (y/n)"

read sub
if [[ $sub == 'n' ]]; then
  break
fi

done


