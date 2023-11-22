#!/bin/bash
#set -x  # debug mode

WPA_SUPPLICANT_PATH="Build/wpa_supplicant"

### ### ### Logging ### ### ###

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

wpa_supplicant_verbose_mode=0



### ### ### wpa_supplicant config file ### ### ###

wpa_supplicant_conf_file_check() {
    log_info "Looking for $wpa_supplicant_config_file... "
    if [ -e "$wpa_supplicant_config_file" ]; then
        log_success
    else
        log_success
        echo "wpa_supplicant configuration file $wpa_supplicant_config_file not found. Please check the file path."
        return 1
    fi
}



### ### ### WiFi ### ### ###&

wifi_check_if() {
    log_info "Checking WiFi interface... "

    wifi_if_status=$(nmcli -t device status | grep "$wifi_if" | grep ':wifi:')
    if [ $? -eq 0 ]; then
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
        # Setting down the current connection. Can interfere with wpa_supplicant.
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



### ### ### Print STA information ### ### ###

sta_print_info() {
    echo "STA settings:"
    echo ""
    cat "$wpa_supplicant_config_file" | grep -vE '^(#|$)'
    echo ""
}

sta_setup() {
    echo ""
    nm_start > /dev/null &&
    wpa_supplicant_conf_file_check &&
    wifi_check_if &&
    wifi_check_conn &&
    nm_stop
    echo ""
}

sta_run() {
    echo -e "${CYAN}Running Wpa-supplicant. Press Ctrl-C to stop.${NC}"
    echo ""
    sta_print_info
    echo ""
    sudo killall wpa_supplicant &> /dev/null
    if [ $cli_mode -eq 0 ]; then
        if [ $wpa_supplicant_verbose_mode -eq 0 ]; then
            sudo "$wpa_supplicant" -i "$wifi_if" -c "$wpa_supplicant_config_file"
        else
            sudo "$wpa_supplicant" -i "$wifi_if" -c "$wpa_supplicant_config_file" -d
        fi
    else
        sudo "$wpa_supplicant" -B -i "$wifi_if" -c "$wpa_supplicant_config_file"
        echo ""
        echo -e "${CYAN}Wpa_cli is running too...${NC}"
        echo ""
        sudo wpa_cli
    fi
    echo ""
    echo -e "${CYAN}Wpa_supplicant is stopped.${NC}"
    echo ""
}

sta_setdown() {
    sudo killall wpa_supplicant &> /dev/null
    sudo killall wpa_cli &> /dev/null
    nm_start
    echo ""
}



### ### ### Main section ### ### ###

main() {
    wifi_if=""
    wpa_supplicant_config_file=""
    wpa_supplicant_verbose_mode=0
    cli_mode=0
    while getopts "w:c:l:d" opt; do
        case $opt in
            w)
                wifi_if="$OPTARG"
                ;;
            c)
                wpa_supplicant_config_file="$OPTARG"
                ;;
            l)
                cli_mode=1
                wpa_supplicant_config_file="$OPTARG"
                ;;
            d)
                wpa_supplicant_verbose_mode=1
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

    if [ "$wifi_if" == "" ] || [ "$wpa_supplicant_config_file" == "" ]; then
        echo "Usage: $0 -w wifi_if <-c conf | -l conf_cli> [-d]"
        exit 1
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    sta_setup &&
    sta_run
    sta_setdown
}


main $@