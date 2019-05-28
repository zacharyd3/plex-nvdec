#!/bin/bash

#Get container ID.
con="$(docker ps -aqf 'name=PlexMediaServer')"

#Copy the files needed from Plex.
docker cp $con:/usr/lib/plexmediaserver/Plex\ Transcoder "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder"

#Make a backup of the original
docker cp $con:/usr/lib/plexmediaserver/Plex\ Transcoder "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder.bak"

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
nvdec=$(nvidia-smi -q | grep -iq Decoder ; echo $?)
if [[ "$marap" == "mpeg4" || $nvdec -ne 0 ]]; then
     exec /usr/lib/plexmediaserver/Plex\ Transcoder2 "$@"
else
     exec /usr/lib/plexmediaserver/Plex\ Transcoder2 -hwaccel nvdec "$@"
fi

##patched'

#Gives the files the correct permissions and copies them back to the docker container
docker cp "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder" $con:/usr/lib/plexmediaserver/Plex\ Transcoder
docker cp "/mnt/user/Storage/Google Drive/Server Files/Plex Patch/Plex Transcoder2" $con:/usr/lib/plexmediaserver/Plex\ Transcoder2
docker exec -i $con chmod +x "/usr/lib/plexmediaserver/Plex Transcoder"
docker exec -i $con chmod +x "/usr/lib/plexmediaserver/Plex Transcoder2"


echo "<font color='green'><b>Done!</b></font>"