#!/bin/bash

new_dir="$HOME/Maildir/work/INBOX/new"
num_mail=$(ls $new_dir|wc -l)
message=""

if [[ $num_mail -gt 0 ]];then
    for i in $new_dir/*;do
        message="$message\n$(grep -m1 '^From: ' $i|sed 's/From: //'|sed 's/ <[^>]*>//')\n$(grep -m1 '^Subject: ' $i|sed 's/Subject: //')\n"
    done
    notify-send "New Mail" "$message" -i /usr/share/icons/HighContrast/48x48/status/mail-unread.png -t 5000 &
fi

#notmuch new &
