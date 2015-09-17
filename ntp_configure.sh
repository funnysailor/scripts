#!/bin/bash
echo "Time setup..."

ntpdate ntp.ubuntu.com

#set GMT
cp /usr/share/zoneinfo/GMT /etc/localtime

/etc/init.d/ntpd start

chkconfig ntpd on
