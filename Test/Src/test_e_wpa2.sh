#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh


# Launch the AS in a new window
exec_new_term -w "hostapd" -c "$AS_UI_PATH -c e:wpa2 -v -l $test_ui_log_dir"

# Launch the AP
$AP_UI_PATH -c e:wpa2 -L $test_ui_log_dir

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null
