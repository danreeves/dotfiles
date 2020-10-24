#!/bin/zsh -f

branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
gitstatus=$(git status --porcelain 2> /dev/null)
dirty=$([[ $gitstatus == "?? 0" || $gitstatus == "" ]] && echo "" || echo " *")
if [[ $branch != "" ]]; then
  echo " | $branch$dirty";
fi
