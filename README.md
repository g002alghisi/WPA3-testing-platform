# My Project Hostapd-test
## TP-Link Archer T2U

To use the Wi-Fi donge it is necessary to install the drivers.

In general, one can follow the official guide. However, in Linux few errors arose.
The Morrowr's driver comes in hand; please visit the GitHub repo at [https://github.com/morrownr/8821au-20210708](https://github.com/morrownr/8821au-20210708) for more information.

### Other useful links

- [https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility](https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility)
- [https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3](https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3)
- [https://github.com/morrownr/Monitor_Mode](https://github.com/morrownr/Monitor_Mode)

## Other devices

### TP-Link

- TP-Link devices that support WPA3 are showed [here](https://www.tp-link.com/ae/wpa3/product-list/).

### Cypress/Infineon

- PSoC6 with CYW43439 should support WPA3 R3 (got a reply from Infineon)

    - [Board page](https://www.infineon.com/cms/en/product/evaluation-boards/cy8cproto-062s2-43439/)
    - [CYW43439 page](https://www.infineon.com/cms/en/product/wireless-connectivity/airoc-wi-fi-plus-bluetooth-combos/wi-fi-4-802.11n/cyw43439/)
    - [This PDF](https://www.infineon.com/dgdl/Infineon-Wireless_Module_Partners_Selector_Guide-ProductSelectionGuide-v02_00-EN.pdf?fileId=8ac78c8c82ce56640183184a05d72e5a) just says that it support WPA3, but it does not specify if WPA3-R3.
    - [This PDF](https://www.infineon.com/dgdl/Infineon-CYW43439-DataSheet-v05_00-EN.pdf?fileId=8ac78c8c8929aa4d01893ee30e391f7a), again, says that it support WPA3, but do not specify WPA3 R3.

- The PSoC 6 WiFi-BT Pioneer Kit (CY8CKIT-062-WiFi-BT) is a low-cost hardware platform that enables design and debug of the PSoC™ 62 MCU and the Murata LBEE5KL1DX Module (CYW4343W WiFi + Bluetooth Combo Chip).
    Visit:

## Raspberry Pi 4
This folder contains information about the Wi-Fi related tests made with a Raspberry Pi 4 board, equipped with Linux raspberrypi 6.1.0-rpi4-rpi-v8 #1 SMP PREEMPT Debian 1:6.1.54-1+rpt2 (2023-10-05) aarch64 GNU/Linux.
    
- [the home page](https://www.infineon.com/cms/en/product/evaluation-boards/cy8ckit-062-wifi-bt/);
- [the CYW4343W page](https://www.infineon.com/cms/en/product/wireless-connectivity/airoc-wi-fi-plus-bluetooth-combos/wi-fi-4-802.11n/cyw4343w/); here they state that it supports WPA2;
- [this pdf](https://www.infineon.com/dgdl/Infineon-CYW4343W_Single-chip_ultra-low_power_IEEE_802.11b_g_nMAC_baseband_radio_with_integrated_Bluetooth_4.2_for_IoT_applications-ProductBrief-v03_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0f6643ff542e) claims that it supports WPA3;
- reading [here](https://iotexpert.com/category/devkits/cy8ckit-062-wifi-bt/) it seems that WPA3 works, but not WPA3-R3;

### Raspberry

- [The Pi Pico W page](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html) says that it uses the same Wi-Fi module, but using the `libwyc43` library; [here](https://github.com/georgerobotics/cyw43-driver/tree/195dfcc10bb6f379e3dea45147590db2203d3c7b/src) the source code is available; inspecting it, WPA3 support has not been found;
- [This article](https://rachelbythebay.com/w/2023/11/06/wpa3/) states that probably the Pi 5 board still doesn't support WPA3.
    
### Persistent USB Tethering Interface name

- Consider [this forum reply](https://unix.stackexchange.com/questions/750214/disable-udev-renaming-for-android-usb-tethering-using-randon-macs) and [this one](https://unix.stackexchange.com/questions/726258/consistent-persistent-network-connection-naming-like-udev) to understand how to make USB Tethering interface name persistent on Ubunut.
