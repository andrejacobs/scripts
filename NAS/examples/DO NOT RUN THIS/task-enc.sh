#/!bin/bash
echo "DISABLED, only uncomment and run this if you know what you are doing."
exit 1
#
#echo "Writing random data to /dev/md0"
#openssl enc -aes-256-ctr -pass pass:"$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)" -nosalt < /dev/zero | pv -pterb | dd bs=4096 of=/dev/md0
#
#EMAILTO="someone@somewhere.com"
#EMAILBODY="Finished writing random data"
#echo $EMAILBODY | /usr/bin/mail -s "[SIMBA] Writing random data" $EMAILTO

#echo ""
#echo "Done!"
