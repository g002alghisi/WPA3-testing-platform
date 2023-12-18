#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh


# launch the ROGUE AP with wpa2 (not wpa3)
#$AP_UI_PATH -c p:wpa2


# Wait 1s
#sleep_with_dots 1


# launch the REAL AP with wpa2-wpa3 and Transition Disable WPA3 -> WPA2
$AP_UI_PATH -c p:wpa2-wpa3


# Wait 5s
sleep_with_dots 1


# launch the ROGUE AP with wpa2 (not wpa3)
$AP_UI_PATH -c p:wpa2

