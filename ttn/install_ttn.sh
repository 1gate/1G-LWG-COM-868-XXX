#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

echo "The Things Network Installer"

# Create the required install directory
INSTALL_DIR="/opt/ttn"
if [ ! -d "$INSTALL_DIR" ]; then mkdir $INSTALL_DIR; fi
pushd $INSTALL_DIR

# Get the The Things Network packet forwarder
wget -N https://github.com/TheThingsNetwork/packet_forwarder/releases/download/v2.0.1/imst-rpi-pktfwd.tar.gz
tar xvf imst-rpi-pktfwd.tar.gz
chmod a+x packet-forwarder

# Symlink
if [ ! -d bin ]; then mkdir bin; fi
if [ -f ./bin/ttn_pkt_fwd ]; then rm ./bin/ttn_pkt_fwd; fi
ln -s $INSTALL_DIR/packet-forwarder ./bin/ttn_pkt_fwd

# Create the required config directory
CONFIG_DIR="/etc/ttn"
if [ ! -d "$CONFIG_DIR" ]; then mkdir $CONFIG_DIR; fi

# Create the configuration file
touch /etc/ttn/ttn_pkt_fwd.yml

popd

echo "Installation completed."

# Start packet forwarder as a service
cp ./reset_lgw.sh $INSTALL_DIR/bin/
cp ./start.sh $INSTALL_DIR/bin/
cp ./ttn.service /lib/systemd/system/
# systemctl enable ttn.service

echo "The system will reboot in 5 seconds..."
sleep 5
shutdown -r now
