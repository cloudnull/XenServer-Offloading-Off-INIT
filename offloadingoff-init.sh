#!/usr/bin/env bash
### BEGIN INIT INFO
# Provides:          offloading
# Required-Start:    mountkernfs $local_fs
# Required-Stop:     $local_fs
# Default-Start:     S 3 5
# Default-Stop:      0 6
# Short-Description: Disables Network Offloading.
### END INIT INFO

# - title        : Disable ALL TCP Offloading at reboot
# - description  : This script will assist in Disabling ALL TCP Offloading.
# - author       : Kevin Carter
# - License      : GPLv3
# - date         : 2012-05-15
# - version      : 1.0    
# - usage        : bash offloadingoff.sh
# - notes        : This Disables all offloading on all Hardware adapters following to ETH naming scheme.
# - bash_version : >= 3.2.48(1)-release
#### ========================================= ####

if [ ! -f `which ethtool` ];then 
	echo "ethtool does not exist on this instance"
	exit 1
		elif [ ! -f `which ifconfig` ];then
			echo "ifconfig does not exist on this instance"
			exit 1
				elif [ ! -f `which ip` ];then
					echo "ip tool does not exist on this instance"
					exit 1	
fi

RESTARTNETWORKING(){
echo -e "\033[1;32mNetworking is Restarting\033[0m"
if [ -f /sbin/ifconfig ];then
  for IFC in `ifconfig | awk '/eth[0-9]/ {print $1}'`; do ifdown ${ETHADP} && ifup ${ETHADP}; done
	elif [ -f /bin/ip ];then
	  for IPT in `ip a | awk '/eth[0-9]/ {print $2}' | sed 's/://g' | sed -n '1~2p'`; do ip l s ${IPT} down && ip l s ${IPT} up; done
		elif [ -f /etc/init.d/networking ];then
		  /etc/init.d/networking restart
			elif [ -f /etc/init.d/network ];then
			  /etc/init.d/network restart
	else
		echo -e "\033[1;31mNetwork Restart Failed\033[0m"
fi
}

DISABLEOFFLOADING(){
if [ -f /sbin/ifconfig ];then
for IFC in `ifconfig | awk '/eth[0-9]/ {print $1}'`
do
echo -e "\033[1;31mDisabling Offloading on the ${IFC} Device\033[0m"
	ethtool -K ${IFC} rx off 
	ethtool -K ${IFC} tx off
	ethtool -K ${IFC} sg off
	ethtool -K ${IFC} tso off
	ethtool -K ${IFC} ufo off
	ethtool -K ${IFC} gso off
	ethtool -K ${IFC} gro off
	ethtool -K ${IFC} lro off
done
	elif [ -f /bin/ip ];then
	for IPT in `ip a | awk '/eth[0-9]/ {print $2}' | sed 's/://g' | sed -n '1~2p'`
	do
	echo -e "\033[1;31mDisabling Offloading on the ${IFC} Device\033[0m"
		ethtool -K ${IPT} rx off 
		ethtool -K ${IPT} tx off
		ethtool -K ${IPT} sg off
		ethtool -K ${IPT} tso off
		ethtool -K ${IPT} ufo off
		ethtool -K ${IPT} gso off
		ethtool -K ${IPT} gro off
		ethtool -K ${IPT} lro off
	done
		else
			echo "We can not determine your Network Interface Devices."
			exit 0
fi
}

case "$1" in
start)
DISABLEOFFLOADING
	;;

stop)
RESTARTNETWORKING
	;;

force-reload)
DISABLEOFFLOADING
	;;

restart)
RESTARTNETWORKING
		DISABLEOFFLOADING
	;;
	
*)
	echo "Usage: $0 {start|force-reload|restart}"
	exit 1
	;;
esac

exit 0
