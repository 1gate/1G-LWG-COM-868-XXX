#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

echo "Semtech Uninstaller"

INSTALL_DIR="/opt/semtech"

systemctl stop semtech.service
systemctl disable semtech.service
rm -rf $INSTALL_DIR

echo "Uninstall completed."
