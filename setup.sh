set -e

apt-get update && apt-get install -y curl git htop zsh

curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

curl https://raw.githubusercontent.com/princemaple/server-setup/master/setup-zsh.sh | zsh

yes "" | ssh-keygen -t rsa -b 4096 -C "chenpaul914@gmail.com" -N ""

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# Leaving it to docker-machine
# curl -fsSL get.docker.com | sh
