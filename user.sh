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
#chmod u+x run.sh
#su -p - steam -c './run.sh'
sudo -u steam sh run.sh
#sleep 6000
