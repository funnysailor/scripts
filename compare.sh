#!/bin/bash

while read ip
	do grep $ip $1 >/dev/null || echo "$ip no passwords found"
done < $2
