#! /bin/bash

# Reset SX1301

# GPIO Header pin 22 (GPIO25)

echo "25" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio25/direction
echo "1" > /sys/class/gpio/gpio25/value
sleep 5
echo "0" > /sys/class/gpio/gpio25/value
echo "25" > /sys/class/gpio/unexport

# Test the connection, wait if needed.
while [[ $(ping -c1 google.com 2>&1 | grep " 0% packet loss") == "" ]]; do
  echo "[LoRa Gateway]: Waiting for internet connection..."
  sleep 30
  done

# Fire up the forwarder.
./ttn_pkt_fwd start --config /etc/ttn/ttn_pkt_fwd.yml --reset-pin 25 --gps-path /dev/ttyS0
