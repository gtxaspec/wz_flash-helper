#!/bin/sh
#
# Description: Initialize GPIO Wi-Fi pin
#

gpio set 59

gpiotool B 08 8ma func1
gpiotool B 09 4ma func1
gpiotool B 10 4ma func1
gpiotool B 11 4ma func1
gpiotool B 13 4ma func1
gpiotool B 14 4ma func1
