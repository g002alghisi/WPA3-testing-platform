#!/bin/bash

# set -x

### ### ### SAE-PK Key Generator ### ### ###
# The function of this script is to create SAE-PK keypair that can be used with
# the hostapd_wpa3.conf configuration file.
# This script is based on the Mathy Vanhoef's code, that can be found at
#   https://github.com/vanhoefm/hostap-wpa3.
# However, the sae_pk_gen.c script is written by Jouni Malinen.


# First generate a private key by means of openssl.
#
# OpenSSL is a cryptography toolkit implementing the Secure Sockets Layer
# (SSL v2/v3) and Transport Layer Security (TLS v1) network protocols and
# related cryptography standards required by them.
#
# The openssl program is a command line program for using the various
# cryptography functions of OpenSSL's crypto library from the shell.
# It can be used for:
# - Creation and management of private keys, public keys and parameters
# - Public key cryptographic operations
# - Creation of X.509 certificates, CSRs and CRLs
# - Calculation of Message Digests and Message Authentication Codes
# - Encryption and Decryption with Ciphers
# - SSL/TLS Client and Server Tests
# - Handling of S/MIME signed or encrypted mail
# - Timestamp requests, generation and verification

# First install some dependencies (Ubuntu):
# sudo apt-get update
# sudo apt-get install libnl-3-dev libnl-genl-3-dev libnl-route-3-dev libssl-dev \
# 	libdbus-1-dev git pkg-config build-essential macchanger net-tools python3-venv \
#	aircrack-ng rfkill


# in particular, the following command allows the EC parameter manipulation
# and generation (ecparam).
# The option -name prime256v1 is used to use  the ec parameters with specified
# 'short name'. In particular, "prime256v1" specifies a 256bit elliptic curve.
# Is then asked to generate a key (-keygen).
# Finally, the -outform parameter is used to specify the output format for cryptographic data. You can choose between PEM (human-readable) and DER (binary) formats based on your context and the intended use of the data.
openssl ecparam -name prime256v1 -genkey -out sae_pk_key.der -outform der

# Now derive the password from it:
cd Vanhoef
make sae_pk_gen
./sae_pk_gen sae_pk_key.der 3 SAEPK-Network

# Example output:
#
# sae_password=2udb-slxf-3ij2|pk=04e8aad54d1a121955e8703d1dfa115e:MHcCAQEEIKMP3SZEAlW9rSwTFsaR/sEyX963opsOo2QYe4G8Kcl+oAoGCCqGSM49AwEHoUQDQgAE4GuxyTkKNt0MEispu/XPxImInj+tl2ri/Jfu2mOQKb1TdNHSPs6UP+rxv5OWnezhOpjpD63Y+zjjz1yk7/iF7g==
#
# Longer passwords can be used for improved security at the cost of usability:
# 2udb-slxf-3ijn-y65k
# 2udb-slxf-3ijn-y65x-vr2e
# 2udb-slxf-3ijn-y65x-vr2i-6qob

