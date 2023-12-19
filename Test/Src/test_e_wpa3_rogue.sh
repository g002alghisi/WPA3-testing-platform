#!/bin/bash
#set -x  # Debug mode


# Launch the REAL AS in a new window
$exec_new_term -w "hostapd" -c "$AS_UI_PATH -c e_wpa3 -v -l $test_ui_log_tmp_dir"

# Launch the REAL AP
$AP_UI_PATH -c e_wpa3 -L "$test_ui_log_tmp_dir"

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null


# Sleep for 1s
sleep 1

# Launch the ROGUE AS in a new window
$exec_new_term -w "hostapd" -c "$AS_UI_PATH -c e_rogue_wpa3 -v -l $test_ui_log_tmp_dir"

# Launch the ROGUE AP
$AP_UI_PATH -c e_rogue_wpa3 -l "$test_ui_log_tmp_dir"

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null
