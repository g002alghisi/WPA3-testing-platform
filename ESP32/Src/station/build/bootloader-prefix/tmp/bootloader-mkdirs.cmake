# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/alghisi/.Espressif/esp-idf/components/bootloader/subproject"
  "/home/alghisi/GitHub/Hostapd-test/ESP32/Src/station/build/bootloader"
  "/home/alghisi/GitHub/Hostapd-test/ESP32/Src/station/build/bootloader-prefix"
  "/home/alghisi/GitHub/Hostapd-test/ESP32/Src/station/build/bootloader-prefix/tmp"
  "/home/alghisi/GitHub/Hostapd-test/ESP32/Src/station/build/bootloader-prefix/src/bootloader-stamp"
  "/home/alghisi/GitHub/Hostapd-test/ESP32/Src/station/build/bootloader-prefix/src"
  "/home/alghisi/GitHub/Hostapd-test/ESP32/Src/station/build/bootloader-prefix/src/bootloader-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/alghisi/GitHub/Hostapd-test/ESP32/Src/station/build/bootloader-prefix/src/bootloader-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/alghisi/GitHub/Hostapd-test/ESP32/Src/station/build/bootloader-prefix/src/bootloader-stamp${cfgdir}") # cfgdir has leading slash
endif()
