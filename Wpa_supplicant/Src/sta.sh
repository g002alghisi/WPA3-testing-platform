#!/bin/bash
#set -x  # debug mode

# Home. DO NOT TERMINATE WITH /
HOME_FOLDER="Wpa_supplicant"

WPA_SUPPLICANT_PATH="Build/wpa_supplicant"
WPA_SUPPLICNT_CTRL_SOCKET="Tmp"

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



### ### ### Utilities ### ### ###

go_home() {
    cd "$(dirname "$HOME_FOLDER")"
    current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_FOLDER" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done
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



### ### ### STA ### ### ###

sta_conf_file_check() {
    log_info "Looking for $sta_conf_file... "
    if [ -e "$sta_conf_file" ]; then
        log_success
    else
        log_success
        echo "wpa_supplicant configuration file $sta_conf_file not found. Please check the file path."
        return 1
    fi
}

sta_print_info() {
    echo "STA settings:"
    echo ""
    cat "$sta_conf_file" | grep -vE '^(#|$)'
    echo ""
}

sta_setup() {

    echo ""
    nm_start > /dev/null &&
    sta_conf_file_check &&
    wifi_check_if &&
    wifi_check_conn &&
    nm_stop
    echo ""
}

sta_run() {
    sudo killall wpa_supplicant &> /dev/null
    sudo killall wpa_gui &> /dev/null

    if [ $sta_cli_mode -eq 1 ]; then
        gnome-terminal -- sudo wpa_cli -p "$WPA_SUPPLICNT_CTRL_SOCKET"

    fi

    if [ $sta_gui_mode -eq 1 ]; then
        gnome-terminal -- sudo wpa_gui -p "$WPA_SUPPLICNT_CTRL_SOCKET" -i "$wifi_if"

    fi

    echo -e "${CYAN}Running Wpa-supplicant. Press Ctrl-C to stop.${NC}"
    echo ""
    sta_print_info
    echo ""

    if [ $sta_verbose_mode -eq 0 ]; then
        sudo "$WPA_SUPPLICANT_PATH" -i "$wifi_if" -c "$sta_conf_file"
    else
        sudo "$WPA_SUPPLICANT_PATH" -i "$wifi_if" -c "$sta_conf_file" -d
    fi

    echo ""
    echo -e "${CYAN}Wpa_supplicant is stopped.${NC}"
    echo ""

    sudo killall wpa_supplicant &> /dev/null
    sudo killall wpa_cli &> /dev/null
}

sta_setdown() {
    nm_start
    echo ""
}



### ### ### Main section ### ### ###

main() {
    go_home

    wifi_if=""
    sta_conf_file=""
    sta_verbose_mode=0
    sta_cli_mode=0
    sta_gui_mode=0
    while getopts "w:c:l:g:d" opt; do
        case $opt in
            w)
                wifi_if="$OPTARG"
                ;;
            c)
                sta_conf_file="$OPTARG"
                ;;
            l)
                sta_cli_mode=1
                sta_conf_file="$OPTARG"
                ;;
            g)
                sta_gui_mode=1
                sta_conf_file="$OPTARG"
                ;;
            d)
                sta_verbose_mode=1
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

    if [ "$wifi_if" == "" ] || [ "$sta_conf_file" == "" ]; then
        echo "Usage: $0 -w wifi_if <-c conf | -l conf_cli | -g conf_gui> [-d]"
        exit 1
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    stty -echo

    sta_setup &&
    sta_run
    sta_setdown

    stty echo
}


main "$@"
