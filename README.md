# RaspberryPi3-Steamlink-WoW3.3.5-PS4-Controller
RaspberryPi3 Steamlink WoW3.3.5 with PS4 Controller

First of all, I like gaming and have no idea about setting up or programming real programs.
But since i started this Project I realised how difficult some things were - me being a IT Noob.
So I want to share my experience with those who maybe want to set up a similar Project like this one.

## Introduction:

Aim was to set up a RaspberryPi 3b+ as a Steamlink device to stream Games to my living room TV.
It should be Controlled by a PS4 Controller (or any controller of your choice)

Project is still unfinished but I'm pretty satisfied with where I am now, updates will follow

## Prerequisite:

-Raspberry Pi 3b+ 

[-Debian Buster (Debian 10)](https://downloads.raspberrypi.org/raspios_oldstable_armhf/images/raspios_oldstable_armhf-2022-09-26/2022-09-22-raspios-buster-armhf.img.xz)
is required since Bullseye (Debian 11) doesent bring the needed DirectX support for Steamlink, Buster Desktop Version is required

[-Raspberry Pi Imager](https://downloads.raspberrypi.org/imager/imager_latest.exe)

#### (Optional):

[-Power Control Board for Rasp Pi for save shutdown sequenze](https://de.elv.com/elv-power-controller-fuer-raspberry-pi-rpi-pc-komplettbausatz-153537) (this is a user friendly way IMO to avoid SD-Card Corruption, but totaly optional for function, Shutdownscript/Manual comes with the hardware)


-Controller of your choice e.g. PS4, XboxOne, PS5 etc.
(For comfort I can Recommend buying a [original PS4 dongle](https://www.mediamarkt.at/de/product/_sony-dualshock-4-usb-wireless-adaptor-1523552.html), Bluetooth pairing is also possible from what I wrote but maybe a bit unreliable/complicated)


Setting up the RaspPi 3b+ 1gb for Steamlink:

    apt-get update & upgrade

#### (Optional): 

installing xrdp Remote Desktop (ftp also if needed)

    sudo apt-get install xrdp
    
    sudo systemctl status xrdp

## installing steamlink

    apt install steamlink
    
    steamlink

adding steamlink to autostart

    sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
    
added line

    @steamlink

increasing gpu_mem to avoid Steamlink Error

    sudo nano /boot/config.txt
    
added line

    gpu_mem=128

(optional:) since I use my WiFi and had bandwidth problems, shutting down power-managment kind of fixed it

    iwconfig
    
    sudo nano /etc/rc.local
    
added Line

    iwconfig wlan0 power off

avoiding errors on boot in case steamlink boots before connection to network has been made, disable HDMI Blanking

    sudo raspi-config
    
    -> advanced -> wait for lan on boot -> enable
    -> display options -> disable HDMI Blanking

After configuring the Pi you can go ahead and pair Controller to your Rasp and Steamlink to Steam running on your Windows PC

For Non-Steam Games you can set up a link into the Library.
In this Case WoW 3.3.5

### Autologin WoW 3.3.5

#### Prerequisite:

-[AutoIt](https://www.autoitscript.com/cgi-bin/getfile.pl?autoit3/autoit-v3-setup.zip)

For Autologin I wrote a primitive Script, feel free to change it as you like

Accountname needs to be **your account name**, 

accountpassword **your password**, 

Path to wow is the **wow.exe file location** (.e.g. C:\Programs\World of Warcraft 3.3.5a\WoW.exe)


in AutoIt you need to set ("") without " script wont work

    Autologin ()
    Func Autologin ()
      Run("Pathtowow")
      WinWaitActive ("World")
      Sleep(7000)
      Send("Accountname")
      Send("{TAB}")
      Send("Accountpassword")
      Send("{ENTER}")
    EndFunc

now the script needs to be compiled into a **.exe** file to be executeable for steam
right click and compile it to .exe

insert to steam library via games-> add non steam game and select the .exe you made

keybindings I assigned via Steam Controller interface instead of DS4 since it doesent work with steamlink (idk how)

for my controller I used this [guide:](https://www.reddit.com/r/wowservers/comments/q3hrnv/consolemod_alternative_controller_support_for_335/)

better download this [CameraKeys](https://www.wowinterface.com/downloads/info4448-CameraKeys.html) than the one mentioned in the guide since its not compatible with 3.3.5

Enjoy Playing streamed via Rasp Streamlink with your controller on your couch :)

If you have any suggestions/issues/improvements feel free to comment!
