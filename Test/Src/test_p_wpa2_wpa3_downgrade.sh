#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh

# launch the fake AP with wpa2 (not wpa3)
#$AP_UI_PATH -c p:wpa2 -e enx7a959c44df52


# Wait 5s
#sleep_with_dots 1


# launch the REAL AP with wpa2-wpa3
$AP_UI_PATH -c p:wpa2-wpa3 -e enx7a959c44df52


# Wait 5s
sleep_with_dots 1


# launch the fake AP with wpa2 (not wpa3)
$AP_UI_PATH -c p:wpa2 -e enx7a959c44df52

