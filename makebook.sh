#!/bin/sh

tool=$1
case "$tool" in
    kindlegen)
        tool="kindlegen"
        ;;
    calibre)
        tool="calibre"
        ;;
    *)
        tool="kindlegen"
        ;;
esac
echo "pushing $tool result to kindle if connected"

zip=$(which zip)
if [ ! -x "$zip" ]; then
    echo "zip utility not found."
    exit 1
fi
echo "zip utility found as '$zip'"

kindlegen=$(which kindlegen)
if [ ! -x "$kindlegen" ]; then
    echo "Amazon 'kindlegen' utility not in path."
    kindlegen="$HOME/KindleGen/kindlegen"
fi
echo "Amazon 'kindlegen' utility found as '$kindlegen'"

ebookconvert=$(which ebook-convert)
if [ ! -x "$ebookconvert" ]; then
    echo "Calibre 'ebook-convert' utility not in path."
else
    echo "Calibre 'ebook-convert' utility found as '$ebookconvert'"
fi


cd epub_root
zip -qX0 ../../Martin_Manley-My_life_and_death.epub mimetype
zip -qXur9D ../../Martin_Manley-My_life_and_death.epub *

cd ../../
if [ ! -x "$kindlegen" ]; then
    echo "Amazon 'kindlegen' utility not found."
else
    $kindlegen Martin_Manley-My_life_and_death.epub
    mv Martin_Manley-My_life_and_death.mobi Martin_Manley-My_life_and_death-kindlegen.mobi
fi

#if [ ! -x "$ebookconvert" ]; then
#    echo "Calibre 'ebook-convert' utility not found."
#else
#    $ebookconvert Martin_Manley-My_life_and_death.epub .mobi
#    mv Martin_Manley-My_life_and_death.mobi Martin_Manley-My_life_and_death-calibre.mobi
#fi

if [ ! -e "Martin_Manley-My_life_and_death-$tool.mobi" ]; then
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
        sudo cp Martin_Manley-My_life_and_death-$tool.mobi /mnt/pt1/documents/Manley,\ Martin/Martin_Manley-My_life_and_death.mobi
        sudo eject /dev/disk/by-id/$device
    fi
fi
