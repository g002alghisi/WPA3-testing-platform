#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh


# Launch the REAL AS in a new window
$terminal_exec_cmd "$AS_UI_PATH -c e:wpa3 -v; sleep 3"

# Launch the REAL AP
$AP_UI_PATH -c e:wpa3 -e enxdea50d1b87b8


# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null


# Sleep for 5s
sleep_with_dots 1


# Launch the FAKE AS in a new window
$terminal_exec_cmd "$AS_UI_PATH -c e:fake-wpa3 -v; sleep 3"

# Launch the FAKE AP
$AP_UI_PATH -c e:wpa3 -e enxdea50d1b87b8


# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null
