#!/bin/bash


while read line;do
# echo $line

 dc=`echo $line | awk '{print $1}'`
 service=`echo $line | awk '{print $2}'`
 account=`echo $line | awk '{print $3}'`
 #echo "dc $dc service $service account $account"

 date >> /var/log/test_discovery.log
 /root/autotest/robot/run_for_zabbix.sh $line 2>>/var/log/test_discovery.log | awk -vdc="${dc}" -vservice="${service}" -vaccount="${account}" '{print dc"_"service"_"account"_"$0}' >> /tmp/test_discovery.tmp
 #cat /tmp/test_discovery.tmp
done < /root/check_list

cat /tmp/test_discovery.tmp >> /var/log/test_discovery.log
mv /tmp/test_discovery.tmp /tmp/test_discovery
