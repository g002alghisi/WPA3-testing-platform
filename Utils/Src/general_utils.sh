#!/bin/bash
#set -x

GENERAL_UTILS_IS_LOADED=true

CODE_OK=0
CODE_KO=1
CODE_ERROR=2


### *** Go Home *** ###

HOME_DIR="Hostapd-test"  # Without final "/"

go_home() {
    cd "$(dirname "$HOME_DIR")"
    local current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_DIR" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done

    if [[ "$current_path" == "/" ]]; then
        echo "Error in $FUNCNAME(), reached "/" position. Wrong HOME_DIR"
        exit 1
    fi
}



### *** Logging *** ###

# Color strings
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'    # No color

print_info() {
    echo "[$(date "+%2H:%2M:%2S.%3N")] $@"
}

print_success() {
    echo -e "${GREEN}Success.${NC}"
}

print_error() {
    echo -e "${RED}Error.${NC}"
}

print_title() {
    echo -e "\n${CYAN}$@${NC}\n"
}



### *** Check file *** ###

file_exists() {
    local _file=""
    local _file_is_dir=0
    while getopts "f:d:" opt; do
        case $opt in
            f)
                _file="$OPTARG"
                ;;
            d)
                _file="$OPTARG"
                _file_is_dir=1
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

    if [ "$_file" == "" ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME < -f file | -d dir >."
        return "$CODE_ERROR"
    fi

    if [ "$_file_is_dir" == 0 ] && [ ! -e "$_file" ]; then
        echo "$FUNCNAME(): File $_file does not exist."
        return "$CODE_KO"
    fi

    if [ "$_file_is_dir" == 1 ] && [ ! -d "$_file" ]; then
        echo "$FUNCNAME(): Directory $_file does not exist."
        return "$CODE_KO"
    fi
}



### *** Get from list *** ###

get_from_list() {
    local _file_list=""
    local _string=""
    while getopts "f:s:" opt; do
        case $opt in
            f)
                _file_list="$OPTARG"
                ;;
            s)
                _string="$OPTARG"
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

    if [ "$_file_list" == "" ] || [ "$_string" == "" ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME -f file -s string."
        return $CODE_ERROR
    fi

    file_exists -f $_file_list || return "$?"

    local _output="$(grep "\b$_string\b""=" "$_file_list" | cut -d "=" -f 2)"
    if [ "$_output" == "" ]; then
        echo "$FUNCNAME(): Cannot find $_string in $_file_list."
        return $CODE_KO
    fi
    echo "$_output"
}



### *** Terminal check *** ###

get_terminal_exec_cmd() {
	if pgrep "gnome-terminal" > /dev/null; then
	    _terminal_exec_cmd="gnome-terminal -- bash -c"
	elif pgrep "qterminal" > /dev/null; then
	    _terminal_exec_cmd="qterminal -e bash -c"
	else
        echo "$FUNCNAME(): Cannot recognise the terminal type."
        return $CODE_KO
	fi
    echo "$_terminal_exec_cmd"
    return $CODE_OK
}



### *** Wait *** ###

