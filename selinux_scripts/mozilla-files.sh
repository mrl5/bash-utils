#!/bin/bash

B_RO=mozilla_read_generic_user_content
B_RW=mozilla_manage_generic_user_content

RO="ro"
RW="rw|1"
OFF="off|0"
HELP="-h"
toggle="on"

print_help() {
	echo "Available options: "
	echo -e "\t[ ${RO} ]\t\tallows mozilla to: manage all user content" | sed 's/|/ | /g'
	echo -e "\t[ ${RW} ]\tallows mozilla to: read all user content" | sed 's/|/ | /g'
	echo -e "\t[ ${OFF} ]\tdenies mozilla to: manage all user content; read all user content" | sed 's/|/ | /g'
	echo -e "\t[ ${HELP} ]\t\tprints this help" | sed 's/|/ | /g'
}

case $1 in
	ro)
		selinux_booleans=$B_RO
		;;
	rw|1)
		selinux_booleans=$B_RW
		;;
	off|0)
		toggle=off
		selinux_booleans="$B_RW $B_RO"
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
