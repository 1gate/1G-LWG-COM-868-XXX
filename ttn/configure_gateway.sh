#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

echo "Configure Gateway with TTN Packet Forwarder"

# Create the configuration file
./opt/ttn/bin/ttn_pkt_fwd configure --configure /etc/ttn/ttn_pkt_fwd.yml

echo "Configuration completed."
