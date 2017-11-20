# KMS-on-pfSense
## Add a KMS server in your pfSense firewall appliance

Tested on 2.4.1-RELEASE (amd64) pfSense appliance<br>
Compiled on FreeBSD 11.1 (amd64)<br>

All credit goes to Wind4 @ https://github.com/Wind4/vlmcsd which is a `KMS Emulator in C` <br><br>

### Nuts and bolts
1- KMS server `vlmcsd` is copied into the `/bin` directory <br>
2- `vlmcsd` is then chmodded to be executable <br>
3- A shell script called `kms_start` is placed in `/etc/rc.d` (to start service with defaults on reboot)<br><br>

### How to Install
Type the following command inside pfSense appliance to run the installer <br>
`curl -L meliton.github.io/kms2pfsense.sh | sh` <br>

