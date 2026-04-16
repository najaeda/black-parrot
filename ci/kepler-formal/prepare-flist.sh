#!/usr/bin/env bash

set -euo pipefail

src_root=${1:?source root is required}
dst_flist=${2:?destination flist is required}
template_relpath=${3:-bp_top/flist.vcs}

template_path=${src_root%/}/${template_relpath}

if [[ ! -f "$template_path" ]]; then
  echo "Required flist template not found: $template_path" >&2
  exit 1
fi

mkdir -p "$(dirname "$dst_flist")"

# Rebase the repository-root placeholder to the caller-selected checkout so the
# same source list can describe both the current and reference designs.
perl -pe "s!\\\$BP_DIR!$src_root!g" "$template_path" > "$dst_flist"

# Some BaseJump modules instantiate hardened variants behind parameterized
# generate branches, but bp_top/flist.vcs omits those source files because the
# standard simulation flow does not elaborate them. Kepler/slang still needs the
# module definitions available during parsing, so append the missing files here.
extra_files=(
  "$src_root/external/basejump_stl/bsg_dataflow/bsg_fifo_1r1w_small_hardened.sv"
  "$src_root/external/basejump_stl/bsg_dataflow/bsg_fifo_1r1w_small_hardened_multi.sv"
)

for extra_file in "${extra_files[@]}"; do
  if [[ ! -f "$extra_file" ]]; then
    echo "Required extra flist source not found: $extra_file" >&2
    exit 1
  fi

  if ! rg -F -x "$extra_file" "$dst_flist" >/dev/null; then
    printf '%s\n' "$extra_file" >> "$dst_flist"
  fi
done

if rg -n '\$BP_DIR' "$dst_flist" >/dev/null; then
  echo "Failed to rewrite all \$BP_DIR placeholders in $dst_flist" >&2
  exit 1
fi

exit 0
