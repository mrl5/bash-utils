#!/bin/bash

selinux_booleans="chromium_rw_usb_dev chromium_read_system_info"

ENABLE="on|1"
DISABLE="off|0"
HELP="-h"

print_help() {
	echo "Available options: "
	echo -e "\t[ ${ENABLE} ]\tallows chromium to: read system information; read/write USB devices" | sed 's/|/ | /g'
	echo -e "\t[ ${DISABLE} ]\tdenies chromium to: read system information; read/write USB devices" | sed 's/|/ | /g'
	echo -e "\t[ ${HELP} ]\t\tprints this help" | sed 's/|/ | /g'
}

case $1 in
	on|1)
		toggle=on
		;;
	off|0)
		toggle=off
		;;
	-h)
		print_help
		exit
		;;
	*)
		print_help
		exit 1
		;;
esac

for bool in $selinux_booleans; do
	setsebool $bool $toggle
	seinfo -b -x | grep $bool
done
