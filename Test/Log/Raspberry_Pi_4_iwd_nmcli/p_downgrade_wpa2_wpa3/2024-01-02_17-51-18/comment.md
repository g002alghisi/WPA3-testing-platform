# Test Comment

## General information

- Date:       2024-01-02 17:51:18
- Device:     Raspberry_Pi_4_iwd_nmcli
- Script:     Test/Src/test_p_downgrade_wpa2_wpa3.sh
- Result:     Bad

## Comment

Transition Disable does not prevent to connect the WPA2 AP.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# launch the REAL AP with wpa2-wpa3 and Transition Disable WPA3 -> WPA2
$ap_ui_path -c p_wpa2_wpa3 -L $test_ui_log_tmp_dir


# Sleep 1 s
sleep 1


# launch the ROGUE AP with wpa2 (not wpa3)
$ap_ui_path -c p_wpa2 -l $test_ui_log_tmp_dir

```
