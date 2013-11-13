#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"
find . -type f -not -path "./.git/*" -not -path "./install.sh" | while read file
do
    d=$(dirname "$file")
    if [ ! -d "$HOME/$d" ]
    then
        mkdir -pv "$HOME/$d"
    fi
    if [ -e "$HOME/$file" ]
    then
        diff -uw "$HOME/$file" "$DIR/$file"
        if [ $? -eq 1 ]
        then
            rm -v "$HOME/$file"
            ln -vs "$DIR/$file" "$HOME/$file"
        fi
    else
        ln -vs "$DIR/$file" "$HOME/$file"
    fi
done
