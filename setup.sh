set -e

apt-get update && apt-get install -y curl git htop zsh sudo

curl https://raw.githubusercontent.com/princemaple/server-setup/main/setup-zsh.sh | zsh
curl https://raw.githubusercontent.com/princemaple/server-setup/main/setup-vim.sh | zsh

yes "" | ssh-keygen -t ed25519 -C "chenpaul914@gmail.com" -N ""

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

curl -fsSL get.docker.com | sh

cat << EOF >> ~/.zshrc
precmd () { echo -n "\x1b]1337;CurrentDir=$(pwd)\x07" }

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

function dcp() {
  hash=\$(container_hash \$1)
  echo \$1:\$hash
  docker cp $hash:\$2 \$3
}

function dbup() {
  old=\$1
  new=\$2
  db=\$3

  docker exec -it \$old pg_dump -U postgres -Fc -d \$db -f /tmp/dump
  docker cp \$old:/tmp/dump ./dump
  docker cp ./dump \$new:/tmp/dump
  docker exec -it \$new psql -U postgres -c "create database \$db;"
  docker exec -it \$new pg_restore -U postgres -Fc -d \$db /tmp/dump
}
EOF
