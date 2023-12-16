# Cypress `Src/` Folder

1. [`cert2cypress_cert.sh`](#cert2cypress_certsh)

## `cert2cypress_cert.sh`

This script, `cert2cypress_cert.sh`, facilitates the conversion of certificate files for use in the Hostapd-test project. The project involves testing Hostapd with various configurations, and this script is specifically designed to convert certificates for compatibility with Cypress.

The script performs the following steps:

1. **Setup:**
   - Fetches the configuration directory associated with the provided configuration string.
   - Validates the existence of the configuration directory and creates a temporary directory (`Cypress/Tmp`) for storing temporary files.

2. **Conversion:**
   - Checks for the existence of `ca.pem`, `client.pem`, and `client.key` files in the configuration directory.
   - Converts each certificate file using a custom conversion function (`c2cc_convert`) to a format suitable for Cypress.
   - Outputs the converted certificates to the console.

### Prerequisites

Before using the script, ensure the following prerequisites are met:

- The script is located in the correct home directory (`Hostapd-test`).
- Necessary utility scripts are available in the `Utils/Src` directory.
- Configuration files are listed in `Freeradius/Conf/conf_list.txt`.

### Usage

To execute the script, use the following command:

```bash
./cert2cypress_cert.sh -c as_conf_string
```

where:

- `-c as_conf_string` specifies the path to the FreeRADIUS configuration directory.
Here's an use example:

```bash
./cert2cypress_cert.sh -c example_configuration
```

### Notes

- Ensure that the script is executed with the appropriate permissions.
- Review the console output for any error messages during the conversion process.

Feel free to reach out if you encounter any issues or have questions related to the certificate conversion process in the Hostapd-test project.
