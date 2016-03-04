#!/bin/bash

ls -1 /dev/sd* | grep -v [0..9] > disks_for_erase
echo "Please modify file: disks_for_erase and run script with erase parameter"
echo "First parameter:"
if [ $1 -eq "erase"]
then
 echo $1
 for i in `cat disks_for_erase`
  do 
   echo "erasing $i"
   #parted -a optimal $i -s mklabel msdos
  done
elif
  echo "empty"
fi
