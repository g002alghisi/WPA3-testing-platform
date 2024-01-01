# Test Comment

## General information

- Date:       2023-12-27 16:32:04
- Device:     Cypress_board
- Script:     Test/Src/test_p_wpa3.sh
- Result:     Good

## Comment

Perfect. The board connects with WPA3 (if selected).

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$ap_ui_path -c p_wpa3 -L $test_ui_log_tmp_dir

```
