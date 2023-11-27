#!/bin/bash
#set -x  # debug mode

# Home. DO NOT TERMINATE WITH "/"
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

# sta.sh path
STA_PATH="Wpa_supplicant/Src/sta.sh"

# Interfaces
WIFI_IF_DEFAULT="wlx5ca6e63fe2da"

# Configuration files list
CONF_LIST_PATH="Wpa_supplicant/Conf/conf_list.txt"

# Socket folder
WPA_SUPPLICNT_CTRL_SOCKET_FOLDER="Wpa_supplicant/Tmp"



### *** Handle config file *** ###

sta_ui_handle_conf_file() {
    # Get configuration file from conf_list
    log_info "Fetching configuration file associated to $sta_conf_string..."
    sta_conf_file="$(get_from_list -f "$CONF_LIST_PATH" -s "$sta_conf_string")" &&
        log_success || { echo "$sta_conf_file"; log_error; echo ""; exit 1; }
}


### *** Main *** ###

main() {
    wifi_if="$WIFI_IF_DEFAULT"
    sta_conf_file=""
    sta_conf_string=""
    sta_verbose_mode=0
    sta_cli_mode=0
    sta_gui_mode=0
    sta_debug_mode=0
    while getopts "w:c:l:g:vd" opt; do
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

    # Check if the input is valid (the user have to insert at least the
    #   configuration string)
    if [ "$sta_conf_string" == "" ]; then
        echo "Usage: $0 [-w wifi_if] [-d] <-c conf | -l conf_cli | -g conf_gui>"
        exit 1
    fi

    # Enable debug for the bash script vith the flag -d
    if [ "$sta_debug_mode" -eq 1 ]; then
        set -x
    fi

    # Fetch sta_conf_file
    echo ""
    sta_ui_handle_conf_file

    # Run wpa_supplicant
    if [ "$sta_verbose_mode" -eq 0 ]; then
        "$STA_PATH" -w "$wifi_if" -c "$sta_conf_file"
    else
        "$STA_PATH" -w "$wifi_if" -c "$sta_conf_file" -v
    fi
}

main $@













    if [ $sta_cli_mode -eq 1 ]; then
        "$terminal_exec_cmd sudo wpa_cli -p $WPA_SUPPLICNT_CTRL_SOCKET_FOLDER -i $wifi_if"
    fi

    if [ $sta_gui_mode -eq 1 ]; then
        "$terminal_exec_cmd sudo wpa_gui -p $WPA_SUPPLICNT_CTRL_SOCKET_FOLDER -i $wifi_if"
    fi