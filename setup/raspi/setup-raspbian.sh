#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

echo "${green}"
echo "##############################################"
echo "#                                            #"
echo "#        This script will install all        #"
echo "# default packages required for a cool setup #"
echo "#                                            #"
echo "##############################################"
echo "${reset}"

function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}

function printPackageInstallingTitle() {
    echo ""
	echo "${green}Installing $1...${reset}"
	echo ""
}

function printPackageFinishedTitle() {
    echo ""
	echo "${green}Finished $1...${reset}"
	echo ""
}

function updatePackages() {
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt --fix-broken install
}

function installPackages() {
    sudo apt install $1 -y
}

if [ "no" == $(ask_yes_or_no "Are you sure?") ]
then
    echo "${red}Setup canceled${reset}"
    echo ""
    exit 0
fi

echo "${green}"
echo "##############################################"
echo "#               Starting setup...            #"
echo "##############################################"
echo "${reset}"

# Basic Setup
#############
name="Basic packages"

printPackageInstallingTitle $name
installPackages "curl"
updatePackages
installPackages "wget git samba ntfs-3g unzip"
installPackages "i2c-tools build-essential raspberrypi-kernel-headers"

sudo usermod -aG dialout $USER

cd /tmp
wget https://project-downloads.drogon.net/wiringpi-latest.deb
sudo dpkg -i wiringpi-latest.deb
updatePackages

printPackageFinishedTitle $name

# DOCKER
# https://docs.docker.com/engine/install/ubuntu/
#############
name="Docker"

printPackageInstallingTitle $name

updatePackages

cd
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip
sudo pip3 install docker-compose
sudo chmod 666 /var/run/docker.sock
sudo systemctl enable docker

updatePackages

sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker
docker version

printPackageFinishedTitle $name

echo "${green}"
echo "##############################################"
echo "#                Setup finished              #"
echo "##############################################"
echo ""
echo "A reboot is highly recommended !"
echo "${reset}"
