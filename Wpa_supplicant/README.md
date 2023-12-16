# Wpa Supplicant Station

1. [Introduction](#introduction)
2. [Basic idea](#basic-idea)
3. [Workflow](#workflow)
4. [Few words about the Wpa-supplicant version](#few-words-about-the-wpa-supplicant-version)

## Introduction

Wpa Supplicant is an open-source software implementation for Wi-Fi clients, providing support for various security protocols and authentication methods. It is instrumental in configuring Wi-Fi connections on Linux systems, allowing devices to connect securely to Wi-Fi networks.

WPA Supplicant is widely used in diverse networking scenarios, ensuring secure Wi-Fi connections, compatibility with WPA3 security standards, and support for enterprise-level authentication. It is a versatile tool that enhances the security of wireless communication by implementing robust authentication mechanisms.

To get started with WPA Supplicant, consider exploring the following documentation:

- [WPA Supplicant Linux Page](https://w1.fi/wpa_supplicant/) offers comprehensive information about WPA Supplicant, its features, and configuration options.
- [WPA Supplicant Configuration Guide](https://w1.fi/cgit/hostap/plain/wpa_supplicant/wpa_supplicant.conf) details the configuration parameters for WPA Supplicant.

For a deeper understanding and technical insights, explore:

- [IEEE 802.11 standards](https://www.ieee802.org/11/) cover the technical specifications for wireless LAN (Local Area Network) communication.
- [The official Hostapd and WPA Supplicant homepage](https://w1.fi/) provides valuable resources, updates, and community discussions related to WPA Supplicant and Hostapd.

## Basic idea

The basic idea is to use `wpa_supplicant` to turn the PC into a Supplicant Station.
The PC shall be equipped with a wireless card.

Similarly to `hostapd`, using `hostapd` is not straight-forward. Indeed, it is important to check the state of the physical interface and to stop all the services that can interfere with the process (like `NetworkManager`).
moreover, the process needs to be reversed once finished, as to reset the original state of the system.
To carry out all these operations, two bash scripts have been created:

- `sta.sh` is a wrapper around `wpa_supplicant`, and it is used to create the Supplicant;
- `sta_ui.sh` acts as a front-end and offers to the user an easier way to setup the STA.

## Workflow

In general, STAs created with `wpa_supplicant` can be configured by editing special `.conf` files, for which some example come with the software download.
Once edited, the user is free to leverage this configuration file by passing it to `sta.sh`, specifying the desired Wi-Fi card to be used.
However, to efficiently work with different settings and seamlessly switch between them, `sta_ui.sh` comes in hand, allowing to directly select the desired `.conf` file by means of a string parameter. Each special string maps (by means of its path) a specific `.conf` file, that should be placed in the `Conf/` directory (or subdirectories). The mapping is encoded in a special file called `conf_list.txt` and located inside `Conf/`.
In addition, it can be annoying to specify at each execution the name of the interfaces. For this reason, `sta_ui.sh` internally defines default interfaces to be used.

In short, this is the work flow to setup the Station:

1. Prepare the `.conf` setting file and place it in the `Conf/` directory (or subdirectory); some templates and examples are already there.
2. Edit the `conf_list.txt` file to create a new mapping string that points to your `.conf` file.
3. Run `sta_ui.sh` by passing it your mapping string (and the name of the interfaces to be used, if different from the ones specified inside the code).

Supplicant Stations setup with `sta.sh` are mainly used to join wireless networks created with the counterpart `ap.sh`, from the `Hostapd/` folder. For these reason, the `.conf` files stored in the `Conf/` folder are themselves the counterparts of the `hostapd` configuration files from the `Hostapd/Conf/` folder. However, to achieve greater flexibility, `ap_ui.sh` allows to interact with `wpa_supplicant` by means of:

- `wpa_cli`, a program that comes with the installation of `wpa_supplicant`, which enables control in CLI mode;
- `wpa_gui`, an additional tool that needs to be manually installed via `apt`, that offers to the user a graphical and intuitive way to interact with `wpa_supplicant` by means of a popup window.

## Few words about the Wpa-Supplicant version

The specific version of `wpa_supplicant` is the 2.10, and it has been directly built from the source code that can be found on the Ubuntu repository. This is required because the same version of the program obtained by doing `sudo apt install wpasupplicant` doesn't properly support WPA3 with SAE-PK (instead, bare WPA3). Additional information can be found in the [README](Build/README.md) file in the `Build/` folder.
