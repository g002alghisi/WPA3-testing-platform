# Test Comment

## General information

- Date:       2023-12-21 17:49:18
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_downgrade_wpa2_wpa3.sh
- Result:     Good

## Comment

perfect. Try again but this time the .conf file of the supplicant was set with "update=1".
Moreover, after the first connection to the real AP and after having turned off the supplicant, the next time it still refused to connect to the ROGUE AP.

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
