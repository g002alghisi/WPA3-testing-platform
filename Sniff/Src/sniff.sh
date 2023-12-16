#!/bin/bash
#set -x  # Debug mode.


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
source Utils/Src/net_if_utils.sh

# Default Wi-Fi interface
wifi_if="wlx5ca6e63fe2da"
channel=1



### *** Wireshark *** ###

wireshark_setup () {
    echo ""

    # Start NetworkManager 
    nm_start &> /dev/null

    # Check Wi-Fi
    log_info "Checking Wi-Fi interface... "
    net_if_exists -w "$wifi_if" && log_success || { log_error; return 1; }

    # Force Wi-Fi up
    log_info "Forcing Wi-Fi interface up... "
    net_if_force_up -w "$wifi_if" && log_success || { log_error; return 1; }

    # Stop Network Manager
    log_info "Stopping NetworkManager... "
    nm_stop && log_success || { log_error; return 1; }

    # Set Wi-Fi interface in monitor mode
    log_info "Setting $wifi_if in monitor mode... "
    net_if_set_monitor_mode -w "$wifi_if" -c "$channel" &&
        log_success || { log_error; return 1; }
}

wireshark_run() {
    log_title "Running Wireshark. Press Ctrl-C to stop."
    sudo wireshark
    log_title "Wiresharkd is stopped."
}

wireshark_setdown() {
    # Set Wi-Fi interface in default mode
    log_info "Setting $wifi_if in default mode... "
    net_if_set_default_mode -w "$wifi_if" &&
        log_success || { log_error; return 1; }

    # Start Network Manager
    log_info "Starting NetworkManager... "
    nm_start && log_success || { log_error; return 1; }

    echo ""
}



### *** Main *** ###

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
    OPTIND=1

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    # Hide keyboard input
    stty -echo

    # If the setup fails, then do not run, but skip this phase and execute
    #   the setdown
    wireshark_setup &&
    wireshark_run
    wireshark_setdown

    # Show keyboard input
    stty echo

    exit 0
}

main $@
