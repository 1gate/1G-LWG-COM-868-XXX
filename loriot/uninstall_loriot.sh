#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

echo "Loriot Uninstaller"

INSTALL_DIR="/opt/loriot"

systemctl stop loriot.service
systemctl disable loriot.service
rm -rf $INSTALL_DIR

echo "Uninstall completed."


