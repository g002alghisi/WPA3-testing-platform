#!/bin/bash
set -x  # debug mode


# Home. DO NOT TERMINATE WITH "/"
HOME_DIR="Hostapd-test"

go_home() {
    cd "$(dirname "$HOME_DIR")"
    current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_DIR" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done

    if [[ "$current_path" == "/" ]]; then
        echo "Error in $0, reached "/" position. Wrong HOME_DIR"
        return 1
    fi
}

# All the file positions are now relative to the Main Repository DIR.

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

    # Force Ethernet up
    log_info "Forcing Ethernet interface up... "
    net_if_force_up -e "$eth_if" && log_success || { log_error; return 1; }

    # Check if Ethernet connected
    log_info "Checking Ethernet connection... "
    net_if_is_connected -e "$eth_if" && log_success || { log_error; return 1; }

    # Check Wi-Fi
    log_info "Checking Wi-Fi interface... "
    net_if_exists -w "$wifi_if" && log_success || { log_error; return 1; }

    # Force Wi-Fi up
    log_info "Forcing Wi-Fi interface up... "
    net_if_force_up -w "$wifi_if" && log_success || { log_error; return 1; }

    # Stop Network Manager
    log_info "Stopping NetworkManager... "
    nm_stop && log_success || { log_error; return 1; }

    # Create the Bridge
    log_info "Creating the bridge... "
    br_setup "$br_if" && log_success || { log_error; return 1; }

    # Add Ethernet interface to the bridge
    log_info "Adding $eth_if to the bridge ($wifi_if is added later by hostapd)... "
    br_add_if -b "$br_if" -n "$eth_if" && log_success || { log_error; return 1; }

    # Check AP config file
    log_info "Looking for $ap_conf_file..."
    file_exists -f "$ap_conf_file" && log_success || { log_error; return 1; }

    # Killing previous instances of Hostapd
    sudo killall hostapd &> /dev/null
    
    return 0
}

ap_run() {
    log_title "Running Hostapd. Press Ctrl-C to stop."

    ap_print_info
    
    if [ "$ap_verbose_mode" -eq 0 ]; then
        sudo "$HOSTAPD_PATH" "$ap_conf_file"
    else
        sudo "$HOSTAPD_PATH" "$ap_conf_file" -d
    fi

    log_title "Hostapd is stopped."
}

ap_setdown() {
    # If something goes wrong, try to kill hostapd
    sudo killall hostapd &> /dev/null

    # Delete the bridge
    log_info "Deleting the bridge... "
    br_setdown "$br_if" && log_success || log_error
    
    # Start Network Manager
    log_info "Starting NetworkManager... "
    nm_start && log_success || log_error
}



### *** Main section *** ###

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

    # Check if the input is valid (the user have to insert at least
    #   the name of all the interfaces, and the configuration file path)
    if [ "$wifi_if" == "" ] || [ "$eth_if" == "" ] || [ "$br_if" == "" ] || [ "$ap_conf_file" == "" ]; then
        echo "Usage: $0 -w wifi_if -e eth_if -b br_if -c conf [-v]."
        exit 1
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    #   during the execution of the successive commands)
    sudo -v

    # Hide keyboard input
    stty -echo

    # If the setup fails, then do not run, but skip this phase and execute
    #   the setdown
    echo ""
    ap_setup &&
    ap_run
    ap_setdown
    echo ""

    # Show keyboard input
    stty echo
}

main $@
