#!/bin/bash
#set -x  # debug mode

HOSTAPD_PATH="Build/hostapd"

### ### ### Logging ### ### ###s

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



### ### ### Ethernet ### ### ###

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



### ### ### WiFi ### ### ###

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



### ### ### Bridge ### ### ###

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



### ### ### NetworkManager ### ### ###

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



### ### ### AP ### ### ###

ap_conf_file_check() {
    log_info "Looking for $ap_config_file... "
    if [ -e "$ap_config_file" ]; then
        log_success
    else
        log_success
        echo "Hostapd configuration file $ap_config_file not found. Please check the file path."
        return 1
    fi
}

ap_print_info() {
    echo "AP settings:"
    echo ""
    cat "$ap_config_file" | grep -vE '^(#|$)'
    echo ""
}

ap_setup() {
    echo ""
    nm_start &&
    ap_conf_file_check &&
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
    if [ "$ap_verbose_mode" -eq 0 ]; then
        sudo "$HOSTAPD_PATH" "$ap_config_file"
    else
        sudo "$HOSTAPD_PATH" "$ap_config_file" -d
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



### ### ### Main section ### ### ###

main() {
    wifi_if=""
    eth_if=""
    br_if=""
    ap_config_file=""
    ap_verbose_mode=0
    while getopts "w:e:b:c:d" opt; do
        case $opt in
            w)
                wifi_if="$OPTARG"
                ;;
            e)
                eth_if="$OPTARG"
                ;;
            b)
                br_if="$OPTARG"
                ;;
            c)
                ap_config_file="$OPTARG"
                ;;
            d)
                ap_verbose_mode=1
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

    if [ "$wifi_if" == "" ] || [ "$eth_if" == "" ] || [ "$br_if" == "" ] || [ "$ap_config_file" == "" ]; then
        echo "Usage: $0 -w wifi_if -e eth_if -b br_if -c conf [-d]"
        exit 1
    fi

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