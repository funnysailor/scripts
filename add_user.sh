#Change USERNAME and PUBKEY before run, default expiration date: +7 days

USERNAME=''
PUBKEY=''
DAYS=7 
adduser ${USERNAME} &&
cd /home/${USERNAME} &&
mkdir .ssh &&
echo ${PUBKEY} >> .ssh/authorized_keys &&
chown ${USERNAME}:${USERNAME} -R .ssh &&
chmod 500 -R .ssh/ &&
chage -E `date  -d "${DAYS} days" "+%Y-%m-%d"` ${USERNAME} &&
echo "$USERNAME      ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
