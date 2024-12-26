# Projeto 2 - Criar uma VM pelo Vagrant e Configurar via Shell Script

## Descrição
Este projeto é o segundo projeto do curso do Iago Ferreira nele irei provisionar uma VM com o Vagrant com os requisitos específicos (2Gb de RAM e 2 núcleo do CPU Ubuntu 24.04) irei instalar e configurar via Shell Script alguns pacotes.

## Objetivos:

- Praticar o uso de Vagrant com provisionamento via shell script.
- Automatizar a instalação de pacotes e a criação de um usuário na máquina virtual.
- Treinar Git para subir o projeto no GitHub.

## Instruções para Iniciar a VM
Para que consiga utilizar este projeto é necessário ter instalado e configurado o Vagrant e algum virtualizador como virtualbox, vmware e etc. Todavia para teste foi utilizado o VirtualBox.

- [ ] Clone este repositório.
- [ ] Dentro da pasta execute o comando: `vagrant up`
- [ ] Para acessar via SSH a VM: `vagrant ssh`

## Provisionamento
Ao rodar o comando `vagrant up` irá subir a VM e conforme script será instalado os pacotes e criado o usuário.

### Entendendo o Script

Atualizando o Ubuntu.
```bash
apt-get update -y
apt-get upgrade -y
```
Instalando os pacotes.
```bash
apt-get install -y vim curl telnet unzip wget net-tools htop nmap
```
Criando usuário.
```bash
adduser eliezerpires
```

## Verificação:
Para verificar se foi tudo criado e instalado corretamente acesse a vm usando `vagrant ssh` e verifique com os seguintes comandos:

- Verificando criação do usuário:
```bash
cat /etc/passwd | grep eliezerpires
```
- Verificando instalação dos pacotes:
```bash
dpkg -l | grep -E "vim|curl|telnet|unzip|wget|net-tools|htop|nmap"
```

## Links

GitHub:

https://github.com/eliezer-pires/

Linkedin:

https://www.linkedin.com/in/eliezer-pires-it-aws-cloud-sre-devops/
