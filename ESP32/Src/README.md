# Source code for the ESP32 board
This folder stores all the code used to test the ESP32 dev board.

As explained in the [README](../README.md) from the `ESP32/` folder, there are 2 possible ways to program the ESP32 microcontroller:
- making use of the Arduino Core;
- by means of ESP32-IDF.
In general, working with the Arduino Core is quite straightforward; however, this approach is not granular. For example, it is not possible to work with SAE-PK.
On the other hand, leveraging the ESP32-IDF is not so easy, but allows to fully control the microcontroller. 

## Arduino Core code
Programs of this kind are programmed with the arduino IDE, where a lot of examples are available. Two of these have been slightly modified to make the first tests with the board:
- `wifi_scan`, to scan all the available WiFi networks;
- `join network`, to connect to an AP and test the Internet connection.

All these examples are also available from GitHub ([https://github.com/espressif/arduino-esp32/tree/master/libraries](https://github.com/espressif/arduino-esp32/tree/master/libraries))

## ESP32-IDF
Also in this case, a lot of use examples for each library come with the ESP32-IDF module when installed.
In particular, `station` goal is to enable the ESP32 to join a desired network. The code is not as simple to understand as the `join_network` Arduino counterpart, but in this case it is possible to easily select the security protocol, set the ssid and password, and enable SAE-PK by means of the project menuconfig. However, if SAE-PK is used with the original code,
it is enabled in automatic mode. The ESP32 is thus able to use SAE-PK, but if such a network is not available, it joins networks with bare SAE. This exposes the board to evil-twin attacks.
To avoid it, the code has been modified to force the SAE-PK only mode if SAE-PK is enabled from menuconfig.
