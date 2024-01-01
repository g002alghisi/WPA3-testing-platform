# Test Comment

## General information

- Date:       2023-12-28 17:44:59
- Device:     Raspberry_Pi_4
- Script:     Test/Src/test_p_wpa3.sh
- Result:     Good

## Comment

With the new firmware and `iwd` solution it worked.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$ap_ui_path -c p_wpa3 -L $test_ui_log_tmp_dir

```
