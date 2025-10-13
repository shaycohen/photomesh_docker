#!/usr/bin/env bash
NAS_IP="${NAS-IP-192.168.1.1}"
NAS_NAME="${NAS-NAME-vs-fn-nfs}"
SHARE_NAME="${SHARE_NAME-data_directory}"
SHAREFOLDER="${\\\\$NAS_NAME\\$SHARE_NAME\\working-folder\\}"
ACTION="${1:-start}"
echo "NASIP[$NAS_IP] NASNAME[$NAS_NAME] SHARENAME[$SHARE_NAME] SHAREFOLDER[$SHAREFOLDER] ACTION[$ACTION]"

mkdir -p ~/.wine/dosdevices/unc/${NAS_IP}
mkdir -p ~/.wine/dosdevices/unc/${NAS_NAME}
ln -sf /data ~/.wine/dosdevices/unc/${NAS_IP}/${SHARE_NAME}
ln -sf /data ~/.wine/dosdevices/unc/${NAS_NAME}/${SHARE_NAME}
mkdir -p ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser
echo -n "$SHAREFOLDER" > ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser/ShareFolder.txt
echo "Content of ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser/ShareFolder.txt :"
cat ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser/ShareFolder.txt
echo
echo "Created folders:"
ls -ld ~/.wine/dosdevices/unc/${NAS_IP} ~/.wine/dosdevices/unc/${NAS_NAME} ~/.wine/dosdevices/unc/${NAS_IP}/${SHARE_NAME} /data ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser

[[ $ACTION == "start" ]] && { 
	sudo Xvfb :0 -screen 0 1024x768x24 &
	exec wine /app/Fuser/PhotoMeshFuser.exe
}

[[ $ACTION == "dryrun" ]] && { 
	echo "sudo Xvfb :0 -screen 0 1024x768x24 &"
	echo "exec wine /app/Fuser/PhotoMeshFuser.exe"
}
