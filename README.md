# auto-tailscale-openwrt
Auto installation/Upgrade script of tailscale for openwrt

Simply run `sh tailscale_setup.sh`, you will need to figure out the CPU architecture and tell the script when it asks.

The script specifies ipv4 when downloading stuff, so you may encounter problem if your network is somehow highly dependant on ipv6.

It can also be used when upgrading, just say no when it asks wheather rewrite procd script.

Oh and it needs persistent storage to work.

Reference:

https://github.com/adyanth/openwrt-tailscale-enabler

https://gist.github.com/willangley/9adf3e34b3c4c7046b1f638647415dae#file-tailscale-procd
