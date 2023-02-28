#!/bin/sh
if [ ! "$(id -u steam)" -eq "$UID" ]; then 
        echo "Changing steam uid to $UID."
        usermod -o -u "$UID" steam ; 
fi
if [ ! "$(id -g steam)" -eq "$GID" ]; then 
        echo "Changing steam gid to $GID."
        groupmod -o -g "$GID" steam ; 
fi
chown -R steam:steam /ark /home/steam
chmod -R 777 /root/

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






echo -n "Server wird eingerichtet... "
while true; do
    echo -n "."
    sleep 0.1
done &
su -p - steam -c 'cd /home/steam && ./steamcmd.sh +login anonymous +force_install_dir /ark/server +app_update 376030 validate +quit' > /dev/null 2>&1
kill $! >/dev/null 2>&1
echo " fertig."

cd /ark/ShooterGame/Binaries/Linux && ./ShooterGameServer '${SERVERMAP}?listen?SessionName=${SESSIONNAME}?Port=${STEAMPORT}?bRawSockets=${STEAMPORT}?QueryPort=${PORT}?usGamePort=${PORT}?ServerAdminPassword=${ADMINPASSWORD}?GameModIds=${GAME_MOD_IDS}?MaxPlayers=${MAX_PLAYERS}?RCONEnabled=${RCON_ENABLED}?RCONPort=${RCON_PORT}' -server -log -UseNewSaveSystem $(if [ $DISABLE_BATTLEYE -eq 1 ]; then echo '-NoBattlEye'; fi)
