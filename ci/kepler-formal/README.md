# Kepler Formal BlackParrot RTL Fixture

This directory holds the first `najaeda/kepler-formal-action` integration for BlackParrot
repository RTL.

The initial lane compares the real `bp_me/src/v/cce/bp_bedrock_size_to_len.sv` source set against
itself and emits a `systemverilog` kepler-formal config. The workflow stages two bundles from
checked-out repository trees:

- the current checkout at the workflow SHA
- a second checkout of the same SHA under `reference/`

Each bundle includes:

- `bp_me/src/v/cce/bp_bedrock_size_to_len.sv`
- `bp_common/src/include/*`
- `external/basejump_stl/bsg_misc/*`
- `external/basejump_stl/bsg_noc/*`

The bundling step flattens those files into a single directory so the quoted include statements used
by BlackParrot headers resolve without extra include-path configuration.
