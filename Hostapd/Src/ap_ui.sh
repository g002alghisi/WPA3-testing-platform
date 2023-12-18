#!/bin/bash
#set -x  # debug mode


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

# ap.sh path
AP_PATH="Hostapd/Src/ap.sh"

# ap.sh and ap_ui.sh log path. WITHOUT "/"
AP_LOG_PATH="Hostapd/Tmp/Log_ap"

# Interfaces
ETH_IF_DEFAULT="enp4s0f1"
WIFI_IF_DEFAULT="wlp3s0"
BR_IF_DEFAULT="br0"

# Configuration files list
CONF_LIST_PATH="Hostapd/Conf/conf_list.txt"



### *** AP UI *** ###

ap_ui_handle_input() {
    wifi_if="$WIFI_IF_DEFAULT"
    eth_if="$ETH_IF_DEFAULT"
    br_if="$BR_IF_DEFAULT"
    ap_conf_file=""
    ap_conf_string=""
    ap_verbose_mode=0
    ap_log_dir=""
    ap_log_mode=""
    while getopts "w:e:b:c:l:L:v" opt; do
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
                ap_conf_string="$OPTARG"
                ;;
            v)
                ap_verbose_mode=1
                ;;
            c)
                ap_conf_string="$OPTARG"
                ;;
            l)
                # Option to not generate a new log session ("app" = append)
                ap_log_dir="$OPTARG"
                ap_log_mode="app"
                ;;
            L)
                ap_log_dir="$OPTARG"
                ap_log_mode="new"
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
    if [ "$ap_conf_string" == "" ]; then
        echo "Usage: $0 [-w wifi_if] [-e eth_if] [-b br_if] -c ap_conf_string [-v] [-l|L log_dir]."
        exit 1
    fi

    # Check if ap_log_dir is valid when -l or -L used
    if [ "$ap_log_mode" != "" ] && [ "$ap_log_dir" == "" ]; then
        echo "Usage: $0 [-w wifi_if] [-e eth_if] [-b br_if] -c ap_conf_string [-v] [-l|L log_dir]."
        exit 1
    fi
}

ap_ui_setup() {
    # Start logging if required
    if [ "$ap_log_mode" == "app" ]; then
        print_info "Beginning logging session inside $ap_log_dir..."
        log_output -d $ap_log_dir -t "ap" &&
            print_success || { print_error; return 1; }
    elif [ "$ap_log_mode" == "new" ]; then
        print_info "Beginning logging session inside $ap_log_dir..."
        log_output -d $ap_log_dir -t "ap" -n &&
            print_success || { print_error; return 1; }
    fi

    # Get configuration file from conf_list
    print_info "Fetching configuration file associated to $ap_conf_string..."
    ap_conf_file="$(get_from_list -f "$CONF_LIST_PATH" -s "$ap_conf_string")" &&
        print_success || { echo "$ap_conf_file"; print_error; echo ""; return 1; }

    # Change interface and bridge name inside the conf_file
    print_info "Changing interface and bridge name inside $ap_conf_file..."
    { sed -i "s/^interface=.*/interface=$wifi_if/" "$ap_conf_file" &&
    sed -i "s/^bridge=.*/bridge=$br_if/" "$ap_conf_file"; } &&
        print_success || { print_error; echo ""; return 1; }
}



### *** Main *** ###

main() {
    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    ap_ui_handle_input $@

    # Fetch, check and modify ap_conf_file, and eventually start logging
    echo ""
    ap_ui_setup &&

    # Run ap.sh
    if [ "$ap_verbose_mode" -eq 0 ]; then
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file"
    else
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file" -v
    fi

    exit 0
}


main $@
