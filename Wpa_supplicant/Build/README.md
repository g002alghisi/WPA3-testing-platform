# Build folder
This folder contains built code. In particular:
- `wpa_supplicant` comes from the building process of the code from the official Ubuntu repository.
    To obtain it the following process has been used:
    1. Download the code from the Ubuntu repository by doing
    ```bash
    apt source wpasupplicant
    ```
    2. Go to the `wpa_supplicant/` folder.
    3. Create the `.config` file by means of the command
    ```bash
    cp defconf .config
    ```
    4. Check if the `.config` file contains the two following strings:
    ```bash
    CONFIG_SAE=y
    CONFIG_SAE_PK=y
    ```
    If these are not preset, please add them.
    5. Finally, execute
    ```bash
    make
    ```
    > It has been noted that if the `hostapd` version is equal or greater than the 2.11,
    > then the `.config` file should already contains the two strings to allow the use of SAEand SAE_PK
    > (this is valid for the code that can be found at [http://w1.fi/hostap.git](http://w1.fi/hostap.git)
    > and [https://github.com/vanhoefm/hostap-wpa3.git](https://github.com/vanhoefm/hostap-wpa3.git)).