#!/bin/bash
set -x  # debug mode

# Home
HOME_FOLDER="Wpa_supplicant"

# sta.sh path
STA_PATH="Src/sta.sh"

# Interfaces
wifi_if="wlx5ca6e63fe2da"

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

    sta_verbose_mode=0
    sta_cli_mode=0
    sta_gui_mode=0
    while getopts "w:c:l:g:d" opt; do
        case $opt in
            w)
                wifi_if="$OPTARG"
                ;;
            c)
                sta_conf_string="$OPTARG"
                ;;
            l)
                sta_cli_mode=1
                sta_conf_string="$OPTARG"
                ;;
            g)
                sta_gui_mode=1
                sta_conf_string="$OPTARG"
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

    if [ "$sta_conf_string" == "" ]; then
        echo "Usage: $0 [-w wifi_if] [-e eth_if] [-b br_if] [-d] <-c conf | -l conf_cli | -g conf_gui>"
        exit 1
    fi

    sta_conf_file="$(grep "$sta_conf_string""=" "$CONF_LIST_PATH" | cut -d "=" -f 2)"
    if [ "$sta_conf_file" == "" ]; then
        echo "Invalid sta_conf_string."
        exit 1
    fi

    sta_cmd=""
    if [ "$sta_cli_mode" -eq 0 ] && [ "$sta_gui_mode" -eq 0 ]; then
        sta_cmd="$STA_PATH -w $wifi_if -c $sta_conf_file"
    elif [ "$sta_cli_mode" -eq 1 ] && [ "$sta_gui_mode" -eq 0 ]; then 
        sta_cmd="$STA_PATH -w $wifi_if -l $sta_conf_file"
    elif [ "$sta_cli_mode" -eq 0 ] && [ "$sta_gui_mode" -eq 1 ]; then 
        sta_cmd="$STA_PATH -w $wifi_if -g $sta_conf_file"
    fi

    if [ "$sta_verbose_mode" -eq 1 ]; then
        sta_cmd="$sta_cmd"" -d"
    fi

    eval "$sta_cmd"
}


main "$@"
