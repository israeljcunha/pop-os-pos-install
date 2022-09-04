#!/usr/bin/env bash

#####	NOME:				upsys
#####	VERSÃO:				0.1
#####	DESCRIÇÃO:			Realiza o update do pacotes do sistema 
#####	DATA DA CRIAÇÃO:	04/09/2022
#####	ESCRITO POR:		Israel CUnha
#####	E-MAIL:				israelcunhamail@gmail.com
#####	DISTRO:				PopOS! 22.04 (jammy)
#####	LICENÇA:			GPLv3


## ========================== CORES ==========================
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
AZUL='\e[1;96m'
AMARELO='\e[1;93m'
SEM_COR='\e[0m'


## ========================== FUNCOES ==========================
update_deb() {
 sudo apt clean -y
 sudo apt-get update -y
 sudo apt-get upgrade -y
 sudo dpkg --configure -a
 sudo apt install -f -y
 sudo apt full-upgrade -y
 sudo apt autoremove --purge
 sudo apt-get autoclean -y
}

clean_cache(){
    sudo rm -rf /home/israelcunha/.local/share/Trash/files/*
    rm -vfr ~/.thumbnails/normal/* 
    rm -f ~/.cache/thumbnails/normal/* 1
}

snap_normal() {
 sudo snap refresh --list
}


flathub () { 
 sudo flatpak update -y
}

extensions(){
 gnome-shell-extension-installer  --yes --update --restart-shell
}

msg(){
 echo -e "${VERDE}=================================================================${SEM_COR}"
 echo -e "${VERDE}[INFO]\t $1 ${SEM_COR}"
 echo -e "${VERDE}=================================================================${SEM_COR}"
}

testes_internet(){
    if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
    	echo -e "${VERMELHO}====================================================================================${SEM_COR}"
        echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
        echo -e "${VERMELHO}====================================================================================${SEM_COR}"
        exit 1
    else
    	echo -e "${VERDE}=================================================================${SEM_COR}"
        echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
        echo -e "${VERDE}=================================================================${SEM_COR}"
    fi
}

testes_internet
msg "Update PopOS and Libs"
update_deb
msg "Update SNAP"
snap_normal
msg "Update Flatpacks"
flathub
msg "Update Extension"
extensions
msg "Limpando Caches"
clean_cache
msg "Script finalizado, instalação concluída! :)"
