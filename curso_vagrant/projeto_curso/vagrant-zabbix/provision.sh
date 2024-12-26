#!/bin/bash
# Ativa o modo seguro: para o script se qualquer comando falhar
set -e

# Variáveis
DB_NAME="zabbix"
DB_USER="zabbix"
DB_PASS="password"
ZBX_NGINX_CONF="/etc/zabbix/nginx.conf"
ZBX_SERVER_CONF="/etc/zabbix/zabbix_server.conf"

# Função para exibir mensagens no terminal
log(){
    echo -e "\n==== $1 ====\n"
}

# Atualização do sistema
log "Atualizando pacotes do Sistema..."
apt-get update -y
apt-get upgrade -y

# Baixar e instalar o Repositório Zabbix (verifica antes de baixar)
if ! dpkg -l | grep -q "zabbix-release"; then
    log "Baixando e instalando o repositório Zabbix..."
    wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu22.04_all.deb
    dpkg -i zabbix-release_latest_7.2+ubuntu22.04_all.deb
    apt update -y
else
    log "Repositório Zabbix já instalado, ignorando."
fi

# Instalar pacotes do Zabbix (verifica se já estão instalados)
if ! dpkg -l | grep -q "zabbix-server-mysql"; then
    log "Instalando pacotes do Zabbix Server e dependências..."
    apt-get install -y zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent
else
    log "Pacotes do Zabbix já instalados, ignorando."
fi

# Instalar  e Configurar o MySQL (verifica se o serviço MySQL está ativo)
if ! systemctl is-active --quiet mysql; then
    log "Instalando o MySQL..."
    apt-get install -y mysql-server
    log "MySQL instalado."
else
    log "MySQL já instalado e em execução, ignorando."
fi

# Criar o BD apenas se não existir
log "Verificando se o BD $DB_NAME existe..."
if ! mysql -uroot -e "SHOW DATABASES LIKE '${DB_NAME}';" | grep -q "$DB_NAME"; then
    log "Configurando o banco de dados para o Zabbix..."
    mysql -uroot <<EOF
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
FLUSH PRIVILEGES;
EOF
    log "Banco de Dados criado com sucesso."
else
    log "Banco de Dados $DB_NAME já existe, ignorando."
fi

# Importart o esquema do Zabbix para o BD
log "Verificando se o esquema do BD já foi importado..."
if ! mysql -uzabbix -ppassword ${DB_NAME} -e "SHOW TABLES;" | grep -q "users"; then
    log "Importando o esquema inicial do Zabix para o BD..."
    zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql -uzabbix -ppassword zabbix
    log "Esquema importado com sucesso."
else
    log "Esquema já importado, ignorando."
fi

# Desabilitando o log_bin_trust_function_creators apenas se estiver ativo
if mysql -uroot -e "SHOW VARIABLES LIKE 'log_bin_trust_function_creators';" | grep -q "ON"; then
    log "Desabilitando log_bin_trust_function_creators..."
    mysql -uroot  -e "SET GLOBAL log_bin_trust_function_creators = 0;"
    log "log_bin_trust_function_creators desabilitado."
else
    log "log_bin_trust_function_creators já está desabilitado, ignorando."
fi

# Configurar o /etc/zabbix/zabbix_server.conf
log "Verificando e configurando o arquivo /etc/zabbix/zabbix_server.conf..."
if ! grep -q "^DBPassword=${DB_PASS}" ${ZBX_SERVER_CONF}; then
    sed -i "s/^# DBPassword=/DBPassword=${DB_PASS}/" ${ZBX_SERVER_CONF}
    log "DBPassword configurado no zabbix_server.conf."
else
    log "DBPassword já configurado, ignorando."
fi

# Configurar o arquivo /etc/zabbix/nginx.conf
log "Verificando e configurando o arquivo nginx.conf..."
if grep -q "^#.*listen\s*8080;" ${ZBX_NGINX_CONF}; then
    sed -i 's/^#\s*\(listen\s*8080;\)/\1/' ${ZBX_NGINX_CONF}
    log "Descomentada a linha 'listen 8080;' no nginx.conf."
fi
if grep -q "^#.*server_name\s*example.com;" ${ZBX_NGINX_CONF}; then
    sed -i 's/^#\s*\(server_name\s*example.com;\)/\1/' ${ZBX_NGINX_CONF}
    log "Descomentada a linha 'server_name example.com;' no nginx.conf."
fi
if ! grep -q "listen.*8006;" ${ZBX_NGINX_CONF}; then
    sed -i 's|listen\s*.*;|listen      8006;|' ${ZBX_NGINX_CONF}
    log "Alterada a porta de escuta para 8006 no nginx.conf."
fi
if ! grep -q "server_name\s*192.168.100.204;" ${ZBX_NGINX_CONF}; then
    sed -i 's|server_name\s*.*;|server_name    192.168.100.204;|' ${ZBX_NGINX_CONF}
    log "Alterado o server_name para 192.168.100.204 no nginx.conf."
fi

# Liberar a Porta 8006 no FW apenas se não estiver liberada
if ! ufw status | grep -q "8006.*ALLOW"; then
    ufw allow 8006
    ufw reload
    log "Porta 8006 liberada no Firewall."
else
    log "Porta 8006 já está liberada, ignorando."
fi

# Reiniciar os Serviços do Zabbix
log "Reiniciando os serviços do Zabbix"
systemctl restart zabbix-server
systemctl restart zabbix-agent
systemctl restart nginx
systemctl restart php8.1-fpm
systemctl enable zabbix-server zabbix-agent nginx

log "Zabbix instalado e configurado com sucesso! Acesse o frontend via navegador para continuar."