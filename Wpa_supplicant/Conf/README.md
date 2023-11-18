# Configuration folder
In this folder, all the `wpa_supplicant.conf` files are stored.

In order to better handle them, several sub-folders have been created:
- `Skeleton/` contains frame configuration files that can be used to create personal solutions.
- `Ko/` contains personal solutions.
- `Basic/` contains configurations copied from Mathy Vanhoef (these are minimal working configurations, but are not well commented).

The configuration files stored in `Basic/` and `Ko/` can be used to join networks created with `ap.sh` when `.conf` files from `Hostapd/Basic/ and `Hostapd/Ko/ folders are used.

## Special use case in CLI mode
`wpa_supplicant` can be configured to work in CLI mode, thus allowing interaction with the user. This mode can exploited thanks to a special `.conf` file included in the `Ko/` folder.

## Strange behaviour with WPA3
It has been noticed that when trying to connect to a WPA3 network, the `auth_alg` causes problems. It is enough to comment it and everyithing works fine.
