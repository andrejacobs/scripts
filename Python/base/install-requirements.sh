#!/bin/bash
# This script will install the required pip dependencies from the requirements.txt
# Author: André Jacobs

set -eu
set -o pipefail
#set -x # debug

# The assumption is that the virtual environment was created in the ./venv directory
source ./venv/bin/activate

echo "Installing pip dependencies"
pip3 install -r requirements.txt
