#!/bin/zsh -f

branch=$(git --no-optional-locks rev-parse --abbrev-ref HEAD 2> /dev/null)
gitstatus=$(git --no-optional-locks status --porcelain 2> /dev/null)
dirty=$([[ $gitstatus == "?? 0" || $gitstatus == "" ]] && echo "" || echo " *")
if [[ $branch != "" ]]; then
  echo " | ${branch:0:9}$dirty";
fi

tmux rename-session "${PWD##*/}"
