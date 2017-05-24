#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

echo "Loriot Installer"

# Create the required install directory
INSTALL_DIR="/opt/loriot"
if [ ! -d "$INSTALL_DIR" ]; then mkdir $INSTALL_DIR; fi
pushd $INSTALL_DIR

# Get the Loriot paket forwarder
wget -N https://eu1.loriot.io/home/gwsw/loriot-pi-3-ic880a-SPI-0-latest.bin
chmod a+x loriot-pi-3-ic880a-SPI-0-latest.bin

# Symlink
if [ ! -d bin ]; then mkdir bin; fi
if [ -f ./bin/loriot_pkt_fwd ]; then rm ./bin/loriot_pkt_fwd; fi
ln -s $INSTALL_DIR/loriot-pi-3-ic880a-SPI-0-latest.bin ./bin/loriot_pkt_fwd

popd

echo "Installation completed."

# Start packet forwarder as a service
cp ./reset_lgw.sh $INSTALL_DIR/bin/
cp ./start.sh $INSTALL_DIR/bin/
cp ./loriot.service /lib/systemd/system/
# systemctl enable loriot.service

echo "The system will reboot in 5 seconds..."
sleep 5
shutdown -r now
