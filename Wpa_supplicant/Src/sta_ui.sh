#!/bin/bash
set -x  # debug mode

# Home
HOME_FOLDER="Wpa_supplicant"

# sta.sh path
STA_PATH="Src/sta.sh"

# Interfaces
wifi_if="wlp3s0"

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

    sta_verbose_mode=0
    while getopts "w:d" opt; do
        case $opt in
            w)
                wifi_if="$OPTARG"
                ;;
            d)
                sta_verbose_mode=1
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

    shift $((OPTIND-1))

    if [ $# -ne 1 ]; then
        echo "Usage: $0 [-w wifi_if] wpa2|wpa3|wpa3-pk|cli"
        exit 1
    fi

    sta_cli_mode=0
    input_string="$1"
    case $input_string in
        "wpa2")
            wpa_supplicant_config_file="$CONF_P_WPA2"
            ;;
        "wpa3")
            wpa_supplicant_config_file="$CONF_P_WPA3"
            ;;
        "wpa3-pk")
            wpa_supplicant_config_file="$CONF_P_WPA3_PK"
            ;;
        "wpa2-wpa3")
            wpa_supplicant_config_file="$CONF_P_WPA2_WPA3"
            ;;
       	"cli")
            sta_cli_mode=1
            wpa_supplicant_config_file="$CONF_P_CLI"
            ;;
        *)
            echo -e "Invalid input_string."
            exit 1
            ;;
    esac

    if [ "$sta_cli_mode" -eq 1 ]; then
        "$STA_PATH" -w "$wifi_if" -l "$wpa_supplicant_config_file"
    elif [ "$sta_verbose_mode" -eq 0 ]; then 
        "$STA_PATH" -w "$wifi_if" -c "$wpa_supplicant_config_file"
    else
        "$STA_PATH" -w "$wifi_if" -c "$wpa_supplicant_config_file" -d
    fi
}