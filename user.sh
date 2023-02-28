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
su -p - steam -c /home/steam/run.sh
