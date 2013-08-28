#!/bin/sh

zip=$(which zip)
if [ ! -x "$zip" ]; then
    echo "zip utility not found."
    exit 1
fi
echo "zip utility found as '$zip'"

kindlegen=$(which kindlegen)
if [ ! -x "$kindlegen" ]; then
    echo "kindlegen utility not in path."
    kindlegen="$HOME/KindleGen/kindlegen"
fi
echo "kindlegen utility found as '$kindlegen'"


cd epub_root
zip -qr ../../Martin_Manley-My_life_and_death.epub .

cd ../../
if [ ! -x "$kindlegen" ]; then
    echo "kindlegen utility not found."
else
    $kindlegen Martin_Manley-My_life_and_death.epub
fi
