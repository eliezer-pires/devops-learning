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

## Problemas no Primeiro Commit

- **Erros de Sintaxe no `vagrant up`**: Identifiquei e corrigi problemas após estudar a documentação oficial.
  - **`config.vm.define`**: Aprendi a usar a funcionalidade multi-machine para gerenciar múltiplas VMs em um único Vagrantfile.
  - **Correção de Sintaxe**: Removido o `=` em `vm.network`.

- **`config.vm.provider`**: Inicialmente considerei opcional configurar o provider, já que utilizo apenas VirtualBox. Contudo, para garantir compatibilidade em qualquer ambiente e definir recursos de memória e CPU, incluí essa configuração no Vagrantfile.

---

Este README será atualizado conforme o progresso no curso e novos aprendizados.
