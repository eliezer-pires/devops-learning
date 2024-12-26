# Projeto 4 - Criando uma VM pelo Vagrant com Zabbix Server

## Descrição:
Este projeto é o quarto projeto do curso de vagrant do Iago Ferreira nele irei provisionar uma VM com o Vagrant com os requisitos específicos (2Gb de RAM e 2 núcleo do CPU Ubuntu 24.04) irei instalar e configurar via Shell Script um Zabbix Server.

## Objetivos:
- Praticar o uso de Vagrant com provisionamento via shell script.
- Automatizar a instalação e configuração do MySQL e do servidor de monitoramento Zabbix.
- Evoluir as técnicas de ShellScript.
- Garantir que os serviços do MySQL e Zabbix Server estão configurados e funcionando perfeitamente.
- Treinar Git para subir o projeto no GitHub.

## Instruções para Iniciar a VM
Para que consiga utilizar este projeto é necessário ter instalado e configurado o Vagrant e algum virtualizador como virtualbox, vmware e etc. Todavia para teste foi utilizado o VirtualBox.

- [ ] Clone este repositório.
- [ ] Dentro da pasta execute o comando: `vagrant up`
- [ ] Para acessar via SSH a VM: `vagrant ssh`

## Provisionamento
Ao rodar o comando `vagrant up` irá criar a VM.

Utilizará o Ubuntu 24.04 como box e atribuirá o hostname.
```bash
Vagrant.configure("2") do |config|
  # Box e nome da VM
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "zabbis"
```
Será definido o modo de trabalho bridge para Interface de Rede e o IP estático.
```bash
  # Rede pública com IP fixo
  config.vm.network "public_network", ip: "192.168.100.204"
```

A VM será criada no provider Virtualbox com 2Gb de memória RAM, 2 CPUs e com o nome "Zabbis".
```bash
  # Configurações do Virtualbox
  config.vm.provider "virtualbox" do |vb|
   vb.memory = "2048"
   vb.cpus = 2
   vb.name = "zabbis"
  end
```

Após a criação da VM vai executar o ShellScript.
```bash
  # Script de provisionamento
  config.vm.provision "shell", path: "provision.sh"
end
```

## Shell Script

No script criado foi escrito de forma que evitasse erros no script e paradas inesperadas, trabalhei com verificação prévia da execução do comando seguinte. Permitindo que esse script pudesse ser executado após a criação seja para atualização, ou para manutenção. Todavia é importante ressaltar que dependerá da necessidade. 

## Acessando o Zabbix Server

Para acessar o Zabbix server via navegador tem-se que colocar `http://IP_do_Server:8006/`

Caso seja a primeira vez logo após o provisionamento, deve-se seguir os passos da instalação Web, conforme documentação.

