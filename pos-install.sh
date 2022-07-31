#!/usr/bin/env bash
#
# pos-install.sh - Instalar e configura programas no Pop!_OS 22.04 LTS
# Autor:         Israel Cunha
#

## ========================== URLS ==========================
 
GOOGLE_CHROME = "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
 
## ========================== DIRETÓRIOS ==========================
DIRETORIO_DOWNLOADS="$HOME/Downloads/pos-install-base"
FILE="/home/$USER/.config/gtk-3.0/bookmarks"

## ========================== CORES ==========================
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'

## ========================== Base de APPS ==========================
SNAP_APP=(
    oxygen-cursors
    brave
    pycharm-community
    sublime-text
    postman
    insomnia
    jupyter
    code
)

DEB_APP=(
    breeze-cursor-theme
    screenfetch
    neofetch
    atom
    sqlite3
    libsqlite3-dev
    sqlitebrowser
    nixnote2
    git
    notepadqq
    speedtest-cli
    deborphan
    pluma
    flatpak
    testdiskf
    net-tools
    traceroute
    inetutils-traceroute
    python3 
    python3-venv 
    python3-pip
    texlive texlive-latex-extra texlive-lang-portuguese
    texlive-math-extra
    texlive-full
    sl
    figlet
    cowsay
    ubuntu-wallpapers ubuntustudio-wallpapers
    gnome-tweaks
    ubuntu-restricted-extras libavcodec-extra
    libdvdcss2
    unace rar unrar p7zip-rar p7zip sharutils uudeview mpack arj cabextract lzip lunzip plzip
    hardinfo
    htop
    curl
    gnome-software-plugin-flatpak
)

FLATPACK_APP=(
    org.audacityteam.Audacity
    io.brackets.Brackets
    org.gnome.Builder
    io.dbeaver.DBeaverCommunity
    io.github.gitahead.GitAhead
    io.github.shiftey.Desktop
    com.skype.Client
    org.gnome.Firmware
    ca.desrt.dconf-editor
    org.texstudio.TeXstudio
    edu.mit.Scratch
    org.kde.kdenlive
    org.darktable.Darktable
    org.inkscape.Inkscape
    org.gimp.GIMP
    org.videolan.VLC
    com.bitwarden.desktop
    com.spotify.Client
    nz.mega.MEGAsync
    com.gitlab.davem.ClamTk
    net.xmind.ZEN
    com.github.marktext.marktext
    io.github.wereturtle.ghostwriter
    us.zoom.Zoom
    org.telegram.desktop
    com.valvesoftware.Steam
    com.discordapp.Discord
    com.jgraph.drawio.desktop
    com.visualstudio.code
    com.microsoft.Edge
)

## ========================== Instalando APP DEB ===========================
install_deb(){
    # Realiza a validação se está instaldo 
    for nome_do_programa in ${DEB_APP[@]}; do
            if ! dpkg -l | grep -q $nome_do_programa; then 
                echo "${VERDE}[INSTALANDO] - $nome_do_programa ${SEM_COR}"
                sudo apt install "$nome_do_programa" -y
            else
                echo "${VERMELHO}[INSTALADO] - $nome_do_programa ${SEM_COR}"
            fi
        done
}

download_deb(){
    echo -e "${VERDE}[INFO] - Baixando pacotes .deb${SEM_COR}"
    mkdir "$DIRETORIO_DOWNLOADS"
    wget -c "$GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"
    
    echo -e "${VERDE}[INFO] - Instalando pacotes .deb baixados${SEM_COR}"
    sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb
}

## ========================== Instalando APP SNAP ===========================
install_snap(){
    # Realiza a validação se está instaldo 
    for nome_do_programa in ${SNAP_APP[@]}; do
            if ! dpkg -l | grep -q $nome_do_programa; then 
                echo "${VERDE}[INSTALANDO] - $nome_do_programa ${SEM_COR}"
                sudo snap install "$nome_do_programa"
            else
                echo "${VERMELHO}[INSTALADO] - $nome_do_programa ${SEM_COR}"
            fi
        done
}

## ========================== Instalando APP FLATPACK ===========================
install_flatpack(){
    # Realiza a validação se está instaldo 
    for nome_do_programa in ${FLATPACK_APP[@]}; do
            if ! dpkg -l | grep -q $nome_do_programa; then 
                echo "${VERDE}[INSTALANDO] - $nome_do_programa ${SEM_COR}"
                sudo flatpak install flathub "$nome_do_programa" -y
            else
                echo "${VERMELHO}[INSTALADO] - $nome_do_programa ${SEM_COR}"
            fi
        done
}

## ========================== UPDATES ===========================

update_deb(){
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -f -y
    sudo apt-get autoremove -y
    sudo apt-get clean -y
    sudo apt-get autoclean -y
    sudo apt dist-upgrade -y
}

update_others(){
    sudo snap refresh --list -y
    flatpak update -y
}

clean_cache(){
    sudo rm -rf /home/israelcunha/.local/share/Trash/files/*
    rm -vfr ~/.thumbnails/normal/* 
    rm -f ~/.cache/thumbnails/normal/* 1
}

updates_all(){
    update_deb -y
    update_others -y
    nautilus -q
    clean_cache
}

## ========================== DOCKER INSTALL ===========================

docker_install_and_config(){
    echo "${VERDE}[INSTALANDO] - Docker ${SEM_COR}"
    curl -fsSL http://get.docker.com/ | sh
    docker --version

    echo "${VERDE}[CONFIG] - Docker ${SEM_COR}"
    sudo /etc/init.d/docker start
    sudo service docker start
    sudo docker run -ti ubuntu /bin/bash
}

## ========================== Setups ===========================
get_keypub(){
    sudo tail /home/$USER/.ssh/id_rsa.pub
}

travas_apt_deb(){
    sudo rm /var/lib/dpkg/lock-frontend
    sudo rm /var/cache/apt/archives/lock
}

add_32bits(){
    sudo dpkg --add-architecture i386
}

firewall(){
    sudo ufw status
    sudo ufw enable
    sudo ufw allow ssh
}

add_swap(){
    sudo swapon --show
    free -h
    df -h
    sudo fallocate -l 20G /swapfile
    ls -lh /swapfile
    -rw-r--r-- 1 root root 20.0G Apr 25 11:14 /swapfile
    sudo chmod 600 /swapfile
    ls -lh /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo swapon --show
    free -h
    sudo cp /etc/fstab /etc/fstab.bak
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    cat /proc/sys/vm/swappiness
    sudo sysctl vm.swappiness=10
    sudo pluma /etc/sysctl.conf
    cat /proc/sys/vm/vfs_cache_pressure
    sudo sysctl vm.vfs_cache_pressure=50
    sudo pluma /etc/sysctl.conf
}

setup(){
    echo "${VERDE}[CONFIG] - Setups ${SEM_COR}"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo dpkg-reconfigure libdvd-dpkg -y
}

testes_internet(){
    if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
        echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
        exit 1
    else
        echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
    fi
}


## ========================== INSTALL ===========================

testes_internet
update_deb
travas_apt_deb
add_32bits
install_deb
download_deb
install_snap
setup
firewall
install_flatpack
docker_install_and_config
add_swap
updates_all
get_keypub

echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"
