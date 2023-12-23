# Test Comment

## General information

- Date:       2023-12-22 17:32:23
- Device:     ESP32
- Script:     Test/Src/test_p_downgrade_wpa2_wpa3.sh
- Result:     Good

## Comment

Perfect. The supplicant notifies the reception of the Transition disable bit with the string "WPA3-Pesonal transition mode disabled based on AP notification for ssid:". Then it neglects the rogue AP network.

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
