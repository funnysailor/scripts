#/bin/bash
#Script for certificate revokation

server=$1
cert=$2
force=$3
cert_base=`basename -s .crt $cert`
path="/etc/openvpn/easy-rsa/2.0/"

ssh root@$1 "uname -a"
echo "Before revoke:"
ssh root@$1 "cd $path && grep $cert_base keys/index.txt" > crt.tmp
cat crt.tmp
lenght=`cat crt.tmp | wc -l`
echo "lenght: $lenght"

if [ $lenght -gt 1 ]; then echo "$lenght certs to revoke, please specify name.";exit 1;fi
if [ $lenght -eq 0 ]; then echo "No certificate to revoke. Exit.";exit 2;fi

read -p "Do you wish to revoke $cert ? " yn
    case $yn in
	[Yy]* ) echo "Revoking...";;
	[Nn]* ) exit;;
	* ) echo "Please answer yes or no.";;
    esac

ssh root@$1 "cd $path && source ./vars && ./revoke-full $cert_base"
echo "After revoke:"
ssh root@$1 "cd $path && grep $cert_base keys/index.txt"
