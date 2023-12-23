#!/bin/bash
#set -x  # Debug mode


# launch the FAKE AP with SAE-PK-like password
$ap_ui_path -c p_fake_wpa3_pk -L $test_ui_log_tmp_dir


# Sleep 1 s
sleep 1


# launch the REAL AP with SAE-PK
$ap_ui_path -c p_wpa3_pk -l $test_ui_log_tmp_dir


# Sleep 1 s
sleep 1


# launch the FAKE AP with WPA3 (not SAE-PK)
$ap_ui_path -c p_fake_wpa3_pk -l $test_ui_log_tmp_dir
