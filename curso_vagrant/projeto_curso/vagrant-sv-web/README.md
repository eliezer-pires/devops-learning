# Projeto 3 - Vagrant + Web Server

## Descrição
Neste projeto vamos provisionar uma VM utilizando o Vagrant iremos atualizar e instalar o nginx, através de um shell script. Além disso, iremos sincronizar uma pasta do host com o guest sendo a pasta /var/www/html do guest. Para que o site possa ser criado/modificado automaticamente no server quando forem feitas as alterações.

## Objetivos
- Praticar o uso de Vagrant com provisionamento via shell script.
- Automatizar a instalação do Nginx e a configuração de um servidor web.
- Sincronizar pastas entre o host e a máquina virtual para hospedar o site.
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
apt-get install -y nginx
```
Reiniciando o Serviço do nginx
```bash
systemctl restart nginx
```

## Acessando o Site

Em seu navegador digite 192.168.100.203 e a página do cep ja irá aparecer.

## Sincronização de Pastas

A pasta `/var/www/html` do servidor web(guest) é o espelho da pasta `sync` do host. Desta forma, qualquer modificação, criação ou deleção de arquivos ou pastas será vista tanto no host como o guest.

## Links

GitHub:

https://github.com/eliezer-pires/

Linkedin:

https://www.linkedin.com/in/eliezer-pires-it-aws-cloud-sre-devops/