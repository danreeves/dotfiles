#!/bin/bash
if pgrep -x webpack >/dev/null
then
	# ps x -o rss,vsz,command | grep '[n]vim' | awk '{$1=int($1/1024)"M"; $2=int($2/1024)"M";}{ print "nvim: " $1 " | ";}'
	ps x -o rss,vsz,command | grep 'webpack' | sort | awk '{$1=int($1/1024)"M"; $2=int($2/1024)"M";}{ print "webpack: " $1 " | ";}'
fi
