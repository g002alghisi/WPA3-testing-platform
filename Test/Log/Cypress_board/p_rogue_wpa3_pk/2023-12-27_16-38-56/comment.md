# Test Comment

## General information

- Date:       2023-12-27 16:38:56
- Device:     Cypress_board
- Script:     Test/Src/test_p_rogue_wpa3_pk.sh
- Result:     Bad

## Comment

SAE-PK not supported. The supplicant joins the rogue WPA3 AP.

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
