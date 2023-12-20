# Test Comment

## General information

- Date:       2023-12-20 18:56:17
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_wpa3.sh
- Result:     Good

## Comment

Ok, wpa_supplicant connects with WPA3.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$AP_UI_PATH -c p_wpa3 -L $test_ui_log_tmp_dir

```
