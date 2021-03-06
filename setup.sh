set -e

apt-get update && apt-get install -y curl git htop zsh sudo

curl -L https://github.com/docker/compose/releases/download/1.28.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

curl https://raw.githubusercontent.com/princemaple/server-setup/master/setup-zsh.sh | zsh

yes "" | ssh-keygen -t rsa -b 4096 -C "chenpaul914@gmail.com" -N ""

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

curl -fsSL get.docker.com | sh

cat << EOF >> ~/.zshrc
function container_hash() {
  docker ps | grep \$1 | cut -d ' ' -f 1
}

function dexec() {
  hash=\$(container_hash \$1)
  echo \$1:$hash
  docker exec -it \$hash \${@:2}
}

function dlogs() {
  hash=\$(container_hash \$1)
  echo \$1:\$hash
  docker logs \$hash \${@:2}
}
EOF
