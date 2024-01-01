# Raspberry Pi 4 Setup Guide

1. [Introduction](#introduction)
2. [Getting started](#getting-started)
3. [Work with the Raspberry Pi 4](work-with-the-raspberry-pi-4)


## Introduction

Welcome to the Raspberry Pi 4 Setup Guide! This comprehensive guide is designed to assist you in setting up your Raspberry Pi 4, a versatile and affordable single-board computer that opens up a world of possibilities for DIY projects, programming, and more.

The Raspberry Pi is a series of small, affordable, and credit-card-sized single-board computers developed by the Raspberry Pi Foundation. These compact devices are equipped with powerful capabilities, making them ideal for various applications, including home automation, media centers, retro gaming consoles, and educational projects.

### Getting Started

Before diving into the setup process, it's essential to gather the necessary components. Ensure you have the following items:

- Raspberry Pi 4 Model B
- MicroSD card (minimum 8GB, recommended 16GB or more)
- Power supply (USB-C with a minimum of 3A)
- HDMI cable
- USB keyboard and mouse
- Display (HDMI-compatible)
- Internet connection (Ethernet or Wi-Fi)

### Helpful Resources

To make your setup process smoother, refer to the official Raspberry Pi resources:

- [Raspberry Pi Official Website](https://www.raspberrypi.org/): The official source for downloads, documentation, and community forums.
- [Raspberry Pi Documentation](https://www.raspberrypi.org/documentation/): In-depth guides and documentation for various Raspberry Pi projects.
- [Getting started guide](https://www.raspberrypi.com/documentation/computers/getting-started.html).

Now that you have everything ready, let's proceed with the step-by-step setup process.

## Work with the Raspberry Pi 4

To make it as easy as possible, the best option was to work directly from the Ubuntu PC being connected to the device.

1. Download the imager by doing
    ```bash
    sudo apt install rpi-imager
    ```
2. Open it and insert the SD Card inside the PC.
3. Select the recommended OS (Raspberry Pi OS 64bit), choose the SD card as target device.
4. Before clicking on "Write", open the advanced settings by pressing the cog button:
    - Set the username and password.
    - Do not ask for the password at startup.
    - Copy somewhere the network name (the default is `raspberripi.local`); this is very important because will allow to reach the device via ssh without knowing the IP address.
    - Allow the acces via ssh with just name and password (no ssh keys).
    - Save and quit the window.
5. Finally write the SD card and wait.
6. When the process is terminated, extract the SD card and install it on the Raspberry.
7. Plug the ethernet cable to the PC, connect the Raspberry pi to a monitor, a keyboard and a mouse, and finally turn it on.
8. Create anew network profile on both the Raspberry and the PC, with a static IP and selecting the checkbox "[ ] Use this connection only for resources on this network".
    An example could be to use

        - 192.168.0.1 - 255.255.255.0 on the Raspberry
        - 192.168.0.2 - 255.255.255.0 on the PC.

    No gateway address is required.

9. After a while, from the terminal it should be possible to connect via ssh to the mini PC.
    ```bash
    ssh selected_username@network_name
    
    # For example
    #alghisi-pi@raspberrypi.loclal
    ```

10. Execute
    ```
    sudo raspi-config
    ```
    and configure VNC. Enable it and check if ssh is active too.

11. Download RealVNC on the PC (it should be possible to use it without signing in).
    Then connect to the Raspberry Pi.

> Remember to check the Raspberry Pi language and keyboard layout.

## Enable WPA3 on Raspberry Pi 4 with iwd

These steps guide you through enabling WPA3 support on a Raspberry Pi 4 using `iwd` (Internet Wireless Daemon).

The following instructions come from [this discussion](https://github.com/raspberrypi/linux/issues/4718#issuecomment-1679315254) on GitHub.

### Steps

1. Update Firmware. Download the updated firmware for Cypress Wi-Fi chip:

    ```bash
    wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/cypress/cyfmac43455-sdio.bin
    ```

    Backup the original firmware:

    ```bash
    mv /lib/firmware/cypress/cyfmac43455-sdio-standard.bin /lib/firmware/cypress/cyfmac43455-sdio-standard.bin.orig
    ```

    Copy the new firmware:

    ```bash
    cp cyfmac43455-sdio.bin /lib/firmware/cypress/cyfmac43455-sdio-standard.bin
    ```

    Reboot your Raspberry Pi:

    ```bash
    reboot
    ```

2. Verify SAE Support. Check if SAE offload support is present:

    ```bash
    iw phy | grep -i sae
    ```

    Look for lines similar to:

    ```
    * [ SAE_OFFLOAD ]: SAE offload support
    * [ SAE_OFFLOAD_AP ]: AP mode SAE authentication offload support
    ```

3. Install `iwd`. Install iwd using your package manager:

    ```bash
    sudo apt-get update
    sudo apt-get install iwd
    ```

4. Enable and start `iwd` service. Enable and start the iwd systemd service:

    ```bash
    sudo systemctl enable iwd
    sudo systemctl start iwd
    ```

5. Connect to WPA3-Personal network. Use `iwctl` to connect to a WPA3-Personal SSID:

    ```bash
    iwctl
    ```

    Inside the `iwctl` interactive shell:

    ```bash
    device list
    station wlan0 scan
    station wlan0 get-networks
    station wlan0 connect <SSID>
    ```

    Follow the prompts to enter the passkey for the WPA3-Personal network.

6. Configure DHCP with systemd-networkd (Optional). Add entries in `/etc/systemd/network` for systemd-networkd to set DHCP for `wlan0`.

    For example, create a file named `/etc/systemd/network/25-wlan0.network` with the following content:

    ```plaintext
    [Match]
    Name=wlan0

    [Network]
    DHCP=yes
    ```

7. Reboot and Verify. Reboot your Raspberry Pi:

    ```bash
    reboot
    ```

    After reboot, verify that the Raspberry Pi connects to the WPA3-Personal network automatically.

### Getting started with iwd

- [This web page](https://wiki.archlinux.org/title/iwd) deeply explains how to use iwd.
- [This other one](https://wiki.debian.org/NetworkManager/iwd) is tailored for Debian (thus Ubuntu). Moreover, it shows how to enable `iwd` as a backend for NetworkManager; this solution is quite interesting because it allows to hide to the user the differences between `iwd` and `wpa_supplicant` if the NetworkManager GUI Applet is used (but also `nmcli`).
