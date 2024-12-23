#!/bin/bash
# Ativa o modo seguro: para o script se qualquer comando falhar
set -e

# Variáveis
DB_NAME="zabbix"
DB_USER="zabbix"
DB_PASS="password"

# Função para exibir mensagens no terminal
log(){
    echo -e "\n==== $1 ====\n"
}

# Atualização do sistema
log "Atualizando pacotes do Sistema..."
apt-get update -y
apt-get upgrade -y

# Baixar e instalar o Repositório Zabbix
log "Baixando e instalando o repositório Zabbix..."
wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu22.04_all.deb
dpkg -i zabbix-release_latest_7.2+ubuntu22.04_all.deb
apt update -y

# Instalar pacotes do Zabbix
log "Instalando pacotes do Zabbix Server e dependências..."
apt-get install -y zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent

# Configuração do MySQL e criação do Banco de Dados
log "Instalando o MySQL e configurando o BD..."
apt-get install -y mysql-server

log "Configurando o banco de dados para o Zabbix..."
mysql -uroot <<EOF
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
FLUSH PRIVILEGES;
EOF

log "Banco de Dados Configurado com sucesso."

# Importart o esquema do Zabbix para o BD
log "Importando o esquema inicial do Zabix para o BD..."
zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql -uzabbix -ppassword zabbix

# Desabilitando o log_bin_trust_function_creators
mysql -uroot <<EOF
SET GLOBAL log_bin_trust_function_creators = 0;
EOF

# Configurando o /etc/zabbix/zabbix_server.conf
log "Configurando o arquivo /etc/zabbix/zabbix_server.conf"
sed -i "s/^# DBPassword=/DBPassword=${DB_PASS}/" /etc/zabbix/zabbix_server.conf
sed -i "s/^# DBHost=/DBHost=/" /etc/zabbix/zabbix_server.conf

# Configurar o arquivo nginx.conf
log "Configurando o arquivo /etc/zabbix/nginx.conf"
sed -i "s|listen    80;|listen      8006;|" /etc/zabbix/nginx.conf
sed -i "s|server_name localhost;|server_name    192.168.100.204;|" /etc/zabbix/nginx.conf

# Liberando a Porta 8006 no FW
ufw allow 8006
ufw reload

# Reiniciar os Serviços do Zabbix
log "Reiniciando os serviços do Zabbix"
systemctl restart zabbix-server
systemctl restart zabbix-agent
systemctl restart nginx
systemctl restart php8.1-fpm
systemctl enable zabbix-server zabbix-agent nginx

log "Zabbix instalado e configurado com sucesso! Acesse o frontend via navegador para continuar."