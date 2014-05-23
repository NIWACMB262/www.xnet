#!/bin/sh
#https://github.com/ajasmin/android-linux-tethering
#Android <-> Linux tethering scripts.
#See http://ajasmin.wordpress.com/2011/07/24/android-usb-tethering-with-a-linux-pc/
# Requires a rooted phone with netfilter and pppd
# Path to ADB
export ADB=

if [ $USER != "root" ]; then
echo "Please run this script as root"
exit
fi

Tether
#!/bin/sh
echo "Enabling NAT on the phone..."
$ADB shell "echo 1 > /proc/sys/net/ipv4/ip_forward"
$ADB shell "iptables -t nat -F"
$ADB shell "iptables -t nat -A POSTROUTING -j MASQUERADE"

echo "Connecting to the phone via 'adb ppp'..."
# This use Google Public DNS servers which should work most of the time
$ADB ppp "shell:pppd nodetach noauth noipdefault ms-dns 8.8.8.8 ms-dns 8.8.4.4 /dev/tty" nodetach noauth noipdefault defaultroute usepeerdns notty 10.0.0.1:10.0.0.2

echo "Done."

Tether Slirp
#!/bin/sh
echo "Connecting to the phone via slirp..."
$ADB ppp "shell:HOME=/data/local /data/local/slirp ppp mtu 1500" nodetach noauth noipdefault defaultroute usepeerdns notty 10.0.2.15:10.64.64.64

echo "Done."

Reverse Tether
#!/bin/sh
echo "Enabling NAT on `hostname`..."
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -F
iptables -t nat -A POSTROUTING -j MASQUERADE

echo "Connecting to the phone via 'adb ppp'..."
$ADB ppp "shell:pppd nodetach noauth noipdefault defaultroute /dev/tty" nodetach noauth noipdefault notty 10.0.0.1:10.0.0.2

echo "Done.".



