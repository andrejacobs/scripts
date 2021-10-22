#!/bin/bash
# This script will generate the list of pip dependencies as a requirements.txt file.
# Author: André Jacobs

set -eu
set -o pipefail
#set -x # debug

# The assumption is that the virtual environment was created in the ./venv directory
source ./venv/bin/activate

echo "Creating the list of pip dependencies to the file: requirements.txt"
pip3 freeze > requirements.txt
