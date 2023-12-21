# Test Comment

## General information

- Date:       2023-12-21 19:21:01
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_downgrade_wpa3_pk.sh
- Result:     Good

## Comment

Ok. Better to try again with "update=1" in the wpa_supplicnt .conf file

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# launch the REAL AP with SAE-PK
$ap_ui_path -c p_wpa3_pk -L $test_ui_log_tmp_dir


# Sleep 1 s
sleep 1


# launch the FAKE AP with WPA3 (not SAE-PK)
$ap_ui_path -c p_fake_wpa3_pk -l $test_ui_log_tmp_dir
```
