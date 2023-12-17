#!/bin/bash

GENERAL_UTILS_IS_LOADED=True

CODE_OK=0
CODE_KO=1
CODE_ERROR=2


### *** Go Home *** ###

HOME_DIR="Hostapd-test"  # Without final "/"

go_home() {
    cd "$(dirname "$HOME_DIR")"
    current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_DIR" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done

    if [[ "$current_path" == "/" ]]; then
        echo "Error in $FUNCNAME(), reached "/" position. Wrong HOME_DIR"
        return "$CODE_ERROR"
    fi
}



### *** Logging *** ###

# Color strings
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'    # No color

log_info() {
    echo "INFO: $@"
}

log_success() {
    echo -e "${GREEN}Success.${NC}"
}

log_error() {
    echo -e "${RED}Error.${NC}"
}

log_title() {
    echo -e "\n${CYAN}$@${NC}\n"
}



### *** Check file *** ###

file_exists() {
    _file=""
    _file_is_dir=0
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
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME() < -f file | -d dir >."
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
    _file_list=""
    _string=""
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
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME() -f file -s string."
        return $CODE_ERROR
    fi

    file_exists -f $_file_list || return "$?"

    _output="$(grep "$_string""=" "$_file_list" | cut -d "=" -f 2)"
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
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME() sec."
        return $CODE_ERROR
    fi

    # Check if the input is a number
    if [ -n "$1" ] || [ "$1" -eq "$1" ] &>/dev/null; then
        _sec="$1"
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

log_fun() {
    _log_path=""
    _log_dir=""
    _log_target=""
    _log_new_session=0
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
                _log_n&&ew_session=1
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
    if [ "$_log_dir" == "" ] || [ "$_log_target" == "" ] || [ "$_log_command" == ""]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME() -d log_dir -t log_target [-a] -c command."
        return $CODE_ERROR
    fi

    # Check if _log_dir ends with "/" or not
    if [ "$_log_dir" == *"/" ]; then
        _log_path="$_log_dir"
    else
        _log_path="$_log_dir/"
    fi

    # Check the last numbered subfolder
    _last_progr_num=$(ls -d $_log_path/* | grep -Eo '[0-9]+' | sort -n | tail -n 1 2>/dev/null)
    if [ -z "$_last_progr_num" ]; then
        _last_progr_num=0
    fi

    # Calculate the next _log_progr_number
    if [ "$_log_new_session" -eq 1 ]; then
        _log_progr_number=$((_last_progr_num + 1))
    elif [ "$_log_new_session" -eq 0 ] && [ "$_last_progr_num" -ne 0 ]; then
        _log_progr_number=$_last_progr_num
    elif [ "$_log_new_session" -eq 0 ] && [ "$_last_progr_num" -eq 0 ]; then
        echo "Error in $FUNCNAME(). Not initializing new log session, but cannot find an old one."
        return $CODE_KO
    fi

    # Update _log_path, ceate the sub directory if does not exists yet and
    # finally get the _log_file full path name
    _log_path="$_log_path/$_log_progr_number"
    mkdir -p "$_log_path"
    _log_file="$_log_path/$_log_target.log"

    # Copy stdout and stderr inside _log_file
    exec > >(tee -a "$_log_file") 2>&1 ||
        { echo "Error in $FUNCNAME(). Cannot initialize log session."; return $CODE_KO; }

    return $CODE_OK
}