#!/bin/bash

###########################
# To use:
# chmod +x pi-config.sh
# ./pi-config.sh
###########################

# Functions
function updateRaspbian {
  echo ""
  echo ""
  echo "---------------------------------------------------------"
  echo "Setting up your Raspberry Pi"
  echo "---------------------------------------------------------"
  echo ""

  echo ""
  echo "Updating Raspbian ..."
  echo ""
  sudo apt update
  sudo apt full-upgrade -y
}

# Vars
doneMessage=""
optionMainMenu=
optionVideoMenu=
optionStandardMenu=

clear

echo ""
echo "---------------------------------------------------------"
echo "BasementMaker Raspberry Pi Configurator"
echo "Version: 1.2.0 - BETA"
echo ""
echo "Warning: This file should only be ran on a Raspberry Pi"
echo "running a recent version of Raspbian. Additionally, this"
echo "script assumes a fresh installation of Raspbian without"
echo "other software installed & that you are running as the"
echo "default pi user."
echo ""
echo "Note: This script has only been tested on Raspberry Pi 3s"
echo "and not yet on Raspberry Pi 4."
echo ""
echo "Website:"
echo "https://github.com/basementmaker/raspberrypi-configurator"
echo "---------------------------------------------------------"
echo ""

echo ""
echo "Your Raspberry Pi Hardware:"
cat /sys/firmware/devicetree/base/model
echo ""
echo ""
echo "Raspbian Version:"
awk -F= '$1=="PRETTY_NAME" { print $2 ;}' /etc/os-release
echo ""

echo ""
echo "Menu:"
echo "1 -> Video Projects"
echo "2 -> Standard Setups"
echo "x -> Exit"
read -p "Choose One: " -n 1 optionMainMenu

if [ $optionMainMenu == "1" ]; then
  echo ""
  echo ""
  echo "Menu:"
  echo "1 -> Raspberry Pi - HomeKit Controlled Single Color LED Strip [May 2020]"
  echo "2 -> Raspberry Pi - HomeKit Controlled RGB LED Strip (Updated) [May 2020]"
  echo "x -> Exit"
  read -p "Choose One: " -n 1 optionVideoMenu
elif [ $optionMainMenu == "2" ]; then
  echo ""
  echo ""
  echo "Menu:"
  echo "1 -> PiGPIO"
  echo "2 -> PiGPIO & Node.js v12"
  echo "3 -> PM2 (Requires Node.js)"
  echo "x -> Exit"
  read -p "Choose One: " -n 1 optionStandardMenu
else
  clear
  exit 0
fi

#
# Video Setups
#
#
if [ "$optionVideoMenu" == "1" ]; then
  updateRaspbian
  echo ""
  echo "Installing Node.js & PiGPIO ..."
  echo ""
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt install -y nodejs git build-essential python-setuptools python3-setuptools
  wget https://github.com/joan2937/pigpio/archive/master.zip && unzip master.zip && cd pigpio-master && make && sudo make install
  cd ..
  echo ""
  echo "Fetching BasementMaker project code ..."
  echo ""
  git clone https://github.com/basementmaker/raspberrypi-homekit-led-strip.git
  cd raspberrypi-homekit-led-strip
  npm install
  doneMessage="Type: cd raspberrypi-homekit-led-strip; sudo npm start"
elif [ "$optionVideoMenu" == "2" ]; then
  updateRaspbian
  echo ""
  echo "Installing Node.js & PiGPIO ..."
  echo ""
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt install -y nodejs git build-essential python-setuptools python3-setuptools
  wget https://github.com/joan2937/pigpio/archive/master.zip && unzip master.zip && cd pigpio-master && make && sudo make install
  cd ..
  echo ""
  echo "Fetching BasementMaker project code ..."
  echo ""
  git clone https://github.com/basementmaker/raspberrypi-homekit-rgb-led-strip.git
  cd raspberrypi-homekit-rgb-led-strip
  npm install
  doneMessage="Type: cd raspberrypi-homekit-rgb-led-strip; sudo npm start"
elif [ "$optionVideoMenu" == "x" ]; then
  clear
  exit 0
fi

#
# Standard Setups
#
#
if [ "$optionStandardMenu" == "1" ]; then
  updateRaspbian
  echo ""
  echo "Installing PiGPIO ..."
  echo ""
  sudo apt install -y build-essential python-setuptools python3-setuptools
  wget https://github.com/joan2937/pigpio/archive/master.zip && unzip master.zip && cd pigpio-master && make && sudo make install
elif [ "$optionStandardMenu" == "2" ]; then
  updateRaspbian
  echo ""
  echo "Installing Node.js & PiGPIO ..."
  echo ""
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt install -y nodejs build-essential python-setuptools python3-setuptools
  wget https://github.com/joan2937/pigpio/archive/master.zip && unzip master.zip && cd pigpio-master && make && sudo make install
elif [ "$optionStandardMenu" == "3" ]; then
  updateRaspbian
  echo ""
  echo "Installing PM2 ..."
  echo ""
  sudo npm install pm2@latest -g
  sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u pi --hp /home/pi
  pm2 list
elif [ "$optionStandardMenu" == "x" ]; then
  clear
  exit 0
fi

sudo apt clean
clear

echo ""
echo "Your Raspberry Pi IP Addresses:"
echo "Note: Blank means no connection."
echo ""
echo "Wired IP Address:"
ip addr show eth0 | grep -Po 'inet \K[\d.]+'
echo ""
echo "Wireless IP Address:"
ip addr show wlan0 | grep -Po 'inet \K[\d.]+'
echo ""

sshStatus=$(systemctl is-active ssh)
if [ $sshStatus != "active" ]; then
echo "SSH is disabled, would you like to enable it for remote connectivity?"
read -p "Enter y or n: " -n 1 optionSSH
echo ""
    if [ $optionSSH == "y" ]; then
        sudo systemctl enable ssh
        sudo systemctl start ssh
        echo ""
        echo "SSH should now be active. In the future if you wish to turn it off and disable it, run these commands:"
        echo "sudo systemctl stop ssh"
        echo "sudo systemctl disable ssh"
    fi
fi

echo ""
echo "Finished!"
echo ""
echo $doneMessage
