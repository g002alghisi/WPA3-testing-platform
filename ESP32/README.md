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
2. at the countrary of what stated in the official starting guide, the USB-UART bridge driver is already included in the Linux kernel.
You can check this by connecting the board to the PC and then inspecting the kernel message by doing
```bash
sudo dmesg
```
and looking for `CP2102 USB to UART Bridge Controller` string.

### Installing procedure
In order to setup evrything required to work with the KS0413 keystudio ESP32 Core Board, on a Windows system it is enough to follow the official starting guide (see [Usefull links](Usefull links) section).
However, if is retuired to work on Mac or Linux, the following procedure is more suited (it can be found on the Espressif GitHub repository page).

### Useful links
- "Official" staring guide [https://wiki.keyestudio.com/KS0413_keyestudio_ESP32_Core_Board#Buy_From](https://wiki.keyestudio.com/KS0413_keyestudio_ESP32_Core_Board#Buy_From)
- "Unofficial" installing guide (use this one if required on a Linux system) [https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html](https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html)
- Espressiff GitHub repository [https://github.com/espressif/arduino-esp32](https://github.com/espressif/arduino-esp32).

### Troubleshooting
If you encounter an error like this
```
ModuleNotFoundError: No module named 'serial' exit status 1 Error compiling for board ESP32S3 Dev Module.
```
please try doing from terminal
```bash
pip3 install pyserial
```
