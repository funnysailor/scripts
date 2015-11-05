#!/bin/sh

#sendEmail installation:
#wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz
#tar -zxvf sendEmail-v1.56.tar.gz
#sudo cp -a sendEmail-v1.XX/sendEmail /usr/local/bin
#sudo chmod +x /usr/local/bin/sendEmail

export MAILTO="$1"
export SUBJECT="$2"
export TEXT="$3"

export FROM="noreply@your-server.com"

export SMTP_SERVER=mail.your-server.com
export SMTP_LOGIN=noreply@your-server.com
export SMTP_PASSWORD=your_password

/usr/local/bin/sendEmail -f "$FROM" -t "$MAILTO" -u "$SUBJECT" -m "$TEXT" -o message-charset=UTF8 -s $SMTP_SERVER:25 -xu $SMTP_LOGIN -xp $SMTP_PASSWORD
