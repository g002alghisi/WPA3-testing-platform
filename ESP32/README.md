# ESP32
ESP32 is a series of low-cost, low-power system on a chip microcontrollers with integrated Wi-Fi and dual-mode Bluetooth.

This folder collects the code that comes from testing the development board KS0413 keyestudio ESP32 Core Board, based on the Espressif ESP32-WROOM-32, with `hostapd`.
The main goal is to be able to make it join a WPA3 with SAE-PK network and analyze its behaviour.

## Installing procedure
In order to setup evrything required to work with the KS0413 keystudio ESP32 Core Board, one possibility is to follow the official starting guide ([https://wiki.keyestudio.com/KS0413_keyestudio_ESP32_Core_Board#Buy_From](https://wiki.keyestudio.com/KS0413_keyestudio_ESP32_Core_Board#Buy_FromA)).
However, an easier approach is the one of the official Espressif Arduino ESP32 installing tutorial ([https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html](https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html)).

> Note that the board may require to install its driver.
> However, for Linux systems the USB-UART bridge driver is already included in the kernel.
> You can check this by connecting the board to the PC and then inspecting the kernel message by doing
> ```bash
> sudo dmesg
> ```
> and look for `CP2102 USB to UART Bridge Controller` string.

> On Ubuntu (and other Linux systems) is very easy to install applications by means of `apt.
> There is a package for the Arduino IDE on current `apt` repositories, but it has not been updated for a while. As such, while it is still possible to install the IDE by running `sudo apt install arduino`, it is not recommended to do so, as asking for support when using outdated software is more difficult and there could be problems installing the ESP32 module.

## ESP32 Arduino Core’s documentation
At the page [https://docs.espressif.com/projects/arduino-esp32/en/latest/index.html](https://docs.espressif.com/projects/arduino-esp32/en/latest/index.html), all the relevant information about the project ESP32 Arduino Core project can be found.

Arduino Core for ESP32 is a platform. It is a set of libraries, tools, and software support that allows you to program the ESP32 microcontroller using the Arduino IDE.
This platform is designed to simplify the development process for the ESP32 for developers familiar with the Arduino development environment by providing a range of tools
and libraries specific to the ESP32. So, the platform extends the Arduino development environment to support the ESP32.


## Troubleshooting
If you encounter an error like this
```
ModuleNotFoundError: No module named 'serial' exit status 1 Error compiling for board ESP32S3 Dev Module.
```
please try doing from terminal
```bash
pip3 install pyserial
```
