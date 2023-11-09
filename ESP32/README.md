# ESP32
ESP32 is a series of low-cost, low-power system on a chip microcontrollers with integrated Wi-Fi and dual-mode Bluetooth.

This folder collects the code that comes from testing the development board KS0413 keyestudio ESP32 Core Board, based on the Espressif ESP32-WROOM-32, with `hostapd`.
The main goal is to be able to make it join a WPA3 with SAE-PK network and analyze its behaviour.

### IDE
As suggested in the starting guide, Arduino IDE will be used.<br>
On Ubuntu, to install everything needed it is enaugh to:
1. Execute from the terminal
```bash
sudo apt install arduino
```
2. ath te countrary of what stated in the official starting guide, the USB-UART bridge driver is already included in the Linux kernel.
You can check this by connecting the board to the PC and then inspecting the kernel message by doing
```bash
sudo dmesg
```
and looking for `CP2102 USB to UART Bridge Controller` string.


### Usefull links
- Staring guide [https://wiki.keyestudio.com/KS0413_keyestudio_ESP32_Core_Board#Buy_From](https://wiki.keyestudio.com/KS0413_keyestudio_ESP32_Core_Board#Buy_From]

