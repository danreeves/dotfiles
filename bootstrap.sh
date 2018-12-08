#!/bin/bash -

for file in files/*
do
  if [ -f "$file" ]; then
	  echo "Linking $(pwd)/$file to ~/.$(basename $file)"
	  ln -s $(pwd)/$file ~/.$(basename $file)
  fi
done
