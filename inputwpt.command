#!/bin/bash
# Simple script for generating gpx file for OpenCPN based on user input

#Set default file output
gpxOutputDir="$HOME/Desktop"

#if VM is not running display error message until ready
while (! vmconnect.sh); do
  echo
  echo -n "WARNING: Windows VM not running. Continue for GPX entry only? (y/n) " 
  read sub
  if [[ $sub == 'y' ]]; then
    break
  fi
done  

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

declat=`deg2dec $lat`
declon=`deg2dec $lon`

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
echo -n "Create GPX file? (y/n) "

read sub
if [[ $sub == 'y' ]]; then

  #remove special characters from file name  
  gpxPrefix=`echo $name | sed 's/[><\.,"/|?*:[:space:]]//g'`
  gpxFile=$gpxOutputDir/$gpxPrefix.gpx

  echo
  if ( creategpx.sh "$name" $declat $declon "$desc" "$type" >> $gpxFile ); then
    echo "Created $gpxPrefix.gpx successfully"
  fi
fi

echo
echo -n "Create email to family? (y/n) "

read sub
if [[ $sub == 'y' ]]; then
  if ( msgfamily.sh "$name" "$lat" "$lon" "$declat" "$declon" "$desc" "$type" ); then
    echo
    echo "Created email in Airmail successfully."
  fi
fi

echo
echo -n "Create position report? (y/n) "

read sub
if [[ $sub == 'y' ]]; then
  if ( msgyotreps.sh "$lat" "$lon" "$desc" ); then
    echo
    echo "Created YOTREPS in Airmail successfully."
  fi
fi



vmdisconnect.sh
