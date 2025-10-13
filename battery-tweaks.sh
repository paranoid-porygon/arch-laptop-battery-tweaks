#!/bin/bash

######################## battery-tweaks.sh #########################
# List of tweaks I attempted to get reasonable battery life out of #
# the Star Labs Starlite mk IV.                                    #
#                                                                  #
# This script assumes that you understand what you are changing in #
# each config file and not to just blindly copy every change. I    #
# use vimdiff with my own recommended configs to give suggestions, #
# but ultimately you are responsible for not borking your machine. #
####################################################################

####### Firmware Update #######

# update firmware
sudo pacman -S fwupd flashrom linux-firmware git wget vim
# there's a bug with the current fwupd package so use 2.0.13-1 instead
sudo rm /var/lib/fwupd/pending.db
sudo pacman -U https://archive.archlinux.org/packages/f/fwupd/fwupd-2.0.13-1-x86_86.pkg.tar.zst
fwupdmgr refresh
fwupdmgr update


######## Driver Tweaks ########

# disable periodic scans on wlan0
#sudo vim /etc/iwd/main.conf
# [General]
# EnableNetworkConfiguration=true
#
# [Scan]
# DisablePeriodicScan=true
# DisableRoamingScan=true
sudo touch /etc/iwd/main.conf
sudo vimdiff ./etc/iwd/main.conf /etc/iwd/main.conf

# set iwlwifi module options
sudo touch /etc/modprob.d/iwlwifi.conf
sudo vimdiff ./etc/modprob.d/iwlwifi.conf /etc/modprob.d/iwlwifi.conf

# disable wake on lan
#sudo vim /etc/udev/rules.d/81-wifi-powersave.rules
# ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", RUN+="/usr/bin/iw dev $name set power_save on"
sudo touch /etc/udev/rules.d/81-wifi-powersave.rules
sudo vimdiff ./etc/udev/rules.d/81-wifi-powersave.rules /etc/udev/rules.d/81-wifi-powersave.rules

# disable bluetooth
#sudo vim /etc/bluetooth/main.conf
# [Policy]
# AutoEnable=false
sudo touch /etc/bluetooth/main.conf
sudo vimdiff ./etc/bluetooth/main.conf /etc/bluetooth/main.conf

# blacklist btusb modules
#sudo vim /etc/modprobe.d/blacklist-custom.conf
# blacklist btusb
# blacklist bluetooth
sudo touch /etc/modprobe.d/blacklist-custom.conf
sudo vimdiff ./etc/modprobe.d/blacklist-custom.conf /etc/modprobe.d/blacklist-custom.conf


#### Power Management Utilities ####

# install various tools
sudo pacman -S upower cpupower powertop xset

# add intel_pstate=disabled to /etc/default/grub
# note: the acpi driver was recommended over the intel-pstate driver
# however this may not be beneficial. Test accordingly.
#sudo vim /etc/default/grub
sudo touch /etc/default/grub
sudo vimdiff ./etc/default/grub /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# install and enable auto-cpufreq from the AUR
yay -S auto-cpufreq
# manually create config
#vim ~/.config/auto-cpufreq/auto-cpufreq.conf
touch ~/.config/auto-cpufreq/auto-cpufreq.conf
vimdiff ./.config/auto-cpufreq/auto-cpufreq.conf ~/.config/auto-cpufreq/auto-cpufreq.conf
sudo systemctl enable --now auto-cpufreq

# install and enable laptop-mode-tools from the AUR
yay -S laptop-mode-tools
# change default config
sudo vimdiff ./etc/laptop-mode/laptop-mode.conf /etc/laptop-mode/laptop-mode.conf
# specify optional configs
#sudo vim /etc/laptop-mode/conf.d/ac97-powersave.conf  # audio devices
#sudo vim /etc/laptop-mode/conf.d/intel-hda-powersave.conf  # audio devices
#sudo vim /etc/laptop-mode/conf.d/intel-sata-powermgmt.conf
#sudo vim /etc/laptop-mode/conf.d/lcd-brightness.conf
#sudo vim /etc/laptop-mode/conf.d/nmi-watchdog.conf
#sudo vim /etc/laptop-mode/conf.d/pcie-asmp.conf
#sudo vim /etc/laptop-mode/conf.d/runtime-pm.conf  # might need to blacklist keyboard or lcd
#sudo vim /etc/laptop-mode/conf.d/sched-mc-power-savings.conf
#sudo vim /etc/laptop-mode/conf.d/sched-smt-power-savings.conf
#sudo vim /etc/laptop-mode/conf.d/wireless-power.conf
#sudo vim /etc/laptop-mode/conf.d/wireless-iwl-power.conf
sudo cp -r ./etc/laptop-mode/conf.d /etc/laptop-mode/.
sudo systemctl enable --now laptop-mode
