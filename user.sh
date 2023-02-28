#!/bin/sh
if [ ! "$(id -u steam)" -eq "$UID" ]; then 
        usermod -o -u "$UID" steam ; 
fi
if [ ! "$(id -g steam)" -eq "$GID" ]; then 
        groupmod -o -g "$GID" steam ; 
fi
chown -R steam:steam /ark /home/steam
chmod -R 777 /root/

if [ ! -d "/ark" ]; then
  mkdir /ark >/dev/null 2>&1
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

echo "Update Server...";
su - steam -c 'cd /home/steam && ./steamcmd.sh +login anonymous +force_install_dir /ark/server +app_update 376030 validate +quit >/dev/null 2>&1'
echo "Start Server...";
su - steam -c "cd /ark/server/ShooterGame/Binaries/Linux && ./ShooterGameServer "${SERVERMAP}?listen?SessionName=${SESSIONNAME}?Port=${STEAMPORT}?bRawSockets=${STEAMPORT}?QueryPort=${PORT}?usGamePort=${PORT}?ServerAdminPassword=${ADMINPASSWORD}?GameModIds=${GAME_MOD_IDS}?MaxPlayers=${MAX_PLAYERS}?RCONEnabled=${RCON_ENABLED}?RCONPort=${RCON_PORT}?serverPVE=${DISABLE_PVP}" -server -log $(if [ ${DISABLE_BATTLEYE} -eq 1 ]; then echo "-NoBattlEye"; fi) >/dev/null 2>&1"
