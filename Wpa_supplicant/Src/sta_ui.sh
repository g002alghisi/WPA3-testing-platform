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

# sta.sh path
STA_PATH="Wpa_supplicant/Src/sta.sh"

# Interfaces
WIFI_IF_DEFAULT="wlx5ca6e63fe2da"

# Configuration files list
STA_UI_CONF_LIST_PATH="Wpa_supplicant/Conf/conf_list.txt"



### *** STA UI *** ###

sta_ui_handle_input() {
    sta_ui_wifi="$WIFI_IF_DEFAULT"
    sta_ui_conf_file=""
    sta_ui_conf_string=""
    sta_ui_verbose_mode=0
    sta_ui_cli_mode=0
    sta_ui_gui_mode=0
    while getopts "w:c:l:g:v" opt; do
        case $opt in
            w)
                sta_ui_wifi="$OPTARG"
                ;;
            c)
                sta_ui_conf_string="$OPTARG"
                ;;
            l)
                sta_ui_cli_mode=1
                sta_ui_conf_string="$OPTARG"
                ;;
            g)
                sta_ui_gui_mode=1
                sta_ui_conf_string="$OPTARG"
                ;;
            v)
                sta_ui_verbose_mode=1
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
    if [ "$sta_ui_conf_string" == "" ]; then
        echo "Usage: $0 [-w sta_ui_wifi] <-c conf | -l conf_cli | -g conf_gui> [-v]."
        exit 1
    fi
}

sta_ui_setup() {
    # Get configuration file from conf_list
    print_info "Fetching configuration file associated to $sta_ui_conf_string..."
    sta_ui_conf_file="$(get_from_list -f "$STA_UI_CONF_LIST_PATH" -s "$sta_ui_conf_string")" &&
        print_success || { echo "$sta_ui_conf_file"; print_error; return 1; }

    if [ "$sta_ui_gui_mode" -eq 1 ] || [ "$sta_ui_cli_mode" -eq 1 ]; then
            print_info "Checking terminal type..."
            terminal_exec_cmd="$(get_terminal_exec_cmd)" &&
                print_success || { echo "$terminal_exec_cmd"; print_error; return 1; }
    fi

    # Try to kill wpa_cli and wpa_gui
    sudo killall wpa_cli &> /dev/null
    sudo killall wpa_gui &> /dev/null  

    if [ "$sta_ui_gui_mode" -eq 1 ]; then
        print_info "Launching GUI..."
        $terminal_exec_cmd "sleep 3; wpa_gui -i $sta_ui_wifi;" &
        if [ "$?" -eq 0 ]; then
            print_success
        else
            print_error
            return 1
        fi
    fi
    
    if [ "$sta_ui_cli_mode" -eq 1 ]; then
        print_info "Launching CLI..."
        $terminal_exec_cmd "sleep 3; wpa_cli -i $sta_ui_wifi;" &
        if [ "$?" -eq 0 ]; then
            print_success
        else
            print_error
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

sta_ui_main() {
    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    sta_ui_handle_input $@

    # Fetch sta_ui_conf_file
    echo ""
    sta_ui_setup &&

    # Run wpa_supplicant
    if [ "$sta_ui_verbose_mode" -eq 0 ]; then
        "$STA_PATH" -w "$sta_ui_wifi" -c "$sta_ui_conf_file"
    else
        "$STA_PATH" -w "$sta_ui_wifi" -c "$sta_ui_conf_file" -v
    fi

    sta_ui_setdown
    echo ""
}

sta_ui_main $@
