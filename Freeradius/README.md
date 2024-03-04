# Setting up WPA-Enterprise Authentication with Freeradius

1. [Introduction](#introduction)
2. [Basic idea](#basic-idea)
3. [Workflow](#workflow)

## Introduction

Freeradius is an open-source Authentication, Authorization, and Accounting (AAA) server widely used for managing access to networks and services.
It can be employed to authenticate users on Wi-Fi networks, VPNs, remote access networks, and other network services.
Freeradius implements standard authentication protocols such as Extensible Authentication Protocol (EAP) and supports
a variety of authentication methods, including username/password, digital certificates, and other mechanisms.

## Basic idea

This guide walks you through the process of configuring an Authentication Server (AS) with RADIUS for a WPA-Enterprise Wi-Fi network using Freeradius on Ubuntu. Unlike having the AS on-board the Access Point (AP), this approach involves the AP acting as a relay for EAP frames between the Station (STA) and an external AS reachable via the Distribution System.

In the realm of WPA-Enterprise security, establishing an effective Wi-Fi network involves integrating an Authentication Server (AS) with RADIUS. Freeradius serves this purpose, and its complexity necessitates a careful setup.

To facilitate the configuration process, two bash scripts are provided:

- `as.sh`: A wrapper around Freeradius, used to create the AS.
- `as_ui.sh`: An intuitive front-end offering users an easier way to configure the AS.

The `as_ui.sh` script streamlines the setup by allowing users to seamlessly switch between different configurations. It achieves this by retrieving the desired configuration folder based on special strings passed as parameters. A mapping of these strings to specific configuration folders is maintained in a `conf_list.txt` file within `Freeradius/Conf/`.

## Workflow

Follow these detailed steps to set up an AP with WPA-Enterprise using Freeradius:

1. Navigate to `Hostapd/Conf/` folder, then create a `.conf` setting file and place it in the directory or a subdirectory. Templates and examples are provided for reference.

2. Open `conf_list.txt` and create a new mapping string pointing to your `.conf` file.

3. Execute `ap_ui.sh` by passing the mapping string and, if needed, the names of the interfaces to be used (if different from defaults).

4. Navigate to `Freeradius/Conf/` and set up the configuration directory. Templates and examples are available to guide you.

5. Go to `Freeradius/Src/` and execute `as_ui.sh` by passing the desired mapping string.
