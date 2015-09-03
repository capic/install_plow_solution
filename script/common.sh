#!/bin/sh
function installNodeJS {
    echo "<<<<< Installation de NodeJS >>>>>"
    if ! which npm >/dev/null; then
#        wget http://nodejs.org/dist/node-latest.tar.gz
#        tar zxvf node-latest.tar.gz
#        cd node-v0.1*
#        ./configure
#        make
#        make install
        if grep -Fxq "deb http://node-arm.herokuapp.com/ /" /etc/apt/sources.list
        then
            # code if found
        else
            # code if not found
            echo "deb http://node-arm.herokuapp.com/ /" | sudo tee --append /etc/apt/sources.list
        fi

        apt-get update
        apt-get install node
    else
        echo "NodeJS déjà installé"
    fi
}
