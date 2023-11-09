# Build folder
This folder contains built code. In particular:
- `hostapd` comes from the building process of the code from the official Ubuntu repository.
    To obtain it the following process has been used:
    1. Download the code from the Ubuntu repository by doing
    ```bash
    apt source hostapd
    ```
    2. Go to the `hostapd/` folder.
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
- `sae_pk_gen` comes from the building process of the code from the (unofficial) `hostapd-wpa3` repository,
    owned by Mathy Vanhoef. Indeed, even though the code from the Ubuntu (version 2.10) and W1.fi repositories
    both contain the file `sae_pk_gen.c`, the relative MakeFile contains errors. These have been overcome by
    Vanhoef and Jouni Malinen and the fixes included in the `hostapd-wpa3` repository.<br>
    To compile the program, the process is similar to the one followed for `hostapd`:
    1. Download the code from the Vanhoef's repository by doing
    ```bash
    git clone https://github.com/vanhoefm/hostap-wpa3.git
    ```
    2. Go to the hostpd folder.
    3. Create the `.config` file by means of the command
    ```bash
    cp defconf .config
    ```
    4. Check if the `.config` file contains the two following strings:
    ```bash
    CONFIG_SAE=y
    CONFIG_SAE_PK=y
    ```
    If these are not preset, please add them (they should be already present).
    5. Execute
    ```bash
    make
    ```
    6. Finally, execute
    ```bash
    make sae_pk_gen.c
    ```
    > Thi process is explained at the Vanhoef's repository page.


### Generate a SAE-PK
These instructions are available at [https://github.com/vanhoefm/hostap-wpa3](https://github.com/vanhoefm/hostap-wpa3).

First generate a private key:
```bash
openssl ecparam -name prime256v1 -genkey -noout -out example_key.der -outform der
```
Now derive the password from it:
```bash
./sae_pk_gen example_key.der <3|5> <ssid_name>
```
The program will print a special string that starts like this:
```
sae_password=abcd-defg-hijk|pk=...
```
This can be directly copied in the hostapd.conf file and will automatically enable WPA3 with SAE-PK (if the `.conf` file is properly written).