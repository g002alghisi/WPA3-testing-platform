# ESP32
ESP32 is a series of low-cost, low-power system on a chip microcontrollers with integrated Wi-Fi and dual-mode Bluetooth.

This folder collects some (not all) the code that comes from testing the development board KS0413 keyestudio ESP32 Core Board, based on the Espressif ESP32-WROOM-32, with `hostapd`.
The main goal is to be able to make it join a WPA3 with SAE-PK network and analyze its behaviour.

## Work with the ESP32 board
The ESP32 offers two primary avenues for development: the ESP32 Arduino Core and the ESP32 IDF (Espressif IoT Development Framework).

### ESP32 Arduino Core
Let's start with the ESP32 Arduino Core. It's like the "Arduino way" of working with the ESP32. Think of it as a familiar environment for Arduino enthusiasts.
You get to use the Arduino IDE, write code in a simplified version of C++, and tap into a vast array of libraries that make handling tasks like
connecting to sensors or displays a breeze. This setup is great for those who already love working with Arduino and want an easier transition to ESP32 development.<br>
At the page [https://docs.espressif.com/projects/arduino-esp32/en/latest/index.html](https://docs.espressif.com/projects/arduino-esp32/en/latest/index.html),
all the relevant information about the project ESP32 Arduino Core project can be found.

### ESP32 IDF
Now, on the other side, we've got the ESP32 IDF, which is like diving into the nitty-gritty of ESP32 capabilities. It's for the developers who want full control,
like the ones who love to tinker with every aspect of their project. You'll be working more closely with C and C++, have access to the ESP32's real-time operating system,
and get direct control over the hardware features. It's perfect for those complex applications where you need to optimize performance and manage resources with utmost precision.<br>
Visit [https://docs.espressif.com/projects/esp-idf/en/latest/esp32/index.html](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/index.html) for more information.


## Install procedure
The procedure depends on the choosen work flow:
- In the use case of the ESP32 Arduino Core platform, follow the 'Getting Started' procedure at the page
  [https://docs.espressif.com/projects/arduino-esp32/en/latest/getting_started.html](https://docs.espressif.com/projects/arduino-esp32/en/latest/getting_started.html).
    > On Ubuntu (and other Linux systems) is very easy to install applications by means of `apt`.
    > There is a package for the Arduino IDE on current `apt` repositories, but it has not been updated for a while. As such, while it is still possible to install the IDE by running
    > ```bash
    > sudo apt install arduino
    > ```
    > it is not recommended to do so, as asking for support when using outdated software is more difficult and there could be problems installing the ESP32 module.

    > When you purchease an ESP32 board, usually you get the instruction manual, which shows the instruction procedure specific for that board. However, it is usually better
    > to follow the above web page because it avoids to install software manually by relying on the Arduino IDE extension manager.

- To work with the ESP32 IDF, please follow the 'Get Started' procedure at
  [https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html).
    > It is required to work with VSCode or Eclipse. I would recommend to use VSCode, which is the one I used and tested.
    > In this case, please visit [https://github.com/espressif/vscode-esp-idf-extension](https://github.com/espressif/vscode-esp-idf-extension) for a detailed explanation about
    > the installing procedure and use tutorial.

In both cases (Arduino Core and IDF), the board may require to install its driver.
However, for Linux systems the USB-UART bridge driver is already included in the kernel.
You can check this by connecting the board to the PC and then inspecting kernel messages with
```bash
sudo dmesg
```
and look for `CP2102 USB to UART Bridge Controller` string.
