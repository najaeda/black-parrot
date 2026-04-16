# Kepler Formal BlackParrot RTL Fixture

This directory holds the first `najaeda/kepler-formal-action` integration for BlackParrot
repository RTL.

The current lane compares the full `bp_top/flist.vcs` source set against itself and emits a
`systemverilog` kepler-formal config targeting `bp_multicore`. The workflow stages two repository
trees:

- the current checkout at the workflow SHA
- a second checkout of the same SHA under `reference/`

The helper script [prepare-flist.sh](/Users/xtof/WORK/black-parrot/ci/kepler-formal/prepare-flist.sh:1)
rewrites `$BP_DIR` inside `bp_top/flist.vcs` so each design gets a checkout-relative SystemVerilog
flist that kepler-formal can consume directly.

The current kepler-formal lane uses SystemVerilog flists with an explicit top:

- `sv_design1_top: bp_multicore`
- `sv_design2_top: bp_multicore`

For larger BlackParrot processor-level work, the repository itself documents these module tops:

- `bp_top/src/v/bp_unicore.sv`: top level module for a unicore BlackParrot processor
- `bp_top/src/v/bp_multicore.sv`: top level module for a multicore BlackParrot processor
