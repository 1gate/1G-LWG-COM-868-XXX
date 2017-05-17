#!/bin/sh

# This script is intended to be used on 1GATE LoRaWAN Compact and Premium Gateway, it performs
# the following actions:
#
#       - export/unexport GPIO25 used to reset the SX1301 chip
#
# Usage examples:
#
#       ./reset_sx1301.sh stop
#       ./reset_sx1301.sh start

# The reset pin of SX1301 is wired with RPi GPIO25

    SX1301_RESET_PIN=25

echo "Accessing concentrator reset pin through GPIO$SX1301_RESET_PIN..."

WAIT_GPIO() {
    sleep 0.1
}

sx1301_init() {
    # setup GPIO
    echo "$SX1301_RESET_PIN" > /sys/class/gpio/export; WAIT_GPIO

    # set GPIO as output
    echo "out" > /sys/class/gpio/gpio$SX1301_RESET_PIN/direction; WAIT_GPIO

    # write output for SX1301 reset
    echo "1" > /sys/class/gpio/gpio$SX1301_RESET_PIN/value; WAIT_GPIO
    echo "0" > /sys/class/gpio/gpio$SX1301_RESET_PIN/value; WAIT_GPIO

    # set GPIO as input
    echo "in" > /sys/class/gpio/gpio$SX1301_RESET_PIN/direction; WAIT_GPIO
}

sx1301_term() {
    # cleanup GPIO
    if [ -d /sys/class/gpio/gpio$SX1301_RESET_PIN ]
    then
        echo "$SX1301_RESET_PIN" > /sys/class/gpio/unexport; WAIT_GPIO
    fi
}

case "$1" in
    start)
    sx1301_term
    sx1301_init
    ;;
    stop)
    sx1301_term
    ;;
    *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac

exit 0
