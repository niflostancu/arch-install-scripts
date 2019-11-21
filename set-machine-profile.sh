#!/bin/sh

set -e

if [ -z "$1" ]; then
	cat /etc/machine-profile
else
	echo "$1" | sudo tee /etc/machine-profile
	echo "Machine profile set to '$1'."
fi

