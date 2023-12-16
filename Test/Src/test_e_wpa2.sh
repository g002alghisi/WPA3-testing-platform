#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh

TEST_ETH_IF_STRING="-e ethf3"


# Launch the AP
$terminal_exec_cmd "$AS_UI_PATH -c e:wpa2 -v; sleep 10" 

# Launch the AS in a new window
$AP_UI_PATH -c e:wpa2 $TEST_ETH_IF_STRING

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null

