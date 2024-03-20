#!/bin/bash
#set -x  # debug mode

# Home. DO NOT TERMINATE WITH "/"
HOME_DIR="WPA3-testing-platform"  # Without final "/"

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
ap_ui_path="Hostapd/Src/ap_ui.sh"
AS_UI_PATH="Freeradius/Src/as_ui.sh"

# Log path. DO NOT TERMINATE WITH "/"
TEST_UI_LOG_DIR="Test/Log"
TEST_UI_LOG_TMP_DIR_ROOT="Test/Tmp/Log"
test_ui_log_tmp_dir="$TEST_UI_LOG_TMP_DIR_ROOT"

# Configuration files list
TEST_UI_SCRIPT_LIST_PATH="Test/Conf/script_list.txt"
TEST_UI_DEVICE_LIST_PATH="Test/Conf/device_list.txt"

# Comment file
TEST_UI_COMMENT_TEMPLATE_PATH="Test/Conf/comment_template.md"
TEST_UI_COMMENT_TMP_PATH="Test/Tmp/comment.md"


### *** Test *** ###

test_ui_handle_input() {
    test_script=""
    test_ui_device_string=""
    test_ui_script_string=""
    test_ui_verb_mode=0
    while getopts "d:s:v" opt; do
        case $opt in
            d)
                # d -> Device string
                test_ui_device_string="$OPTARG"
                ;;
            s)
                # s -> Script string
                test_ui_script_string="$OPTARG"
                ;;
            v)
                # v -> Verbose mode
                test_ui_verb_mode=1
                ;;
            \?)
                echo "Error in $FUNCNAME(). Invalid option: -$OPTARG."
                exit 1
                ;;
            :)
                echo "Error in $FUNCNAME(). Option -$OPTARG requires an argument."
                exit 1
                ;;
        esac
    done
    OPTIND=1

    # Check if the input is valid (the user have to insert at least the
    #   script and the device string)
    if [ "$test_ui_script_string" == "" ] || [ "$test_ui_device_string" == "" ]; then
        echo "Usage: $0 -s script_string -d device_string."
        exit 1
    fi

    return
}

test_ui_setup() {
    # Save test time and date
    test_ui_date_string="$(date "+%Y-%m-%d %H:%M:%S")"

    # Empty Test/Tmp/Log/
    rm -r "$TEST_UI_LOG_TMP_DIR_ROOT" &> /dev/null

    # Get script from conf_list
    print_info "Fetching test script associated to $test_ui_script_string..."
    test_ui_script="$(get_from_list -f "$TEST_UI_SCRIPT_LIST_PATH" -s "$test_ui_script_string")" &&
        print_success || { echo "$test_ui_script"; print_error; echo ""; return 1; }
    print_info "Fetching device name associated to $test_ui_device_string..."
    test_ui_device="$(get_from_list -f "$TEST_UI_DEVICE_LIST_PATH" -s "$test_ui_device_string")" &&
        print_success || { echo "$test_ui_device"; print_error; echo ""; return 1; } 

    # Prepare log dir path
    test_ui_log_tmp_dir="$test_ui_log_tmp_dir/$test_ui_device/$test_ui_script_string"
}

test_ui_handle_comment() {
    # Print query and get reply
    read -p "Do you want to leave a comment? [y/N] " choice_comment

    # Default choice is 'N' if the user presses Enter without typing anything
    choice_comment=${choice_comment:-N}

    # Convert the choice to uppercase
    choice_comment=$(echo "$choice_comment" | tr '[:lower:]' '[:upper:]')

    if [ "$choice_comment" = "Y" ]; then
        # Copy comment template, adapt and let te user modify it
        cp "$TEST_UI_COMMENT_TEMPLATE_PATH" "$TEST_UI_COMMENT_TMP_PATH"
        # Create a new subshell. If a cmd fails, then the subshell is stopped.
        (
            sed -i "s|@test_ui_date_string|$test_ui_date_string|g" "$TEST_UI_COMMENT_TMP_PATH"
            sed -i "s|@test_ui_device|$test_ui_device|g" "$TEST_UI_COMMENT_TMP_PATH"
            sed -i "/@test_ui_script_content/ r $test_ui_script" "$TEST_UI_COMMENT_TMP_PATH"
            sed -i "/@test_ui_script_content/ d" "$TEST_UI_COMMENT_TMP_PATH"
            sed -i "s|@test_ui_script|$test_ui_script|g" "$TEST_UI_COMMENT_TMP_PATH"
        )

        # Let te user modify the comment.    
        vim "$TEST_UI_COMMENT_TMP_PATH"

        # Create a new subshell to save the comment by means of log_output()
        (
            # Start saving stdout and stderr of the subshell
            log_output -d "$test_ui_log_tmp_dir" -t "comment.md"

            cat "$TEST_UI_COMMENT_TMP_PATH"

        ) > /dev/null

        # Delete the tmp comment.txt file
        rm "$TEST_UI_COMMENT_TMP_PATH"
    fi

    echo ""
}

test_ui_save_log() {
    # Print query and get reply
    read -p "Do you want to save the log? [y/N] " choice_log

    # Default choice is 'N' if the user presses Enter without typing anything
    choice_log=${choice_log:-N}

    # Convert the choice to uppercase
    choice_log=$(echo "$choice_log" | tr '[:lower:]' '[:upper:]')

    if [ "$choice_log" = "Y" ]; then
        cp -r "$TEST_UI_LOG_TMP_DIR_ROOT"/* "$TEST_UI_LOG_DIR"
    fi

    rm -rf "$TEST_UI_LOG_TMP_DIR_ROOT"
}


### *** Main section *** ###

test_ui_main() {
    test_ui_handle_input $@

    # Update the cached credentials
    # during the execution of the successive commands).
    sudo -v

    # Hide keyboard input
    stty -echo
    
    # Set verbose mode for hostapd if required by the user
    if [ $test_ui_verb_mode -eq 1 ]; then
        ap_ui_path="$ap_ui_path -v"
    fi

    echo ""
    test_ui_setup &&
    
    # Run test
    source $test_ui_script

    # Show keyboard input
    stty echo

    # Ask the user to leave a comment
    test_ui_handle_comment

    test_ui_save_log
    echo ""
}

test_ui_main $@
