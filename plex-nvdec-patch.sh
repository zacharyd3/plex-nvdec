#!/bin/bash

#Get container ID.
con="$(docker ps -aqf 'name=PlexMediaServer')"

#Copy the files needed from Plex.
docker cp $con:/usr/lib/plexmediaserver/Plex\ Transcoder "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder"

#Check if the files already been patched.
pcheck="$(tail -n 1 '/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder')"
echo ""
#echo $pcheck
patched=##patched
if [[ "$pcheck" == "$patched" ]]
then
        echo "<hr>"
	echo "<font color='red'><b>Patch has already been applied!</b></font>"
	exit
else
	echo "<hr>"
	echo "<font color='green'><b>Applying hardware decode patch...</b></font>"
fi

#Copy the default transcoder as a backup
mv "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder" "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder2"

#Adds the needed script to use hardware decoding
cat > "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder" <<< '#!/bin/bash
marap=$(cut -c 10-14 <<<"$@")
if [ $marap <> "mpeg4" ]; then
     exec /usr/lib/plexmediaserver/Plex\ Transcoder2 -hwaccel nvdec "$@"
else
     exec /usr/lib/plexmediaserver/Plex\ Transcoder2 "$@"
fi

##patched'

#Gives the files the correct permissions and copies them back to the docker container
chmod +x "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder"
chmod +x "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder2"
docker cp "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder" $con:/usr/lib/plexmediaserver/Plex\ Transcoder
docker cp "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder2" $con:/usr/lib/plexmediaserver/Plex\ Transcoder2
docker exec -i $con chmod +x "/usr/lib/plexmediaserver/Plex Transcoder"
docker exec -i $con chmod +x "/usr/lib/plexmediaserver/Plex Transcoder2"


echo "<font color='green'><b>Done!</b></font>"
