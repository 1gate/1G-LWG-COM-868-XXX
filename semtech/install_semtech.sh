#!/bin/bash

echo "Install Semtech"

# Stop on the first sign of trouble
set -e

# Create the required install directory and make sure it is clean
INSTALL_DIR="/opt/semtech"
if [ ! -d "$INSTALL_DIR" ]; then mkdir $INSTALL_DIR; fi
pushd $INSTALL_DIR
rm -rf *

# Build lora gateway libraries
if [ ! -d lora_gateway ]; then
    git clone https://github.com/Lora-net/lora_gateway.git
    pushd lora_gateway
else
    pushd lora_gateway
    git reset --hard
    git pull
fi

make clean all

popd

# Build packet forwarder
if [ ! -d packet_forwarder ]; then
    git clone https://github.com/Lora-net/packet_forwarder.git
    pushd packet_forwarder
else
    pushd packet_forwarder
    git pull
    git reset --hard
fi

make clean all

popd

# Symlink
if [ ! -d bin ]; then mkdir bin; fi
if [ -f ./bin/semtech_pkt_fwd ]; then rm ./bin/semtech_pkt_fwd; fi
ln -s $INSTALL_DIR/packet_forwarder/lora_pkt_fwd/lora_pkt_fwd ./bin/semtech_pkt_fwd
cp -f ./packet_forwarder/lora_pkt_fwd/cfg/global_conf.json.PCB_E286.EU868.basic ./bin/global_conf.json
cp -f ./packet_forwarder/lora_pkt_fwd/local_conf.json ./bin/local_conf.json

# Reset gateway ID based on MAC
./packet_forwarder/lora_pkt_fwd/update_gwid.sh ./bin/local_conf.json

popd

echo "Installation completed."

# Start packet forwarder as a service
cp ./start.sh $INSTALL_DIR/bin/
cp ./semtech.service /lib/systemd/system/
systemctl enable semtech.service

echo "The system will reboot in 5 seconds..."
sleep 5
shutdown -r now
