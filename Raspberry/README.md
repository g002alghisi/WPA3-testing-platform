# Raspberry Pi 4
This folder contains information about the Wi-Fi related tests made with a Raspberry Pi 4 board, equipped with Linux raspberrypi 6.1.0-rpi4-rpi-v8 #1 SMP PREEMPT Debian 1:6.1.54-1+rpt2 (2023-10-05) aarch64 GNU/Linux.

## Wi-Fi test results
Unfortunately, the Raspberry Pi 4 (and olders) doesn't support WPA3 out-of-the-box.
This is due to problems of the Broadcom wireless module driver, and can be fixed in two ways:
- Patch the firmware/kernel with Cypress patches, but this solution can be very tedious for non-technical users.
- Make the system use `iwd` instead of wpa_supplicant, but the same, it can be complicated and it is not so scalable... (tried, but it doesn't work...)
