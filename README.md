# Raspberry Pi Configurator

## About
The Raspberry Pi Configurator is a script I created to simplify reproducing my Raspberry Pi project videos from YouTube. Instead of manually typing commands to install various pieces of software you just need to download and run the script and select the desired setup from the menu.

## Supported Automated Installs
- [PiGPIO](https://github.com/joan2937/pigpio)
- [PiGPIO](https://github.com/joan2937/pigpio) & [Node.js v12](https://github.com/nodesource/distributions/blob/master/README.md)
- [Raspberry Pi - Homekit LED Strip](https://github.com/basementmaker/raspberrypi-homekit-led-strip)
- [Raspberry Pi - Homekit RGB LED Strip](https://github.com/basementmaker/raspberrypi-homekit-rgb-led-strip)

## How to use

### Using WGET
```console
wget https://raw.githubusercontent.com/basementmaker/raspberrypi-configurator/master/pi-config.sh
chmod +x pi-config.sh
./pi-config.sh
```
or use the shorter URL version:
```console
wget https://basementmaker.net/pi-config.sh
chmod +x pi-config.sh
./pi-config.sh
```

### Copy & Paste
Connect to remote Raspberry Pi, then on the command line:
```console
vi pi-config.sh
(copy and then paste pi-config.sh's code)
:w
:q
chmod +x pi-config.sh
./pi-config.sh
```

## YouTube Channel
[BasementMaker](https://www.youtube.com/basementmaker)
