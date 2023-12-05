# Cypress Board CYW954907AEVAL1F
The Cypress CYW954907AEVAL1F Evaluation Kit serves as a platform for assessing and developing single-chip Wi-Fi applications using the CYW54907 device.
This kit is centered around a module that harnesses the capabilities of the CYW54907, a single-chip 802.11ac dual-band Wi-Fi System-on-Chip (SoC) supporting both 2.4 GHz and 5 GHz frequencies.
For more information, visit [Infineon's product page](https://www.infineon.com/cms/en/product/evaluation-boards/cyw954907aeval1f/).

The board supports WPA3 R2 but not WPA3 R3. Consequently, SAE-PK and Transition Disable are currently unavailable (refer to [Infineon community forum](https://community.infineon.com/t5/AIROC-Wi-Fi-MCUs/CYW54907-with-SAE-PK-and-or-Transition-Disable/td-p/642416)).

## Working with the Cypress board
Program the board using the official SDK called WICED-Studio, available for Linux and Windows. It's highly recommended to work on a Windows PC to avoid potential issues with code building and downloading on Linux. You can also use it on a virtual machine (like VirtualBox), but consider installing an older version of Windows (e.g., 7) to avoid overloading the host system.

In addition to the SDK, a tool to read messages from the serial interface is required. Here are some recommendations:
- On Ubuntu, use `Minicom`.
- On Windows, use `Putty`.

A practical starting guide is available [here](https://www.infineon.com/dgdl/Infineon-CYW954907AEVAL1F_Evaluation_Kit_User_Guide-UserManual-v01_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0eff8331169e). It provides useful information, including:
- An introduction to the board and the development environment.
- Instructions on how to install the SDK and set everything up.
- A step-by-step tutorial to build, download, and run programs on the board.
- Example programs for initial testing.

## Documentation
In addition to the getting started guide, you can find support by searching online. However, the most accurate and comprehensive documentation is available directly inside the IDE. In the project tree, under `43xxx_Wi-Fi > doc`, several PDF files can be found, each focusing on a specific aspect of the platform. For convenience, some of them have been copied inside the [`Doc/`](Doc/) folder.

## Testing the board
The manual offers examples to start working with the board. However, the most useful and complete tool available, without delving too much into code complexity, is probably `test.console`. This program allows you to entirely control the board using a terminal-like interface.

Despite the example programs found under `43xxx_Wi-Fi > apps > snip`, the main code for `test.console` is located under `43xxx_Wi-Fi > apps > test`. Here's how to use this software:
1. Select `43xxx_Wi-Fi` in the WICED Target selector drop-down box.
2. Right-click `43xxx_Wi-Fi` in the Make Target window and click `New`.
3. Create the make target `test.console-CYW954907AEVAL1F download run`.
   - `snip` = directory inside the apps folder.
   - `scan` = sub-directory and name of the application to be built.
   - `CYW954907AEVAL1F` = board/platform name.
   - `download` = indicates download to the target.
   - `run` = resets the target and starts execution.
4. Double-click the `Clean` Make Target to remove any output from the previous build. Do this when new files are added or removed. Remember to connect the board to the PC via USB before executing the build target to avoid `download_dct` error.
5. Double-click the `test.console-CYW954907AEVAL1F download run` make target to build and download it to the CYW954907AEVAL1F board.

Once the program is loaded and running, start the terminal emulation program (such as `Putty`), select the right COM port, and set the baud rate to 115200. A black screen should appear. Press the `Reset` button on the board to run the program from the beginning, and the CLI will appear magically.

Type `help` and press enter to get a long list of interesting commands.

### Join a Wi-Fi Personal Network
The `join` command can be used to join a Wi-Fi network protected with WPA-Personal. The full syntax is:
```plain text
join <ssid> <open|wpa_aes|wpa_tkip|wpa2|wpa2_aes|wpa2_tkip|wpa2_fbt|wpa3|wpa3_wpa2> [key] [psk(for wpa3_wpa2 amode only)] [channel] [ip netmask gateway]
```
If `wpa3_wpa2` is specified, `key` and `psk` fields shall be written as the same word.

To disconnect simply use `leave`.

### Join a Wi-Fi Enterprise Network
The `join_ent` command is quite similar to the previous, but specific for WPA-Enterprise networks. The full syntax is:
```plain text
join_ent <ssid> <eap_tls|peap|eap_ttls> [username] [password] [eap] [mschapv2] [client-cert] <wpa2|wpa2_tkip|wpa|wpa_tkip|wpa2_fbt>
```
Note that `eap` and `mschapv2` can be used only if `eap_ttls` is selected.

Woriking with Enterprise networks is not as easy as Personal ones. Thus, the framework is explained in the document [WICED Enterprise Security User Guide](WICED-Enterprise_Security_User_Guide-Enterprise_Security_User_guide_002-22776_00_V.pdf), available under `43xxx_Wi-Fi > doc`.
Among other things, it details how to include certificates.
It is recommended to read it, but to make it short, this operation is carried out by editing the `certificate.h` file located under `43xxx_Wi-Fi > libraries > utilities > command_console > wifi`.

By inspecting the file, it is quickly noticeable how tedious can be to include the certificate inside it. To streamline the process, the `cert2cypress_cert.sh` script comes in hand. Please refer to the [README](Src/README.md) file inside the `Src/` folder for more details


## Other boards
- The PSoC™ 6 WiFi-BT Pioneer Kit (CY8CKIT-062-WiFi-BT) is a low-cost hardware platform that enables design and debug of the PSoC™ 62 MCU and the Murata LBEE5KL1DX Module (CYW4343W WiFi + Bluetooth Combo Chip).
    Visit:
    - [the home page](https://www.infineon.com/cms/en/product/evaluation-boards/cy8ckit-062-wifi-bt/);
    - [the CYW4343W page](https://www.infineon.com/cms/en/product/wireless-connectivity/airoc-wi-fi-plus-bluetooth-combos/wi-fi-4-802.11n/cyw4343w/); here they state that it supports WPA2;
    - [this pdf](https://www.infineon.com/dgdl/Infineon-CYW4343W_Single-chip_ultra-low_power_IEEE_802.11b_g_nMAC_baseband_radio_with_integrated_Bluetooth_4.2_for_IoT_applications-ProductBrief-v03_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0f6643ff542e) claims that it supports WPA3;
    - [the Pi Pico W page](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html) says that it uses the same Wi-Fi module, but using the `libwyc43` library; [here](https://github.com/georgerobotics/cyw43-driver/tree/195dfcc10bb6f379e3dea45147590db2203d3c7b/src) the source code is available; inspecting it, WPA3 support has not been found;
    - reading [here](https://iotexpert.com/category/devkits/cy8ckit-062-wifi-bt/) and [here]() it seems that WPA3 works, but not WPA3-R3; 
