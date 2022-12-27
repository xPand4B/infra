#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

echo "${green}"
echo "##############################################"
echo "#           Starting SAMBA setup...          #"
echo "##############################################"
echo "${reset}"

read -p "Share name: " shareName
echo ""

read -p "Share path: " sharePath
echo ""

read -p "Share user [xpand]: " shareUser
shareUser=${shareUser:-xpand}
echo ""

sudo apt install curl -y

# Update packages
bash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/update.sh)

# Install SAMBA
#############
sudo apt install samba -y

smbConfFile="/etc/samba/smb.conf"

echo "" >> $smbConfFile
echo "[$shareName]" >> $smbConfFile
echo "   path = $sharePath" >> $smbConfFile
echo "   writeable = yes" >> $smbConfFile
echo "   browsable = yes" >> $smbConfFile
echo "   create mask = 0777" >> $smbConfFile
echo "   directory mask = 0777" >> $smbConfFile
echo "   public = no" >> $smbConfFile

# Set password for user
#############
echo ""
sudo smbpasswd -a $shareUser
sudo smbpasswd -e $shareUser
echo ""

sudo service smbd restart

echo "${green}"
echo "##############################################"
echo "#            Finished SAMBA setup            #"
echo "##############################################"
echo "${reset}"
echo "Other usefull scripts:"
echo ""
echo "${green}RasPi setup:${reset}"
echo -e "\tbash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/raspi/setup.sh)"
echo "${green}Update script:${reset}"
echo -e "\tbash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/update.sh)"