#!/bin/bash
#set -x  # debug mode


# Home. DO NOT TERMINATE WITH "/"
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

# ap.sh path
AP_PATH="Hostapd/Src/ap.sh"

# ap.sh and ap_ui.sh log path. WITHOUT "/"
AP_LOG_PATH="Hostapd/Tmp/Log_ap"

# Interfaces
ETH_IF_DEFAULT="enp0s20f0u1"
WIFI_IF_DEFAULT="wlp3s0"
BR_IF_DEFAULT="br0"

# Configuration files list
AP_UI_CONF_LIST_PATH="Hostapd/Conf/conf_list.txt"



### *** AP UI *** ###

ap_ui_handle_input() {
    ap_ui_wifi_if="$WIFI_IF_DEFAULT"
    ap_ui_eth_if="$ETH_IF_DEFAULT"
    ap_ui_br_if="$BR_IF_DEFAULT"
    ap_ui_conf_file=""
    ap_ui_conf_string=""
    ap_ui_verb_mode=0
    ap_ui_log_dir=""
    ap_ui_log_mode=""
    while getopts "w:e:b:c:l:L:v" opt; do
        case $opt in
            w)
                # w -> Wi-Fi interface
                ap_ui_wifi_if="$OPTARG"
                ;;
            e)
                # e -> Ethernet interface
                ap_ui_eth_if="$OPTARG"
                ;;
            b)
                # b -> Bridge interface
                ap_ui_br_if="$OPTARG"
                ;;
            v)
                # v -> Verbose
                ap_ui_verb_mode=1
                ;;
            c)
                # c -> Configuration string
                ap_ui_conf_string="$OPTARG"
                ;;
            l)
                # l -> Log session (append to the last progressive number dir)
                # Option to not generate a new log session ("app" = append)
                ap_ui_log_dir="$OPTARG"
                ap_ui_log_mode="app"
                ;;
            L)
                # L -> Log session (increment progressive number dir)
                # Option to generate a new log session
                ap_ui_log_dir="$OPTARG"
                ap_ui_log_mode="new"
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

    # Check if the input is valid (the user have to insert at least the
    #   configuration string)
    if [ "$ap_ui_conf_string" == "" ]; then
        echo "Usage: $0 [-w ap_ui_wifi_if] [-e ap_ui_eth_if] [-b ap_ui_br_if] -c ap_ui_conf_string [-v] [-l|L log_dir]."
        exit 1
    fi

    # Check if ap_ui_log_dir is valid when -l or -L used
    if [ "$ap_ui_log_mode" != "" ] && [ "$ap_ui_log_dir" == "" ]; then
        echo "Usage: $0 [-w ap_ui_wifi_if] [-e ap_ui_eth_if] [-b ap_ui_br_if] -c ap_ui_conf_string [-v] [-l|L log_dir]."
        exit 1
    fi
}

ap_ui_setup() {
    # Start logging if required
    if [ "$ap_ui_log_mode" == "app" ]; then
        log_output -d $ap_ui_log_dir -t "ap.log" &&
            print_info "Beginning saving session of stdout and stderr $ap_ui_log_dir..." &&
            { print_success; echo ""; } || { print_error; return 1; }
    elif [ "$ap_ui_log_mode" == "new" ]; then
        log_output -d $ap_ui_log_dir -t "ap.log" -n &&
            print_info "Beginning saving session of stdout and stderr $ap_ui_log_dir..." &&
            { print_success; echo ""; } || { print_error; return 1; }
    fi

    # Get configuration file from conf_list
    print_info "Fetching configuration file associated to $ap_ui_conf_string..."
    ap_ui_conf_file="$(get_from_list -f "$AP_UI_CONF_LIST_PATH" -s "$ap_ui_conf_string")" &&
        print_success || { echo "$ap_ui_conf_file"; print_error; echo ""; return 1; }

    # Change interface and bridge name inside the conf_file
    print_info "Changing interface and bridge name inside $ap_ui_conf_file..."
    { sed -i "s/^interface=.*/interface=$ap_ui_wifi_if/" "$ap_ui_conf_file" &&
    sed -i "s/^bridge=.*/bridge=$ap_ui_br_if/" "$ap_ui_conf_file"; } &&
        print_success || { print_error; echo ""; return 1; }
}



### *** Main *** ###

ap_ui_main() {
    ap_ui_handle_input $@
    
    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    echo ""
    # Fetch, check and modify ap_ui_conf_file, and eventually start logging
    ap_ui_setup &&

    # Run ap.sh
    if [ "$ap_ui_verb_mode" -eq 0 ]; then
        "$AP_PATH" -w "$ap_ui_wifi_if" -e "$ap_ui_eth_if" -b "$ap_ui_br_if" -c "$ap_ui_conf_file"
    else
        "$AP_PATH" -w "$ap_ui_wifi_if" -e "$ap_ui_eth_if" -b "$ap_ui_br_if" -c "$ap_ui_conf_file" -v
    fi

    exit 0
}


ap_ui_main $@
