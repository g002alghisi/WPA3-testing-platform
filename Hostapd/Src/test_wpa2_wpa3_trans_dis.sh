#!/bin/bash

# 1 Launch WPA2 AP
./ap.sh wpa2

sleep 3

# 2 Launch WPA2/3 AP (with trans dis)
./ap.sh wpa2-wpa3

sleep 3

# 3 Launch Wpa2 AP
./ap.sh wpa2