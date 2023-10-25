#!/bin/bash

# set -x  # Debug mode.

### Full Acces Point script ###
# The function of this script is setting up an AP using hostapd and, by means
# of a bridge, get acces to the ethernet network, getting DHCP services and
# acces to the Internet.
#
# The program is oranized as follow:
# - At the beginning, all the interfaces are manually specified. It has to be
#   highlighted that the WiFi interface has to match the one specified in the
#   hostapd.conf file.
# - It follows a setup phase, that consist of checking the state of all the
#   interfaces, stop NetworkManager, setup the bridge.
# - The hostapd deamon is then executed.
# - Finally, a setdown phase allows to dismiss the bridge, start NetworkManager.


# Update the cached credentials (this avoid the insertion of the sudo password
# during the execution of the successive commands).
sudo -v



### *** Support *** ###

CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'    # No color


recho() {
    if [ "$#" -eq 1 ]; then
        echo -e "${RED}$*${NC}"
    else
        echo "Error using recho. Too many arguments."
        return 1
    fi
}

gecho() {
    if [ "$#" -eq 1 ]; then
        echo -e "${GREEN}$*${NC}"
    else
        echo "Error using gecho. Too many arguments."
        return
    fi
}

cecho() {
    if [ "$#" -eq 1 ]; then
        echo -e "${CYAN}$*${NC}"
    else
        echo "Error using recho. Too many arguments."
        return 1
    fi
}


# Silent execution function. Execute the code printing just stderr.
se() {
    $* >/dev/null
    return $?
}




### *** hostapd Config *** ###

config_file="../Conf/hostapd_wpa2.conf"

hostapd_conf_file_check() {
    echo -n "Looking for hostapd.conf... "
    se test -e "$config_file"
    if [ "$?" -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        return 1
    fi
}



### *** Ethernet *** ###

eth_if="enp4s0f1"

eth_check_if() {
    echo -n "Checking Ethernet interface... "
    eth_if_status="$(nmcli -t device status | grep $eth_if | grep ':ethernet:')"
    if [ "$?" -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        echo "Ethernet $eth_if interface not found. Please check $eth_if"
        return 1
    fi
}

eth_check_conn() {
    echo -n "Checking Ethernet connection... "
    eth_current_conn="$(echo $eth_if_status | grep ":connected:" | cut -d ':' -f 4)"
    if ! [ -z "$eth_current_conn" ]; then
        gecho "Done."
        echo "$eth_if currently connected to $eth_current_conn."
    else
        recho "Failed."
        echo "$eth_if currently not connected. Please connect."
        return 1
    fi
}

eth_check() {
    eth_check_if && eth_check_conn
    return $?
}


### *** WiFi *** ###

wifi_if="wlp3s0"

wifi_check_if() {
    echo -n "Checking WiFi interface... "
    wifi_if_status="$(nmcli -t device status | grep $wifi_if | grep ':wifi:')"
    if [ $? -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        echo "WiFi $wifi_if interface not found. Please check $wifi_if."
        return 1
    fi

}

wifi_check_conn() {
    echo -n "Checking WiFi connection... "
    wifi_current_conn="$(echo $wifi_if_status | grep ":connected:"| cut -d ':' -f 4)"
    if ! [ -z "$wifi_current_conn" ]; then
        gecho "Done."
        echo -n "$wifi_if currently connected to $wifi_current_conn. Disconnecting..."
        # Setting down current connection. Can interfere with hostapd.
        se nmcli c down "$wifi_current_conn"
        if [ $? -eq 0 ]; then
            gecho "Done."
        else
            recho "Failed."
            return 1
        fi
    else
        gecho "Done."
        echo "$wifi_if currently not connected."
    fi
}

wifi_check() {
    wifi_check_if && wifi_check_conn
    return $?
}




### *** Bridge *** ###

br_if="br-ap"

br_setup() {
    echo -n "Setting up the bridge $br_if... "
    # Check if br_if already exists. If so, setdown the current and then setup
    # a new bridge.
    if ! [ -z "$(brctl show | grep $br_if)" ]; then
        se br_setdown
    fi
    se sudo brctl addbr "$br_if" &&
        se sudo brctl addif "$br_if" "$eth_if" &&
        # && se sudo brctl addif "$br_if" "$wifi_if" # Done by hostapd.
        se sudo ip link set "$br_if" up
        # Apparently, the bridge interface has been created, but not brought up.
        # To force it, the ip command can be used.
    if [ $? -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        return 1
    fi
}

br_setdown() {
    # If the bridge doesn't exist, then do not do anything.
    se brctl show | grep "$br_if"
    if [ $? -eq 0 ]; then
        return
    fi
    echo -n "Setting down the bridge $br_if... "
    se sudo ip link set "$br_if" down &&
        sudo brctl delbr br-ap
    if [ $? -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        return 1
    fi
}




### *** NetworkManager *** ###

nm_start() {
    se systemctl is-active NetworkManager
    if [ $? -eq 0 ]; then
        return
    fi
    echo -n "Starting Network Manager... "
    se sudo systemctl start NetworkManager # Restart nmcli.
    if [ $? -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        return 1
    fi
}

nm_stop() {
    echo -n "Stopping Network Manager... "
    se sudo systemctl stop NetworkManager
    if [ $? -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        return 1
    fi
}



### *** Main section *** ###

exit_status=0

ap_setup() {
    echo ""
    nm_start &&
        hostapd_conf_file_check &&
        eth_check &&
        wifi_check &&
        nm_stop &&    # Disable nmcli. It can interfere with brctl.
        br_setup
    return $?
}

ap_run() {
    local exit_status=0
    echo ""
    cecho "Running Hostapd. Press Ctrl-C to stop."
    sudo hostapd "$config_file"
    exit_status=$?
    cecho "Hostapd is stopped."
    echo ""
    return $?
}

ap_setdown() {
    local exit_status=0
    br_setdown || exit_status=$?
    nm_start || exit_status=$?
    echo ""
    return $exit_status
}

ap_setup &&
ap_run
ap_setdown
