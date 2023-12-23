# Test Comment

## General information

- Date:       2023-12-23 20:13:36
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_downgrade_wpa3_pk.sh
- Result:     Good

## Comment

The device first connect to the FAKE SAE-PK AP (Ok, coherent to the WPA3 standard...).
After that, it joins the real AP and gets the Transition disable bit ("wlx5ca6e63fe2da: TRANSITION-DISABLE 02").
Then it does not connect to the FAKE SAE-PK AP, neither after the reboot (it updates the .conf file by selecting `key_mgmt=SAE`, not `WPA-PSK SAE` anymore, and `sae_pk=1`, thus only mode).

## Test script

```bash
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
```
