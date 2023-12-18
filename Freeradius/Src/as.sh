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

# Tmp DIR to store the certificates
tmp_dir="Freeradius/Tmp"



### *** AS *** ###

as_handle_input() {
    as_ip_addr=""
    as_port=""
    as_conf_dir=""
    as_verb_mode=0
    while getopts "c:v" opt; do
        case $opt in
            c)
                as_conf_dir="$OPTARG"
                ;;
            v)
                as_verb_mode=1
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

    # Check if the input is valid (the user have to insert at lease the
    #   configuration dir path)
    if [ "$as_conf_dir" == "" ]; then
        echo "Usage: $0 -c conf_dir [-v] [-l|L log_dir]."
        exit 1
    fi
}

as_setup() {
    # Check if $as_conf_dir ends with "/"
    if [[ "$as_conf_dir" != */ ]]; then
        as_conf_dir="$as_conf_dir""/"
    fi

    # Check AS config directory
    print_info "Looking for $as_conf_dir..."
    file_exists -d $as_conf_dir && print_success || { print_error; return 1; }

    # Kill previous instances of Freeradius
    sudo killall freeradius &> /dev/null

    return 0
}

as_run() {
    print_title "Running FreeRADIUS. Press Ctrl-C to stop."

    if [ "$as_verb_mode" -eq 0 ]; then
        sudo freeradius -f -d "$as_conf_dir"
    else
        sudo freeradius -d "$as_conf_dir" -X
    fi

    print_title "FreeRADIUS is stopped."
}

as_setdown() {
    # If something goes wrong, try to kill freeradius
    sudo killall freeradius &> /dev/null
}



### *** Main section *** ###

as_main() {
    # Update the cached credentials (this avoid the insertion of the sudo password
    #   during the execution of the successive commands)
    sudo -v

    # Hide keyboard input
    stty -echo

    # Handle input
    as_handle_input $@

    # If the setup fails, then do not run, but skip this phase and execute
    #   the setdown
    echo ""
    as_setup &&
    as_run
    as_setdown
    echo ""

    # Show keyboard input
    stty echo
}

as_main $@
