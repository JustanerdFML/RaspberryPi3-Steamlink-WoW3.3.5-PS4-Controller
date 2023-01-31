# Setting up Proxmox and Samba

### Get latest version of Proxmox

https://www.proxmox.com/de/downloads

### Make Bootable Device with e.g. Etcher

https://www.balena.io/etcher

### Boot via usb stick and install Proxmox
(check Router DNS/Server IPs for any conflicts in case of no internet)

go to webinterface "https://servername or IP:8006"
log in via shell

Allowing Root Access via SSH

         nano /etc/ssh/sshd_config

change line to:

         PermitRootLogin yes
         
Restard SSH Service

         service sshd restart

Changing source lists

         nano /etc/apt/sources.list

from

         deb http://ftp.debian.org/debian bullseye main contrib
         deb http://ftp.debian.org/debian bullseye-updates main contrib
         # security updates
         deb http://security.debian.org/debian-security bullseye-s

to

         deb http://ftp.debian.org/debian bullseye main contrib
         deb http://ftp.debian.org/debian bullseye-updates main contrib
         # PVE pve-no-subscription repository provided by proxmox.com,
         # NOT recommended for production use
         deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
         # security updates
         deb http://security.debian.org/debian-security bullseye-security main contrib
         
Reposetry non-sub change

         nano /etc/apt/sources.list.d/pve-enterprise.list

from

         deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise

to

         #deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise
         
do a reboot

         sudo reboot

Updating Repos

         apt-get update
         apt-get upgrade -y

Configuring HDD

         apt install parted -y

         lsblk
         
Format/Partition

         parted /dev/DEVICE(e.g.sda) "mklabel gpt"

go to web-UI
mount ZFS System -> DEVICE you have chosen

### Proxmox now installed/root access enabled via SSH/parted installed/reposetorys updated-changed

## Configuring/Attaching LXC-Container to Proxmox

choose image to download for LXC container
make you LXC - port /24

go to host system shell

         lxc-attach --name "number"
         
"number" is lxc containers ID

Repeat Allowing Root Access via SSH

         nano /etc/ssh/sshd_config

change line to:

         PermitRootLogin yes
         
Restard SSH Service

         service sshd restart

login via putty

         mkdir mnt/DEVICE

go to proxmox web-UI

shutdown container

mount Disk into mnt/DEVICE

start container

check if DEVICE is mounted correct into directory

         df -h
## Setting up Samba         
Installing Samba

         sudo apt-get install samba
         
Setting up Unix-User

         adduser TEST

Setting up Samba-User password

         sudo smbpasswd -a TEST
         
Configuring smb.conf

         sudo nano /etc/samba/smb.conf
         chmod 777 /mnt/DEVICE
         
setup users and directorys as you like
chmod directory as you like

Restart smbd.service

         sudo systemctl restart smbd.service
         sudo service smbd reload

## Mounting Samba network storage to Raspberry Pi

(temporally) Mounting Samba Network drive into Raspberry

         apt-get install cifs-utils
         sudo mount -t cifs //"YOUR SERVERS IP ADRESS/folder setup in Samba conf" /mnt/DEVICE -o user=nobody
         sudo mount -t cifs -o username=user,password=yourpassword,vers=2.0 //serverip/public /'path where Samba should be mounted'

permanently mounting Samba Network drive into Raspberry

         sudo nano /etc/fstab
insert into conf:

         //'IP of Samba server'/'sambadrive'	/raspberry/folder cifs	defaults,noauto,nofail,username=TEST,password=PASSWORD,x-systemd.automount,x-systemd.requires=network-online.target	0	0


## Backup of Pi via Samba Mounted Network storage

Find Device

         lsblk
         df -l
         
Run Backup
SD_Card e.g. mmcblk0

         sudo dd bs=4M if=/dev/SD_Card of=/media/sambadrive/imagename.img 
         status=progress

Use PiShrink to make image smaller (first download, 2nd make it executeable, 3rd move to /usr/local/bin, 4th execute script)

         wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
         chmod +x pishrink.sh
         sudo mv pishrink.sh /usr/local/bin
         sudo pishrink.sh /sambamountlocation/backup.img /sambamountlocation/backup_small.img
