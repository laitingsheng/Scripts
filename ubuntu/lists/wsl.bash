# main repository
install -o root -g root -m 644 ${DIR}/lists/sources.list /etc/apt/sources.list
sed -i "s|%REPO%|http://au.archive.ubuntu.com/ubuntu|g;s/%DIST%/${dist}/g" /etc/apt/sources.list

# extra repositories for common development requirements
install -o root -g root -m 644 ${DIR}/lists/azure.list /etc/apt/sources.list.d/azure.list
sed -i "s/%DIST%/${dist}/g" /etc/apt/sources.list.d/azure.list
install -o root -g root -m 644 ${DIR}/lists/docker.list /etc/apt/sources.list.d/docker.list
sed -i "s/%DIST%/${dist}/g" /etc/apt/sources.list.d/docker.list
install -o root -g root -m 644 ${DIR}/lists/google.list /etc/apt/sources.list.d/google.list
install -o root -g root -m 644 ${DIR}/lists/microsoft.list /etc/apt/sources.list.d/microsoft.list
sed -i "s/%RELEASE%/${release}/g;s/%DIST%/${dist}/g" /etc/apt/sources.list.d/microsoft.list
install -o root -g root -m 644 ${DIR}/lists/hashicorp.list /etc/apt/sources.list.d/hashicorp.list
sed -i "s/%DIST%/${dist}/g" /etc/apt/sources.list.d/hashicorp.list
install -o root -g root -m 644 ${DIR}/lists/github.list /etc/apt/sources.list.d/github.list
sed -i "s/%DIST%/${dist}/g" /etc/apt/sources.list.d/github.list

xargs apt-key adv -q --fetch-keys <<- EOL
https://packages.microsoft.com/keys/microsoft.asc
https://download.docker.com/linux/ubuntu/gpg
https://packages.cloud.google.com/apt/doc/apt-key.gpg
https://apt.releases.hashicorp.com/gpg
EOL

apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
