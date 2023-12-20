# Test Comment

## General information

- Date:       2023-12-20 19:09:20
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_downgrade_wpa3_pk.sh
- Result:     Good

## Comment

Ok, wpa_supplicant gets the Transition Disable 0x02 bit and refuses to join the rogue network. Wpa_supplicant was set to use SAE-PK Automatic mode.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# launch the REAL AP with SAE-PK
$AP_UI_PATH -c p_wpa3_pk -L $test_ui_log_tmp_dir


# Sleep 1 s
sleep 1


# launch the FAKE AP with WPA3 (not SAE-PK)
$AP_UI_PATH -c p_fake_wpa3_pk -l $test_ui_log_tmp_dir
```
