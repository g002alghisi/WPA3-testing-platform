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

# Interfaces
ETH_IF_DEFAULT="enp4s0f1"
WIFI_IF_DEFAULT="wlp3s0"
BR_IF_DEFAULT="br0"

# Configuration files list
CONF_LIST_PATH="Hostapd/Conf/conf_list.txt"



### *** AP UI *** ###

ap_ui_setup() {
    # Get configuration file from conf_list
    log_info "Fetching configuration file associated to $ap_conf_string..."
    ap_conf_file="$(get_from_list -f "$CONF_LIST_PATH" -s "$ap_conf_string")" &&
        log_success || { echo "$ap_conf_file"; log_error; echo ""; return 1; }

    # Change interface and bridge name inside the conf_file
    log_info "Changing interface and bridge name inside $ap_conf_file..."
    { sed -i "s/^interface=.*/interface=$wifi_if/" "$ap_conf_file" &&
    sed -i "s/^bridge=.*/bridge=$br_if/" "$ap_conf_file"; } &&
        log_success || { log_error; echo ""; return 1; }
}



### *** Main *** ###

main() {
    wifi_if="$WIFI_IF_DEFAULT"
    eth_if="$ETH_IF_DEFAULT"
    br_if="$BR_IF_DEFAULT"
    ap_conf_file=""
    ap_conf_string=""
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
                ap_conf_string="$OPTARG"
                ;;
            v)
                ap_verbose_mode=1
                ;;
            c)
                ap_conf_string="$OPTARG"
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
        echo "Usage: $0 [-w wifi_if] [-e eth_if] [-b br_if] -c ap_conf_string [-v]."
        exit 1
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    # Fetch, check and modify ap_conf_file
    echo ""
    ap_ui_setup &&

    # Run ap.sh
    if [ "$ap_verbose_mode" -eq 0 ]; then
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file"
    else
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file" -v
    fi
}


main $@
