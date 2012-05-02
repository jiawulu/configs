#!/bin/bash

#put it to /etc/network/if-up.d/
myip=`ifconfig| grep "255.255.255.0" | awk '{print $2 }' | awk -F: '{print $2}'`
echo $myip >> /home/admin/logs/dyndns.log
wget --user=jiawulu --password=home301 "http://www.3322.org/dyndns/update?system=dyndns&hostname=jiawulu.3322.org&myip=$myip" >/dev/null 2>/dev/null
