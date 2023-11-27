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

# sta.sh path
STA_PATH="Wpa_supplicant/Src/sta.sh"

# Interfaces
WIFI_IF_DEFAULT="wlx5ca6e63fe2da"

# Configuration files list
CONF_LIST_PATH="Wpa_supplicant/Conf/conf_list.txt"



### *** Handle config file *** ###

sta_ui_setup() {
    # Get configuration file from conf_list
    log_info "Fetching configuration file associated to $sta_conf_string..."
    sta_conf_file="$(get_from_list -f "$CONF_LIST_PATH" -s "$sta_conf_string")" &&
        log_success || { echo "$sta_conf_file"; log_error; return 1; }

    if [ "$sta_gui_mode" -eq 1 ] || [ "$sta_cli_mode" -eq 1 ]; then
            log_info "Checking terminal type..."
            terminal_exec_cmd="$(get_terminal_exec_cmd)" &&
                log_success || { echo "$terminal_exec_cmd"; log_error; return 1; }
    fi

    # Try to kill wpa_cli and wpa_gui
    sudo killall wpa_cli &> /dev/null
    sudo killall wpa_gui &> /dev/null  

    if [ "$sta_gui_mode" -eq 1 ]; then
        log_info "Launching GUI..."
        $terminal_exec_cmd bash -c "sleep 3; wpa_gui -i $wifi_if;" &
        if [ "$?" -eq 0 ]; then
            log_success
        else
            log_error
            return 1
        fi
    fi
    
    if [ "$sta_cli_mode" -eq 1 ]; then
        log_info "Launching CLI..."
        $terminal_exec_cmd bash -c "sleep 3; wpa_cli -i $wifi_if;" &
        if [ "$?" -eq 0 ]; then
            log_success
        else
            log_error
            return 1
        fi
    fi
}

sta_ui_setdown() {
    # Try to kill wpa_cli and wpa_gui
    sudo killall wpa_cli &> /dev/null
    sudo killall wpa_gui &> /dev/null

    # Try to kill all the terminal windows created
    sudo pkill -P $$ &> /dev/null
}



### *** Main *** ###

main() {
    wifi_if="$WIFI_IF_DEFAULT"
    sta_conf_file=""
    sta_conf_string=""
    sta_verbose_mode=0
    sta_cli_mode=0
    sta_gui_mode=0
    while getopts "w:c:l:g:v" opt; do
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
        echo "Usage: $0 [-w wifi_if] <-c conf | -l conf_cli | -g conf_gui> [-v]."
        exit 1
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    # Fetch sta_conf_file
    echo ""
    sta_ui_setup &&

    # Run wpa_supplicant
    if [ "$sta_verbose_mode" -eq 0 ]; then
        "$STA_PATH" -w "$wifi_if" -c "$sta_conf_file"
    else
        "$STA_PATH" -w "$wifi_if" -c "$sta_conf_file" -v
    fi

    sta_ui_setdown
    echo ""
}

main $@