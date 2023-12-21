#!/bin/bash
#set -x  # Debug mode


# Launch the REAL AS in a new window, but wait for hostapd to be running
$exec_new_term -w hostapd "$AS_UI_PATH -c e_wpa2 -v -l $test_ui_log_tmp_dir"

# Launch the REAL AP
$ap_ui_path -c e_wpa2 -L "$test_ui_log_tmp_dir"

# Try to kill the terminal window created.
pkill "as_ui.sh" &> /dev/null


# Sleep for 1s
sleep 1


# Launch the ROGUE AS in a new window
$exec_new_term -w hostapd "$AS_UI_PATH -c e_rogue_wpa2 -v -l $test_ui_log_tmp_dir"

# Launch the ROGUE AP
$ap_ui_path -c e_rogue_wpa2 -l "$test_ui_log_tmp_dir"


# Try to kill all terminal window created.
pkill "as_ui.sh" &> /dev/null
