# Test Comment

## General information

- Date:       2023-12-19 14:40:25
- Device:     iPad
- Script:     Test/Src/test_p_wpa2.sh
- Result:     Good/Bad

## Comment

Please add a description...

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$AP_UI_PATH -c p_wpa2 -L $test_ui_log_tmp_dir
```