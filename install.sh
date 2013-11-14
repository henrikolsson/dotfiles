#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REL="$(lsb_release -sc)"
cd "$DIR"
find . -type f -not -path "./.git/*" -not -path "./install.sh" -not -path "./override/*" | while read file
do
    d=$(dirname "$file")
    if [ ! -d "$HOME/$d" ]
    then
        mkdir -pv "$HOME/$d"
    fi
    if [ -e "$DIR/override/$file.$REL" ]
    then
        target="/override/$file.$REL"
    else
        target="$file"
    fi
    if [ -e "$HOME/$file" ]
    then
        diff -uw "$HOME/$file" "$DIR/$target"
        if [ $? -eq 1 ]
        then
            rm -v "$HOME/$file"
            ln -vs "$DIR/$target" "$HOME/$file"
        fi
    else
        ln -vs "$DIR/$target" "$HOME/$file"
    fi
done
