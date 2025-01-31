echo "Shell Commands used in OpenVario Project"
echo "-------------------------------------------------------------------------"

echo "Date Time"
echo "========="
echo "reinterpret unix timestamp to date time"
echo "date -u -d @1692282364"
date -u -d @1692282364

echo "currently timestamp"
echo "date +%c"
date +%c
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"

echo "if-Statement"
echo "============"
if 3 && 4; then echo "3 && 4 = true"; else echo "3 && 4 = false"; fi 
if 0 && 4; then echo "0 && 4 = true"; else echo "0 && 4 = false"; fi 
if 3 && 0; then echo "3 && 0 = true"; else echo "3 && 0 = false"; fi 

echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"

# remove a yocto project to make a new build:
find . -type f -name "*Name*.*" -delete
# find only:
find . -type f -name "*Name*.*" 
find . -type f -name "/opensoar*.*" 

# kernel values
## temperature:
cat /sys/class/thermal/thermal_zone*/temp
## frequency:
cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_cur_freq

# set datetime: this is setting the software clock only, the hardware clock
# is untouched (and set the system clock at next boot
date -s "2024-10-06 10:21"

=============================================================
So kann man Zeichen oder Strings von hinten, bzw. rechts abschneiden:

VALUE=textpart.txt.dat
echo ${VALUE%.*}

#Ausgabe:
textpart.txt

So kann man den längst möglichen String von rechts entfernen:

VALUE=textpart.txt.dat.gz
echo ${VALUE%%.*}

# Ausgabe:
textpart

Beides umgedreht geht mit #. Möchte man also den kürzest möglichen String von links abschneiden:

VALUE="/path/filename.dat.txt"
echo ${VALUE#*/}

# Ausgabe:
path/filename.dat

# oder:
VALUE="/path/filename.dat.txt"
echo ${VALUE#*.}

#Ausgabe:
dat.txt

für den längsmöglichen String von links:
VALUE="/path/filename.dat.txt"
echo ${VALUE##*/}

# Ausgabe:
filename.dat.txt


# oder
VALUE="/path/filename.dat.txt"
echo ${VALUE##*.}

# Ausgabe:
txt
=============================================================
# Search and Replace
[[ das muss ich noch ergaenzen...]]
siehe https://www.data2type.de/xml-xslt-xslfo/regulaere-ausdruecke/regex-methoden-aus-der-praxis/einige-kleine-beispiele/verschachtelte-klammerpaare

Search(1):      \([^()]*\)
Search(2):      \([^()]*(\([^()]*\)[^()]*)*\)
*** Ersetzen klappt noch gar nicht!
(Ersetzen:       $1 oder \1)

