#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 cert_file.pem."
    exit 1
fi

cert_file_pem="$1"


# Save content of cert_file_pem inside tmp.txt
cat $cert_file_pem > tmp.txt

# Add " char at the beginning of each line
sed -i "s/^/\"/" tmp.txt

# Add \r\n"\ chars at the end of each line
sed -i 's/$/\\r\\n"\\/' tmp.txt

# Add \0"\ at the end of tmp.txt
echo '"\0"\' >> tmp.txt

# Add \0" at the end of tmp.txt
echo '"\0"' >> tmp.txt


# Print the result
cat tmp.txt

# Delete tmp.txt
rm tmp.txt
