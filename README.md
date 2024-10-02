## Usage examples
The usage examples folder contains code examples that demonstrates FIAT testing properties. Both VHDL and Python examples are included, along with test results. 
## Implementation
The implementation folder contains a testbench implemented with FIAT testing to ensure that each test would find errors in the testbench design. 
The testbench in the usage example is written in Python for use with Cocotb and Questa or GHDL. 
The makefile is set up for Questa, but GHDL can be used with minor changes[^1]. 

The testbench itself is intended to find errors in student designs of a pulse width or pulse density modulating circuit. 
The intention is to weed out dysfunctional designs before implementation and avoid burning circuits in the lab. 

The testbench does check that the module works according to the assignment text. 
The text for the assignment and the solution is not a part of this repository, since they are both subject to change and still in use. 
To provide the ability to test the testbench, a non-synthesizable (behavioral) simulation model of a pulse with modulator is included.
The simulation model does model PWM, but not in a way that would be safe or according to the assignment, hence it will trigger and demonstrate error reporting. 

The testbench starts all checkers and performs tests as long as the VHDL files compiles. 
The testbench has two main tests, FIAT tests and an ordinary test. 
Ideally the FIAT tests should be completed before the ordinary tests[^1]. 
Depending on which simulation tool is used, reporting will happen either during or after each test.  

[^1]: In GHDL 4.0.0, release does not work properly, thus the FIAT test sequence may have to be moved after the ordinary tests when using this tool (see comments in the code).
