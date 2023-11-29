#!/bin/bash

AP_UI_PATH="Hostapd/Src/ap_ui.sh"
AS_UI_PATH="Freeradius/Src/as_ui.sh"


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

go_home

# Source Utils
source "Utils/Src/general_utils.sh"

# Get terminal execution cmd
terminal_exec_cmd="$(get_terminal_exec_cmd)" || { echo "$terminal_exec_cmd"; exit 1; }

