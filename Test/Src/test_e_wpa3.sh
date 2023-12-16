#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh


# Launch the AS
$terminal_exec_cmd "$AS_UI_PATH -c e:wpa2 -v; sleep 10" 

# Launch the AP in a new window
$AP_UI_PATH -e enx9677d3c1defb -c e:wpa3
#$AP_UI_PATH -c e:wpa2

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null
