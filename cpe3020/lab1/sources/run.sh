#!/bin/bash
ghdl -a referees.vhd
ghdl -a referees_tb.vhd

ghdl -e referees
ghdl -e referees_tb

OUTPUT_FILE=test.vcd

ghdl -r referees_tb --vcd=$OUTPUT_FILE
gtkwave $OUTPUT_FILE
