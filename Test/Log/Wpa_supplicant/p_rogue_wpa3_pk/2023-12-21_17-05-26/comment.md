# Test Comment

## General information

- Date:       2023-12-21 17:05:26
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_rogue_wpa3_pk.sh
- Result:     Good

## Comment

Perfect. It refuses to connect. Better to try again with verbose mode.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


#but  Launch the REAL AP with SAE-PK
$ap_ui_path -c p_wpa3_pk -L $test_ui_log_tmp_dir


# Sleep 1 s
sleep 1


# Launch the ROGUE AP with SAE-PK and wrokg modifier/pP keys
$ap_ui_path -c p_rogue_wpa3_pk -l $test_ui_log_tmp_dir


```
