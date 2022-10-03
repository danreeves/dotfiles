if [ `uname` = "Darwin" ]; then
  track="$(osascript ~/.applescript/now-playing)"
  if [ "$track" ]; then
    echo "$track | "
  fi
fi
