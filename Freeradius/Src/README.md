# Source Code

1. [`as.sh`](#assh)
2. [`as_ui.sh`](#as_uish)


## `as.sh`
This Bash script, `as.sh`, acts as a wrapper around FreeRADIUS, facilitating the setup and execution of the Authentication Server (AS). The script is designed with the following main functions:

1. **Setup Phase**:
- Checks the existence of the AS configuration directory.
- Kills any previous instances of FreeRADIUS.

2. **Execution (Main) Phase**:
- Runs FreeRADIUS with the specified configuration directory.
- Supports verbose and debug modes.

3. **Teardown Phase**:
- Attempts to kill any remaining FreeRADIUS instances.

### Prerequisites
- FreeRADIUS executable installed on the system.

### Usage
```bash
./as.sh -c conf_dir [-v] [-d]
```
where:
- `c conf_dir`: Specifies the path to the FreeRADIUS configuration directory.
- `v`: Enables verbose mode.
- `d`: Enables debug mode (optional).

Here's a minimal example:
```bash
./as.sh -c Freeradius/Conf/example_config
```
### Important
- Ensure that the FreeRADIUS executable is in the system's PATH.
The script assumes that all file paths are relative to the main repository directory.
- Verbose mode (`-v`) can be used to print detailed information during FreeRADIUS execution.

### Notes
- Ensure that the script is executed with appropriate permissions (may require sudo).
- Debug mode (`-d`) provides additional debugging information for the script.


## `as_ui.sh`
This Bash script, `as_ui.sh`, serves as a user interface (UI) wrapper around the FreeRADIUS AS script (`as.sh`). It streamlines the setup, execution, and teardown phases for creating and managing the FreeRADIUS Authentication Server. The UI script is designed with the following primary functions:

1. **Setup Phase**:
- - Retrieves the AS configuration directory based on a configuration string.

2. **Execution (Main) Phase**:
- Launches the AS script (as.sh) with the specified parameters.

3. **Teardown Phase**:
- No explicit teardown phase is present in the UI script, as it relies on the teardown steps within the AS script.

### Prerequisites
- FreeRADIUS AS script (`as.sh`) available at the specified path.

### Usage
```bash
./as_ui.sh -c conf_string [-v]
```
where:
- `c conf_string`: Specifies the configuration string for AS setup.
- `v`: Enables verbose mode.

Here's a minimal example:
```bash
./as_ui.sh -c example_config -v
```

### Important
- Ensure that the AS script path (as.sh) is correctly specified.
- Verbose mode (-v) can be used to print detailed information during the execution of as.sh.

### Notes
- Ensure that the script is executed with appropriate permissions (may require sudo).
- The configuration string maps to a specific FreeRADIUS configuration directory and is specified in the conf_list.txt file in the `Freeradius/Conf/` directory.