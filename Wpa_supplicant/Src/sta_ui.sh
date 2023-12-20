#!/bin/bash
#set -x  # debug mode

# Home../test_ui.sh -s p_wpa2 -d wpa_supplicant DO NOT TERMINATE WITH "/"
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
    sta_ui_log_dir=""
    sta_ui_log_mode=""
    while getopts "w:c:k:g:l:L:v" opt; do
        case $opt in
            w)
                # w -> Wi-Fi interface
                sta_ui_wifi="$OPTARG"
                ;;
            c)
                # c -> Configuration string
                sta_ui_conf_string="$OPTARG"
                ;;
            k)
                # k -> Keyboard user interaction
                sta_ui_cli_mode=1
                sta_ui_conf_string="$OPTARG"
                ;;
            g)
                # G -> GUI user interaction
                sta_ui_gui_mode=1
                sta_ui_conf_string="$OPTARG"
                ;;
            v)
                # v -> Verbose mode
                sta_ui_verbose_mode=1
                ;;
            l)
                # l -> Log session (append to the last progressive number dir)
                # Option to not generate a new log session ("app" = append)
                sta_ui_log_dir="$OPTARG"
                sta_ui_log_mode="app"
                ;;
            L)
                # L -> Log session (increment progressive number dir)
                # Option to generate a new log session
                sta_ui_log_dir="$OPTARG"
                sta_ui_log_mode="new"
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
        echo "Usage: $0 [-w sta_ui_wifi] <-c conf | -k conf_cli | -g conf_gui> [-v] [-l|L log_dir]."
        exit 1
    fi

    # Check if sta_ui_log_dir is valid when -l or -L used
    if [ "$sta_ui_log_mode" != "" ] && [ "$sta_ui_log_dir" == "" ]; then
        echo "Usage: $0 [-w sta_ui_wifi] <-c conf | -k conf_cli | -g conf_gui> [-v] [-l|L log_dir]."
        exit 1
    fi
}

sta_ui_setup() {
    # Start logging if required
    if [ "$sta_ui_log_mode" == "app" ]; then
        log_output -d $sta_ui_log_dir -t "sta.log" &&
            print_info "Beginning saving session of stdout and stderr $sta_ui_log_dir..." &&
            { print_success; echo ""; } || { print_error; return 1; }
    elif [ "$sta_ui_log_mode" == "new" ]; then
        log_output -d $sta_ui_log_dir -t "sta.log" -n &&
            print_info "Beginning saving session of stdout and stderr $sta_ui_log_dir..." &&
            { print_success; echo ""; } || { print_error; return 1; }
    fi

    # Get configuration file from conf_list
    print_info "Fetching configuration file associated to $sta_ui_conf_string..."
    sta_ui_conf_file="$(get_from_list -f "$STA_UI_CONF_LIST_PATH" -s "$sta_ui_conf_string")" &&
        print_success || { echo "$sta_ui_conf_file"; print_error; return 1; }

    if [ "$sta_ui_gui_mode" -eq 1 ]; then
        print_info "Launching GUI..."
        exec_new_term -w "wpa_supplicant" -c "wpa_gui -i $sta_ui_wifi;" &
        if [ "$?" -eq 0 ]; then
            print_success
        else
            print_error
            return 1
        fi
    fi
    
    if [ "$sta_ui_cli_mode" -eq 1 ]; then
        print_info "Launching CLI..."
        exec_new_term -w "wpa_supplicant" -c "wpa_cli -i $sta_ui_wifi;" &
        if [ "$?" -eq 0 ]; then
            print_success
        else
            print_error
            return 1
        fi
    fi
}

sta_ui_setdown() {
    # Try to kill all the terminal windows created
    sudo pkill -P $$ &> /dev/null

    # Try to kill wpa_cli and wpa_gui
    sudo killall wpa_cli &> /dev/null
    sudo killall wpa_gui &> /dev/null

    # Try to kill wpa_supplicant
    sudo killall wpa_supplicant &> /dev/null
}



### *** Main *** ###

sta_ui_main() {
    sta_ui_handle_input $@
    
    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

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
