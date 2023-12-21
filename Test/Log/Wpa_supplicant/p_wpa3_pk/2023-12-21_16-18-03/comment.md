# Test Comment

## General information

- Date:       2023-12-21 16:18:03
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_wpa3_pk.sh
- Result:     Good

## Comment

Perfect.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$ap_ui_path -c p_wpa3_pk -L $test_ui_log_tmp_dir

```