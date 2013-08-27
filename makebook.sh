#!/bin/sh

zip=$(which zip)
if [ ! -x "$zip" ]; then
    echo "zip utility not found."
    exit 1
fi

cd epub_root
zip -r ../Martin_Manley-My_life_and_death.epub .
