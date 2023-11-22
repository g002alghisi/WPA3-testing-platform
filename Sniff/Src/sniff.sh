#!/bin/bash
#set -x  # Debug mode.

### ### ### Launch Wireshark script ### ### ###
# This script is used to setup everything needed to use wireshark with the wireless card.
# In particular, it sets the wireless card in monitor mode, and then runs wireshark.

### Input
# The program accepts a single (optional) argument, to specify wireless card.
#       launch_wireshark.sh [-w wifi_if]

### Output
# To do...


### *** Files, interfaces and constants *** ###

# Move to Sniff/ folder
cd "$(dirname "$0")"
ecurrent_path=$(pwd)
while [[ "$current_path" != *"/Sniff" ]]; do
    cd ..
    current_path=$(pwd)
done


wifi_if="wlx5ca6e63fe2da"
channel=0


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



## *** WiFi *** ###

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
    sudo rfkill unblock wlan  > /dev/null &&
    sudo ip link set "$wifi_if" > /dev/null up
    if [ $? -eq 0 ]; then
        log_success
    else
        log_error
    fi
}

wifi_check_conn() {
    log_info "Checking WiFi connection... "

    wifi_current_conn=$(echo "$wifi_if_status" | grep ":connected:" | cut -d ':' -f 4)
    if [ -n "$wifi_current_conn" ]; then
        log_success
        log_info "$wifi_if currently connected to $wifi_current_conn. Disconnecting..."

        if nmcli c down "$wifi_current_conn" > /dev/null; then
            log_success
        else
            log_error
        fi
    else
        log_success
        log_info "$wifi_if currently not connected."
    fi
}

wifi_if_set_monitor () {
    log_info "Setting $wifi_if in monitor mode... "
    sudo airmon-ng check kill > /dev/null &&
    if [ "$channel" -eq 0 ]; then
        sudo airmon-ng start "$wifi_if" > /dev/null
    else
        sudo airmon-ng start "$wifi_if" "$channel" > /dev/null
    fi
    new_wifi_if="$(ifconfig | grep "$wifi_if" | cut -d ":" -f 1)"
    if [ $? -eq 0 ]; then
        log_success
        # The previous command is needed because sometimes
        # the wifi_interface name is changed in this way:
        #   wlan0 -> wlan0mon
    else
        log_error
        return 1
    fi
}

wifi_if_set_default () {
    log_info "Setting $new_wifi_if in default mode... "
    sudo airmon-ng stop "$new_wifi_if" > /dev/null &&
    sudo ip link set "$wifi_if" up > /dev/null
    if [ $? -eq 0 ]; then
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



### *** Handle monitor mode *** ###



### ### ### Main section ### ### ###

wireshark_setup () {
    echo ""
    wifi_check_if &&
    wifi_check_conn &&
    nm_stop &&
    wifi_if_set_monitor
}

wireshark_run() {
    echo ""
    echo -e "${CYAN}Running Wireshark. Press Ctrl-C to stop.${NC}"
    echo ""
    sudo wireshark
    echo ""
    echo -e "${CYAN}Wiresharkd is stopped.${NC}"
    echo ""
}

wireshark_setdown() {
    wifi_if_set_default
    nm_start
    echo ""
}



main() {
    while getopts "w:c:" opt; do
        case $opt in
            w)
                wifi_if="$OPTARG"
                ;;
            c)
                channel="$OPTARG"
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                exit 1
                ;;
        esac
    done

    shift $((OPTIND-1))

    if [ $# -ne 0 ]; then
        echo "Usage: $0 [-w wifi_if] [-c channel]"
        exit 1
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    stty -echo

    wireshark_setup &&
    wireshark_run
    wireshark_setdown

    stty echo
}


main "$@"
