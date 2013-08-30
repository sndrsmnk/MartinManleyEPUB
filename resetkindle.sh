#!/bin/sh
device=$(grep -il "amazon kindle" /sys/bus/usb/devices/*/product | sed -e 's#/product.*##')
echo 0 | sudo tee ${device}/authorized
sleep 1
echo 1 | sudo tee ${device}/authorized
