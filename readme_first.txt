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

$ sudo systemctl start semtech.service
$ sudo systemctl stop semtech.service
$ sudo systemctl restart semtech.service

Checking the status of service :

$ sudo systemctl status semtech.service

Enabling / disabling service :

Start service automatically at boot
$ sudo systemctl enable semtech.service

Disable the service from starting automatically
$ sudo systemctl disable semtech.service

See packet forwarder activity
$ sudo tail -f /var/log/syslog
or
$ sudo tcpdump -AUq port 1680

--- Loriot Folder ---

Install_loriot.sh : install libraries, packet forwarder, update the gateway id

loriot.service : make it a service

start.sh : start semtech_pkt_fwd in background

uninstall_loriot.sh : stop service, remove links, delete installation folder

--- Install ---

$ cd loriot
$ sudo ./install_loriot.sh

--- Update ---

If you have a running gateway and want to update, simply run the installer again

$ cd loriot
$ sudo ./install_loriot.sh

--- Start manually the packet forwarder (foreground)---

$ cd /opt/loriot/bin

$ sudo ./reset_lgw.sh start 25

$ sudo ./loriot_pkt_fwd -f

Ctrl-C to abort

--- How to use systemctl to manage loriot service (see semtech.service & start.sh) ---

start.sh reset the gateway (SX1301/SX1308), no need to do it manually

Starting / Stopping / Restarting  :

$ sudo systemctl start loriot.service
$ sudo systemctl stop loriot.service
$ sudo systemctl restart loriot.service

Checking the status of service :

$ sudo systemctl status loriot.service

Enabling / disabling service :

Start service automatically at boot
$ sudo systemctl enable loriot.service

Disable the service from starting automatically
$ sudo systemctl disable loriot.service

See packet forwarder activity
$ sudo tail -f /var/log/syslog
or
$ sudo tcpdump -AUq port 1680


--- The Things Network Folder ---

Install_ttn.sh : install libraries, packet forwarder, update the gateway id

ttn.service : make it a service

start.sh : start semtech_pkt_fwd in background

uninstall_ttn.sh : stop service, remove links, delete installation folder

--- Install ---

$ cd ttn
$ sudo ./install_ttn.sh

--- Update ---

If you have a running gateway and want to update, simply run the installer again

$ cd ttn
$ sudo ./install_ttn.sh

--- Configuration ---

$ sudo nano /opt/ttn/bin/global_conf.json

change server_adress, serv_port_up and serv_port_down with the parameters of the network server.

for example 

    "gateway_conf": {
        /* change with default server address/ports, or overwrite in local_conf.json */
        "gateway_ID": "AA555A0000000000",
        /* Devices */
        "gps": true,
        "beacon": false,
        "monitor": false,
        "upstream": true,
        "downstream": true,
        "ghoststream": false,
        "radiostream": true,
        "statusstream": true,
        /* node server */
        "server_address": "127.0.0.1",
        "serv_port_up": 1680,
        "serv_port_down": 1681,
        /* node servers for poly packet server (max 4) */
        "servers":
        [ { "server_address": "127.0.0.1",
            "serv_port_up": 1680,
            "serv_port_down": 1681,
            "serv_enabled": true },
          { "server_address": "router.eu.thethings.network",
            "serv_port_up": 1700,
            "serv_port_down": 1700,
            "serv_enabled": true },
          { "server_address": "iot.semtech.com",
            "serv_port_up": 1680,
            "serv_port_down": 1680,
            "serv_enabled": true } ],
        /* adjust the following parameters for your network */
        "keepalive_interval": 10,
        "stat_interval": 30,
        "push_timeout_ms": 100,
        /* forward only valid packets */
        "forward_crc_valid": true,
        "forward_crc_error": false,
        "forward_crc_disabled": false,
        /* GPS configuration */
        "gps_tty_path": "/dev/ttyS0",
        "fake_gps": false,
        "ref_latitude": 10,
        "ref_longitude": 20,
        "ref_altitude": -1,
        /* Ghost configuration */
        "ghost_address": "127.0.0.1",
        "ghost_port": 1918,
        /* Monitor configuration */
        "monitor_address": "127.0.0.1",
        "monitor_port": 2008,
        "ssh_path": "/usr/bin/ssh",
        "ssh_port": 22,
        "http_port": 80,
        "ngrok_path": "/usr/bin/ngrok",
        "system_calls": ["df -m","free -h","uptime","who -a","uname -a"],
        /* Platform definition, put a asterix here for the system value, max 24 chars. */
        "platform": "*", 
        /* Email of gateway operator, max 40 chars*/
        "contact_email": "operator@gateway.tst", 
        /* Public description of this device, max 64 chars */
        "description": "Update me"       
}

--- Start manually the poly packet forwarder (foreground)---

$ cd /opt/ttn/bin

$ sudo ./reset_lgw.sh start 25

$ sudo ./ttn_pkt_fwd

Ctrl-C to abort

--- How to use systemctl to manage ttn service (see ttn.service & start.sh) ---

start.sh reset the gateway (SX1301/SX1308), no need to do it manually

Starting / Stopping / Restarting  :

$ sudo systemctl start ttn.service
$ sudo systemctl stop ttn.service
$ sudo systemctl restart ttn.service

Checking the status of service :

$ sudo systemctl status ttn.service

Enabling / disabling service :

Start service automatically at boot
$ sudo systemctl enable ttn.service

Disable the service from starting automatically
$ sudo systemctl disable ttn.service

See packet forwarder activity
$ sudo tail -f /var/log/syslog
or
$ sudo tcpdump -AUq port 1700
