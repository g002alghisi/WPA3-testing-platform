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
In addition to the getting started guide, you can find support by searching online. However, the most accurate and comprehensive documentation is available directly inside the IDE. In the project tree, under `43xxx_Wi-Fi > doc`, several `.pdf` files can be found, each focusing on a specific aspect of the platform. For convenience, some of them have been copied inside the [`Doc/`](Doc/) folder.

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
4. Double-click the `Clean` Make Target to remove any output from the previous build. Do this when new files are added or removed.
    > Note: Connect CYW954907AEVAL1F EVK to the same PC via USB before executing the build target to avoid a `download_dct` error.
5. Double-click the `test.console-CYW954907AEVAL1F download run` make target to build and download it to the CYW954907AEVAL1F board.

Once the program is loaded and running, start the terminal emulation program (such as `Putty`), select the right COM port, and set the baud rate to 115200. A black screen should appear. Press the `Reset` button on the board to run the program from the beginning, and the CLI will appear magically.

To start, type `help` and press enter. It will display and explain a long list of interesting commands you can try, including:
- `join`: used to join a Wi-Fi network protected with WPA-Personal.
    Full syntax:
    ```shell
    join <ssid> <open|wpa_aes|wpa_tkip|wpa2|wpa2_aes|wpa2_tkip|wpa2_fbt|wpa3|wpa3_wpa2> [key] [psk(for wpa3_wpa2 amode only)] [channel] [ip netmask gateway]
    ```
    If you are working with `wpa3_wpa2`, `key` and `psk` shall be written as the same word.

    To disconnect, use `leave`.

- `join_ent`: similar to the previous, but specified for WPA-Enterprise networks.
    Complete syntax:
    ```shell
    join_ent <ssid> <eap_tls|peap|eap_ttls> [username] [password] [eap] [mschapv2] [client-cert] <wpa2|wpa2_tkip|wpa|wpa_tkip|wpa2_fbt>
    ```
    Note that `eap` and `mschapv2` can be used only if `eap_ttls` is selected. For more details, refer to the `WICED_Enterprise_Security_User_Guide` pdf document available under `43xxx_Wi-Fi > doc`.

    To disconnect, use `leave_ent`.
