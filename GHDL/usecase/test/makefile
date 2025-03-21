# Makefile

# defaults
SIM ?= ghdl
#SIM ?= questa
TOPLEVEL_LANG ?= vhdl

# GHDL: VHDL 2008
EXTRA_ARGS +=--std=08

# TOPLEVEL is the name of the toplevel module in your VHDL file
TOPLEVEL = pulse_width_modulator

#VHDL_SOURCES += $(PWD)/../src/$(TOPLEVEL).vhd
VHDL_SOURCES += $(PWD)/../src/*.vhd*

# GHDL: waveform generation (vcd or ghw)
# SIM_ARGS +=--wave=$(TOPLEVEL).ghw
SIM_ARGS +=--vcd=$(TOPLEVEL).vcd

# MODULE is the basename of the Python test file
MODULE = tb_pwm

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# removing generated binary of top entity and .o-file on make clean
clean::
	-@rm -f $(TOPLEVEL)
	-@rm -f e~$(TOPLEVEL).o
