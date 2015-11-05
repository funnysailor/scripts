#!/bin/bash
disk=$1
config=$2

echo $disk
sed -i "s/<\/Disks>/  <Item>\n        <MountPoint>\/data$disk\/<\/MountPoint>\n        <State>On<\/State>\n      <\/Item>\n      <\/Disks>/" $config
