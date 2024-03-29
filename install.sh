#!/bin/sh
if [ ! "$(id -u steam)" -eq "$UID" ]; then 
        usermod -o -u "$UID" steam ; 
fi
if [ ! "$(id -g steam)" -eq "$GID" ]; then 
        groupmod -o -g "$GID" steam ; 
fi

if [ ! -d "/ark" ]; then
  mkdir /ark >/dev/null 2>&1
fi

if [ ! -d "/mnt/server" ]; then
  ln -s /ark /mnt/server >/dev/null 2>&1
fi

if [ ! -d "/home/container" ]; then
  ln -s /ark /home/container >/dev/null 2>&1
fi

if [ ! -d "/ark/logs" ]; then
  mkdir /ark/logs >/dev/null 2>&1
fi

if [ ! -d "/ark/server" ]; then
  mkdir /ark/server >/dev/null 2>&1
fi

if [ ! -f "/ark/Game.ini" ]; then
  ln -s /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini /ark/Game.ini >/dev/null 2>&1
fi

if [ ! -f "/ark/GameUserSettings.ini" ]; then
  ln -s /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini /ark/GameUserSettings.ini >/dev/null 2>&1
fi

chown -R steam:steam /ark/ /home/steam/
chmod -R 777 /root/

echo "Update Server...\n";
su - steam -c 'cd /home/steam && ./steamcmd.sh +login anonymous +force_install_dir /ark/server +app_update 376030 ${UPDATEPONSTART:+validate} +quit'

echo "Start Server...\n";

SESSIONNAME="${SESSIONNAME:-Server by Ryzehost}"
ADMINPASSWORD="${ADMINPASSWORD:-password}"
SERVERPASSWORD="${SERVERPASSWORD:-}"

start="cd /ark/server/ShooterGame/Binaries/Linux && ./ShooterGameServer ${SERVERMAP}?listen?SessionName='${SESSIONNAME}'?Port=${STEAMPORT}?bRawSockets=${STEAMPORT}?QueryPort=${PORT}?usGamePort=${PORT}?ServerAdminPassword='${ADMINPASSWORD}'?ServerPassword='${SERVERPASSWORD}'?GameModIds=${GAME_MOD_IDS}?MaxPlayers=${MAX_PLAYERS}?RCONEnabled=${RCON_ENABLED}?RCONPort=${RCON_PORT}?serverPVE=${DISABLE_PVP} -server -log"

if [ "$DISABLE_BATTLEYE" = true ]; then
 echo "Start ARK without BattlEye.\n"
 su - steam -c "$start -NoBattlEye"
else
 echo "Start ARK with BattlEye.\n"
 su - steam -c "$start"
fi
