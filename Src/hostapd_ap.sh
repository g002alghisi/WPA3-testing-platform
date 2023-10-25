#!/bin/bash

# set -x  # Debug mode.

### Full Acces Point script ###
# The function of this script is setting up an AP using hostapd and, by means
# of a bridge, get acces to the ethernet network, getting DHCP services and
# acces to the Internet.
# The security protocol used (WPA, WPA2, WPA3, ...) and the specific operational
# mode depends on the .conf file. The specific .conf file can be selected by
# means of an optiona parameter.
#
# The program is oranized as follow:
# - At the beginning, all the interfaces are manually specified. It has to be
#   highlighted that the WiFi interface has to match the one specified in the
#   hostapd.conf file.
# - It follows a setup phase, that consist of checking the state of all the
#   interfaces, stop NetworkManager, setup the bridge.
# - The hostapd deamon is then executed.
# - Finally, a setdown phase allows to dismiss the bridge, start NetworkManager.

### Input
# The program accepts a single (optional) argument, to specify the security
# protocol to be used between WPA2-Personal and WPA3-Personal.
#
#       hostapd_ap.sh [wpa2|wpa3]



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



### *** Input parameters *** ###

input_parameter_number="$#"
input_parameter="$@"

hostapd_config_file_wpa2="../Conf/hostapd_wpa2.conf"
hostapd_config_file_wpa3="../Conf/hostapd_wpa3.conf"

handle_input_parameter() {
    if [ "$input_parameter_number" -ne 1 ]; then
        echo -e "Wrong number of parameters. It should be 1: (wpa2|wpa3)."
        return 1
    fi

    security_protocol="$input_parameter"
    case $security_protocol in
        "wpa2")
            echo "[WPA2]"
            hostapd_config_file="$hostapd_config_file_wpa2"
            ;;
        "wpa3")
            echo "[WPA3]"
            hostapd_config_file="$hostapd_config_file_wpa3"
            ;;
        *)
            echo -e "Invalid parameter (wpa2|wpa3)."
            return 1
            ;;
    esac
}



### *** hostapd Config *** ###

hostapd_conf_file_check() {
    echo -n "Looking for $hostapd_config_file... "
    se test -e "$hostapd_config_file"
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

    # Force the eth_if up
    echo -n "Forcing Ethernet interface up... "
    se sudo ip link set $eth_if up
    if [ "$?" -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
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

    # Force the wifi_if up
    echo -n "Forcing WiFi interface up... "
    se sudo ip link set $wifi_if up
    if [ "$?" -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
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
    echo -n "Creating the bridge... "
    # Check if br_if already exists. If so, setdown the current and then setup
    # a new bridge.
    if ! [ -z "$(brctl show | grep $br_if)" ]; then
        se br_setdown
    fi
    se sudo brctl addbr "$br_if" &&
        se sudo brctl addif "$br_if" "$eth_if" &&
        # && se sudo brctl addif "$br_if" "$wifi_if" # Done by hostapd.
    if [ $? -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        return 1
    fi

    # Apparently, the bridge interface has been created, but not brought up.
    # To force it, the ip command can be used.
    echo -n "Forcing up the bridge... "
    se sudo ip link set "$br_if" up
    if [ $? -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        return 1
    fi
}

br_setdown() {
    # If the bridge doesn't exist, then do not do anything.
    if [ -z "$(brctl show | grep $br_if)" ]; then
        return
    fi

    echo -n "Forcig down the bridge $br_if... "
    se sudo ip link set "$br_if" down
    if [ $? -eq 0 ]; then
        gecho "Done."
    else
        recho "Failed."
        return 1
    fi

    echo -n "Deleting the bridge... "
    se sudo brctl delbr br-ap
    if [ $? -eq 0 ]; then
        gecho "Done"
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



### ### ### Main section ### ### ###

ap_setup() {
    echo ""
    handle_input_parameter &&
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
    sudo hostapd "$hostapd_config_file"
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


# Trap to handle errors and start ap_setdown phase
trap ap_setdown ERR

stty -echo  # Disable echo of keyboard
ap_setup &&
ap_run
ap_setdown
stty echo  # Disable echo of keyboard

