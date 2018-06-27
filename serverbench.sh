#!/bin/bash
get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

speed_test() {
    speedtest=$(wget -4O /dev/null -T300 $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}')
    ipaddress=$(ping -c1 -n `awk -F'/' '{print $3}' <<< $1` | awk -F'[()]' '{print $2;exit}')
    nodeName=$2
    if   [ "${#nodeName}" -lt "8" ]; then
        echo -e "\e[33m$2\e[0m\t\t\t\t\t\e[32m$ipaddress\e[0m\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -lt "16" ]; then
        echo -e "\e[33m$2\e[0m\t\t\t\t\e[32m$ipaddress\e[0m\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -lt "24" ]; then
        echo -e "\e[33m$2\e[0m\t\t\t\e[32m$ipaddress\e[0m\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -lt "28" ]; then
        echo -e "\e[33m$2\e[0m\t\t\e[32m$ipaddress\e[0m\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -ge "28" ]; then
        echo -e "\e[33m$2\e[0m\t\e[32m$ipaddress\e[0m\t\e[31m$speedtest\e[0m"
    fi
}

speed_test_v6() {
    speedtest=$(wget -6O /dev/null -T300 $1 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}')
    ipaddress=$(ping6 -c1 -n `awk -F'/' '{print $3}' <<< $1` | awk -F'[()]' '{print $2;exit}')
    nodeName=$2
    if   [ "${#nodeName}" -lt "8" -a "${#ipaddress}" -eq "13" ]; then
        echo -e "\e[33m$2\e[0m\t\t\t\t\t\e[32m$ipaddress\e[0m\t\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -lt "13" -a "${#ipaddress}" -eq "13" ]; then
        echo -e "\e[33m$2\e[0m\t\t\t\t\e[32m$ipaddress\e[0m\t\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -lt "24" -a "${#ipaddress}" -eq "13" ]; then
        echo -e "\e[33m$2\e[0m\t\t\t\e[32m$ipaddress\e[0m\t\t\e[31m$speedtest\e[0m"
    elif [ "${#nodeName}" -lt "24" -a "${#ipaddress}" -gt "13" ]; then
        echo -e "\e[33m$2\e[0m\t\t\e[32m$ipaddress\e[0m\t\e[31m$speedtest\e[0m"
    fi
}

speed() {
    speed_test 'http://cachefly.cachefly.net/100mb.test' 'CacheFly'
    speed_test 'http://la-lg.v4.gomach5.com/100MB.test' 'Go Mach 5 (Psychz), Los Angeles, US'
    speed_test 'http://lg.chi2-c.fdcservers.net/100MBtest.zip' 'FDC Servers, Chicago, US'
    speed_test 'http://ny.lg.virmach.com/100MB.test' 'Virmach (ColoCrossing), Buffalo, US'
    speed_test 'http://dal.lg.virmach.com/100MB.test' 'Virmach (ColoCrossing), Dallas, US'
    speed_test 'http://la.lg.virmach.com/100MB.test' 'Virmach (ColoCrossing), Los Angeles, US'
    speed_test 'http://mirror.incero.com/100mb.test' 'Incero, Dallas, US'
    speed_test 'http://speedtest-nyc1.digitalocean.com/100mb.test' 'DO 1, NYC, US'
    speed_test 'http://speedtest-nyc2.digitalocean.com/100mb.test' 'DO 2, NYC, US'
    speed_test 'http://speedtest-nyc3.digitalocean.com/100mb.test' 'DO 3, NYC, US'
    speed_test 'https://fl-us-ping.vultr.com/vultr.com.100MB.bin' 'Vultr, Miami, US'
    speed_test 'https://wa-us-ping.vultr.com/vultr.com.100MB.bin' 'Vultr, Washington, US'
    speed_test 'http://speedtest-sfo2.digitalocean.com/100mb.test' 'DO, San Francisco, US'
    speed_test 'http://speedtest-sfo1.digitalocean.com/100mb.test' 'DO, San Francisco, US'
    speed_test 'http://bhs.proof.ovh.net/files/100Mb.dat' 'OVH, Beauharnois, CA'
    speed_test 'http://lookingglass.netcup.net/100MB.test' 'Netcup, Nuremberg, DE'
    speed_test 'http://rbx.proof.ovh.net/files/100Mb.dat' 'OVH, Roubaix, FR'
    speed_test 'http://ping.online.net/100Mo.dat' 'Online.Net, Paris, FR'
    speed_test 'http://speedtest.mex01.softlayer.com/downloads/test100.zip' 'Softlayer, Mexico, MX'
    speed_test 'http://speedtest.sao01.softlayer.com/downloads/test100.zip' 'Softlayer, Brazil, BR'
}

speed_v6() {
    speed_test_v6 'http://speedtest.atlanta.linode.com/100MB-atlanta.bin' 'Linode, Atlanta, GA'
    speed_test_v6 'http://speedtest.dallas.linode.com/100MB-dallas.bin' 'Linode, Dallas, TX'
    speed_test_v6 'http://speedtest.newark.linode.com/100MB-newark.bin' 'Linode, Newark, NJ'
    speed_test_v6 'http://speedtest.singapore.linode.com/100MB-singapore.bin' 'Linode, Singapore, SG'
    speed_test_v6 'http://speedtest.tokyo.linode.com/100MB-tokyo.bin' 'Linode, Tokyo, JP'
    speed_test_v6 'http://speedtest.par01.softlayer.com/downloads/test100.zip' 'Softlayer, Paris, FR'
    speed_test_v6 'http://speedtest.sng01.softlayer.com/downloads/test100.zip' 'Softlayer, Singapore, SG'
    speed_test_v6 'http://speedtest.tok02.softlayer.com/downloads/test100.zip' 'Softlayer, Tokyo, JP'
}

io_test() {
    (LANG=en_US dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

if  [ -e '/usr/bin/wget' ]; then
    cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
    freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    tram=$( free -m | awk '/Mem/ {print $2}' )
    swap=$( free -m | awk '/Swap/ {print $2}' )
    up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60;d=$1%60} {printf("%ddays, %d:%d:%d\n",a,b,c,d)}' /proc/uptime )
    load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
    opsy=$( get_opsy )
    arch=$( uname -m )
    lbit=$( getconf LONG_BIT )
    host=$( hostname )
    kern=$( uname -r )
    ipv6=$( wget -qO- -t1 -T2 ipv6.icanhazip.com )

    clear
    next
    echo "CPU model            : $cname"
    echo "Number of cores      : $cores"
    echo "CPU frequency        : $freq MHz"
    echo "Total amount of ram  : $tram MB"
    echo "Total amount of swap : $swap MB"
    echo "System uptime        : $up"
    echo "Load average         : $load"
    echo "OS                   : $opsy"
    echo "Arch                 : $arch ($lbit bits)"
    echo "Kernel               : $kern"
    next

    io1=$( io_test )
    echo "I/O speed(1st run)   : $io1"
    io2=$( io_test )
    echo "I/O speed(2nd run)   : $io2"
    io3=$( io_test )
    echo "I/O speed(3rd run)   : $io3"
    ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
    [ "`echo $io1 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw1=$( awk 'BEGIN{print '$ioraw1' * 1024}' )
    ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
    [ "`echo $io2 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw2=$( awk 'BEGIN{print '$ioraw2' * 1024}' )
    ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
    [ "`echo $io3 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw3=$( awk 'BEGIN{print '$ioraw3' * 1024}' )
    ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
    ioavg=$( awk 'BEGIN{print '$ioall'/3}' )
    echo "Average I/O speed    : $ioavg MB/s"
    next

    echo -e "Node name\t\t\t\tIPv4 address\tDownload speed"
    speed && next
    if [[ "$ipv6" != "" ]]; then
        echo -e "Node name\t\t\tIPv6 address\t\tDownload speed"
        speed_v6 && next
    fi
else
    echo "Error: wget command not found. You must be install wget command at first."
    exit 1
fi
