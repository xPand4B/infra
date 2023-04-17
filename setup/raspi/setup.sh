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
    bash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/update.sh)
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
installPackages "wget git samba ntfs-3g"
# https://askubuntu.com/a/1347002
sudo apt-get purge needrestart -y
printPackageFinishedTitle $name

# ZSH
# https://github.com/ohmyzsh/ohmyzsh/wiki
#############
name="ZSH"

printPackageInstallingTitle $name
updatePackages
installPackages "zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

zshrcFile="~/.zshrc"
# Replace default theme
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="avit"/g' $zshrcFile
# Add plugins
sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' $zshrcFile
# Add default shortcuts
echo "" >> $zshrcFile
echo "###############################" >> $zshrcFile
echo "# Common shortcuts            #" >> $zshrcFile
echo "###############################" >> $zshrcFile
echo "alias ll=\"ls -la\"" >> $zshrcFile
echo "" >> $zshrcFile
echo "###############################" >> $zshrcFile
echo "# Docker                      #" >> $zshrcFile
echo "###############################" >> $zshrcFile
echo "alias dc=\"docker compose\"" >> $zshrcFile
echo "alias dcup=\"dc up -d\"" >> $zshrcFile
echo "alias dcr=\"docker compose run --rm\"" >> $zshrcFile
source ~/.zshrc

printPackageFinishedTitle $name

# DOCKER
# https://docs.docker.com/engine/install/ubuntu/
#############
name="Docker"

printPackageInstallingTitle $name
# Update the apt package index and install packages to allow apt to use a repository over HTTPS
updatePackages
installPackages "ca-certificates curl gnupg lsb-release"
# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# Use the following command to set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
updatePackages
# Try granting read permission for the Docker public key file before updating the package index
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y
# Install Docker Engine, containerd, and Docker Compose
installPackages "docker-ce docker-ce-cli containerd.io docker-compose-plugin"
sudo chmod 666 /var/run/docker.sock
printPackageFinishedTitle $name

echo "${green}"
echo "##############################################"
echo "#                Setup finished              #"
echo "##############################################"
echo "${reset}"
echo "Other usefull scripts:"
echo ""
echo "${green}Update script:${reset}"
echo -e "\tbash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/update.sh)"
echo "${green}SAMBA setup:${reset}"
echo -e "\tbash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/raspi/smb-setup.sh)"
