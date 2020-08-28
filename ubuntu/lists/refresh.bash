apt-get update
apt list --installed | cut -d '/' -f1 | xargs apt-mark auto
