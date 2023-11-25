#!/bin/bash
#set -x  # debug mode

# Home
HOME_FOLDER="Hostapd"

# ap.sh path
AP_PATH="Src/ap.sh"

# Interfaces
eth_if="enp4s0f1"
wifi_if="wlp3s0"
br_if="br0"

# Configuration files list
CONF_LIST_PATH="Conf/conf_list.txt"

### ### ### Utilities ### ### ###

go_home() {
    cd "$(dirname "$HOME_FOLDER")"
    current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_FOLDER" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done
}


### ### ### Main ### ### ###

main() {
    go_home

    ap_verbose_mode=0
    ap_conf_file=""
    ap_conf_string=""
    while getopts "w:e:b:c:d" opt; do
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
            d)
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

    if [ "$ap_conf_string" == "" ]; then
        echo "Usage: $0 [-w wifi_if] [-e eth_if] [-b br_if] [-d] <-c ap_conf_string>"
        exit 1
    fi

    ap_conf_file="$(grep "$ap_conf_string""=" "$CONF_LIST_PATH" | cut -d "=" -f 2)"
    if [ "$ap_conf_file" == "" ]; then
        echo "Invalid ap_conf_string."
        exit 1
    fi

    sed -i "s/^interface=.*/interface=$wifi_if/" "$ap_conf_file"
    sed -i "s/^bridge=.*/bridge=$br_if/" "$ap_conf_file"

    if [ "$ap_verbose_mode" -eq 0 ]; then
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file"
    else
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file" -d
    fi
}


main "$@"
