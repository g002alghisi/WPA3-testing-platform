# Test Comment

## General information

- Date:       2023-12-21 16:16:19
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_wpa2.sh
- Result:     Good

## Comment

Perfect.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$ap_ui_path -c p_wpa2 -L $test_ui_log_tmp_dir
```
