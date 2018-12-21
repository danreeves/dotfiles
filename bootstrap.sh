#!/bin/bash -

for file in files/*
do
  if [ -f "$file" ]; then
    echo "Linking $(pwd)/$file to ~/.$(basename $file)"
    ln -sfn $(pwd)/$file ~/.$(basename $file)
  else
    echo "Creating ~/.$(basename $file)/"
    mkdir -p ~/.$(basename $file)
    for dirfile in $file/*
    do
      echo "Linking $(pwd)/$dirfile to ~/.$(basename $file)/$(basename $dirfile)"
      ln -sfn $(pwd)/$dirfile ~/.$(basename $file)/$(basename $dirfile)
    done
  fi
done
