>disks_with_uuid
>disks

path=`pwd`

rpm -qa | grep parted
if [ $? -ne 0 ];
then echo "parted in not installed"
	exit 1
fi

#Old way to find disks without FS
#blkid | awk '{print $1}' |  sed -e 's/[0-9]//g' -e 's/\:/\[0-9\]/g'| sort | uniq > exlude_list
#ls -1 /dev/sd* | grep -v -f exlude_list > disks

for i in `ls -1 /dev/sd*`;
do
	file -s $i | grep partition
	if [ $? -eq 0 ]
	 then echo "$i - without FS,adding to list"
	 echo $i >> disks
	fi
done

dates=`ls / | grep "data" | wc -l`
total_drives=`cat disks | wc -l`

echo total drives\: "$total_drives"
if [ $dates -lt 10 ]
then
 echo start_point 0$dates
 start_point="0$dates"
else
 echo start_point $dates
 start_point="$dates"
fi

start_point=$((start_point+1))

for i in `cat disks`;do
 echo $i
 sleep 2
 parted -a optimal $i -s mklabel gpt mkpart primary 0% 100%
 mkfs.ext4 -m0 -E lazy_itable_init ${i}1
 echo $i
 blkid | grep "$i" | awk '{print $2}' >> disks_with_uuid
done

for i in `seq $start_point $total_drives`
 do cd /
 mkdir `printf "data%02u\n" $i`
done

cd $path

cat disks_with_uuid | (i=$start_point; while read uuid; do printf "$uuid /data%02u                 ext4    defaults,user_xattr        0 0\n" $i; i=$(($i+1)); done) >> /etc/fstab
mount -a
df -h | grep data
