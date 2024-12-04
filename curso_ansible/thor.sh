#!/bin/bash

echo "Atualizando o Sistema..."
sudo apt update -y
echo "Fazendo upgrade dos pacotes..."
sudo apt upgrade -y
echo "Fazendo Limpeza dos pacotes antigos..."
sudo apt autoremove -y
echo "Atualização Concluída!"
echo "Instalando o Ansible..."
sudo apt install pipx -y
pipx ensurepath
pipx ensurpath --global
pipx install --include-deps ansible
echo "Atualizando o Ansible..."
pipx upgrade --include-injected ansible
pipx inject --include-apps ansible argcomplete
echo "Instalação Concluída!"