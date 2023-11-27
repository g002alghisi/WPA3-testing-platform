#!/bin/bash

GENERAL_UTILS_IS_LOADED=True

CODE_OK=0
CODE_KO=1
CODE_ERROR=2


### *** Go Home *** ###

HOME_FOLDER="Hostapd-test"  # Without final "/"

go_home() {
    cd "$(dirname "$HOME_FOLDER")"
    current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_FOLDER" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done

    if [[ "$current_path" == "/" ]]; then
        echo "Error in $FUNCNAME(), reached "/" position. Wrong HOME_FOLDER"
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
    if [ "$#" -ne 1 ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME() file."
        return "$CODE_ERROR"
    fi

    _file="$1"
    if [ ! -e "$_file" ]; then
        echo "$FUNCNAME(): File $_file does not exist."
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

    file_exists $_file_list || return "$?"

    _output="$(grep "$ap_conf_string""=" "$CONF_LIST_PATH" | cut -d "=" -f 2)"
    if [ "$_output" == "" ]; then
        echo "$FUNCNAME(): Cannot find $_string in $_file_list."
        return $CODE_KO
    fi
    echo "$_output"
}



### *** Terminal check *** ###

get_terminal_exec_cmd() {
	if pgrep "gnome-terminal" > /dev/null; then
	    _terminal_exec_cmd="gnome-terminal --"
	elif pgrep "qterminal" > /dev/null; then
	    _terminal_exec_cmd="qterminal -e"
	else
        echo "$FUNCNAME(): Cannot recognise the terminal type."
        return $CODE_KO
	fi
    echo "$_terminal_exec_cmd"
    return $CODE_OK
}

