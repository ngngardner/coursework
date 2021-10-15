#!/bin/bash
# ghdl -a and_gate.vhd
# ghdl -a and_tb.vhd

# ghdl -e and_gate
# ghdl -e and_tb

# OUTPUT_FILE=test.vcd

# ghdl -r and_tb --vcd=$OUTPUT_FILE
# gtkwave $OUTPUT_FILE

ghdl -a slvectortb.vhd
ghdl -e slvectortb
ghdl -r slvectortb

$SHELL
