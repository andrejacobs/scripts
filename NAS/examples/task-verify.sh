#/!bin/bash

cd /media/megalodon/backup/greatwhite/greatwhite
./verify-hashes.sh

cd /media/megalodon/backup/hammerhead/hammerhead
./verify-hashes.sh

EMAILTO="someone@somewhere.com"
EMAILBODY="Finished checking the hashes"
echo $EMAILBODY | /usr/bin/mail -s "[SIMBA] Hashes have been checked" $EMAILTO

echo ""
echo "Done!"
