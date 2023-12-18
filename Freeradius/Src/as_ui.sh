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

# as.sh path
AS_PATH="Freeradius/Src/as.sh"

# Configuration files list
AS_UI_CONF_LIST_PATH="Freeradius/Conf/conf_list.txt"



### *** AS UI *** ###

as_ui_handle_input() {
    as_ui_conf_dir=""
    as_ui_conf_string=""
    as_ui_verb_mode=0
    as_ui_debug_mode=0
    as_ui_log_dir=""
    as_ui_log_mode=""
    while getopts "c:l:L:v" opt; do
        case $opt in
            c)
                # c -> Configuration string
                as_ui_conf_string="$OPTARG"
                ;;
            v)
                # v -> Verbose
                as_ui_verb_mode=1
                ;;
            l)
                # l -> Log session (append to the last progressive number dir)
                # Option to not generate a new log session ("app" = append)
                as_ui_log_dir="$OPTARG"
                as_ui_log_mode="app"
                ;;
            L)
                # L -> Log session (increment progressive number dir)
                # Option to generate a new log session
                as_ui_log_dir="$OPTARG"
                as_ui_log_mode="new"
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
    if [ "$as_ui_conf_string" == "" ]; then
        echo "Usage: $0 -c as_ui_conf_string [-v] [-l|L log_dir]."
        exit 1
    fi

    # Check if as_ui_log_dir is valid when -l or -L used
    if [ "$as_ui_log_mode" != "" ] && [ "$as_ui_log_dir" == "" ]; then
        echo "Usage: $0 -c as_ui_conf_string [-v] [-l|L log_dir]."
        exit 1
    fi
}

as_ui_setup() {
    # Start logging if required
    if [ "$as_ui_log_mode" == "app" ]; then
        log_output -d $as_ui_log_dir -t "$as_ui_conf_string" &&
            print_info "Beginning saving session of stdout and stderr $as_ui_log_dir..." &&
            { print_success; echo ""; } || { print_error; return 1; }
    elif [ "$as_ui_log_mode" == "new" ]; then
        log_output -d $as_ui_log_dir -t "$as_ui_conf_string" -n &&
            print_info "Beginning saving session of stdout and stderr $as_ui_log_dir..." &&
            { print_success; echo ""; } || { print_error; return 1; }
    fi

    # Get configuration dir from conf_list
    print_info "Fetching configuration directory associated to $as_ui_conf_string..."
    as_ui_conf_dir="$(get_from_list -f "$AS_UI_CONF_LIST_PATH" -s "$as_ui_conf_string")" &&
        print_success || { echo "$as_ui_conf_dir"; print_error; echo ""; return 1; }
}



### *** Main *** ###

as_ui_main() {
    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    as_ui_handle_input $@

    echo ""
    as_ui_setup &&

    # Run as.sh
    if [ "$as_ui_verb_mode" -eq 0 ]; then
        "$AS_PATH" -c "$as_ui_conf_dir"
    else
        "$AS_PATH" -c "$as_ui_conf_dir" -v
    fi
}


as_ui_main $@
