#!/bin/bash

if [ ! -d "/ark" ]; then
  mkdir /ark
fi

if [ ! -d "/ark/logs" ]; then
  mkdir /ark/logs
fi

if [ ! -d "/ark/server" ]; then
  mkdir /ark/server
fi

if [ ! -f "/ark/Game.ini" ]; then
  ln -s /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini /ark/Game.ini
fi

if [ ! -f "/ark/GameUserSettings.ini" ]; then
  ln -s /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini /ark/GameUserSettings.ini
fi

./user.sh
su -p - steam -c 'cd /home/steam && ./steamcmd.sh +login anonymous +force_install_dir /ark/server +app_update 376030 validate +quit'
cd /ark/ShooterGame/Binaries/Linux && ./ShooterGameServer '${SERVERMAP}?listen?SessionName=${SESSIONNAME}?Port=${STEAMPORT}?bRawSockets=${STEAMPORT}?QueryPort=${PORT}?usGamePort=${PORT}?ServerAdminPassword=${ADMINPASSWORD}?GameModIds=${GAME_MOD_IDS}?MaxPlayers=${MAX_PLAYERS}?RCONEnabled=${RCON_ENABLED}?RCONPort=${RCON_PORT}' -server -log -UseNewSaveSystem $(if [ $DISABLE_BATTLEYE -eq 1 ]; then echo '-NoBattlEye'; fi)
