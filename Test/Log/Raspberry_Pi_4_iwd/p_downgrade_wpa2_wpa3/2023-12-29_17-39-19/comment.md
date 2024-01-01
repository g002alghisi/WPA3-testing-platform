# Test Comment

## General information

- Date:       2023-12-29 17:39:19
- Device:     Raspberry_Pi_4_iwd
- Script:     Test/Src/test_p_downgrade_wpa2_wpa3.sh
- Result:     Bad

## Comment

It seems that no transition disable is present in iwd. The version is the 2.3-1.
The supplicant was configured with the Network Manager GUI by selecting WPA/WPA2/WPA3.
Moreover, by selecting WPA3 in the network profile, the supplicant connects to the real AP, then if it does not connet to the downgraded AP, if the user click again on the SSID from the GUI, the system creates a new network profile with same name and "1" appended at the end, then it joins the WPA2 rogue network.

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
