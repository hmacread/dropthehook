#!/bin/bash
# Takes arguements and creates a sailmail formatted email for our boat and injects it to sailmail
# Usage createmsg.sh <toaddr> <subject> <msg_txt>
# Note: must be connected to VM for address to work.


# Callsign to be used in final message ID
callsign="VJN4218"
airmaildir="/Volumes/Airmail"

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]]; then
  echo "Error: Usage createmsg.sh <toaddr> <subject> <msg_txt>"
  exit 1
fi

# Check for current connection to airmail
if [ ! -s $airmaildir/MID.txt ]; then
  echo "Error: No connection to Airmail"
  exit 1
fi  

# Possible variables for email

toaddr=$1
subject=$2
msg_txt=$3

# Compute new msg ID

callsign="_$callsign"
msgnum=`cat $airmaildir/MID.txt`
declare -i msgnum
let msgnum++

msgid="$msgnum$callsign"

# Echo the new message to a .msg file in the Airmail directory

printf "X-MID: $msgid\r
To: $toaddr\r
Subject: $subject\r
X-Type: Email;Outmail\r
X-Status: Posted\r
X-Via: Sailmail\r
X-Date: `date -u "+%Y/%m%d %H:%M:%S"`\r
\r
$msg_txt" > $airmaildir/Outbox/$msgid.msg

# Increment Airmail's current message counter

echo -n $msgnum > /Volumes/Airmail/MID.txt

