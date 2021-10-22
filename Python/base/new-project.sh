#!/bin/bash
# This script will create a basic Python project the way I like it
# Author: André Jacobs

set -eu
set -o pipefail
#set -x # debug

if [[ ! -f ./.gitignore ]]; then
  echo "Creating .gitignore"
  echo "# Environments" >> ./.gitignore
  echo "venv/" >> ./.gitignore
fi

if [[ ! -d ./venv ]]; then
  echo "Creating a new Python virtual environment"
  python3 -m venv ./venv
fi

echo "Sourcing the virtual environment"
source ./venv/bin/activate

echo "Upgrading pip"
python3 -m pip install --upgrade pip

echo ""
echo "Don't forget to activate the venv on every shell session:"
echo "  source ./venv/bin/activate"
