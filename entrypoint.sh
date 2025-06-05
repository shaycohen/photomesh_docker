#!/usr/bin/env bash
set -e  

# Validate environment variables
IP="${ENV_IP-192.168.1.1}"
DIR="${ENV_DIR-data_directory}"
SHAREFOLDER="${ENV_SHAREFOLDER-\\\\$IP\\c\\temp\\}"
ACTION="${1:-start}"
echo "IP[$IP] DIR[$DIR] SHAREFOLDER[$SHAREFOLDER] ACTION[$ACTION]"

# Prepare Wine directories with environment variables
mkdir -p ~/.wine/dosdevices/unc/${ENV_IP}
mkdir -p ~/.wine/dosdevices/unc/${ENV_DIR}
ln -sf /data ~/.wine/dosdevices/unc/${ENV_DIR}/d
mkdir -p ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser
echo -n "$SHAREFOLDER" > ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser/ShareFolder.txt
echo "Content of ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser/ShareFolder.txt :"
cat ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser/ShareFolder.txt
echo
echo "Created folders:"
ls -ld ~/.wine/dosdevices/unc/${ENV_IP} ~/.wine/dosdevices/unc/${ENV_DIR} /data ~/.wine/drive_c/users/ubuntu/AppData/Roaming/PhotomeshFuser

[[ $ACTION == "start" ]] && { 
	Xvfb :0 -screen 0 1024x768x24 &
	exec wine /app/Fuser/PhotoMeshFuser.exe
}

[[ $ACTION == "dryrun" ]] && { 
	echo "Xvfb :0 -screen 0 1024x768x24 &"
	echo "wine /app/Fuser/PhotoMeshFuser.exe"
}
