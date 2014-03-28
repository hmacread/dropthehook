#/bin/bash
#Script to convert degrees and decemil minutes into decimal degrees (input DDD.MM.MMMn|s|w|e)
#Only basic validation performed on date

if [[ -z $1 ]]; then
	echo Error: Usage "deg3dec DDD.MM.MMM[n|e|s|w]"
	exit 1
fi

deg=$(echo $1 | cut -f1 -d . | sed s/^0*//)

#add back leading zero if all removed
if [[ -z $deg ]]; then
	deg=0
fi

min=$(echo $1 | cut -f2 -d .)
decsec=$(echo $1 | cut -f3 -d .)

#Input Validation

#Check for direction
echo $1 | egrep -i '.[0-9][n|e|s|w]$' >/dev/null
val=$?
if (($val)); then
	echo "Lat or long must contain a letter for direction (I.e. 102.29.234E)"
	exit 1
fi

# Check for invalid Long or Lat
if (($deg >= 180 || $deg < 0)); then
	echo Input degrees lat/long invalid
	exit 1
fi

#Check for invalid Latitude
echo $1 | egrep -i '[n|s]' > /dev/null
isLat=!$?

if (($deg >= 90 && $isLat)); then
	echo "Input degrees latitude invalid (>=90)"
	exit 1
fi

#Check for invalid minutes

if (($min >= 60 || $min < 0)); then
	echo "Input minutes lat/long invalid (>60)"
	exit 1
fi


echo $decsec | egrep -i '[s|w]' > /dev/null
nth=$?

decsec=$(echo $decsec | sed 's/[nNsSeEwW]//')
min=$min.$decsec


decmin=$(echo "scale=9; $min / 60" | bc)


if (($nth)); then
	echo $deg$decmin | sed 's/^\./0./'
else
	echo -$deg$decmin | sed 's/^-\./-0./'
fi


