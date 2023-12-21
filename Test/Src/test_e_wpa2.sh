#!/bin/bash
#set -x  # Debug mode


# Launch the AS in a new window, but wait for hostapd to be running
exec_new_term -w hostapd -c "$AS_UI_PATH -c e_wpa2 -v -l $test_ui_log_tmp_dir"

# Launch the AP
$ap_ui_path -c e_wpa2 -L $test_ui_log_tmp_dir

# Try to kill all the terminal windows created, hostapd and freeradius
pkill "as_ui.sh" > /dev/null
