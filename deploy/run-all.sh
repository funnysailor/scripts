#!/bin/bash
#Full deploy

./repos_install.sh
./package_install.sh
./mkfs.sh
./ntp_configure.sh
./selinux_disable.sh
#./storage_install.sh
