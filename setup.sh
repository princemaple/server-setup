set -e

apt-get update
apt-get install curl git htop zsh

curl -L https://github.com/docker/compose/releases/download/1.10.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

curl https://raw.githubusercontent.com/princemaple/server-setup/master/setup-zsh.sh | zsh

yes "" | ssh-keygen -t rsa -b 4096 -C "chenpaul914@gmail.com" -N ""
