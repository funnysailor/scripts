#!/bin/bash


echo "{"
echo "\"data\":["

last_string=`tail -n1 $1`

while read line
 do
  TESTCASE=`echo $line | awk -F\# '{print $1}'`
  TESTSTATUS=`echo $line | awk -F\# '{print $2}'`
 echo "{"
 echo \"\{\#TSTNAME\}\"\:\"${TESTCASE//[[:space:]]}\"\,
 echo \"\{\#TSTSTATUS\}\"\:\"${TESTSTATUS//[[:space:]]}\"\}\,

 done < $1 | head -n-2

 TESTCASE=`echo $last_string | awk -F\# '{print $1}'`
 TESTSTATUS=`echo $last_string | awk -F\# '{print $2}'`

 echo \"\{\#TSTNAME\}\"\:\"${TESTCASE//[[:space:]]}\"\,
 echo \"\{\#TSTSTATUS\}\"\:\"${TESTSTATUS//[[:space:]]}\"\}


echo "]"
echo "}"
