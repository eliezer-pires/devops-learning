#!/bin/bash

# Ativa o modo seguro: para o script se qualquer comando falhar
set -e

# Função para exibir mensagens no terminal
log(){
    echo -e "\n========= $1 ============\n"
}

# Atualização do sistema
log "Atualizando pacotes do Sistema..."
dnf update -y
log "Fazendo upgrade dos pacotes..."
dnf upgrade -y
# Fazendo Limpeza de pacotes antigos
log "Fazendo Limpeza dos pacotes antigos..."
dnf autoremove -y
dnf clean all
log "Atualização Concluída!"

# Baixar e instalar o Ansible (verifica antes de baixar)
if | rpm -qa | grep -q "ansible"; then
    log "Baixando e instalando o ansible..."
    dnf install ansible
    dnf install ansible-collection-community-general
    log "Instalação Concluída!"
else
    log "Repositório Ansible já instalado, ignorando.
