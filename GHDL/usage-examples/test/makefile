# Makefile

# defaults
SIM ?= ghdl
#SIM ?= questa
TOPLEVEL_LANG ?= vhdl

#Questa specific: GUI is not required
#GUI =1

# GHDL specific: VHDL 2008
EXTRA_ARGS +=--std=08

# TOPLEVEL is the name of the toplevel module in your VHDL file
TOPLEVEL ?= qcount

# Path to all relevant vhdl sources 
#VHDL_SOURCES += $(PWD)/../src/$(TOPLEVEL).vhd*
VHDL_SOURCES += $(PWD)/../src/*.vhd*

# GHDL specific: SIM_ARGS is GHDL Simulation arguments. 
# wave or vcd selects vcd or ghw format 
#SIM_ARGS +=--wave=$(TOPLEVEL).ghw
SIM_ARGS+=--vcd=$(TOPLEVEL).vcd

# Questa specific: instructions to create .do file
# add to sim_build/ runsim.do --  
#add log -r *
#vcd file wave.vcd 
#vcd add -r /*
#run -all
#quit -sim

# GHDL specific: generics
# -g<GENERIC> is used in GHDL to set generics defined in the toplevel entity
# SIM_ARGS +=-gWIDTH=4

# MODULE is the basename of the Python test file
MODULE ?= tb_FIAT_min

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# removing generated binary of top entity and .o-file on make clean
clean::
	-@rm -f $(TOPLEVEL)
	-@rm -f e~$(TOPLEVEL).o
