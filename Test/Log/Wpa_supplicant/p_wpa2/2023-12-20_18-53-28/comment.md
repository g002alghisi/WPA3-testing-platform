# Test Comment

## General information

- Date:       2023-12-20 18:53:28
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_wpa2.sh
- Result:     Good

## Comment

Ok, wpa_supplicant works properly and connects to the WPA2 network.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$AP_UI_PATH -c p_wpa2 -L $test_ui_log_tmp_dir
```
