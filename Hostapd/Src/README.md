# Hostapd Access Point (AP)

## `ap.sh`
This Bash script orchestrates the setup, execution, and teardown phases for creating and managing a Wi-Fi Access Point (AP) using Hostapd. The script streamlines the process, allowing users to configure and test a Wi-Fi AP effortlessly. The script's main functions are categorized into the following phases:

1. **Setup Phase:**
   - Starts NetworkManager.
   - Checks and forces the Ethernet and Wi-Fi interfaces.
   - Creates a bridge for AP functionality.

2. **Execution (Main) Phase:**
   - Launches Hostapd with the specified configuration file.

3. **Teardown Phase:**
   - Deletes the bridge.
   - Restarts NetworkManager upon completion.

### Prerequisites
- Hostapd executable available at the specified path.
- NetworkManager installed.

### Usage
```bash
./ap.sh -w wifi_if -e eth_if -b br_if -c conf [-v]
```
where:
- `w wifi_if`: Specifies the Wi-Fi interface to be used.
- `e eth_if`: Specifies the Ethernet interface to be used.
- `b br_if`: Specifies the bridge interface to be created.
- `c conf`: Specifies the path to the AP configuration file.
- `v`: Enables verbose mode.

Here's a minimal example:
```bash
./ap.sh -w wlan0 -e eth0 -b br0 -c ap_config.conf
```

### Important
- The script assumes that all file paths are relative to the main repository directory.
- Ensure that the Hostapd executable path (`hostapd`) is correctly specified.
- The script requires the existence of a bridge interface (`br_if`) and corresponding Ethernet (`eth_if`) and Wi-Fi (`wifi_if`) interfaces.

### Notes
- Ensure that the script is executed with appropriate permissions (may require sudo).
- Verbose mode (`-v`) can be used to print detailed information during Hostapd execution.


## `ap_ui.sh`
This Bash script, `ap_ui.sh`, acts as a user interface (UI) wrapper around the Hostapd AP script (`ap.sh`), streamlining the setup, execution, and teardown phases for creating and managing a Wi-Fi Access Point (AP). The UI script is designed with the following primary functions:

1. **Setup Phase:**
   - Fetches the AP configuration file based on a configuration string.
   - Modifies the interface and bridge names inside the configuration file.

2. **Execution (Main) Phase:**
   - Launches the AP script (`ap.sh`) with the specified parameters.

3. **Teardown Phase:**
   - No explicit teardown phase is present in the UI script, as it relies on the teardown steps within the AP script.

### Prerequisites
- Hostapd AP script (`ap.sh`) available at the specified path.
- NetworkManager installed.

### Usage
```bash
./ap_ui.sh -w wifi_if -e eth_if -b br_if -c ap_conf_string [-v]
```
where:
- `w wifi_if`: Specifies the Wi-Fi interface to be used (default: wlp3s0).
- `e eth_if`: Specifies the Ethernet interface to be used (default: enp4s0f1).
- `b br_if`: Specifies the bridge interface to be created (default: br0).
- `c ap_conf_string`: Specifies the configuration string for AP    setup.
- `v`: Enables verbose mode.

Here's a minimal example:
```bash
./ap_ui.sh -w wlan0 -e eth0 -b br1 -c "example_config" -v
```

### Important
- The script assumes that all file paths are relative to the main repository directory.
- Ensure that the AP script path (`ap.sh`) is correctly specified.
- Default values are provided for Wi-Fi interface (`wlp3s0`), Ethernet interface (`enp4s0f1`), and bridge interface (`br0`).

### Notes
- Ensure that the script is executed with appropriate permissions (may require sudo).
- Verbose mode (`-v`) can be used to print detailed information during the execution of `ap.sh`.


## `sae_pk_key_gen.sh`
This Bash script, `sae_pk_gen.sh`, generates a private key and utilizes the `sae_pk_gen` tool to derive a password and SAE-PK key for a specified SSID. The key generation process is orchestrated with the following main functions:

1. **Setup Phase:**
   - Creates a temporary directory (`tmp_dir`) to store generated data.
   - Generates a private key (`ssid.der`) inside the temporary directory.

2. **Execution (Main) Phase:**
   - Runs the `sae_pk_gen` tool to derive the password and SAE-PK key from the generated private key.
   - Prints the derived SAE-PK key and password information.

### Prerequisites
- `sae_pk_gen` binary available at the specified path.
- OpenSSL installed.

## Usage
```bash
./sae_pk_gen.sh <Sec:3|5> <ssid_name>
```
- `<Sec:3|5>`: Specifies the security level (3 or 5) for the SAE-PK key derivation.
- `<ssid_name>`: Specifies the SSID name for which the SAE-PK key is generated.

Here's a minimal example:
```bash
./sae_pk_gen.sh 3 example_ssid
```
### Important
- The script assumes that all file paths are relative to the main repository directory.
- Ensure that the `sae_pk_gen` tool path (`Hostapd/Build/sae_pk_gen`) is correctly specified.
