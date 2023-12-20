# Test Comment

## General information

- Date:       2023-12-20 19:04:38
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_downgrade_wpa2_wpa3.sh
- Result:     Good

## Comment

Ok, it works as expected. It notifies the reception of the Transition Disable 0x01 bit and the supplicant refuses to connect to the rogue WPA2 network.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# launch the REAL AP with wpa2-wpa3 and Transition Disable WPA3 -> WPA2
$AP_UI_PATH -c p_wpa2_wpa3 -L $test_ui_log_tmp_dir


# Sleep 1 s
sleep 1


# launch the ROGUE AP with wpa2 (not wpa3)
$AP_UI_PATH -c p_wpa2 -l $test_ui_log_tmp_dir

```
