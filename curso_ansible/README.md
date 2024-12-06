# Curso de Ansible: Formação DevOps - Iago Ferreira

Este repositório documenta práticas e aprendizados do curso de Ansible, com o uso do Vagrant para provisionamento de VMs.

## Conteúdo do Projeto

1. **Provisionamento de VMs**
   - Configura três máquinas virtuais:
     - **CentOS 9 Stream**
     - **Debian 11**
     - **Windows 10**
   - Define endereços IP e hostnames para as VMs.
   - Executa scripts personalizados durante o provisionamento.

2. **Scripts Executados**
   - Atualizam e fazem upgrade de todos os pacotes do sistema.
   - Instalam o Ansible nas VMs compatíveis.
  
3. **Ansible.cfg**

  Este arquivo é o de configuração principal do Ansible e nele possue diversos parâmetro importantes.
  A pasta padrão deste arquivo é /etc/ansible/ porém não necessariamente precisam estar nesta pasta, entretanto para fazer o Ansible ver os arquivos tem-se que mudar alguns aspectos como:
  
  1° Variáveis de ambiente.
  2° Arquivo ansible.cfg na pasta corrente.
  3° /home/usuário/.ansible.cfg

  ### Alguns Detalhes do Ansible.cfg

  [defaults] = Entre colchetes é GRUPOS
  become = Escalação de privilégios
  host_key_checking = False -> Para não ter troca de Chaves
  nocows = 1 -> Desabilita a Vaquinha.

  **Dicas Boas Práticas: Sempre que for alterar criar algum coisa, criar cópia do arquivo.

4. **Comandos Ad-hoc**
  Realizei alguns comandos ad-hoc, como:
    - ansible -i hosts all -u teste -k -m ping
    - ansible -i hosts capitao-america -u teste -k -m apt -a "name=vim state=latest"

  Foi necessário realizar uma configuração devido a alguns erros que apresentou.
    - o sshd não estava configurado para permitir acesso com senha, mesmo não sendo recomendado para ambiente de produção, ativei para uso acadêmico. Foi alterado o PermitLoginRoot e o PasswordAuthentication.

5. **Configurando SSH Keys**
  Para configurar o acesso remoto seguro sem senha, apenas trocando chaves ssh, precisamos gerar a chave. Para isso acessamos o servidor capitao-america e executamos o seguinte comando

    ssh-keygen -t rsa -b 2048

  O caminho da chave criada é por padrão a home do usuário logado no momento que no meu caso foi: /root/.ssh/id_rsa

  O próximo passo é passar a chave criada a outros servidores que queremos poder acessar remotamente. Faremos da seguinte forma:

    ssh-copy-id -i /root/.ssh/id_rsa root@192.168.100.102

  Após isso é importante desativarmos as configurações de acesso com senha que liberamos no passo anterior.


## Problemas no Primeiro Commit

- **Erros de Sintaxe no `vagrant up`**: Identifiquei e corrigi problemas após estudar a documentação oficial.
  - **`config.vm.define`**: Aprendi a usar a funcionalidade multi-machine para gerenciar múltiplas VMs em um único Vagrantfile.
  - **Correção de Sintaxe**: Removido o `=` em `vm.network`.

- **`config.vm.provider`**: Inicialmente considerei opcional configurar o provider, já que utilizo apenas VirtualBox. Contudo, para garantir compatibilidade em qualquer ambiente e definir recursos de memória e CPU, incluí essa configuração no Vagrantfile.


## Melhorias

- Melhorei o recurso de memória da VM Thanos.
- Alterei a instalação do ansible pois estava incompleta.

## Próximos Passos

  - [ ] Configurar o arquivo ansible.cfg.
  - [ ] Configurar o inventory.
  - [ ] Testar o ansible com comandos ad-hoc.

---

Este README será atualizado conforme o progresso no curso e novos aprendizados.
