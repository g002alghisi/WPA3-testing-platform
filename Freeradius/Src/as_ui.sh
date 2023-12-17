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

# as.sh path
AS_PATH="Freeradius/Src/as.sh"

# Configuration files list
CONF_LIST_PATH="Freeradius/Conf/conf_list.txt"



### *** AP UI *** ###

as_ui_setup() {
    # Get configuration dir from conf_list
    print_info "Fetching configuration directory associated to $as_conf_string..."
    as_conf_dir="$(get_from_list -f "$CONF_LIST_PATH" -s "$as_conf_string")" &&
        print_success || { echo "$as_conf_dir"; print_error; echo ""; return 1; }
}



### *** Main *** ###

main() {
    as_conf_dir=""
    as_conf_string=""
    as_verbose_mode=0
    as_debug_mode=0
    while getopts "c:v" opt; do
        case $opt in
            c)
                as_conf_string="$OPTARG"
                ;;
            v)
                as_verbose_mode=1
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
    if [ "$as_conf_string" == "" ]; then
        echo "Usage: $0 -c as_conf_string [-v]."
        exit 1
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    echo ""
    as_ui_setup &&

    # Run as.sh
    if [ "$as_verbose_mode" -eq 0 ]; then
        "$AS_PATH" -c "$as_conf_dir"
    else
        "$AS_PATH" -c "$as_conf_dir" -v
    fi
}


main $@
