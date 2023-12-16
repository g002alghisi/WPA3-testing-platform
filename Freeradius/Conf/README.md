# Configuration Folder

1. [Introduction](#introduction)
2. [Organization of the configuration directories](#organization-of-the-configuration-directories)
3. [Switching between different configurations](#switching-between-different-configurations)
4. [Content of each configuration directory](#content-of-each-configuration-directory)
5. [Creating new certificates](#creating-new-certificates)

## Introduction

In this folder, all the `.conf` files for `freeradius` are stored. These files have been created based on the template that can be found at `/etc/freeradius/3.0/` (Ubuntu).

Please notice that, as specified in the original FreeRADIUS guide, these files should be modified as minimally as possible.

## Organization of the configuration directories

Several sub-folders store the configuration directories with the goal to be more organised:

- `E_wpa2/` contains configuration files used to set up the Authentication Server (AS) for a WPA-Enterprise Wi-Fi network.
- `E_fake_wpa2/` contains a copy of `E_wpa2` used to set up the fake AS for a WPA-Enterprise Wi-Fi evil twin network of `E-wpa2`.
- `Skeleton/` contains the copy of the original files that come with the installation of `freeradius`.

## Switching between different configurations

As explained in [this section](../../Utils/README.md#getting-file-from-conf_listtxt), to make it as seamless as possible to switch between different `freeradius` configurations, `as_ui.sh` leverages the file `conf_list.txt`. This file is located here using the `get_from_list()` function from the `general_utils.sh` module. For more information, please read the `Utils/` [README](../../Utils/README.md) file.

## Content of each configuration directory

Here the main content of each configuration directory is presented and described. Please refer to [this pdf file](https://networkradius.com/doc/FreeRADIUS%20Technical%20Guide.pdf) for more information.

- `certs`: This directory is crucial for implementing secure communications. It holds certificates and keys necessary for enabling TLS/SSL. These files are used to authenticate and encrypt communication between the RADIUS server and its clients.

- `dictionary`: This directory contains the `dictionary` file, which serves as a dictionary of RADIUS attributes. RADIUS attributes define the information exchanged between the RADIUS client and server. You can extend this dictionary with custom attributes to tailor RADIUS to your specific needs.

- `mods-available`: This directory contains modules. Modules in FreeRADIUS provide additional functionalities such as authentication and authorization methods. The `mods-available` folder houses configuration files for these modules. To activate a module, you create a symbolic link to its configuration file in the `mods-enabled` folder.

- `mods-enabled`: This directory contains symbolic links to the configuration files of enabled modules. Only the modules present in this folder are loaded and utilized by FreeRADIUS.

- `policy.d`: This folder holds configuration files that define policies for user authentication and authorization. These policies can be based on various criteria, including user groups, time of day, and other attributes.

- `sites-available`: This directory includes configuration files for different "sites" or services supported by FreeRADIUS. You enable a site by creating a symbolic link to its configuration file in the `sites-enabled` folder.

- `sites-enabled`: This directory contains symbolic links to the configuration files of enabled sites. Only sites in this folder are actively used by FreeRADIUS.

- `radiusd.conf`: This is the main configuration file for FreeRADIUS. It contains global settings that affect the behavior of the RADIUS server. Detailed comments within the file provide insights into each configuration option.

- `clients.conf`: This file specifies which RADIUS clients are authorized to communicate with the RADIUS server. It includes information such as the IP addresses of Wi-Fi access points and shared keys for secure communication.

- `users`: This file contains information about local users, including their usernames and passwords. FreeRADIUS uses this information for user authentication.

## Creating new certificates

As outlined earlier, the certs folder houses the certificates utilized to facilitate TLS/SSL sessions. While it's possible to obtain certificates from external sources and place them here, FreeRADIUS provides tools for generating new certificates specifically designed for testing purposes. Refer to the [README](Skeleton/certs/README.md) files located in the certs directories for detailed instructions on utilizing these tools and crafting personalized certificates.

During the certificate generation phase the `xpextensions` file is processed. This contains several comments showing that FreeRADIUS programmers found relevant to implement, by default, TOD-Policies just in case the certificates were used for WPA3-Enterprise networks.
Please examine the [`xpextensions`](../Skeleton/certs/xpextensions) file for further insights.
