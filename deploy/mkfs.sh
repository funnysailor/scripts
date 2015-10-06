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

for i in `cat disks_fix`;do echo $i; parted $i  -s mktable msdos;done

for i in `ls -1 /dev/sd* | grep -v [0-9]`;
do
        file -s $i | grep partition > /dev/null
        if [ $? -ne 0 ]
         then echo "$i - without FS,adding to list"
         echo $i >> disks
        else
         echo "$i - with FS, skip it"
        fi
done

echo "Disks to process:"
cat disks
wc -l disks

echo "Continue? [y/n]"
read cont

if [ $cont == "y" ]
then
 echo "continue..."
else
 echo "exit"
 exit 1
fi

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
 echo "preparing disk $i"
 parted -a optimal $i -s mklabel gpt mkpart primary 0% 100%
 mkfs.ext4 -m0 -E lazy_itable_init ${i}1 > /dev/null
 blkid | grep "$i" | awk '{print $2}' >> disks_with_uuid
 echo "preparing disk $i finished."
done
total_drives=$((start_point+total_drives-1))
echo "Making dirs..."
echo "Start:$start_point Stop:$total_drives"
for i in `seq $start_point $total_drives`
 do cd /
 echo "making... $i"
 mkdir `printf "data%02u\n" $i`
done
echo "Making dirs... finished"

cd $path
echo "prepare fstab..."
cat disks_with_uuid | (i=$start_point; while read uuid; do printf "$uuid /data%02u                 ext4    defaults,user_xattr        0 0\n" $i; i=$(($i+1)); done) >> /etc/fstab
echo "prepare fstab... finished"
echo "mounting..."
mount -a
echo "mounting... done"
df -h | grep data
