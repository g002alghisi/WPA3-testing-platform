# Access Point with Hostapd

1. [Introduction](#introduction)
2. [Basic idea](#basic-idea)
3. [Workflow](#workflow)
4. [Few words about the Hostapd version](#few-words-about-the-hostapd-version)
5. [WPA3-Personal with SAE-PK](#wpa3-personal-with-sae-pk)
6. [Enterprise configurations](#enterprise-configurations)

## Introduction

Hostapd, an abbreviation for Host Access Point Daemon, is an open-source software implementation for Wi-Fi access points. It allows to turn a compatible wireless network interface card into a full-featured access point, supporting a range of security protocols and authentication methods.

Hostapd is commonly used in various networking scenarios, including creating secure Wi-Fi networks, implementing WPA3 security standards, and facilitating enterprise-level authentication. It supports both WPA (Wi-Fi Protected Access) and WPA2, providing robust security features for wireless communication.

## Basic idea

The basic idea is to use Hostapd to transform the PC into an access point (AP).
The PC shall be equipped with:

- an Ethernet card, connected to a wired network with a DHCP server;
- a wireless card, that supports AP mode.

Both the interfaces are needed: Hostapd is used to create an AP with the wireless card, and by means of `brctl` (from `bridge-utils` package) the traffic is forwarded to the wired LAN passing through the ethernet card. In this way, it is not necessary to configure the DHCP server on the PC.

In general, using Hostapd is not straight-forward. Indeed, it is important to check the state of the physical interfaces, stop all the services that can interfere with the process (like NetworkManager) and prepare the bridge;
moreover, the process needs to be reversed once finished, as to get the original state of the system.
To carry out all these operations, two bash scripts have been created:

- `ap.sh` is a wrapper around Hostapd, and it is used to create the Access Point with bridge;
- `ap_ui.sh` acts as a front-end and offers to the user an easier way to setup the AP.

### Overcome Ethernet interface lack

In case the PC lacks the Ethernet interface card, it should be possible to install a DHCP server on the computer directly, but this option has not been analyzed.

Otherwise, another option is to use a phone with internet connectivity and harness the USB-Tethering, a feature that allows a mobile device to share its cellular data connection with another one by means of a USB cable.

However, the default behavior of Ubuntu is to change the interface name assigned to the device (in simple terms, the string retrieved by `ifconfig`) upon each connection. This matter is related to Udev, a device manager that dynamically creates and handles device nodes in the `/dev` directory, facilitating automatic detection and configuration. To overcome this issue, please procede as follows:

1. Connect the device via USB to the computer, and enable the USB-Tethering function.

2. Get the temporary `temp_eth_if` name by means of `ifconfig`

3. Get the environment `ID_NET_NAME` string from the output of

    ```
    sudo udevadm info /sys/class/net/temp_eth_if
    ```
    The resulting string has a structure described [at this page](https://github.com/systemd/systemd/blob/ccddd104fc95e0e769142af6e1fe1edec5be70a6/src/udev/udev-builtin-net_id.c#L29)

3. Edit `/etc/udev/rules.d/76-network.rules` file

    ```
    sudo vim /etc/udev/rules.d/76-network.rules
    ```

    and add the following string

    ```
    SUBSYSTEM=="net", ENV{ID_NET_NAME}="your_id_net_name", ACTION=="add", NAME="your_id_net_name"

    # Example
    # SUBSYSTEM=="net", ACTION=="add", ENV{ID_NET_NAME_PATH}=="enp0s20f0u1", NAME="enp0s20f0u1"
    ```

4. Reload the `udev` rules

   ```
   sudo udevadm control --reload-rules && sudo udevadm trigger
   ```

5. Unplug and replug the USB cable, enable the USB-Tethering mode and finally check if the interface name is now correct.

This solution is derived from [this forum](https://unix.stackexchange.com/questions/388300/udev-does-not-rename-usb-ethernet-device)

Remember that the name `ID_NET_NAME` depends on the USB assigned to the phone. For this reason, if suddenly the static name of the interface, es `enp0s20f0u1`, changes to the random one, es `enxd626b3450fb5`, maybe it is because another USB device is used (maybe the ESP32 or the Cypress board)enxd626b3450fb5.
Please unplug both of them, reconnect the phone and check via `ifconfig` that everything is okay again. Then connect the other device.

## Workflow

In general, APs created with Hostapd can be configured by editing special `.conf` files, for which some example come with the software download.
Once edited, the user is free to leverage this configuration file by passing it to `ap.sh`, specifying the desired Ethernet and Wi-Fi cards to be used.

However, to efficiently work with different settings and seamlessly switch between them, `ap_ui.sh` comes in hand, allowing to directly select the desired `.conf` file by means of a string parameter. Each special string maps (by means of its path) a specific `.conf` file, that should be placed in the `Conf/` directory (or subdirectories). The mapping is encoded in a special file called `conf_list.txt` and located inside `Conf/`.

In addition, it can be annoying to specify at each execution the name of the interfaces. For this reason, `ap_ui.sh` internally defines default interfaces to be used.

In short, this is the work flow to setup the Access Point:

1. Prepare the `.conf` setting file and place it in the `Conf/` directory (or subdirectory); some templates and examples are already there.
2. Edit the `conf_list.txt` file to create a new mapping string that points to your `.conf` file.
3. Run `ap_ui.sh` by passing it your mapping string (and the name of the interfaces to be used, if different from the ones specified inside the code).

More details can be found in the README files inside [`Conf/`](Conf/) and the [`Src/`](Src/).

## Few words about the Hostapd version

The specific version of Hostapd is the 2.10, and it has been directly built from the source code that can be downloaded from the Ubuntu repository.
This is required because the same version obtained by doing `sudo apt install hostapd` doesn't properly support WPA3 with SAE-PK (instead, bare WPA3).
Additional information can be found reading the [README](Build/README.md) file from the [`Build/`](Build/) folder.

## WPA3 Personal with SAE-PK

To use WPA3 SAE-PK, a special PSK is required and has to be included in the specific `.conf` file. To generate it, the script `sae_pk_key_gen.sh`, located in the [`Src/`](Src/) folder, carries out the task.

## Enterprise configurations

To set up a Wi-Fi network protected by WPA-Enterprise, another component is required: an Authentication Server with RADIUS. In general there are two possible scenarios:

- the AS is implemented on-board the AP;
- the AP do not implement a full AS, but one can be reached by means of the Distribution System; in this case, the AP acts as a relay for the EAP frames between the STA and the AS entities.

Hostapd supports both these modes: by properly editing the `.conf` file it can act as an AS, or it can be instructed to contact the desired AS and delegate to it the AAA matter.
In this work, the second alternative has been preferred, just to have a taste of another widely adopted software: FreeRADIUS. Please consider the [`Freeradius/`](../Freeradius/) directory for detailed information and the related material.

FreeRADIUS is a complex software, and its usage can be not so straightforward.
In some way, it resembles the Hostapd approach. Indeed, a specific configuration folder needs to be passed to the program in order to set it up. However, the structure of the configuration directories and the organization of the relative internal files is more complicated by far.

To make the creation process of the AS as streamline as possible, two bash scripts are available:

- `as.sh`, is a wrapper around Freeradius, and it is used to create the AS;
- `as_ui.sh` acts as a front-end and offers to the user an easier way to setup the AS.

Again, the User Interface program make it seamless the process of switching between different configuration by retrieving the desired configuration folder based on special strings passed as parameter. This is thanks to a `conf_list.txt` file located in `Freeradius/Conf/` that maps configuration folders to different strings.

To summarize, the entire process to set up an AP with WPA-Enterprise is as follows:

1. Prepare the `.conf` setting file and place it in the `Conf/` directory (or subdirectory); some templates and examples are already there.
2. Edit the `conf_list.txt` file to create a new mapping string that points to your `.conf` file.
3. Run `ap_ui.sh` by passing it the mapping string (and the name of the interfaces to be used, if different from the ones specified inside the code).
4. Go to the `Freeradius/Conf/` folder, and prepare the configuration directory; some templates and examples are already there.
5. Go to the `Freeradius/Src/` folder and run `as_ui.sh` by passing to it the desired mapping string.

Be careful to configure both Hostapd and FreeRADIUS with the right IP address and port. The configuration files proposed work on localhost and default RADIUS port (1812).
