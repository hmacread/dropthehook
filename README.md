dropthehook
===========

Open source app for logging and sharing marine anchorages, waypoints and more.

Installation
------------

1. Download to target `<installdir>` 

2. Change permissions

`cd <installdir>`
`chmod +x *.command`
`chmod +x *.sh`

3. Add `<installdir>` to PATH in users `.profile`

4. Change the following explicit paths:

`inputmulti.command:gpxOutputDir="$HOME/Desktop”`
`inputtrack.command:gpxOutputDir="$HOME/Desktop”`
`inputwpt.command:gpxOutputDir="$HOME/Desktop”`
`msgfamily.sh:addrfile="$HOME/dev/family_addresses.txt”`
`msgyotreps.sh:addrfile="$HOME/dev/yotreps_addresses.txt”`

5. Run inputwpt.command  

Current Features
----------------

* Create an anchorage waypoint (inputwpt.command)
* Create multiple anchorage waypoints in a row (inputmulti.command)
* Create a set of multiple waypoints (inputtrack.command)
* Output entered information to GPX file for use in OpenCPN charting software.
* Output emails to family and / or yotreps and inserts them to Airmail ready for sending.

Known Issues
------------

* Implementation of Airmail integration is extremely basic and relies on some fiddling with airmail file structure that may not be the best idea.  In it’s current form very unlikely to work on any computer but mine due to OSX -> VMWare communication.  
