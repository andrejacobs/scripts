#/!bin/bash

mkdir -p /media/megalodon/backup/greatwhite
mkdir -p /media/megalodon/backup/hammerhead

rsync -av /media/greatwhite /media/megalodon/backup/greatwhite
rsync -av /media/hammerhead /media/megalodon/backup/hammerhead  

EMAILTO="someone@somewhere.com"
EMAILBODY="Finished syncing all the data!"
echo $EMAILBODY | /usr/bin/mail -s "[SIMBA] Sync completed" $EMAILTO

echo ""
echo "Done!"
