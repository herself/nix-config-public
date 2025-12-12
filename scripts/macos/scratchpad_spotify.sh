#!/bin/bash

if [[ ! -f /tmp/spotify_scratchpad ]]; then
  echo 0 > /tmp/spotify_scratchpad
fi

if [[ $(cat /tmp/spotify_scratchpad) -eq 0 ]]; then
  #note where were we
  ~/bin/aerospace list-windows --focused | awk '{ print $1 }' > /tmp/spotify_scratchpad
  #focus on Spofity window
  ~/bin/aerospace focus --window-id $(~/bin/aerospace list-windows --all --format "%{window-id}%{right-padding} | %{app-name}" | grep Spotify | awk '{ print $1 }')
else
  #focus on previous window
  ~/bin/aerospace focus --window-id $(cat /tmp/spotify_scratchpad)
  #reset scrachpad
  echo 0 > /tmp/spotify_scratchpad
fi
