#!/bin/bash
>results.tmp
while read network
do
 #nmap -sV -n -p T:80 $network
 nmap -sS -n $network
 done < networks.list | grep -E "report for|open" >> results.tmp

while read line
do
 if [[ "$line" == *"report"* ]]
 then
  server=`printf "$line" | awk '{print $5}'`
  echo -ne "\r\n $server ,\t "
 else
  port=`printf "$line" | awk -F\/ '{print $1}'`
  echo -ne " $port,"
 fi
done < results.tmp
echo "Done."
