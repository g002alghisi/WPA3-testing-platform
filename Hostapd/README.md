# Access Point with `hostapd`
Setup an Acces Point with bridge on Ubuntu by using `hostapd` and `brutils`.

## Basic idea
The basic idea is to use `hostapd` to transform the PC into an acces point (AP).
The PC shall be equipped with:
- an ethernet card, connected to a wired network with a DHCP server;
- a wireless card, that supports AP mode.

> To verify that the wireless card supports AP mode, inspect the result of
> ```bash
> iw list
> ```
> and look for `"Supported interface modes"` section. It should be there specified if the AP mode is supported or not.

Both the interfaces are needed: `hostapd` is used to create an AP with the wireless card, and by means of `brctl` (from `bridge-utils` package) the traffic is forwarded to the wired LAN passing through the ethernet card. In this way, it is not necessary to configure the DHCP server on the PC.<br>
In case the PC lacks the ethernet interface card, it should be possible to install a DHCP server on the computer directly, but this option has not been analyzed.

In general, using `hostapd` is not straight-forward. Indeed, it is important to check the state of the physical interfaces, stop all the servicies that can interfere with the process (like `NetworkManager`) and prepare the bridge;
moreover, the process needs to be reversed once finished, as to ripristinate the original state of the system.
To carry out all these operations, two bash scripts have been created:
- `ap.sh` is a wrapper around `hostapd`, and it is used to create the Access Point with bridge;
- `ap_ui.sh` acts as a front-end and offers to the user an easier way to setup the AP.

## Work flow
In general, APs created with `hostapd` can be configured by editing special `.conf` files, for which some example come with the software download.
Once edited, the user is free to leverage this configuration file by passing it to `ap.sh`, specifying the desired Ethernet and Wi-Fi cards to be used.<br>
However, to efficiently work with different settings and seamlessly switch between them, `ap_ui.sh` comes in hand, allowing to directly select the desired `.conf` file by means of a string parameter. Each special string maps (by means of its path) a specific `.conf` file, that should be placed in the `Conf/` directory (or subdirectories). The mapping is encoded in a special file called `conf_list.txt` and located inside `Conf/`.<br>
In addition, it can be annoying to specify at each execution the name of the interfaces. For this reason, `ap_ui.sh` internally defines default interfaces to be used.

In short, this is the work flow to setup the Access Point:
1. Prepare the `.conf` setting file and place it in the `Conf/` directory (or subdirectory); some templates and examples are already there.
2. Edit the `conf_list.txt` file to create a new mapping string that points to your `.conf` file.
3. Run `ap_ui.sh` by passing it your mapping string (and the name of the interfaces to be used, if different from the ones specified inside the code).

More details can be found in the `Conf/` [README](Conf/README.md) and the `Src/` [README](Src/README.md) files.

## Few words about the Hostapd version...
The specific version of `hostapd` is the 2.10, and it has been directly built from the source code that can be downloaded from the Ubuntu repository.
This is required because the same version obtained by doing `sudo apt install hostapd` doesn't properly support WPA3 with SAE-PK (instead, bare WPA3). 
Additional information can be found in the `Build/` [README](Build/README.md) file. 

## WPA3 Personal with SAE-PK
To use WPA3 SAE-PK, a special PSK is required and has to be included in the specific `.conf` file. To generate it, the script `sae_pk_key_gen.sh`, located in the [`Src/`](Src/) folder, can be used.

## WPA Enterprise
To set up a Wi-Fi network proteced by WPA-Enterprise, another component is required: an Authentication Server with RADIUS. In general there are two possible scenarios:
- the AS is implemented on-board the AP;
- the AP do not implement a full AS, but one can be reached by means of the Distribution System; in this case, the AP acts as a relay for the EAP frames between the STA and the AS entities.

`hostapd` supports both these modes: by properly editing the `.conf` file it can act as an AS, or it can be instructed to contact the desired AS and delegate to it the AAA matter.
In this work, the secon alternative has been preferred, just to have a taste of another widely adopted software: `freeradius`. Please refer to the [`Freeradius`](../Freeradius/) directory for more information and all the related material.

`freeradius` is a complex software, and its usage can be not so straightforward.
In some way, it resembles the `hostapd` approach. Indeed, a specific configuration folder needs to be passed to the program in order to set it up. However, the structure of the configuration directories and the organization of the relative internal files is more complicated by far.

To make the creation process of the AS as streamline as possible, two bash scripts are available:
- `as.sh`, is a wrapper around `freeradius`, and it is used to create the AS;
- `as_ui.sh` acts as a front-end and offers to the user an easier way to setup the AS.

Again, the User Interface program make it seamless the process of switching between different configuration by retriving the desired configuration folder based on special strings passed as parameter. This is thanks to a `conf_list.txt` file located in `Freeradius/Conf/` that maps configuration folders to different strings.

To summarize, the entire process to set up an AP with WPA-Enterprise is as follows:
1. Prepare the `.conf` setting file and place it in the `Conf/` directory (or subdirectory); some templates and examples are already there.
2. Edit the `conf_list.txt` file to create a new mapping string that points to your `.conf` file.
3. Run `ap_ui.sh` by passing it the mapping string (and the name of the interfaces to be used, if different from the ones specified inside the code).
4. Go to the `Freeradius/Conf/` folder, and prepare the configuration directory; some templates and examples are already there.
5. Go to the `Freeradius/Src/` folder and run `as_ui.sh` by passing to it the desider mapping string.

Be carefull to configure both `hostapd` and `freeradius` with the right IP address and port. The configuration files proposed work on localhost and default RADIUS port (1812).

