#!/bin/bash
#set -x  # debug mode


# Home
HOME_FOLDER="Hostapd-test"  # Without final "/"

go_home() {
    cd "$(dirname "$HOME_FOLDER")"
    current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_FOLDER" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done

    if [[ "$current_path" == "/" ]]; then
        echo "Error in $0, reached "/" position. Wrong HOME_FOLDER"
        return 1
    fi
}

# All the file positions are now relative to the Main Repository folder.
# Load utils scripts
go_home
source Utils/Src/general_utils.sh
source Utils/Src/nm_utils.sh
source Utils/Src/br_utils.sh
source Utils/Src/net_if_utils.sh


# Hostapd path
HOSTAPD_PATH="Hostapd/Build/hostapd"



### *** AP *** ###

ap_print_info() {
    echo "AP settings:"
    echo ""
    cat "$ap_conf_file" | grep -vE '^(#|$)'
    echo ""
    echo ""
}

ap_setup() {
    # Start NetworkManager 
    nm_start &> /dev/null

    # Check Ethernet
    log_info "Checking Ethernet interface... "
    net_if_exists -e "$eth_if" && log_success || { log_error; return 1; }

    log_info "Forcing Ethernet interface up... "
    net_if_force_up -e "$eth_if" && log_success || { log_error; return 1; }

    #log_info "Checking Ethernet connection... "
    #net_if_is_connected -e "$eth_if" && log_success || { log_error; return 1; }

    # Check Wi-Fi
    log_info "Checking Wi-Fi interface... "
    net_if_exists -w "$wifi_if" && log_success || { log_error; return 1; }

    log_info "Forcing Wi-Fi interface up... "
    net_if_force_up -w "$wifi_if" && log_success || { log_error; return 1; }

    # Stop Network Manager
    log_info "Stopping NetworkManager... "
    nm_stop && log_success || { log_error; return 1; }

    # Create the Bridge
    log_info "Creating the bridge... "
    br_setup "$br_if" && log_success || { log_error; return 1; }

    log_info "Creating the bridge... "
    br_add_if -b "$br_if" -n "$eth_if" && log_success || { log_error; return 1; }

    # Check AP config file
    log_info "Looking for $ap_conf_file..."
    file_exists "$ap_conf_file" && log_success || { log_error; return 1; }

    # Killing previous instances of Hostapd
    pkill hostapd &> /dev/null
    
    return 0
}

ap_run() {
    echo -e "\n${CYAN}Running Hostapd. Press Ctrl-C to stop.${NC}\n"

    ap_print_info
    
    if [ "$ap_verbose_mode" -eq 0 ]; then
        sudo "$HOSTAPD_PATH" "$ap_conf_file"
    else
        sudo "$HOSTAPD_PATH" "$ap_conf_file" -d
    fi

    echo -e "\n${CYAN}Hostapd is stopped.${NC}\n"
}

ap_setdown() {
    # Delete the bridge
    log_info "Deleting the bridge... "
    br_setdown "$br_if" && log_success || log_error
    
    # Start Network Manager
    log_info "Starting NetworkManager... "
    nm_start && log_success || log_error
}



### ### ### Main section ### ### ###

main() {
    wifi_if=""
    eth_if=""
    br_if=""
    ap_conf_file=""
    ap_verbose_mode=0
    while getopts "w:e:b:c:v" opt; do
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
                ap_conf_file="$OPTARG"
                ;;
            v)
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
    OPTIND=1

    if [ "$wifi_if" == "" ] || [ "$eth_if" == "" ] || [ "$br_if" == "" ] || [ "$ap_conf_file" == "" ]; then
        echo "Usage: $0 -w wifi_if -e eth_if -b br_if -c conf [-v]"
        exit 1
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    # Do not show keyboard input
    stty -echo

    echo ""
    ap_setup &&
    ap_run
    ap_setdown
    echo ""

    # Show keyboard input
    stty echo
}

main $@