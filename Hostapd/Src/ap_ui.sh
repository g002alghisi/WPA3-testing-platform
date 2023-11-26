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

# ap.sh path
AP_PATH="Hostapd/Src/ap.sh"

# Interfaces
eth_if="enp4s0f1"
wifi_if="wlp3s0"
br_if="br0"

# Configuration files list
CONF_LIST_PATH="Hostapd/Conf/conf_list.txt"



### ### ### Main ### ### ###

main() {
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

    if [ "$ap_conf_string" == "" ]; then
        echo "Usage: $0 [-w wifi_if] [-e eth_if] [-b br_if] [-v] <-c ap_conf_string>"
        exit 1
    fi

    ap_conf_file="$(get_from_list -f "$CONF_LIST_PATH" -s "$ap_conf_string")" || \
        exit 1

    sed -i "s/^interface=.*/interface=$wifi_if/" "$ap_conf_file"
    sed -i "s/^bridge=.*/bridge=$br_if/" "$ap_conf_file"

    if [ "$ap_verbose_mode" -eq 0 ]; then
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file"
    else
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file" -v
    fi
}


main $@