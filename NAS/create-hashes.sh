#!/bin/bash
# This script will generate a file containing all the hashes of files in this directory and sub directories.
# You will need to have hashdeep installed. "sudo apt install hashdeep" or "brew install hashdeep"

if [ -f ./hashes.sha256 ]; then
	echo "The file hashes.sha256 already exists!" >&2
	exit 1
fi

echo "Calculating hashes ..."
hashdeep -c sha256 -l -r ./ | sed -e '/create-hashes.sh/d' -e '/hashes.sha256/d' > ./hashes.sha256
echo "Hashes have been written to ./hashes.sha256"

echo "Creating script './verify-hashes.sh' used to check if all hashes still match the files"
echo "#!/bin/bash" > ./verify-hashes.sh
echo "hashdeep -c sha256 -k ./hashes.sha256 -x -l -r ./ | sed -e '/create-hashes.sh/d' -e '/hashes.sha256/d' -e '/hashes_did_not_match.txt/d' -e '/verify-hashes.sh/d' > hashes_did_not_match.txt" >> ./verify-hashes.sh
chmod +x ./verify-hashes.sh
