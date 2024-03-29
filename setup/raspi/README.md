# RasPi Setup

## Generate SSH key
```bash
ssh-keygen -t rsa
```

## Add root user (Ubuntu)
```bash
# Creating Users
sudo adduser USERNAME

# To set the password of the new user, enter the following command:
sudo passwd USERNAME

# Assigning Sudo Rights to a User
sudo usermod -aG sudo USERNAME
```

## How to install
```bash
# RasPi Setup
   # Ubuntu Server
   bash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/raspi/setup.sh)
   
   # Raspbian
   bash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/raspi/setup-raspbian.sh)

# SAMBA Setup
bash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/raspi/smb-setup.sh)

# Package Update
bash <(curl -s https://raw.githubusercontent.com/xPand4B/infra/main/setup/update.sh)
```

## How to mount NTFS drive
```bash
# Install package
sudo apt install ntfs-3g

# Find correct drive
sudo fdisk -l

# Mount drive
sudo mount ntfs /dev/{NAME} /mnt/{DESTINATION}
```

### Auto-mount drive
```bash
# Get drive UUID
sudo blkid

# Set auto-mount
sudo nano /etc/fstab

# UUID=<uuid-of-your-drive>  <mount-point>  <file-system-type>  <mount-option>  <dump>  <pass>
UUID=<uuid-of-ntfs-file-system>   /mnt/ntfs    ntfs    defaults   0   2

sudo mount -a
```
