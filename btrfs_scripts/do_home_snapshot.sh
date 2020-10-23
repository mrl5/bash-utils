#!/bin/bash

BCKP_TARGET='/home'
BCKP_DIR='/home/btrfs/snapshots/'
SNAPSHOT_NAME="home_`date -u -Iseconds`"
SNAPSHOT_LOC="${BCKP_DIR}/${SNAPSHOT_NAME}"

get_subvolumes() {
	echo -e "\n=== btrfs subvolumes ==="
	btrfs subvolume list "$BCKP_TARGET"
}

print_disc_usage() {
	echo -e "\n=== disc usage ==="
	df "$@" | grep '/$'
}

do_btrfs_snapshot() {
	echo -e "\ntaking subvolume snapshot ..."
	btrfs subvolume snapshot "$BCKP_TARGET" "$SNAPSHOT_LOC"
}

set_label() {
	local label="${SNAPSHOT_LOC}/current-is_${SNAPSHOT_NAME}"
	touch "$label"
}

# main()
get_subvolumes &&
	print_disc_usage "-h" &&
	do_btrfs_snapshot &&
	set_label &&
	get_subvolumes &&
print_disc_usage "-h"
