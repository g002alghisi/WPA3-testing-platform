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

# Personal
CONF_P_WPA2="Conf/Minimal/Personal/p_wpa2.conf"
CONF_P_WPA3="Conf/Minimal/Personal/p_wpa3.conf"
CONF_P_WPA2_WPA3="Conf/Minimal/Personal/p_wpa2_wpa3.conf"
CONF_P_WPA3_PK="Conf/Minimal/Personal/p_wpa3_pk.conf"
CONF_P_FAKE_WPA3_PK="Conf/Minimal/Personal/p_fake_wpa3_pk.conf"

# Enterprise
# ...



### ### ### Utilities ### ### ###

go_home() {
    cd "$(dirname "$1")"
    current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_FOLDER" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done
}


### ### ### Main ### ### ###

main() {
    go_home "$HOME_FOLDER"

    ap_verbose_mode=0
    while getopts "w:e:b:d" opt; do
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

    shift $((OPTIND-1))

    if [ $# -ne 1 ]; then
        echo "Usage: $0 [-w wifi_if] [-e eth_if] [-b br_if] [-d] <ap_conf_string>"
        exit 1
    fi

    ap_conf_string="$1"
    ap_conf_file=""
    case $ap_conf_string in
        "p:wpa2")
            ap_conf_file="$CONF_P_WPA2"
            ;;
        "p:wpa3")
            ap_conf_file="$CONF_P_WPA3"
            ;;
        "p:wpa2-wpa3")
            ap_conf_file="$CONF_P_WPA2_WPA3"
            ;;
        "p:wpa3-pk")
            ap_conf_file="$CONF_P_WPA3_PK"
            ;;
        "p:fake-wpa3-pk")
            ap_conf_file="$CONF_P_FAKE_WPA3_PK"
            ;;
        *)
            echo -e "Invalid ap_conf_string."
            exit 1
            ;;
    esac

    sed -i "s/^interface=.*/interface=$wifi_if/" "$ap_conf_file"

    if [ "$ap_verbose_mode" -eq 0 ]; then
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file"
    else
        "$AP_PATH" -w "$wifi_if" -e "$eth_if" -b "$br_if" -c "$ap_conf_file" -d
    fi
}


main "$@"