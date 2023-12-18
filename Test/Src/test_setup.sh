#!/bin/bash
#set -x  # debug mode

# Home. DO NOT TERMINATE WITH "/"
HOME_DIR="Hostapd-test"  # Without final "/"

go_home() {
    current_dir="$(basename $(pwd))"
    while [[ "$current_dir" != "$HOME_DIR" ]] && [[ "$current_dir" != "/" ]]; do
        cd ..
        current_dir="$(basename $(pwd))"
    done

    if [[ "$current_dir" == "/" ]]; then
        echo "Error in $FUNCNAME(), reached "/" position."
        exit 1
    fi
}

# All the file positions are now relative to the Main Repository DIR.
# Load utils scripts
go_home
source Utils/Src/general_utils.sh

# ap.sh and as.sh paths
AP_UI_PATH="Hostapd/Src/ap_ui.sh"
AS_UI_PATH="Freeradius/Src/as_ui.sh"

# Log path. DO NOT TERMINATE WITH "/"
test_ui_log_dir="Test/Log"

# Configuration files list
TEST_UI_SCRIPT_LIST_PATH="Test/Conf/script_list.txt"
TEST_UI_SCRIPT_LIST_PATH="Test/Conf/device_list.txt"


### *** Test *** ###

test_ui_handle_input() {
    test_script=""
    test_ui_device_string=""
    test_script_string=""
    while getopts "d:s:" opt; do
        case $opt in
            d)
                # d -> Device string
                test_ui_device_string="$OPTARG"
                ;;
            s)
                # s -> Script string
                test_script_string="$OPTARG"
                ;;
            \?)
                echo "Error in $FUNCNAME(). Invalid option: -$OPTARG."
                return $CODE_ERROR
                ;;
            :)
                echo "Error in $FUNCNAME(). Option -$OPTARG requires an argument."
                return $CODE_ERROR
                ;;
        esac
    done
    OPTIND=1

    # Check if the input is valid (the user have to insert at least the
    #   script and the device string)
    if [ "$test_script_string" == "" ] || [ "$test_ui_device_string" == "" ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME() -c script_string -d device_string."
        return "$CODE_ERROR"
    fi

    return $CODE_OK
}

test_ui_setup() {
    # Get script from conf_list
    print_info "Fetching test script associated to $test_ui_script_string..."
    test_ui_script="$(get_from_list -f "$CONF_LIST_PATH" -s "$test_ui_script_string")" &&
        print_success || { echo "$test_ui_script"; print_error; echo ""; return 1; }

    # Get device from conf_list
    print_info "Fetching device name associated to $test_ui_device_string..."
    test_ui_device="$(get_from_list -f "$CONF_LIST_PATH" -s "$test_ui_device_string")" &&
        print_success || { echo "$test_ui_device"; print_error; echo ""; return 1; } 

    # Prepare log dir path
    test_ui_log_dir="$test_ui_log_dir/$test_ui_device/test_ui_script_string"
}


### *** Main section *** ###

test_ui_main() {
    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    # Hide keyboard input
    stty -echo

    test_ui_handle_input $@

    test_ui_setup &&

    # Run test
    $test_ui_script

    # Show keyboard input
    stty echo
}

test_ui_main $@
