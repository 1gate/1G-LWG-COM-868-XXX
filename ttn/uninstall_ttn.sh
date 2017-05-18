#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

echo "The Things Network Uninstaller"

INSTALL_DIR="/opt/ttn"

systemctl stop ttn.service
systemctl disable ttn.service
rm -rf $INSTALL_DIR

echo "Uninstall completed."
