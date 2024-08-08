#!/usr/bin/env sh
# KMS-on-pfSense Installer
# by Meliton Hinojosa
# Installer for KMS server on your pfSense appliance
#
# Install with this command (from your pfSense appliance):
#
# curl -L meliton.github.io/kms2pfsense.sh | sh

getPFspecs()
{
# Notice to gather specs
echo 
echo "======= CHECKING for compatible device"

# check for FreeBSD OS
case "$(uname -s 2>/dev/null | grep -c "FreeBSD" )" in
   1) echo " PASSED - Running on FreeBSD" ;;
   *) echo " FAILED - Wrong OS type, not FreeBSD" ; 
   exit 1 ;;
esac

# check for amd64 hardware
case "$(uname -m 2>/dev/null | grep -c "amd64" )" in
   1) echo " PASSED - Hardware platform is amd64" ;;
   *) echo " FAILED - Wrong Hardware type, not amd64" ; 
   exit 1 ;;
esac

# check for OS version 11.xx through 14.xx
case "$(uname -r 2>/dev/null | grep -c "11.\|12.\|13.\|14.|15." )" in
   1) echo " PASSED - Operating system 11.xx or higher" ;;
   *) echo " FAILED - Wrong OS version. Not at least 11.xx" ; 
   exit 1 ;;
esac

# check for kms server dependancy
case "$(ls /libexec/ld-elf.so.1 2>/dev/null | grep -c "ld" )" in
   1) echo " PASSED - KMS server dependancy OK" ;;
   *) echo " FAILED - KMS server dependancy missing" ; 
   exit 1 ;;
esac

echo " SUCCESS! You are running a compatible pfSense appliance" 
}

getUserStatus()
{
# Checks if user is root
echo "First we will check if you are running as root"
case "$(id -u | grep -c "0")" in
    1) echo " PASSED - Running as root" ;;
    *) echo " FAILED - Installation must be run as ROOT user" ; 
    exit 1 ;;
esac 
}

copyKMS()
{
echo " "
echo "======= COPYING KMS binary"
echo " COPYING KMS server to /bin directory"
curl -o /bin/vlmcsd -sS https://raw.githubusercontent.com/meliton/KMS-on-pfSense/master/bin/vlmcsd
}

createStartup()
{
echo " "
echo "======= WRITING startup script"
echo " WRITING startup script as /usr/local/etc/rc.d/kms_start.sh"
echo "#!/bin/sh" > /usr/local/etc/rc.d/kms_start.sh
echo "#" >> /usr/local/etc/rc.d/kms_start.sh
echo "# startup script on bootup for KMS server" >> /usr/local/etc/rc.d/kms_start.sh
echo "# 30 day renewal, 7 day failed retry interval" >> /usr/local/etc/rc.d/kms_start.sh
echo "#" >> /usr/local/etc/rc.d/kms_start.sh
echo "/bin/vlmcsd -R30d -A7d" >> /usr/local/etc/rc.d/kms_start.sh
}

makeExecute()
{
echo " "
echo "======= SETTING executable flags on files"
echo " SETTING KMS binary executable"
chmod 755 /bin/vlmcsd
echo " SETTING kms_start script executable"
chmod 755 /usr/local/etc/rc.d/kms_start.sh
echo " CHECKING KMS binary and kms_start script for execute permissions"
ls -l /bin/vlmcsd | cut -d" " -f1,13
ls -l /usr/local/etc/rc.d/kms_start.sh | cut -d" " -f1,13
}

preCleanUp()
{
# clean-up old files
echo " "
echo "======= CLEANING up old files"
echo " KILLING KMS server..."
pkill vlmcsd
echo " DELETING old KMS server..."
rm -f /bin/vlmcsd
echo " DELETING old kms_start script..."
rm -f /usr/local/etc/rc.d/kms_start.sh
}

runKMS()
{
# run KMS server
echo " "
echo "======= STARTING KMS server on port 1688"
vlmcsd -R30d -A7d
netstat -an | grep 1688
}

#get the user status
#getUserStatus

# get the hardware specs
getPFspecs

# clean-up old files
preCleanUp

# copy the KMS server to /bin 
copyKMS

# create startup script at /etc/rc.d
createStartup

# make files executable
makeExecute

# run KMS server
runKMS
