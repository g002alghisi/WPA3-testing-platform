#!/bin/bash
#set -x  # Debug mode.

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

# Move to Hostapd/ folder
cd "$(dirname "$0")"
ecurrent_path=$(pwd)
while [[ "$current_path" != *"/Hostapd" ]]; do
    cd ..
    current_path=$(pwd)
done

hostapd="Build/hostapd"
hostapd_mode_verbose=0;

eth_if="enp4s0f1"
wifi_if="wlp3s0"
br_if="br-ap"

HOSTAPD_WPA2_CONF_PATH="Conf/Ko/hostapd_wpa2.conf"
HOSTAPD_WPA3_CONF_PATH="Conf/Ko/hostapd_wpa3.conf"
HOSTAPD_WPA2_WPA3_CONF_PATH="Conf/Ko/hostapd_wpa2_wpa3.conf"
HOSTAPD_WPA3_PK_CONF_PATH="Conf/Ko/hostapd_wpa3_pk.conf"
HOSTAPD_ROGUE_WPA3_PK_WITHOUT_PK_CONF_PATH="Conf/Ko/hostapd_rogue_wpa3_pk_without_pk.conf"
HOSTAPD_ROGUE_WPA3_PK_WRONG_PRIV_KEY_CONF_PATH="Conf/Ko/hostapd_rogue_wpa3_pk_wrong_priv_key.conf"
HOSTAPD_ROGUE_WPA3_WITH_WPA2_CONF_PATH="Conf/Ko/hostapd_rogue_wpa3_with_wpa2.conf"


HOSTAPD_BASIC_WPA2_CONF_PATH="Conf/Basic/hostapd_wpa2.conf"
HOSTAPD_BASIC_WPA3_CONF_PATH="Conf/Basic/hostapd_wpa3.conf"
HOSTAPD_BASIC_WPA3_PK_CONF_PATH="Conf/Basic/hostapd_wpa3_pk.conf"



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

    eth_if_status=$(nmcli -t device status | grep "$eth_if" | grep ':ethernet:')
    if [ $? -eq 0 ]; then
        log_success
    else
        log_error
        return 1
    fi

   log_info "Forcing Ethernet interface up... "
   if sudo ip link set "$eth_if" up; then
       log_success
   else
       log_error
       return 1
   fi
}

eth_check_conn() {
    log_info "Checking Ethernet connection... "

    eth_current_conn=$(echo "$eth_if_status" | grep ":connected:" | cut -d ':' -f 4)
    if [ -n "$eth_current_conn" ]; then
        log_success
        log_info "$eth_if currently connected to $eth_current_conn."
    else
        log_error
        return 1
    fi
}



### *** WiFi *** ###

wifi_check_if() {
    log_info "Checking WiFi interface... "

    wifi_if_status=$(nmcli -t device status | grep "$wifi_if" | grep ':wifi:')
    if [ $? -eq 0 ]; then
        log_success
    else
        log_error
        return 1
    fi

   log_info "Forcing WiFi interface up... "
   if sudo ip link set "$wifi_if" up; then
       log_success
   else
       log_error
       return 1
   fi
}

wifi_check_conn() {
    log_info "Checking WiFi connection... "

    wifi_current_conn=$(echo "$wifi_if_status" | grep ":connected:" | cut -d ':' -f 4)
    if [ -n "$wifi_current_conn" ]; then
        log_success
        log_info "$wifi_if currently connected to $wifi_current_conn. Disconnecting..."
        # Setting down the current connection. Can interfere with hostapd.
        if nmcli c down "$wifi_current_conn" > /dev/null; then
            log_success
        else
            log_error
            return 1
        fi
    else
        log_success
        log_info "$wifi_if currently not connected."
    fi
}



### *** Bridge *** ###

