#!/bin/bash
USER=Paul
ID="73B4C405-6CF9-4475-A31D-689872FC143A"

SRC="/Users/$USER/Library/Application Support/iPhone Simulator/5.0/Applications/$ID/Documents/"

DST="/Users/$USER/Dropbox/Projects/Rocketman/Rocketman/Resources/Level Data/"

TYPE=*.plist

cp -i "$SRC"$TYPE "$DST"

