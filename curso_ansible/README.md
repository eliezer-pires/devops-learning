# Curso de Ansible: Formação DevOps - Iago Ferreira

Este repositório documenta práticas e aprendizados do curso de Ansible, com o uso do Vagrant para provisionamento de VMs.

## Conteúdo do Projeto

### 1. **Provisionamento de VMs**
   - Configura três máquinas virtuais:
     - **CentOS 9 Stream**
     - **Debian 11**
     - **Windows 10**
   - Define endereços IP e hostnames para as VMs.
   - Executa scripts personalizados durante o provisionamento.

### 2. **Scripts Executados**
   - Atualizam e fazem upgrade de todos os pacotes do sistema.
   - Instalam o Ansible nas VMs compatíveis.
  
### 3. **Arquivo de Configuração (`ansible.cfg`)**
O arquivo `ansible.cfg` é o principal arquivo de configuração do Ansible e pode estar em diferentes locais:
1. Diretório padrão: `/etc/ansible/`.
2. Arquivo na pasta corrente do projeto.
3. Arquivo no diretório do usuário: `/home/usuário/.ansible.cfg`.

#### Principais Parâmetros
- `[defaults]`: Indica um grupo de configurações.
- `become`: Habilita a escalada de privilégios.
- `host_key_checking = False`: Desativa a verificação de troca de chaves SSH.
- `nocows = 1`: Desabilita o mascote "vaquinha" ao executar comandos.

> **Dica de Boas Práticas**: Sempre crie uma cópia de backup antes de alterar o arquivo `ansible.cfg`.

### 4. **Comandos Ad-hoc**
Comandos Ad-hoc são úteis para execução direta de tarefas no Ansible. Alguns exemplos executados:
- **Teste de conectividade:**
  ```bash
  ansible -i hosts all -u teste -k -m ping
  ```
- **Instalação de pacote**
    ```bash
    ansible -i hosts capitao-america -u teste -k -m apt -a "name=vim state=latest"
    ```
#### Solução de Problemas
Durante os testes com comandos Ad-hoc, enfrentei problemas relacionados à configuração do SSH. As soluções aplicadas foram:

1. **Ajuste Temporário no SSH**:
   - Para permitir acesso por senha, mesmo que não seja recomendado em ambientes de produção, alterei as seguintes opções no arquivo de configuração do SSH (`/etc/ssh/sshd_config`):
     ```plaintext
     PermitRootLogin yes
     PasswordAuthentication yes
     ```
   - Após as alterações, reiniciei o serviço SSH:
     ```bash
     systemctl restart sshd
     ```

### 5. **Configurando SSH Keys**
Para configurar um acesso remoto seguro sem senha, utilizando chaves SSH, segui os passos abaixo:

1. **Gerar a Chave SSH no Servidor**:
   No servidor `capitao-america`, utilizei o comando para gerar uma chave SSH:
   ```bash
   ssh-keygen -t rsa -b 2048
   ```
   
  O caminho da chave criada é por padrão a home do usuário logado no momento que no meu caso foi: /root/.ssh/id_rsa

  O próximo passo é passar a chave criada a outros servidores que queremos poder acessar remotamente. Faremos da seguinte forma:
  
  ``` bash
    ssh-copy-id -i /root/.ssh/id_rsa root@192.168.100.102
  ```

  Após isso é importante desativarmos as configurações de acesso com senha que liberamos no passo anterior.

### 6. **Organizando o Inventory File em Grupos e Subgrupos**

  No arquivo hosts foi criado os grupos:

    [web] e [db] para os servidores 192.168.100.101 e 192.168.100.102 respectivamente.

    Após isso criamos um subgrupo [filial_01:children] e renomeamos os grupos para web_f01 e db_f01 e colocamos dentro do subgrupo.

### 7. **Criando Variáveis no Inventory - Hosts e Grupos**

  No aquivo hosts utilizamos algumas variáveis para estabelecer alguns parametros padronizados, simplificando assim os comandos ad-hoc.

    - ansible_hosts
    - ansible_user
    - ansible_port

  Desta forma, os comandos ad-hoc utilizados para esse servidor não precisará enviar parametro como  -k e outros.

  Além disso, aprendi a usar variáveis dentro do escopo de um grupo isso traz um benefício de não ter que passar parâmetros repetidos em diversos hosts que fazem parte do mesmo grupo.

  Dessa forma a implementação fica da seguinte forma:

    - Adiciona [filial_01:vars] e coloca as variáveis comuns a todos os hosts desse grupo.
    - no nosso exemplo adicionamos as variáveis: ansible_user=ansible e ansible_port=22

## Problemas no Primeiro Commit

- **Erros de Sintaxe no `vagrant up`**: Identifiquei e corrigi problemas após estudar a documentação oficial.
  - **`config.vm.define`**: Aprendi a usar a funcionalidade multi-machine para gerenciar múltiplas VMs em um único Vagrantfile.
  - **Correção de Sintaxe**: Removido o `=` em `vm.network`.

- **`config.vm.provider`**: Inicialmente considerei opcional configurar o provider, já que utilizo apenas VirtualBox. Contudo, para garantir compatibilidade em qualquer ambiente e definir recursos de memória e CPU, incluí essa configuração no Vagrantfile.


## Melhorias

- Melhorei o recurso de memória da VM Thanos.
- Alterei a instalação do ansible pois estava incompleta.

## Próximos Passos

  - [x] Configurar o arquivo ansible.cfg.
  - [x] Configurar o inventory.
  - [x] Testar o ansible com comandos ad-hoc.
  - [x] Testar o ansible com a organização do Inventory File com variáveis e grupos.

---

Este README será atualizado conforme o progresso no curso e novos aprendizados.
