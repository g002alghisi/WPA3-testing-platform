# Conf folder

Here's a copy of the original configuration folder `/etc/freeradius/3.0/`, made in order
to work without modifying the original ones. The process used to prepare them is the following:
```shell
# 1. Copy anything from /etc/freeradius/3.0/
sudo cp -r /etc/freeradius/3.0/ .

# 2. Change owner and group
sudo chown -R freeradius:freeradius *
```

Please notice that, as specified in the original FreeRADIUS guide, these files should be
modified as few as possible.


## Folders

+ `certs` is crucial for implementing secure communications. It holds certificates and keys necessary for enabling TLS/SSL. These files are used to authenticate and encrypt communication between the RADIUS server and its clients.

+ `dictionary` contains the `dictionary` file, which serves as a dictionary of RADIUS attributes. RADIUS attributes define the information exchanged between the RADIUS client and server. You can extend this dictionary with custom attributes to tailor RADIUS to your specific needs.

+ `mods-available` contains Modules. These in FreeRADIUS provide additional functionalities such as authentication and authorization methods. The `mods-available` folder houses configuration files for these modules. To activate a module, you create a symbolic link to its configuration file in the `mods-enabled` folder.

+ `mods-enabled` contains symbolic links to the configuration files of enabled modules. Only the modules present in this folder are loaded and utilized by FreeRADIUS.

+ `policy.d` folder holds configuration files that define policies for user authentication and authorization. These policies can be based on various criteria, including user groups, time of day, and other attributes.

+ `sites-available` includes configuration files for different "sites" or services supported by FreeRADIUS. You enable a site by creating a symbolic link to its configuration file in the `sites-enabled` folder.

+ `sites-enabled`, where you find symbolic links to the configuration files of enabled sites. Only sites in this folder are actively used by FreeRADIUS.


## Files

+ `radiusd.conf`, the main configuration file for FreeRADIUS. It contains global settings that affect the behavior of the RADIUS server. Detailed comments within the file provide insights into each configuration option.

+ `clients.conf` file specifies which RADIUS clients are authorized to communicate with the RADIUS server. It includes information such as the IP addresses of Wi-Fi access points and shared keys for secure communication.

+ `users` file contains information about local users, including their usernames and passwords. FreeRADIUS uses this information for user authentication.

Feel free to explore the detailed comments within configuration files and refer to the official FreeRADIUS documentation for a comprehensive understanding of each configuration option.

