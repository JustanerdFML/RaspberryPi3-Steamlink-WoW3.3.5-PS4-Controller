Setting up Proxmox and Samba

#Get latest version of Proxmox
https://www.proxmox.com/de/downloads

#Make Bootable Device with e.g. Etcher
https://www.balena.io/etcher

#Boot via usb stick and install Proxmox
(check Router DNS/Server IPs for any conflicts in case of no internet)

#go to webinterface "https://servername or IP:8006"
#log in via shell
apt update
apt upgrade

nano /etc/ssh/sshd_config

#change line to:
PermitRootLogin yes

service sshd restart

nano /etc/apt/sources.list

->change

deb http://ftp.debian.org/debian bullseye main contrib
deb http://ftp.debian.org/debian bullseye-updates main contrib
# security updates
deb http://security.debian.org/debian-security bullseye-s

->to

deb http://ftp.debian.org/debian bullseye main contrib
deb http://ftp.debian.org/debian bullseye-updates main contrib
# PVE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
# security updates
deb http://security.debian.org/debian-security bullseye-security main contrib

nano /etc/apt/sources.list.d/pve-enterprise.list

->change

deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise

->to

#deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise

apt-get update
apt-get upgrade -y

apt install parted -y

lsblk
parted /dev/DEVICE(e.g.sda) "mklabel gpt"

#go to web-UI
#mount ZFS System -> DEVICE you have chosen

#Proxmox now installed/root access enabled via SSH/parted installed/reposetorys updated-changed

#choose image to download for LXC container
#make you LXC - port /24
#go to shell
#repeat

#go to host system shell
lxc-attach --name "number"
#"number" is lxc containers ID

nano /etc/ssh/sshd_config

#change line to:
PermitRootLogin yes

service sshd restart

#login via putty
mkdir mnt/DEVICE

#go to proxmox web-UI
#mount Disk into mnt/DEVICE

df -h
#check if DEVICE is mounted correct into directory

sudo apt-get install samba
adduser TEST
#setup password etc.
sudo smbpasswd -a TEST
#setup password for sambauser

sudo nano /etc/samba/smb.conf
chmod 777 /mnt/DEVICE
#setup users and directorys as you like
#chmod it as you like

sudo systemctl restart smbd.service
sudo service smbd reload

 apt-get install cifs-utils
 sudo mount -t cifs //"YOUR SERVERS IP ADRESS/folder setup in Samba conf" /mnt/DEVICE -o user=nobody
