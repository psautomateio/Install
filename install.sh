#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
package="curl wget software-properties-common git nano htop mc lshw zip unzip dialog sudo"

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  NOTICE: PSautomate Version 0.2.0 - Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
By installing, you agreeing to the terms and conditions of the GNUv3 License!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please Standby!
EOF
#sleep 4

# Delete If it Exist for Cloning
if [ -e "/psa/blitz" ]; then rm -rf /psa/blitz; fi
if [ -e "/psa/stage" ]; then rm -rf /psa/stage; fi
rm -rf /psa/stage/place.holder 1>/dev/null 2>&1

# Make Critical Folders
mkdir -p /psa /psa/logs /psa/data /psa/stage /psa/logs /psa/tmp /psa/var/install
chmod 775 /psa /psa/logs /psa/data /psa/stage /psa/logs /psa/tmp /psa/var/install
chown 1000:1000 /psa /psa/logs /psa/data /psa/stage /psa/logs /psa/tmp /psa/var/install
rm -rf /psa/var/first.update 1>/dev/null 2>&1

# Clone the Program to Stage for Installation
git clone -b 0.2.0 --single-branch https://github.com/psautomateio/Stage.git /psa/stage

# Checking to See if the Installer ever Installed Python; if so... skip
var37="/psa/var/python.firstime"
if [ ! -e "${var37}" ]; then
  bash /psa/stage/pyansible.sh
  touch /psa/var/python.firstime
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Executing a Base Install - Please Standby
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
apt-get install lsb-release -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get install software-properties-common -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Updating the Server - Please Standby (Can Take 1-2 Minutes)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

fullrel=$(lsb_release -sd)
osname=$(lsb_release -si)
relno=$(lsb_release -sr)
relno=$(printf "%.0f\n" "$relno")
hostname=$(hostname -I | awk '{print $1}')
# add repo

if echo $osname "Debian" &>/dev/null; then
	add-apt-repository main 2>&1 >> /dev/null
	add-apt-repository non-free 2>&1 >> /dev/null
	add-apt-repository contrib 2>&1 >> /dev/null
elif echo $osname "Ubuntu" &>/dev/null; then
	add-apt-repository main 2>&1 >> /dev/null
	add-apt-repository universe 2>&1 >> /dev/null
	add-apt-repository restricted 2>&1 >> /dev/null
	add-apt-repository multiverse 2>&1 >> /dev/null
elif echo $osname "Rasbian" "Fedora" "CentOS"; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ System Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Supported: UB 16/18.04 ~ LTS/SERVER and Debian 9+
This server may not be supported due to having the incorrect OS detected!

For more information, read:
https://pgblitz.com/threads/pg-install-instructions.243/
EOF
  sleep 10
fi

apt-get update -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get upgrade -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get dist-upgrade -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get autoremove -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get install $package -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Finished - Basic Updates
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

ansible-playbook /psa/stage/clone.yml
bash /psa/stage/psacloner/solo/update.sh

# Copy Starting Commands for PSAutomate
path="/psa/stage/alias"
cp -t /bin $path/psautomate $path/psa $path/psablitz

# Verifying the Commands Installed
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Verifiying Started Commands Installed via @ /bin
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Installation fails if the pgblitz command is not in the correct location
file="/bin/psablitz"
if [ ! -e "$file" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! The PSAutomate Installer Failed ~ http://psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please Reinstall PSAutomate by running the Command Again! This step is to
ensure that everything is working prior to the install!
Ensure that you utilizing the correct versions of linux as described on
the installation page!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EXITING!!!
EOF
exit
fi

# If nothing failed, notify the user that installation passed!
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASSED! The PSAutomate Command Installed! ~ http://psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# creates a blank var; if this executes; psautomate will go through the install process
touch /psa/var/new.install

chmod 775 /bin/psautomate /bin/psablitz /bin/psa
chown 1000:1000 /bin/psautomate /bin/psablitz /bin/psa

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Start AnyTime By Typing >>> psablitz [or] psautomate [or] psa
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
