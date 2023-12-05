# STA Source Code

## `sta.sh`
This Bash script facilitates the configuration and testing of a Wi-Fi station (STA) using Wpa-supplicant. It automates the setup, execution, and teardown phases, allowing users to quickly test and configure Wi-Fi connections. The script performs the following main tasks:

1. **Setup Phase:**
   - Starts NetworkManager.
   - Checks the Wi-Fi interface.
   - Forces the Wi-Fi interface up.
   - Stops NetworkManager.
   - Validates the presence of the STA (Station) configuration file.
   - Kills any previous instances of wpa_supplicant, wpa_cli, and wpa_gui.

2. **Run Phase:**
   - Executes Wpa-supplicant with the specified Wi-Fi interface and configuration file.
   - Allows the user to interrupt the execution with Ctrl-C.

3. **Teardown Phase:**
   - Kills any running instance of wpa_supplicant.
   - Restarts NetworkManager.

### Prerequisites
- NetworkManager installed.
- Wpa-supplicant built and available at the specified path.

### Usage
```bash
./sta.sh -w wifi_if -c conf [-v]
```
where:
- `w wifi_if`: Specifies the Wi-Fi interface to be used.
- `c conf`: Specifies the path to the STA configuration file.
- `v`: Enables verbose mode.

Here's a minimal example
```bash
./sta.sh -w wlan0 -c path/to/sta.conf -v
```

### Important
- The script assumes that all file paths are relative to the main repository directory `Hostapd-test`.
- The Wpa-supplicant executable is expected to be at `Wpa_supplicant/Build/wpa_supplicant`.
- This script is designed for testing purposes and may require adjustments based on specific use cases.


## `sta_ui.sh`
This Bash script serves as a wrapper around the `sta.sh` script, offering a user interface (UI) for configuring and testing Wi-Fi connections. The script simplifies the setup, execution, and teardown phases, enabling users to interact with Wpa-supplicant via a graphical user interface (GUI) or a command-line interface (CLI). Key features include:

- Fetching the Wpa-supplicant configuration file based on a configuration string.
- Launching Wpa-supplicant with the specified Wi-Fi interface and configuration file.
- Providing options for GUI and CLI modes.

The script is organized into three primary phases:

1. **Setup Phase**:
   - Initiates NetworkManager to manage network connections.
   - Verifies the existence and status of the specified Wi-Fi interface.
   - Temporarily halts NetworkManager.
   - Validates the presence of the designated STA (Station) configuration file.
   - Terminates any existing instances of wpa_supplicant, wpa_cli, and wpa_gui.

2. **Run Phase**:
   - Executes the Wpa-supplicant STA script with the provided Wi-Fi interface and configuration file.
   - Allows users to interrupt the execution using Ctrl-C.

3. **Teardown Phase**:
   - Terminates any running instances of wpa_supplicant.
   - Restarts NetworkManager to resume normal network management operations.

These phases collectively streamline the process of configuring and testing Wi-Fi connections, providing users with a seamless and efficient experience.


### Prerequisites
- Bash environment.
- Wpa-supplicant STA script available at the specified path.
- Wpa-supplicant configuration file list (`conf_list.txt`) for associating configuration strings with file paths.
- `wpa_gui` to be installed via `apt`.

### Usage
```bash
./sta_ui.sh [-w wifi_if] <-c conf | -l conf_cli | -g conf_gui> [-v]
```
where:
- `w wifi_if`: Specifies the Wi-Fi interface to be used (default: "wlx5ca6e63fe2da").
- `c conf`: Specifies the configuration string for general Wpa-supplicant usage.
- `l conf_cli`: Activates CLI mode and specifies the configuration string.
- `g conf_gui`: Activates GUI mode and specifies the configuration string.
- `v`: Enables verbose mode.

Here's a minimal example:
```bash
./wrapper.sh -w wlan0 -c "example_config" -v
./wrapper.sh -l "cli_config" -v
./wrapper.sh -g "gui_config" -v
```

### Important
- The script assumes that all file paths are relative to the main repository directory.
- The default Wi-Fi interface is set to "wlx5ca6e63fe2da."
- Ensure that the STA script (`sta.sh`) path is correctly specified.
 