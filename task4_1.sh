#! /bin/bash
exec 1> task4_1.out
echo --- Hardware ---
cpu=$(lscpu | grep "Model name:" | cut -d ":" -f2 | sed 's/^ *//;s/ *$//')
ram=$(cat /proc/meminfo | grep "MemTotal" | cut -d ":" -f2 | sed 's/^ *//;s/ *$//')
motherboard=$(dmidecode -s baseboard-product-name)
sysserialnum=$(dmidecode -s system-serial-number)
osdistrname=$(cat /etc/*-release | grep NAME | grep -v "PRETTY_NAME" | grep -o '".*"'| sed 's/"//g')
osversion=$(cat /etc/*-release | grep VERSION | grep -v "VERSION_ID"| grep -o '".*"'| sed 's/"//g'| sed 's/(//g'| sed 's/)//g')
kernel=$(uname -mrs)
installdate=$(ls -alct / | tail -1| awk '{print $6, $7, $8}')
uptimeDays=$(uptime -p | cut -d' ' -f2-)
numberOfProcesses=$(ps aux --no-heading | wc -l)
userLoggedIn=$(who | wc -l)
exec 1>> task4_1.out
echo CPU: $cpu
echo RAM: $ram
echo Motherboard: ${motherboard:-"Unknow"}
echo System Serial Number: ${sysserialnum:-"Unknow"}
echo --- System ---
echo OS Distribution: $osdistrname $osversion
echo Kernel version: $kernel
echo Installation date: $installdate
echo "Hostname:" $(hostname) 
echo Uptime: $uptimeDays
echo Processes running: $numberOfProcesses
echo User logged in: $userLoggedIn
echo --- Network ---
ip -o link show | awk  -F': ' '{print $2}' > /tmp/ifacess.txt
ip -o -f inet addr show | awk '{print $2":",$4}'> /tmp/ips.txt
uniq /tmp/ifacess.txt /tmp/unicfacess.txt
ifaces=$(cat /tmp/unicfacess.txt)
for var in $ifaces
do
ips=$(grep $var /tmp/ips.txt | cut -d':' -f2)
ipstr=""
for ip in $ips
do
ipstr+=$ip," "
done
if [ -z "$ipstr" ]; then
echo $var: -
else
echo $var: ${ipstr::-2}
fi
done

