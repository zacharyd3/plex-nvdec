#!/bin/bash

pcheck=`tail -n 1 /usr/lib/plexmediaserver/Plex\ Transcoder`
if [ "$pcheck" <> "##patched" ]; then
  echo "Patch has already been applied!"
  exit
fi

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit
fi

mv /usr/lib/plexmediaserver/Plex\ Transcoder /usr/lib/plexmediaserver/Plex\ Transcoder2

cat > /usr/lib/plexmediaserver/Plex\ Transcoder <<< '#!/bin/bash
marap=$(cut -c 10-14 <<<"$@")
if [ $marap <> "mpeg4" ]; then
     exec /usr/lib/plexmediaserver/Plex\ Transcoder2 -hwaccel nvdec "$@"
else
     exec /usr/lib/plexmediaserver/Plex\ Transcoder2 "$@"
fi

##patched'

chmod +x /usr/lib/plexmediaserver/Plex\ Transcoder