br_setup() {
    log_info "Creating the bridge... "
    if brctl show | grep -q "$br_if"; then
        br_setdown
    fi
    if sudo brctl addbr "$br_if" &&
        sudo brctl addif "$br_if" "$eth_if"; then
        log_success
    else
        log_error
        return 1
    fi

    log_info "Forcing up the bridge... "
    if sudo ip link set "$br_if" up; then
        log_success
    else
        log_error
        return 1
    fi
}

br_setdown() {
    log_info "Forcing down the bridge $br_if... "
    if sudo ip link set "$br_if" down; then
        log_success
    else
        log_error
        return 1
    fi

    log_info "Deleting the bridge... "
    if sudo brctl delbr "$br_if"; then
        log_success
    else
        log_error
        return 1
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



### *** Print AP information *** ###

ap_print_info() {
    echo "AP settings:"
    echo ""
    cat "$hostapd_config_file" | grep -vE '^(#|$)'
    echo ""
}



### ### ### Main section ### ### ###

ap_setup() {
    echo ""
    nm_start &&
    hostapd_conf_file_check &&
    eth_check_if &&
    eth_check_conn &&
    wifi_check_if &&
    wifi_check_conn &&
    nm_stop &&    # Disable nmcli. It can interfere with brctl.
    br_setup
}

ap_run() {
    echo ""
    echo -e "${CYAN}Running Hostapd. Press Ctrl-C to stop.${NC}"
    echo ""
    ap_print_info
    echo ""
    killall hostapd &> /dev/null
    if [ "$hostapd_mode_verbose" -eq 0 ]; then
        sudo "$hostapd" "$hostapd_config_file"
    else
        sudo "$hostapd" "$hostapd_config_file" -d
    fi
    echo ""
    echo -e "${CYAN}Hostapd is stopped.${NC}"
    echo ""
}

ap_setdown() {
    br_setdown
    nm_start
    echo ""
}



main() {

        while getopts "w:e:d" opt; do
        case $opt in
            w)
                wifi_if="$OPTARG"
                ;;
            e)
                eth_if="$OPTARG"
                ;;
            d)
                hostapd_mode_verbose=1
                ;;
            \?)
                echo "Invalid option: -$OPTARG"
                exit 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument."
                exit 1
                ;;
        esac
    done

    shift $((OPTIND-1))

    if [ $# -ne 1 ]; then
        echo "Usage: $0 [-d] [-w wifi_if] [-e eth_if] <wpa2|wpa3|wpa3-pk|...>"
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
        "wpa2-wpa3")
            hostapd_config_file="$HOSTAPD_WPA2_WPA3_CONF_PATH"
            ;;
        "wpa3-pk")
            hostapd_config_file="$HOSTAPD_WPA3_PK_CONF_PATH"
            ;;
        "basic-wpa2")
            hostapd_config_file="$HOSTAPD_BASIC_WPA2_CONF_PATH"
            ;;
        "basic-wpa3")
            hostapd_config_file="$HOSTAPD_BASIC_WPA3_CONF_PATH"
            ;;
        "basic-wpa3-pk")
            hostapd_config_file="$HOSTAPD_BASIC_WPA3_PK_CONF_PATH"
            ;;
        "rogue-wpa3-pk-without-pk")
            hostapd_config_file="$HOSTAPD_ROGUE_WPA3_PK_WITHOUT_PK_CONF_PATH"
            ;;
        "rogue-wpa3-pk-wrong-priv-key")
            hostapd_config_file="$HOSTAPD_ROGUE_WPA3_PK_WRONG_PRIV_KEY_CONF_PATH"
            ;;
        "rogue-wpa3-with-wpa2")
            hostapd_config_file="$HOSTAPD_ROGUE_WPA3_WITH_WPA2_CONF_PATH"
            ;;
        *)
            echo -e "Invalid parameter (wpa2|wpa3|wpa3-pk|...)."
            exit 1
            ;;
    esac

    sed -i "s/^interface=.*/interface=$wifi_if/" "$hostapd_config_file"

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v


    stty -echo

    ap_setup &&
    ap_run
    ap_setdown

    stty echo
}


main "$@"
