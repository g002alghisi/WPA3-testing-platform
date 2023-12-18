#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh

TEST_ETH_IF_STRING="-e enp0s20f0u1"


# Launch the REAL AS in a new window
$terminal_exec_cmd "$AS_UI_PATH -c e:wpa3 -v; sleep 3"

# Launch the REAL AP
$AP_UI_PATH -c e:wpa3 $TEST_ETH_IF_TRING

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null


# Sleep for 1s
sleep_with_dots 1


# Launch the ROGUE AS in a new window
$terminal_exec_cmd "$AS_UI_PATH -c e:rogue-wpa3 -v; sleep 3"

# Launch the ROGUE AP
$AP_UI_PATH -c e:wpa3 $TEST_ETH_IF_TRING

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
sudo killall hostapd &> /dev/null
sudo killall freeradius &> /dev/null
