#!/usr/bin/env bash

CONF="/etc/init/transmission-daemon.conf"
#declare -a CONFIG_DIRS
CONFIG_DIRS="/var/lib/transmission-daemon
/etc/transmission-daemon"

NAME="$0"
USER="$1"
GROUP="$2"
#_UID=`id -u $USER`
#_GID=`id -g $GROUP`


help() {
        echo "Usage:"
        echo "  " $0 " USER GROUP"
}

ask (){
        echo "NAME " $NAME
        echo "USER " $USER
        echo "GROUP " $GROUP
        echo "DIRS " "${CONFIG_DIRS}"

        read -p "Continue? [y/N] > " do_it

        if [[ $do_it != 'y' ]]; then
                echo "Exiting."
                exit 0
        fi
}

switch() {
        echo "Switching user."
        sed -i 's/setuid .*/setuid '$USER'/' $CONF
        sed -i 's/setgid .*/setgid '$GROUP'/' $CONF
        sed -i 's/USER=.*/USER='$USER'/' /etc/init.d/transmission-daemon
        sed -i 's/User=.*/User='$USER'/' /etc/systemd/system/multi-user.target.wants/transmission-daemon.service
        sed -i 's/User=.*/User='$USER'/'  /lib/systemd/system/transmission-daemon.service
        systemctl daemon-reload
}

permissions() {
        echo "Changing permissions."
        for dir in $CONFIG_DIRS; do
                echo "Changing ownership of $dir"
                chown $USER:$GROUP -R $dir
        done
}


main() {
        ask

        echo "Stopping daemon"
        systemctl stop transmission-daemon.service

        switch
        permissions

        echo "Starting daemon"
        systemctl start transmission-daemon.service

        sleep 5
        echo `journalctl -xb | grep transmission | tail -n 25`
}

main
