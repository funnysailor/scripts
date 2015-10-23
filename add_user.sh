#Change USERNAME and PUBLIC-KEY before run

USERNAME=username
adduser $USERNAME &&
cd /home/$USERNAME &&
mkdir .ssh &&
echo 'PUBLIC-KEY' >> .ssh/authorized_keys &&
chown $USERNAME:$USERNAME -R .ssh &&
chmod 500 -R .ssh/ &&
echo "$USERNAME      ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
