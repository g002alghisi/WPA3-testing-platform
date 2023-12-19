#!/bin/bash
#set -x  # Debug mode


# launch the REAL AP with SAE-PK
$AP_UI_PATH -c p_wpa3_pk -L $test_ui_log_dir


# Sleep 1 s
sleep 1


# launch the FAKE AP with WPA3 (not SAE-PK)
$AP_UI_PATH -c p_fake_wpa3_pk -l $test_ui_log_dir
