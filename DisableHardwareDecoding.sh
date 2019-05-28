#!/bin/bash
echo "<hr>"
echo "<font color='green'><b>Undoing hardware decode patch...</b></font>"
con="$(docker ps -aqf 'name=PlexMediaServer')"
docker cp "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder.bak" $con:/usr/lib/plexmediaserver/Plex\ Transcoder
docker exec $con rm -rf /usr/lib/plexmediaserver/Plex\ Transcoder2
echo "<font color='green'><b>Done!</b></font>"