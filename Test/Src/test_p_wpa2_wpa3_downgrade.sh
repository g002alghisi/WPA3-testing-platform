#!/bin/bash
#set -x  # Debug mode


# launch the REAL AP with wpa2-wpa3 and Transition Disable WPA3 -> WPA2
$AP_UI_PATH -c p_wpa2_wpa3 -L $test_ui_log_dir


# Sleep 1 s
sleep 1


# launch the ROGUE AP with wpa2 (not wpa3)
$AP_UI_PATH -c p_wpa2 -l $test_ui_log_dir

