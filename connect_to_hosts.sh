#!/bin/bash
#rpm -qa | grep sshpass || yum install sshpass #Centos 6.6
line=$1
ip=`echo $line | awk '{print $2}'`
user=`echo $line | awk '{print $3}'`
passwd=`echo $line | awk '{print $4}'`
echo "$ip $user $passwd"

sshpass -p $passwd ssh -n $user@$ip "ls -la ~/.ssh/"
