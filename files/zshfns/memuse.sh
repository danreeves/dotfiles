#!/bin/bash
if pgrep -x nvim >/dev/null
then
	ps x -o rss,vsz,command | grep '[n]vim' | awk '{$1=int($1/1024)"M"; $2=int($2/1024)"M";}{ print "|nvim: " $1 "|";}'
fi
