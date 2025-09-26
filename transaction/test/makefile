# Makefile

# defaults
SIM ?= nvc
#SIM ?= ghdl
#SIM ?= questa

# TOPLEVEL is the name of the toplevel module in the VHDL file
#TOPLEVEL = receiver
TOPLEVEL = transmitter

TOPLEVEL_LANG ?= vhdl

# GHDL: VHDL 2008
ifeq ($(SIM), ghdl)
	EXTRA_ARGS +=--std=08
	SIM_ARGS +=--wave=$(TOPLEVEL).ghw
	#SIM_ARGS +=--vcd=$(TOPLEVEL).vcd
endif

# nvc simulator
ifeq ($(SIM), nvc)
	EXTRA_ARGS +=--std=2008
	SIM_ARGS +=--format=fst --wave=$(TOPLEVEL).fst
endif

#VHDL_SOURCES += $(PWD)/../src/$(TOPLEVEL).vhd
VHDL_SOURCES += $(PWD)/../src/*.vhd

# MODULE is the basename of the Python test file
MODULE = tb_$(TOPLEVEL)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# removing generated binary of top entity and .o-file on make clean
clean::
	-@rm -f $(TOPLEVEL)
	-@rm -f e~$(TOPLEVEL).o
