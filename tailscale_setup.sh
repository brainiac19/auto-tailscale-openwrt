#!/bin/sh

echo Installing required packages...
opkg update
opkg install libustream-openssl ca-bundle kmod-tun

read -p $'Enter target architecture\n(386/amd64/arm/arm64/mips/mips64/mips64le/mipsle/riscv64):\n' architecture
if [ "$architecture" == '' ];then
echo Please enter valid CPU architecture.
exit
fi

echo Acquiring the latest stable version tag for architecture $architecture ...
stable_tag=$(wget https://pkgs.tailscale.com/stable/ -4 -t 2 --timeout=10 -qO- | grep "$architecture.tgz" | awk -F_ '{print $2}')
if [ "$stable_tag" == '' ];then
	read -p $'Failed to acquire latest stable version tag. \nEnter version tag manually in the script, in the format of xx.xx.xx:\n' stable_tag
fi
if [ "$stable_tag" == '' ];then 
	echo Please enter valid CPU architecture.
	exit
else
	echo The latest stable version is $stable_tag
fi

cd /tmp
bin_host=https://pkgs.tailscale.com/stable/
bin_name=tailscale_"$stable_tag"_"$architecture"
bin_link="$bin_host""$bin_name".tgz
procd_link=https://gist.githubusercontent.com/willangley/9adf3e34b3c4c7046b1f638647415dae/raw/84709873b10b7d1d9ac2b8dee973b6ca894819a4/tailscale-procd

echo Downloading tailscale binary...
wget $bin_link -O $bin_name.tgz -4 -c -t 2 -q && echo Binary download complete. || echo Failed to download binary, exiting.|exit
echo Extracting Binary...
tar xvf "$bin_name".tgz --overwrite
cd $bin_name
mv tailscale tailscaled /usr/sbin/ -f
echo Binary extraction complete.

read -p "Setup procd script? Not needed when upgrading.(y/n)" procd
if [[ $procd == [yY] || $procd == [yY][eE][sS] ]];then
	echo Downloading procd script...
	wget $procd_link -O /etc/init.d/tailscale -4 -t 2 --timeout=10 -q
	echo Procd script downloaded.
	echo Enabling autostart.
	chmod +x /etc/init.d/tailscale
	/etc/init.d/tailscale enable
fi

echo Starting tailscale.
/etc/init.d/tailscale start
tailscale up
