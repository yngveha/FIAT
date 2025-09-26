TLM using FIAT to validate testbench correctness
===

Requirements:
    pip install construct
    simulator: ghdl, nvc ( https://github.com/nickg/nvc )

Simulator:
    When using TLM with FIAT and GHDL, due to a bug in either Cocotb or GHDL, the test might not be executed.
    The FIAT test will show which tests have not been executed.

    To execute all tests, update the makefile and set SIM ?= nvc
    Rerun the tests and observer that the FIAT messages are as expected.

Usage:
    To execute the transmitter, edit the makefile.
    Set TOPLEVEL=transmitter

    To execute the receiver, edit the makefile.
    Set TOPLEVEL=receiver


    
