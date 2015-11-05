#!/bin/sh

export MAILTO="$1"
export SUBJECT="$2"
export TEXT="$3"

export FROM="noreply@your-server.com"

export SMTP_SERVER=mail.your-server.com
export SMTP_LOGIN=noreply@your-server.com
export SMTP_PASSWORD=your_password

/usr/local/bin/sendEmail -f "$FROM" -t "$MAILTO" -u "$SUBJECT" -m "$TEXT" -o message-charset=UTF8 -s $SMTP_SERVER:25 -xu $SMTP_LOGIN -xp $SMTP_PASSWORD
