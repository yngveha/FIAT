#!/bin/bash

# For compilation using a subset of the available VHDL files, use:
# ghdl -a --std=08 <filename 1> <filename 2> <...>

# compile all available .vhdl files
ghdl -a --std=08 *vhdl

# run the testbench, and create a ghw format waveform
# ghdl -r --std=08 tb_fiat --wave=wave.ghw

# run the testbench, and create a .vcd format waveform
ghdl -r --std=08 tb_fiat --vcd=wave.vcd

# run the testbench without waveform
# ghdl -r --std=08 tb_fiat

# start gtkwave in a separate window using our newly created waveform
# requires gtkwave installed. Other waveform viewers may be used
# gtkwave wave.ghw &
# gtkwave wave.vcd &
