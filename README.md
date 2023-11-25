# My ProjectHostapd-test

## To do list
- [ ] Try to use WPA-Enterprise
- [ ] Look for new dev boards with WPA3
- [ ] Write the `FreeRADIUS/` README file
- [ ] Write the `Freeradius/Conf` README file
- [ ] Write the `FreeRADIUS/Src` README file
- [ ] Update the `Hostapd/` README files (based on the new features of `ap.sh` and `ap_ui.sh`)
- [ ] Update the `Wpa_supplicant/` README files (based on the new features of `ap.sh` and `ap_ui.sh`)


## Tests

### ESP32
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (OK)
- [x] Test with WPA2/3 and transition disable (OK)
- [x] Test with SAE-PK and transition disable (!!)

### Cypress board
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (--)
- [x] Test with WPA2/3 and transition disable (--)
- [x] Test with SAE-PK and transition disable (--)

### Raspberry Pi 4
- [x] Test with WPA3 (!!)
- [x] Test with WPA2/3 and transition disable
- [x] Test with SAE-PK (--)
- [x] Test with SAE-PK and transition disable (--)
- [x] Test with MFP set as required (--)
- [x] Test with `iwd` (--)

### Wpa-supplicant
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (OK)
- [x] Test with WPA2/3 and transition disable (OK)
- [x] Test with SAE-PK and transition disable (OK)

### POCO F3
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (!!)
- [x] Test with WPA2/3 and transition disable (!!)
- [x] Test with SAE-PK and transition disable (--)

### iPad
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (!!)
- [x] Test with WPA2/3 and transition disable (~~)
- [x] Test with SAE-PK and transition disable (--)

### Ubuntu (out-of-the-box)
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (!!)
- [x] Test with WPA2/3 and transition disable (~~)
- [x] Test with SAE-PK and transition disable (--)


## TP-Link Archer T2U

To use the Wi-Fi donge, it is required to install the drivers.

In general, one can follow the official guide. However, in Linux few problems have been encountered.
To overcome them and use the USB Wireless Interface, try the Morrowr's driver,available on GitHub at [https://github.com/morrownr/8821au-20210708](https://github.com/morrownr/8821au-20210708)

### Other useful links
- [https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility](https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility)
- [https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3](https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3)
- [https://github.com/morrownr/Monitor_Mode](https://github.com/morrownr/Monitor_Mode)


## Cypress Board CYW954907AEVAL1F
The Cypress CYW954907AEVAL1F Evaluation Kit serves as a platform to assess and create single-chip Wi-Fi applications employing the CYW54907 device. This kit is centered around a module that harnesses the capabilities of the CYW54907, a single-chip 802.11ac dual-band Wi-Fi System-on-Chip (SoC) supporting both 2.4 GHz and 5 GHz frequencies.
More information can be found at [https://www.infineon.com/cms/en/product/evaluation-boards/cyw954907aeval1f/](https://www.infineon.com/cms/en/product/evaluation-boards/cyw954907aeval1f/).

### Work with the Cypress board
This board can be prorgammed by means of the official SDK called WICED-Studio, and a practical guide is available at [https://www.infineon.com/dgdl/Infineon-CYW954907AEVAL1F_Evaluation_Kit_User_Guide-UserManual-v01_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0eff8331169e](https://www.infineon.com/dgdl/Infineon-CYW954907AEVAL1F_Evaluation_Kit_User_Guide-UserManual-v01_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0eff8331169e).

It is highly recommended to work on a Windows PC, because on Linux there can be problems with the IDE. It is okay also to use a virtual machine (like on VirtualBox).

In addition to the IDE, a tool to read messages from the serial interface is required. Some recommendations are
- on Ubuntu use `Minicom`;
- on Widows use `Putty`.

### Test the board
The manual offers some exaples to begin working with the board. However, the most useful tool available withouth diving too much into the code complexity is probably `test.console`.
This program comes with the installation of WICED-Studio and can be found in the folder `W3xxx_Wi-Fi/apps/`
> Note that `test.console` is not in `snip.xxx`.

### Supported security protocols
The board supports WPA3, but support to SAE-PK has not been found.


## Raspberry Pi 4
This folder contains information about the Wi-Fi related tests made with a Raspberry Pi 4 board, equipped with Linux raspberrypi 6.1.0-rpi4-rpi-v8 #1 SMP PREEMPT Debian 1:6.1.54-1+rpt2 (2023-10-05) aarch64 GNU/Linux.

### Wi-Fi test results
Unfortunately, the Raspberry Pi 4 (and olders) doesn't support WPA3 out-of-the-box.
This is due to problems of the Broadcom wireless module driver, and can be fixed in two ways:
- Patch the firmware/kernel with Cypress patches, but this solution can be very tedious for non-technical users.
- Make the system use `iwd` instead of wpa_supplicant, but the same, it can be complicated and it is not so scalable... (tried, but it doesn't work...)
