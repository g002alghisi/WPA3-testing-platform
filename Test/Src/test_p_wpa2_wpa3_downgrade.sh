#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh

# launch the fake AP with wpa2 (not wpa3)
$ap_ui_path -c p:wpa2


# Wait 5s
sleep_with_dots 1


# launch the REAL AP with wpa3
$ap_ui_path -c p:wpa2


# Wait 5s
sleep_with_dots 1


# launch the fake AP with wpa2 (not wpa3)
$ap_ui_path -c p:wpa2

