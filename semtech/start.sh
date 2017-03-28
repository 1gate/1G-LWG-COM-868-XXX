#! /bin/bash

# Reset SX1301
# GPIO Header pin 22 / GPIO25
gpio -1 mode 22 out
gpio -1 write 22 0
sleep 0.1
gpio -1 write 22 1
sleep 0.1
gpio -1 write 22 0
sleep 0.1

# Test the connection, wait if needed.
while [[ $(ping -c1 google.com 2>&1 | grep " 0% packet loss") == "" ]]; do
  echo "[LoRa Gateway]: Waiting for internet connection..."
  sleep 30
  done

# Fire up the forwarder.
/opt/semtech/bin/lora_pkt_fwd
