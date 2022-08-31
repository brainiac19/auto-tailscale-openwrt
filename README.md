# auto-tailscale-openwrt
Auto installation script of tailscale for openwrt

Modify the target CPU architecture to suit your device.

Then simply run `sh tailscale_setup.sh`

The script specifies ipv4 when downloading stuff, so you may encounter problem if your network is somehow highly dependant on ipv6.

Oh and it needs persistent storage to work.

Reference:

https://github.com/adyanth/openwrt-tailscale-enabler

https://gist.github.com/willangley/9adf3e34b3c4c7046b1f638647415dae#file-tailscale-procd
