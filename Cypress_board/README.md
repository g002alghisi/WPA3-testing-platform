# Cypress Board CYW954907AEVAL1F
The Cypress CYW954907AEVAL1F Evaluation Kit serves as a platform to assess and create single-chip Wi-Fi applications employing the CYW54907 device. This kit is centered around a module that harnesses the capabilities of the CYW54907, a single-chip 802.11ac dual-band Wi-Fi System-on-Chip (SoC) supporting both 2.4 GHz and 5 GHz frequencies.
More information can be found at [https://www.infineon.com/cms/en/product/evaluation-boards/cyw954907aeval1f/](https://www.infineon.com/cms/en/product/evaluation-boards/cyw954907aeval1f/). 

## Work with the Cypress board
This board can be prorgammed by means of the official SDK called WICED-Studio, and a practical guide is available at [https://www.infineon.com/dgdl/Infineon-CYW954907AEVAL1F_Evaluation_Kit_User_Guide-UserManual-v01_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0eff8331169e](https://www.infineon.com/dgdl/Infineon-CYW954907AEVAL1F_Evaluation_Kit_User_Guide-UserManual-v01_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0eff8331169e).

It is highly recommended to work on a Windows PC, because on Linux there can be problems with the IDE. It is okay also to use a virtual machine (like on VirtualBox).

In addition to the IDE, a tool to read messages from the serial interface is required. Some recommendations are
- on Ubuntu use `Minicom`;
- on Widows use `Putty`.

## Test the board
The manual offers some exaples to begin working with the board. However, the most useful tool available withouth diving too much in the code is probably `test.console`.
This program comes with the installation of WICED-Studio and can be found in the folder `W3xxx_Wi-Fi/apps/`
> Note that `test.console` is not in `snip.xxx`.

## Supported security protocols
The board supports WPA3, but support to SAE-PK has not been found.

