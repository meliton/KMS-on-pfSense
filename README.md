# Add a KMS server in your pfSense firewall appliance

Tested on 2.4.4-RELEASE-p3 (amd64) pfSense appliance<br>
Compiled on FreeBSD 11.2-RELEASE-p10 (amd64)<br>

All credit goes to Wind4 @ https://github.com/Wind4/vlmcsd which is a `KMS Emulator in C` <br><br>

### Nuts and bolts
1- KMS server `vlmcsd` is copied into the `/bin` directory <br>
2- `vlmcsd` is then chmodded to be executable <br>
3- A shell script called `kms_start.sh` is created (and chmodded) in `/usr/local/etc/rc.d` (to start service on reboot)<br><br>

### How to Install
From the pfSense web interface, `Diagnostics` --> `Command Prompt`... type<br>
`curl -L meliton.github.io/kms2pfsense.sh | sh` <br>
Then click `Execute` <br>

## How to Install Screenshot
![Alt text](install.jpg?raw=true "How-to-Install screenshot")

### Some helpful commands
From the pfSense web command prompt<br>
`netstat -an | grep 1688` to check if KMS service is running <br>
`pkill vlmcsd` to kill/stop KMS service <br>
`vlmcsd -h` for a list of options <br>
`vlmcsd -V` for the KMS server version <br>

NOTE: If you stop the service, you'll need to restart the firewall or SSH into the box to restart with `vlmcsd` command. <br>
Typing `vlmcsd` from the GUI command prompt does not work. <br>
