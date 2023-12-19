# Test Comment

## General information

Date:       2023-12-19 12:27:53
Device:     Poco_F3
Script:     Test/Src/test_p_wpa2.sh
Result:     Good

## Description

It works.


## Script

```bash
Test/Src/test_p_wpa2.sh_content
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$AP_UI_PATH -c p_wpa2 -L $test_ui_log_dir
```
