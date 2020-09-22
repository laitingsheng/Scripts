rm -f /etc/apt/sources.list.d/*.list
cp ${DIR}/lists/sources.list /etc/apt/sources.list
cp -r ${DIR}/lists/base/. /etc/apt/sources.list.d
chmod 755 /etc/apt/sources.list.d
chmod 644 /etc/apt/sources.list /etc/apt/sources.list.d/*

sed -i "s/%RELEASE%/${release}/g;s/%DIST%/${dist}/g" /etc/apt/sources.list.d/*.list

rm -f /etc/apt/trusted.gpg /etc/apt/trusted.gpg~ /etc/apt/trusted.gpg.d/*.gpg
xargs apt-key adv --keyserver keyserver.ubuntu.com --recv-key <<- EOL
3B4FE6ACC0B21F32
C99B11DEB97541F0
EOL
xargs apt-key adv -q --fetch-keys <<- EOL
https://packages.microsoft.com/keys/microsoft.asc
https://download.docker.com/linux/ubuntu/gpg
https://packages.cloud.google.com/apt/doc/apt-key.gpg
https://apt.releases.hashicorp.com/gpg
https://deb.nodesource.com/gpgkey/nodesource.gpg.key
EOL

rm -rf /etc/apt/preferences /etc/apt/preferences.d
cp ${DIR}/lists/preferences /etc/apt/preferences
chmod 644 /etc/apt/preferences
mkdir -m 755 /etc/apt/preferences.d
