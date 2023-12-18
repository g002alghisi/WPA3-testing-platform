#!/bin/bash
#set -x  # debug mode


# Home. DO NOT TERMINATE WITH /
HOME_DIR="Hostapd-test"

go_home() {
    current_dir="$(basename $(pwd))"
    while [ "$current_dir" != "$HOME_DIR" ] && [ "$current_dir" != "/" ]; do
        cd ..
        current_dir="$(basename $(pwd))"
    done

    if [ "$current_dir" == "/" ]; then
        echo "Error in $0, reached "/" position."
        exit 1
    fi
}

# All the file positions are now relative to the Main Repository DIR.

# Load utils scripts
go_home
source Utils/Src/general_utils.sh
source Utils/Src/nm_utils.sh
source Utils/Src/net_if_utils.sh

# Wpa-supplicant path. DO NOT TERMINATE WITH /
WPA_SUPPLICANT_PATH="Wpa_supplicant/Build/wpa_supplicant"


### *** STA *** ###

sta_handle_input() {
    sta_wifi_if=""
    sta_conf_file=""
    sta_verb_mode=0
    while getopts "w:c:v" opt; do
        case $opt in
            w)
                sta_wifi_if="$OPTARG"
                ;;
            c)
                sta_conf_file="$OPTARG"
                ;;
            v)
                sta_verb_mode=1
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

    # Check if the input is valid (the user have to insert at lease the name
    # of the wifi interface, and the configuration file path).
    if [ "$sta_wifi_if" == "" ] || [ "$sta_conf_file" == "" ]; then
        echo "Usage: $0 -w sta_wifi_if -c conf [-v]."
        exit 1
    fi
}

sta_print_info() {
    echo "STA settings:"
    echo ""
    cat "$sta_conf_file" | grep -vE '^(#|$)'
    echo ""
    echo ""
}

sta_setup() {
    # Start NetworkManager 
    nm_start &> /dev/null    

    # Check Wi-Fi
    print_info "Checking Wi-Fi interface... "
    net_if_exists -w "$sta_wifi_if" && print_success || { print_error; return 1; }

    # Force Wi-Fi up
    print_info "Forcing Wi-Fi interface up... "
    net_if_force_up -w "$sta_wifi_if" && print_success || { print_error; return 1; }

    # Stop Network Manager
    print_info "Stopping NetworkManager... "
    nm_stop && print_success || { print_error; return 1; }

    # Check STA config file
    print_info "Looking for $sta_conf_file..."
    file_exists -f "$sta_conf_file" && print_success || { print_error; return 1; }

    # Kill previous instances of wpa_supplicant, wpa_cli and wpa_gui
    sudo killall wpa_supplicant &> /dev/null

    return 0
}

sta_run() {
    print_title "Running Wpa-supplicant. Press Ctrl-C to stop."

    sta_print_info

    if [ $sta_verb_mode -eq 0 ]; then
        sudo "$WPA_SUPPLICANT_PATH" -i "$sta_wifi_if" -c "$sta_conf_file"
    else
        sudo "$WPA_SUPPLICANT_PATH" -i "$sta_wifi_if" -c "$sta_conf_file" -d
    fi

   print_title "Wpa_supplicant is stopped."
}

sta_setdown() {
    # If something goes wrong, try to kill wpa_supplicant
    sudo killall wpa_supplicant &> /dev/null

    # Start Network Manager
    print_info "Starting NetworkManager... "
    nm_start && print_success || print_error
}



### ### ### Main section ### ### ###

sta_main() {
    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    # Hide keyboard input
    stty -echo

    sta_handle_input $@

    # If the setup fails, then do not run, but skip this phase and execute
    # the setdown
    echo ""
    sta_setup &&
    sta_run
    sta_setdown
    echo ""

    # Show keyboard input
    stty echo
}

sta_main $@
