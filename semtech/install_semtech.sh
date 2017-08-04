#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

echo "Semtech Installer"

# Create the required install directory
INSTALL_DIR="/opt/semtech"
if [ ! -d "$INSTALL_DIR" ]; then mkdir $INSTALL_DIR; fi
pushd $INSTALL_DIR

# Build lora gateway libraries
if [ ! -d lora_gateway ]; then
    git clone https://github.com/1gate/lora_gateway.git
    pushd lora_gateway
else
    pushd lora_gateway
    git reset --hard
    git pull
fi

make

popd

# Build packet forwarder
if [ ! -d packet_forwarder ]; then
    git clone https://github.com/1gate/packet_forwarder.git
    pushd packet_forwarder
else
    pushd packet_forwarder
    git reset --hard
    git pull
fi

make

popd

# Symlink
if [ ! -d bin ]; then mkdir bin; fi
if [ -f ./bin/semtech_pkt_fwd ]; then rm ./bin/semtech_pkt_fwd; fi
ln -s $INSTALL_DIR/packet_forwarder/lora_pkt_fwd/lora_pkt_fwd ./bin/semtech_pkt_fwd
cp -f ./packet_forwarder/lora_pkt_fwd/cfg/global_conf.json.PCB_E286.EU868.basic ./bin/global_conf.json
#cp -f ./packet_forwarder/lora_pkt_fwd/cfg/global_conf.json.PCB_E286.EU868.gps ./bin/global_conf.json
#cp -f ./packet_forwarder/lora_pkt_fwd/cfg/global_conf.json.PCB_E286.EU868.beacon ./bin/global_conf.json
cp -f ./packet_forwarder/lora_pkt_fwd/local_conf.json ./bin/local_conf.json

popd

# Reset gateway ID based on MAC
./update_gwid.sh /$INSTALL_DIR/bin/local_conf.json

echo "Installation completed."

# Start packet forwarder as a service
cp ./reset_lgw.sh $INSTALL_DIR/bin/
cp ./start.sh $INSTALL_DIR/bin/
cp ./semtech.service /lib/systemd/system/
# systemctl enable semtech.service

#echo "The system will reboot in 5 seconds..."
#sleep 5
#shutdown -r now