sleep_with_dots() {
    if [ "$#" -ne 1 ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME sec."
        return $CODE_ERROR
    fi

    # Check if the input is a number
    if [ -n "$1" ] || [ "$1" -eq "$1" ] &>/dev/null; then
        local _sec="$1"
    else
        echo "Error in $FUNCNAME(). Input parameter is not a number."
        return $CODE_ERROR
    fi

    echo "Wait $_sec s."
    for ((i=1; i<=$_sec; i++)); do
        sleep 1
        echo -n "."
    done
    echo ""
}



### *** Handle Logs *** ###

# Log hieracy:
#
#   - log_dir (es. Test/Tmp/iPad/test_e_wpa2)
#   |
#   ----- progressive number (es. 1)
#   |   |
#   |   ----- log_target.log (es. ap.log)
#   |   |
#   |   ----- another log_target.log (es. as.log)
#   |
#   ----- next progressive number (es. 2)
#       |
#       ----- log_target.log (es. ap.log)
#       |
#       ----- another log_target.log (es. as.log)

log_output() {
    local _log_file=""
    local _log_dir=""
    local _log_target=""
    local _log_mode="app"
    while getopts "d:t:n" opt; do
        case $opt in
            d)
                #  Name of the main log directory (es. Test/Tmp/iPad)
                _log_dir="$OPTARG"
                ;;
            t)
                # Name of the subprogram to be logged (es. ap, or as)
                _log_target="$OPTARG"
                ;;
            n)
                # Enforce number progression or not 
                _log_mode="new"
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

    # Check if the input is valid
    if [ "$_log_dir" == "" ] || [ "$_log_target" == "" ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME -d log_dir -t log_target [-a]."
        return $CODE_ERROR
    fi

    # Check if _log_dir ends with "/" or not
    if [[ "$_log_dir" == *"/" ]]; then
        _log_file="$_log_dir"
    else
        _log_file="$_log_dir/"
    fi

    # Create it if it does not exist
    mkdir -p "$_log_dir"

    # Check the last numbered subfolder
    # local _log_progr_num=0
    # local _log_last_progr_num=$(ls $_log_file | grep -Eo '^[0-9]+' | sort -n | tail -n 1 2>/dev/null)
    # if [ -z "$_log_last_progr_num" ]; then
    #     _log_last_progr_num=0
    # fi

    # # Calculate the next _log_progr_num
    # if [ "$_log_mode" == "new" ]; then
    #     _log_progr_num=$((_log_last_progr_num + 1))
    # elif [ "$_log_mode" == "app" ] && [ "$_log_last_progr_num" -ne 0 ]; then
    #     _log_progr_num=$_log_last_progr_num
    # elif [ "$_log_mode" == "app" ] && [ "$_log_last_progr_num" -eq 0 ]; then
    #     echo "Error in $FUNCNAME(). Not initializing new log session, but cannot find an old one."
    #     return $CODE_KO
    # fi

    # Get log dates
    local _log_date=""
    local _log_last_date=$(ls $_log_file | sort -n | tail -n 1 2>/dev/null)

    # Calculate the next _log_progr_num
    if [ "$_log_mode" == "new" ]; then
            local _log_date="$(date "+%Y-%m-%d_%H-%M-%S")"
    elif [ "$_log_mode" == "app" ] && ! [ -z "$_log_last_date" ]; then
        _log_date=$_log_last_date
    elif [ "$_log_mode" == "app" ] && [ -z "$_log_last_date" ]; then
        echo "Error in $FUNCNAME(). Not initializing new log session, but cannot find an old one."
        return $CODE_KO
    fi

    # Update _log_file, ceate the sub directory if does not exists yet and
    # finally get the _log_file full path name
    _log_file="$_log_file""$_log_date"
    mkdir -p "$_log_file"
    _log_file="$_log_file/$_log_target"

    # Save stdout and stderr inside _log_file
    exec > >(trap '' INT; tee -a "$_log_file") 2>&1

    return "$?"
}




### *** Interprocessing *** ###

exec_new_term() {
    local _exec_wait_process=""
    local _exec_wait_process_request=false
    local _exec_input_cmd_string=""
    while getopts "w:c:" opt; do
        case $opt in
            w)
                _exec_wait_process_request=true
                _exec_wait_process="$OPTARG"
                ;;
            c)
                _exec_input_cmd_string="$OPTARG"
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

    # Check if the input is valid
    if [ "$_exec_input_cmd_string" == "" ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME -w process_to_wait -c \"cmd_string\"."
        return $CODE_ERROR
    fi

    if [ $_exec_wait_process_request ] && [ "$_exec_wait_process" == "" ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME -w process_to_wait -c \"cmd_string\"."
        return $CODE_ERROR
    fi

    # Prepare _exec, the cmd to open a new terminal window and execute stuff
    _exec_cmd="$(get_terminal_exec_cmd)"

    _exec_wait_cmd='while [ "$(pgrep '$_exec_wait_process')" == "" ]; do sleep 1; done'

    # Execute the _exec_cmd. Wait for the other process if specified
    if [ $_exec_wait_process_request ]; then
        $_exec_cmd "$_exec_wait_cmd; $_exec_input_cmd_string;"
    else
        $_exec_cmd "$_exec_input_cmd_string;"
    fi
    
    return
}


### *** Handle Hostapd and Wpa_supplicant timestamps *** ###

exec_and_convert_timestamp() {
    # Run Hostapd and filter the output
    "$@" | awk '
        {            
            if ($0 ~ /^[0-9]+\.[0-9]+:/) {
                if ($0 ~ /^[0-9]+\.[0-9]+: [0-9]+\.[0-9]+:/) {
                    # Remove the second timestamp if two consecutive timestamps are found
                    sub(/ [0-9]+\.[0-9]+:/, "")
                } 
                # Extract seconds and milliseconds
                split($1, a, "\\.")
                seconds = a[1]
                milliseconds = substr(a[2] "000", 1, 3)

                # Format the timestamp with milliseconds
                formatted_output = "[" strftime("%H:%M:%S.", seconds) milliseconds "]"

                # Replace the original timestamp with the converted one
                sub(/^[0-9]+\.[0-9]+:/, formatted_output)

                # Flush the output buffer
                fflush()
            }

            # Process the line or do something else with the output
            print
        }'
}