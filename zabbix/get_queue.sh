/usr/local-enable-shared/bin/python3.4 event_queue.py --host hostname | awk -vdc=mc-backup '{print dc"-"$0}'
