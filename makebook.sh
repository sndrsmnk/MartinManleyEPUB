#!/bin/sh

zip=$(which zip)
if [ ! -x "$zip" ]; then
    echo "zip utility not found."
    exit 1
fi
echo "zip utility found as '$zip'"

kindlegen=$(which kindlegen)
if [ ! -x "$kindlegen" ]; then
    echo "Amazon 'kindlegen' utility not in path."
    exit
fi

cd epub_root
zip -qX0 ../../Martin_Manley-My_life_and_death.epub mimetype
zip -qXur9D ../../Martin_Manley-My_life_and_death.epub *

cd ../../
if [ ! -x "$kindlegen" ]; then
    echo "Amazon 'kindlegen' utility not found."
else
    $kindlegen Martin_Manley-My_life_and_death.epub
fi

if [ ! -e "Martin_Manley-My_life_and_death.mobi" ]; then
    echo "No .mobi version found?"
    exit 1
fi

# FIXME now we just assume kindle is not in use / mounted :O
device=$(grep -il "amazon kindle" /sys/bus/usb/devices/*/product | sed -e 's#/product.*##')
if [ ! -z "$device" ]; then
    echo 0 | sudo tee ${device}/authorized
    sleep 1
    echo 1 | sudo tee ${device}/authorized
    sleep 10
    device=$(readlink /dev/disk/by-id/usb-Kindle_Internal_Storage*-part1)
    if [ -b "/dev/disk/by-id/$device" ]; then
        sudo mkdir -p /mnt/pt1
        sudo mount /dev/disk/by-id/$device /mnt/pt1
        sudo mkdir -p /mnt/pt1/documents/Manley,\ Martin/
        sudo cp Martin_Manley-My_life_and_death.mobi /mnt/pt1/documents/Manley,\ Martin/Martin_Manley-My_life_and_death.mobi
        sudo eject /dev/disk/by-id/$device
    fi
fi
