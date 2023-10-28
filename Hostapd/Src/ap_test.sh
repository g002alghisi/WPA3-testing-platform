#!/bin/bash
# set -x  # Debug mode.

### ### ### Hostapd Acces Point script ### ### ###
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
#       hostapd_ap.sh [wpa2|wpa3]

### Output
# To do...


### *** Files, interfaces and constants *** ###

ETH_IF="enp4s0f1"
WIFI_IF="wlp3s0"
BR_IF="br-ap"

HOSTAPD_WPA2_CONF_PATH="../Conf/hostapd_wpa2.conf"
HOSTAPD_WPA3_CONF_PATH="../Conf/hostapd_wpa3_test.conf"
HOSTAPD_WPA3_PK_CONF_PATH="../Conf/hostapd_wpa3_pk.conf"


### *** Support *** ###

CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'    # No color

log_info() {
    echo "INFO: $1"
}

log_success() {
    echo -e "${GREEN}Success.${NC}"
}

log_error() {
    echo -e "${RED}Error.${NC}"
}


# Silent execution function. Execute the code printing just stderr.
se() {
    $* >/dev/null
    return $?
}



### *** hostapd Config *** ###

hostapd_conf_file_check() {
    log_info "Looking for $hostapd_config_file... "
    if [ -e "$hostapd_config_file" ]; then
        log_success
    else
        log_success
        echo "Hostapd configuration file $hostapd_config_file not found. Please check the file path."
        return 1
    fi
}



### *** Ethernet *** ###

eth_check_if() {
    log_info "Checking Ethernet interface... "

    eth_if_status=$(nmcli -t device status | grep "$ETH_IF" | grep ':ethernet:')
    if [ $? -eq 0 ]; then
        log_success
    else
        log_error
    fi

#    log_info "Forcing Ethernet interface up... "
#    if sudo ip link set "$ETH_IF" up; then
#        log_success
#    else
#        log_error
#    fi
}

eth_check_conn() {
    log_info "Checking Ethernet connection... "

    eth_current_conn=$(echo "$eth_if_status" | grep ":connected:" | cut -d ':' -f 4)
    if [ -n "$eth_current_conn" ]; then
        log_success
        log_info "$ETH_IF currently connected to $eth_current_conn."
    else
        log_error
    fi
}

eth_check() {
    eth_check_if
    eth_check_conn
    return $?
}


### *** WiFi *** ###

wifi_check_if() {
    log_info "Checking WiFi interface... "

    wifi_if_status=$(nmcli -t device status | grep "$WIFI_IF" | grep ':wifi:')
    if [ $? -eq 0 ]; then
        log_success
    else
        log_error
    fi

#    log_info "Forcing WiFi interface up... "
#    if sudo ip link set "$WIFI_IF" up; then
#        log_success
#    else
#        log_error
#    fi
}

wifi_check_conn() {
    log_info "Checking WiFi connection... "

    wifi_current_conn=$(echo "$wifi_if_status" | grep ":connected:" | cut -d ':' -f 4)
    if [ -n "$wifi_current_conn" ]; then
        log_success
        log_info "$WIFI_IF currently connected to $wifi_current_conn. Disconnecting..."
        # Setting down the current connection. Can interfere with hostapd.
        if nmcli c down "$wifi_current_conn" > /dev/null; then
            log_success
        else
            log_error
        fi
    else
        log_success
        log_info "$WIFI_IF currently not connected."
    fi
}

wifi_check() {
    wifi_check_if &&
    wifi_check_conn
}



### *** Bridge *** ###

br_setup() {
    log_info "Creating the bridge... "
    if brctl show | grep -q "$BR_IF"; then
        br_setdown
    fi
    if sudo brctl addbr "$BR_IF" &&
        sudo brctl addif "$BR_IF" "$ETH_IF"; then
        log_success
    else
        log_error
    fi

    log_info "Forcing up the bridge... "
    if sudo ip link set "$BR_IF" up; then
        log_success
    else
        log_error
    fi
}

br_setdown() {
    log_info "Forcing down the bridge $BR_IF... "
    if sudo ip link set "$BR_IF" down; then
        log_success
    else
        log_error
    fi

    log_info "Deleting the bridge... "
    if sudo brctl delbr "$BR_IF"; then
        log_success
    else
        log_error
    fi
}



### *** NetworkManager *** ###

nm_start() {
    if systemctl is-active NetworkManager > /dev/null; then
        log_info "NetworkManager is already active."
    else
        log_info "Starting Network Manager... "
        if sudo systemctl start NetworkManager; then
            log_success
        else
            log_error
            return 1
        fi
    fi
}

nm_stop() {
    log_info "Stopping Network Manager... "
    if sudo systemctl stop NetworkManager; then
        log_success
    else
        log_error
        return 1
    fi
}


### ### ### Main section ### ### ###

ap_setup() {
    echo ""
    nm_start &&
    hostapd_conf_file_check &&
    eth_check &&
    wifi_check &&
    nm_stop &&    # Disable nmcli. It can interfere with brctl.
    br_setup
}

ap_run() {
    echo ""
    echo -e "${CYAN}Running Hostapd. Press Ctrl-C to stop.${NC}"
    sudo hostapd "$hostapd_config_file"
    echo -e "${CYAN}Hostapd is stopped.${NC}"
    echo ""
}

ap_setdown() {
    br_setdown
    nm_start
    echo ""
}



main() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 STRING"
        exit 1
    fi

    security_protocol="$1"
    case $security_protocol in
        "wpa2")
            hostapd_config_file="$HOSTAPD_WPA2_CONF_PATH"
            ;;
        "wpa3")
            hostapd_config_file="$HOSTAPD_WPA3_CONF_PATH"
            ;;
        "wpa3-pk")
            hostapd_config_file="$HOSTAPD_WPA3_PK_CONF_PATH"
            ;;
        *)
            echo -e "Invalid parameter (wpa2|wpa3)."
            return 1
            ;;
    esac

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    # Trap to handle errors and start ap_setdown phase
    trap ap_setdown ERR

    stty -echo

    ap_setup &&
    ap_run
    ap_setdown

    stty echo
}


main $@
