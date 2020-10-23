#!/bin/bash

BCKP_TARGET='/'
BCKP_DIR='/btrfs/snapshots/'
SNAPSHOT_NAME="rootfs_`date -u -Iseconds`"
SNAPSHOT_LOC="${BCKP_DIR}/${SNAPSHOT_NAME}"
META_REPO_LOC='/var/git/meta-repo'
DIST_STATE_LOCS=(
	'/var/db/pkg'
	'/var/lib/portage/world'
)

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

_get_meta_repo_sha() {
	cd "$META_REPO_LOC" &&
		echo `git rev-parse HEAD`
	cd - > /dev/null
}

set_label() {
	local label="${SNAPSHOT_LOC}/current-is_${SNAPSHOT_NAME}"
	touch "$label"
	_get_meta_repo_sha > "$label"
}

set_dist_state() {
	local dist_state="dist_state.tar.gz"
	tar czf "${SNAPSHOT_LOC}/${dist_state}" ${DIST_STATE_LOCS[@]}
}

# main()
get_subvolumes &&
	print_disc_usage "-h" &&
	do_btrfs_snapshot &&
	set_label &&
	set_dist_state &&
	get_subvolumes &&
print_disc_usage "-h"
