#/!bin/bash

./create-hashes.sh

EMAILTO="someone@somewhere.com"
EMAILBODY="Finished generating checksums for "$(pwd)
echo $EMAILBODY | /usr/bin/mail -s "[SIMBA] Checksum task" $EMAILTO

echo ""
echo "Done!"
