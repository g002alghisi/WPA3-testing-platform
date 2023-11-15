#!/bin/bash

# 1 Launch WPA2 AP
./ap.sh fake-wpa3-pk

sleep 1

# 2 Launch WPA2/3 AP (with trans dis)
./ap.sh -d wpa3-pk

sleep 1

# 3 Launch Wpa2 AP
./ap.sh -d fake-wpa3-pk
