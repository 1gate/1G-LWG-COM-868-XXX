--- LoRaWAN Gateway / Compact Edition ---

--- Quick Start Guide --- 

Login as ogate (default password : ogate)

Clone the installer

$ sudo git clone https://github.com/1gate/1G-LWG-COM-868-XXX

$ cd 1G-LWG-COM-868-XXX

Update the hostname to 1gate-mac_address

$ sudo ./update_hostname.sh

Choose your packet forwarder (semtech, loriot, ttn)

--- Semtech folder ---

install_semtech.sh : install libraries, packet forwarder, update the gateway id

semtech.service : make it a service

start.sh : start semtech_pkt_fwd in background

uninstall_semtech.sh : stop service, remove links, delete installation folder

--- Install ---

$ cd semtech
$ sudo ./install_semtech.sh

--- Update ---

If you have a running gateway and want to update, simply run the installer again

$ cd semtech
$ sudo ./install_semtech.sh

--- Configuration ---

$ sudo nano /opt/semtech/bin/global_conf.json

change server_adress, serv_port_up and serv_port_down with the parameters of the network server.

for example 

    "gateway_conf": {
        "gateway_ID": "AA555A0000000000",
        /* change with default server address/ports, or overwrite in local_conf.json */
        "server_address": "iot.semtech.com",
        "serv_port_up": 1680,
        "serv_port_down": 1680,
        /* adjust the following parameters for your network */
        "keepalive_interval": 10,
        "stat_interval": 30,
        "push_timeout_ms": 100,
        /* forward only valid packets */
        "forward_crc_valid": true,
        "forward_crc_error": false,
        "forward_crc_disabled": false
}

--- Start manually the packet forwarder (foreground)---

$ cd /opt/semtech/bin

$ sudo ./reset_lgw.sh start 25

$ sudo ./semtech_pkt_fwd

Ctrl-C to abort

--- How to use systemctl to manage semtech service (see semtech.service & start.sh) ---

start.sh reset the gateway (SX1301/SX1308), no need to do it manually

Starting / Stopping / Restarting  :

sudo systemctl start semtech.service
sudo systemctl stop semtech.service
sudo systemctl restart semtech.service

Checking the status of service :

sudo systemctl status semtech.service

Enabling / disabling service :

Start service automatically at boot
sudo systemctl enable semtech.service

Disable the service from starting automatically
sudo systemctl disable semtech.service
