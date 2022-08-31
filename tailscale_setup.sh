#!/bin/sh

#Set target CPU architecture here
architecture=arm64

echo Acquiring the latest stable version tag for architecture $architecture ...
stable_tag=$(wget https://api.github.com/repos/tailscale/tailscale/releases/latest -4 -t 3 -q | grep tag_name | awk -Fv '{print $2}' | tr -d '",')
#Set version tag manually if failed to retrieve.
#stable_tag=1.28.0
if [ "$stable_tag" == "" ];then
	echo -e 'Failed to acquire latest stable version tag.\nYou can specify version tag manually in the script, in the format of xx.xx.xx'
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
wget $bin_link -O $bin_name.tgz -4 -c -t 3 -q && echo Binary download complete. || echo Failed to download binary, exiting.|exit
echo Extracting Binary...
tar xvf "$bin_name".tgz --overwrite
cd $bin_name
mv tailscale tailscaled /usr/sbin/ -f
echo Downloading procd script...
wget $procd_link -O /etc/init.d/tailscale -4 -t 3 -q
echo Procd script downloaded.
echo Enabling autostart.
chmod +x /etc/init.d/tailscale
/etc/init.d/tailscale enable
echo Starting tailscale.
/etc/init.d/tailscale start
tailscale up
/etc/init.d/tailscale restart
