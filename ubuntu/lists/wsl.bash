# main repository
install -o root -g root -m 644 ${DIR}/lists/sources.list /etc/apt/sources.list
sed -i "s|%REPO%|http://au.archive.ubuntu.com/ubuntu|g;s/%DIST%/${dist}/g" /etc/apt/sources.list

# extra repositories for common development requirements
install -o root -g root -m 644 ${DIR}/lists/azure.list /etc/apt/sources.list.d/azure.list
sed -i "s/%DIST%/${dist}/g" /etc/apt/sources.list.d/azure.list
install -o root -g root -m 644 ${DIR}/lists/docker.list /etc/apt/sources.list.d/docker.list
sed -i "s/%DIST%/${dist}/g" /etc/apt/sources.list.d/docker.list
install -o root -g root -m 644 ${DIR}/lists/google.list /etc/apt/sources.list.d/google.list
