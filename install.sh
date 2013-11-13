#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for file in .bashrc
do
	rm -v "$HOME/$file"
	ln -vs "$DIR/$file" "$HOME/$file"
done

