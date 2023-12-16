# Source Code

1. [`sniff.sh`](#sniffsh)

## sniff.sh

The Bash script sniff.sh facilitates the controlled initiation of Wireshark in Monitor Mode, enabling the capturing and analysis of wireless network traffic. The script performs the following main functions:

1. **Setup Phase**:
    - Starts NetworkManager.
    - Checks and forces the specified Wi-Fi interface up.
    - Stops NetworkManager.
    - Sets the Wi-Fi interface in monitor mode on the specified channel.

2. **Execution (Main) Phase**:
    - Runs Wireshark, allowing the user to capture and analyze wireless network traffic interactively.

3. **Teardown Phase**:
    - Sets the Wi-Fi interface back to its default mode.
    - Starts NetworkManager.

### Prerequisites

- Wireshark installed on the system.
- NetworkManager installed.

### Usage

```bash
./sniff.sh -w wifi_if -c channel
```

where:

- `w wifi_if` specifies the Wi-Fi interface to be used (default: `wlx5ca6e63fe2da`).
- `c channel` specifies the Wi-Fi channel to be used for monitoring (default: `1`).

Here's a minimal example:

```bash
./sniff.sh -w wlan0 -c 6
```

### Important

- The script assumes that all file paths are relative to the main repository directory.
- Ensure that Wireshark is installed on the system.
- Default values are provided for the Wi-Fi interface (`wlx5ca6e63fe2da`) and channel (`1`).

### Notes

- Ensure that the script is executed with appropriate permissions (may require sudo).
- The script is designed for the TP-Link Archer T2U v3; modify the Wi-Fi interface variable (`wifi_if`) and configuration as needed for different wireless interfaces.
- Press `Ctrl-C` to stop Wireshark and complete the execution.
