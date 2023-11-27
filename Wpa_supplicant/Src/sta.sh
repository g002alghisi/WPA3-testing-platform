#!/bin/bash
#set -x  # debug mode


# Home. DO NOT TERMINATE WITH /
HOME_FOLDER="Hostapd-test"

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
source Utils/Src/net_if_utils.sh

# Wpa-supplicant path. DO NOT TERMINATE WITH /
WPA_SUPPLICANT_PATH="Wpa_supplicant/Build/wpa_supplicant"


### *** STA *** ###

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
    log_info "Checking Wi-Fi interface... "
    net_if_exists -w "$wifi_if" && log_success || { log_error; return 1; }

    # Force Wi-Fi up
    log_info "Forcing Wi-Fi interface up... "
    net_if_force_up -w "$wifi_if" && log_success || { log_error; return 1; }

    # Stop Network Manager
    log_info "Stopping NetworkManager... "
    nm_stop && log_success || { log_error; return 1; }

    # Check STA config file
    log_info "Looking for $sta_conf_file..."
    file_exists "$sta_conf_file" && log_success || { log_error; return 1; }

    # Kill previous instances of wpa_supplicant, wpa_cli and wpa_gui
    sudo killall wpa_supplicant &> /dev/null
    sudo killall wpa_cli &> /dev/null
    sudo killall wpa_gui &> /dev/null

    # Remove previous ctrl sockets
    rm "$WPA_SUPPLICNT_CTRL_SOCKET_FOLDER""/*" &> /dev/null

    return 0
}

sta_run() {
    log_title "Running Wpa-supplicant. Press Ctrl-C to stop."

    sta_print_info

    if [ $sta_verbose_mode -eq 0 ]; then
        sudo "$WPA_SUPPLICANT_PATH" -i "$wifi_if" -c "$sta_conf_file"
    else
        sudo "$WPA_SUPPLICANT_PATH" -i "$wifi_if" -c "$sta_conf_file" -d
    fi

   log_title "Wpa_supplicant is stopped."
}

sta_setdown() {
    # If something goes wrong, try to kill wpa_supplicant, wpa_cli and wpa_gui
    sudo killall wpa_supplicant &> /dev/null
    sudo killall wpa_cli &> /dev/null
    sudo killall wpa_gui &> /dev/null

    # Start Network Manager
    log_info "Starting NetworkManager... "
    nm_start && log_success || log_error
}



### ### ### Main section ### ### ###

main() {
    wifi_if=""
    sta_conf_file=""
    sta_verbose_mode=0
    sta_debug_mode=0
    while getopts "w:c:vd" opt; do
        case $opt in
            w)
                wifi_if="$OPTARG"
                ;;
            c)
                sta_conf_file="$OPTARG"
                ;;
            v)
                sta_verbose_mode=1
                ;;
            d)
                sta_debug_mode=1
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
    if [ "$wifi_if" == "" ] || [ "$sta_conf_file" == "" ]; then
        echo "Usage: $0 -w wifi_if -c conf [-v] [-d]"
        exit 1
    fi

    # Enable debug for the bash script vith the flag -d
    if [ "$sta_debug_mode" -eq 1 ]; then
        set -x
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    # Hide keyboard input
    stty -echo

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

main $@