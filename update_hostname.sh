#!/bin/sh

# This script is a helper to update the hostname of the gateway

NEW_HOSTNAME=$(ip link show eth0 | awk '/ether/ {print $2}' | awk -F\: '{print "1gate-"$1$2$3$4$5$6}')
#NEW_HOSTNAME=${NEW_HOSTNAME^^} #toupper

CURRENT_HOSTNAME=$(hostname)

echo "Updating hostname to '$NEW_HOSTNAME'..."
hostname $NEW_HOSTNAME
echo $NEW_HOSTNAME > /etc/hostname
sed -i "s/$CURRENT_HOSTNAME/$NEW_HOSTNAME/" /etc/hosts

exit 0
