## Usage examples
The usage examples folder contains code examples that demonstrates FIAT testing properties. Both VHDL and Python examples are included, along with test results. 
## Implementation
The implementation folder contains a testbench implemented with FIAT testing to ensure that each test would find errors in the testbench design. 
The testbench in the usage example is written in Python for use with Cocotb and Questa or GHDL. 
The makefile is set up for Questa, but GHDL can be used with minor changes. 
Note that GHDL 4.0.0 does not perform release properly, thus tests may have to be rearranged for the testbench to complete (see comments in the code). 

The testbench itself is intended to find errors in student designs of a pulse width or pulse density modulating circuit. 
The intention is to weed out dysfunctional designs before implementation and avoid burning circuits in the student lab.

A non-synthesizable (behavioral) simulation model of a pulse with modulator is included to allow testing the testbench without writing new code. 
The simulation model does model PWM, but not in a way that would be safe way for the lab setup, hence it will trigger and demonstrate error reporting as intended. 

The testbench goes through all testing, as long as the VHDL files compiles, and reports errors and completion of each test.  
