source ${DIR}/lists/wsl.bash

# extra repositories for applications
install -o root -g root -m 644 ${DIR}/lists/google-chrome.list /etc/apt/sources.list.d/google-chrome.list
install -o root -g root -m 644 ${DIR}/lists/steam.list /etc/apt/sources.list.d/steam.list
install -o root -g root -m 644 ${DIR}/lists/vscode.list /etc/apt/sources.list.d/vscode.list
