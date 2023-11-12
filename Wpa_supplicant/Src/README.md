# Source folder
This folder contains source code written to work with `wpa_supplicant`. Note that this folder does not contain `wpa_supplicant` source code.

## Supplicant Station with `sta.sh`
This script allows you to seamlessly setup a supplicant Station to join a WiFi network.

In general, `wpa_supplicant` requires `.conf` files to be, as the extension suggests, configured. These can be found in the `Conf/` folder.

### Usage
The script handles few inputs:
- the `-d` optional parameter to enable the verbose mode.
- the `-w wifi_if` optional parameter to specify the wireless interface, if different from the default one specified inside the code.
- a string to select the desired `.conf` file; indeed, to achieve more flexibility, at the beginning of the program is possible to specifie different configuration files. in the main section, the input of the user are handled, and by means of a switch-case structure, the proper `.conf` file is selected in accordance.

An example of use is the following:
```bash
./sta.sh -w wlan0 wpa3-pk
```

### CLI mode
`wpa_supplicant` can be used also in an interactive way by means of another program, `wpa_cli`, that acts as a frontend.
The script `sta.sh` allows the user to trigger this mode by means of a special parameter string, as depicted from the following example:
```bash
./sta.sh -w wlan0 cli
```
Once the program is launched, execute
```
> help
```
to have more information.
