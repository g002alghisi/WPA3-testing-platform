#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh


# Launch the REAL AS in a new window
$terminal_exec_cmd "$AS_UI_PATH -c e:wpa2 -v; sleep 10"

# Launch the REAL AP
$AP_UI_PATH -c e:wpa2

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null


# Wait 5s
for i in {1..5}; do
    sleep 1
    echo -n "."
done
echo ""


# Launch the FAKE AS in a new window
$terminal_exec_cmd "$AS_UI_PATH -c e:fake-wpa2 -v"

# Launch the FAKE AP
$AP_UI_PATH -c e:wpa2

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null
