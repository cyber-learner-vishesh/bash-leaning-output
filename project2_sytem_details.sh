#!/usr/bin/env bash

echo -e "\e[32m Starting the SYSTEM INFO BY VISHESH \e[0m"
sleep 2
echo ""
echo "-----------------------------------------------------------"
sleep 1

read -p "Enter your name : " username
username=${username:-$UNAME}

echo ""
echo "Authenticate required ...."


if sudo -v ; then
	echo -e "\e[32m Authentication successful.... \e[0m"
else
	echo -e "\e[31m Authetication Failed ...... retry \e[0m"
	exit 0 
fi

sleep 1

echo "_____________________________________________________________________"


echo -e "\e[36m You are ${username} Working as $USER \n \e[0m"
echo -e "\e[36m hostname :\e[0m $HOSTNAME"

echo -e "\e[36m Current SHELL \e[0m $SHELL"


echo -e "\e[36m SYSTEM Details \e[0m"
echo "CPU MODEL : $(lscpu | awk "/Model name/" |xargs)"
echo "total Cpu: $(lscpu | awk "/CPU\(s\)/" |xargs)"

echo -e "\e[32m RAM DETAILS \e[0m "
echo $(free -h | awk '/Mem:/ {print "Total:\t", $2, "Used:\t", $3, "Free:\t", $4}')
echo "-------------------------------------------------------------------------------------------------"
echo -e "\e[36m Current dict :\t \e[0m "
echo -e "\e[32m $(pwd)\n \e[0m"
echo -e "\e[36m files in $(pwd)\n \e[0m"
ls -l -1
echo ""
echo "-----------------------------------------------------------------------------------------"
echo -e "\e[36m Disk Details : \e[0m"
echo -e "\e[36m Disk Structure----- \e[0m"

lsblk

echo -e "\e[36m disk Space : \e[0m"
df -h



echo "--------------------------------------------------------------------"
echo -e "\e[36m Network INFO : \e[0m"
echo $(ip addr show eth0 | grep inet |awk "{print $1 $2}") 

sleep 1

echo -e "\e[32m RUNNING NMAP TO check open port\e[0m"
nmap -T5 localhost


