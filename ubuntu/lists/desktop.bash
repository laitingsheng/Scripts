source ${DIR}/lists/base.bash

cp -r ${DIR}/lists/desktop/. /etc/apt/sources.list.d
chmod -R go-w /etc/apt/sources.list.d

xargs apt-key adv -q --fetch-keys <<- EOL
https://dl.google.com/linux/linux_signing_key.pub
https://repo.steampowered.com/steam/archive/precise/steam.gpg
EOL
