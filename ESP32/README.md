# ESP32
ESP32 is a series of low-cost, low-power system on a chip microcontrollers with integrated Wi-Fi and dual-mode Bluetooth.

This folder collects the code that comes from testing the development board KS0413 keyestudio ESP32 Core Board, based on the Espressif ESP32-WROOM-32, with `hostapd`.
The main goal is to be able to make it join a WPA3 with SAE-PK network and analyze its behaviour.

### Installing procedure
In order to setup evrything required to work with the KS0413 keystudio ESP32 Core Board, one possibility is to follow the official starting guide ([https://wiki.keyestudio.com/KS0413_keyestudio_ESP32_Core_Board#Buy_From](https://wiki.keyestudio.com/KS0413_keyestudio_ESP32_Core_Board#Buy_FromA)).
However, an easier approach is the one of the official Espressif Arduino ESP32 installing tutorial ([https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html](https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html)).

> Note that the board may require to install its driver.
> However, for Linux systems the USB-UART bridge driver is already included in the kernel.
> You can check this by connecting the board to the PC and then inspecting the kernel message by doing
> ```bash
> sudo dmesg
> ```
> and look for `CP2102 USB to UART Bridge Controller` string.

### Troubleshooting
If you encounter an error like this
```
ModuleNotFoundError: No module named 'serial' exit status 1 Error compiling for board ESP32S3 Dev Module.
```
please try doing from terminal
```bash
pip3 install pyserial
```
