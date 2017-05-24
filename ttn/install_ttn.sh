#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

echo "TTN Installer"

# Install LoRaWAN packet forwarder repositories
INSTALL_DIR="/opt/ttn"
if [ ! -d "$INSTALL_DIR" ]; then mkdir $INSTALL_DIR; fi
pushd $INSTALL_DIR

# Build lora gateway libraries
if [ ! -d lora_gateway ]; then
    git clone -b legacy https://github.com/TheThingsNetwork/lora_gateway.git
    pushd lora_gateway
else
    pushd lora_gateway
    git fetch origin
    git checkout legacy
    git reset --hard
fi

sed -i -e 's/PLATFORM= kerlink/PLATFORM= imst_rpi/g' ./libloragw/library.cfg

make

popd

# Build packet forwarder
if [ ! -d packet_forwarder ]; then
    git clone -b legacy https://github.com/TheThingsNetwork/packet_forwarder.git
    pushd packet_forwarder
else
    pushd packet_forwarder
    git fetch origin
    git checkout legacy
    git reset --hard
fi

make

popd

# Symlink poly packet forwarder
if [ ! -d bin ]; then mkdir bin; fi
if [ -f ./bin/ttn_pkt_fwd ]; then rm ./bin/ttn_pkt_fwd; fi
ln -s $INSTALL_DIR/packet_forwarder/poly_pkt_fwd/poly_pkt_fwd ./bin/ttn_pkt_fwd
cp -f ./packet_forwarder/poly_pkt_fwd/global_conf.json ./bin/global_conf.json
cp -f ./packet_forwarder/poly_pkt_fwd/local_conf.json ./bin/local_conf.json

popd

# Reset gateway ID based on MAC
./update_gwid ./$INSTALL_DIR/bin/local_conf.json

echo "Installation completed."

# Start packet forwarder as a service
cp ./reset_lgw.sh $INSTALL_DIR/bin/
cp ./start.sh $INSTALL_DIR/bin/
cp ./ttn.service /lib/systemd/system/
#systemctl enable ttn-gateway.service

echo "The system will reboot in 5 seconds..."
sleep 5
shutdown -r now
