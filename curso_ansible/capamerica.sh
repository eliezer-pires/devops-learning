#!/bin/bash

echo "Atualizando o Sistema..."
dnf update -y
echo "Fazendo upgrade dos pacotes..."
dnf upgrade -y
echo "Fazendo Limpeza dos pacotes antigos..."
dnf autoremove -y
dnf clean all
echo "Atualização Concluída!"
echo "Instalando o Ansible..."
dnf install ansible
dnf install ansible-collection-community-general
echo "Instalação Concluída!"
