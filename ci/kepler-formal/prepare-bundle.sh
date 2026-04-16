#!/usr/bin/env bash

set -euo pipefail

src_root=${1:?source root is required}
dst_root=${2:?destination root is required}

rm -rf "$dst_root"
mkdir -p "$dst_root"

copy_tree_files() {
  local src_dir=$1
  find "$src_dir" -maxdepth 1 -type f -exec cp {} "$dst_root"/ \;
}

# Flatten the include tree so quoted includes resolve without extra -I handling.
copy_tree_files "$src_root/bp_common/src/include"
copy_tree_files "$src_root/external/basejump_stl/bsg_misc"
copy_tree_files "$src_root/external/basejump_stl/bsg_noc"
cp "$src_root/bp_me/src/v/cce/bp_bedrock_size_to_len.sv" "$dst_root"/
