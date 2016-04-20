#!/bin/bash
# Check file age
 
warn=0
crit=0
 
if [ ! $# == 3 ]; then
   echo "Provide 3 args: <filename> <minutes_warn> <minutes_crit>"
   exit 1
else
   filename=$1
   warn=$2
   crit=$3
fi

# get current time 
timee=`date +%s`

# file exists? 
if [ -f "$filename" ]; then
 lmod=`stat --format -%Y $filename | tr -d "-"`
else
 echo "UNKOWN - File $filename does not exists"
 exit 3
fi

# calc diff 
diff=`expr $timee - $lmod`
diffm=`expr $diff / 60`

#  compare creation time to current time
if [ $diffm -ge $crit ]; then
 echo "CRITICAL - The file $filename is $diffm min. old"
 exit 2
elif [ $diffm -ge $warn ]; then
 echo "WARNING - The file $filename is $diffm min. old "
 exit 1
else
 echo "OK - The file $filename is $diffm min. old"
 exit 0
fi
