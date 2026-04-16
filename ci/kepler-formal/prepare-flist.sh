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

if rg -n '\$BP_DIR' "$dst_flist" >/dev/null; then
  echo "Failed to rewrite all \$BP_DIR placeholders in $dst_flist" >&2
  exit 1
fi

exit 0
