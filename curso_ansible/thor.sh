#!/bin/bash

echo "Atualizando o Sistema..."
apt update -y
echo "Fazendo upgrade dos pacotes..."
apt upgrade -y
echo "Fazendo Limpeza dos pacotes antigos..."
apt autoremove -y
echo "Atualização Concluída!"
echo "Instalando o Ansible..."
apt-get -y install ansible
echo "Instalação Concluída!"