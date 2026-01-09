#############################################################This is the begining of the script!###############################################
#This script is made to install and configure xrdp and to have sound over xrdp on Debian 13 - trixie
#Most of the scripts and lines belongs to: https://github.com/neutrinolabs/pulseaudio-module-xrdp;
#https://github.com/lnee94/pulseaudio-headers-xrdb and https://www.c-nergy.be
#
#next lines are used for debian 13 - trixie in order to deactivate 'suspend' | added by - itadmintech - https://www.youtube.com/@itadmintech
sudo sed -i 's/# sleep-inactive-ac-timeout=1200/sleep-inactive-ac-timeout=0/g' /etc/gdm3/greeter.dconf-defaults
sudo sed -i 's/# sleep-inactive-ac-type='\''suspend'\''/sleep-inactive-ac-type='\''nothing'\''/g' /etc/gdm3/greeter.dconf-defaults
#next lines are used in order to install xrdp | and are added by - itadmintech - https://www.youtube.com/@itadmintech
sudo apt install xrdp -y
sudo adduser xrdp ssl-cert
sudo systemctl enable xrdp
#next scripts are used from official neutrionlabs https://github.com/neutrinolabs/pulseaudio-module-xrdp/wiki/Build-on-Debian-or-Ubuntu
#although the .deb file is from a 3rd party which is not affiliated to the project https://github.com/lnee94/pulseaudio-headers-xrdb
cd ~/Downloads
wget https://github.com/lnee94/pulseaudio-headers-xrdb/releases/download/v1.0/pulseaudio-headers-xrdb.deb
sudo dpkg -i pulseaudio-headers-xrdb.deb
sudo apt install build-essential dpkg-dev libpulse-dev git autoconf libtool libltdl-dev -y
cd ~
git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git
cd pulseaudio-module-xrdp
#the next 2 lines to modify "install_pulseaudio_sources_apt.sh" are added by - itadmintech - https://www.youtube.com/@itadmintech
sed -i 's/Debian-12/Debian-13/g' scripts/install_pulseaudio_sources_apt.sh
sed -i 's/bookworm/trixie/g' scripts/install_pulseaudio_sources_apt.sh
scripts/install_pulseaudio_sources_apt_wrapper.sh
./bootstrap && ./configure PULSE_DIR=$HOME/pulseaudio.src
make
sudo make install
#the script from below belongs to "https://www.c-nergy.be"
cd ~/Downloads
wget https://www.c-nergy.be/downloads/xRDP/xrdp-installer-1.5.4.zip
unzip xrdp-installer-1.5.4.zip
chmod +x  xrdp-installer-1.5.4.sh
./xrdp-installer-1.5.4.sh -s
rm ~/Downloads/xrdp-installer-1.5.4.zip
rm ~/Downloads/xrdp-installer-1.5.4.sh
rm ~/Downloads/pulseaudio-headers-xrdb.deb
rm ~/pulseaudio.src -r
rm ~/pulseaudio-module-xrdp -f -r
###############################################################This is the end of the script!##################################################
