# Testbench analysis using non-invasive fault injection
This repository contains the source code presented and discussed in the paper "Testbench analysis using non-invasive fault injection". 
The paper will be presented on the Reconfigurable Architectures Workshop (RAW) in Milano June 2025. 
Link to the paper in IEEE-Xplore will be posted here later. 

## Usage examples
This folder contains code examples that demonstrates FIAT-testing properties. 
These code examples are the full version of the code shown in the paper. 
Both VHDL and Python examples are included, along with test results. 
The examples are made to encapsulate principles described in the paper in a compact form. 

## Usecase
The usecase folder contains a VHDL simulation model and a testbench implemented with FIAT testing to ensure that each ordinary test would find errors. 
This testbench is an actual usecase for non-invasive FIAT-testing, and showcases how FIAT methods implemented for practical purposes. 
This testbench is written in Python for use with Cocotb and Questa or GHDL. 
The makefile is set up for Questa, but GHDL can be used with minor changes[^1]. 

The testbench itself is intended to find errors in student designs of a pulse width (PWM) or pulse density modulating circuit. 
The intention is to weed out dysfunctional designs before implementation and avoid burning circuits in the lab. 

The testbench does also check that the module work according to the assignment text. 
The text for the assignment and the solution is not a part of this repository, since they are both subject to change and still in use. 
To provide the ability to test the testbench, a non-synthesizable simulation model of a pulse width modulator is included.
The simulation module does model PWM, but neither in a way that would be safe nor according to the assignment text, hence it will trigger and demonstrate error reporting. 

The testbench starts all checkers and performs tests as long as the VHDL files compiles. 
The testbench has two main tests, FIAT tests and an ordinary test. 
Ideally the FIAT tests should be completed before the ordinary tests[^1]. 
Depending on which simulation tool is used, reporting will happen either during or after each test.  

### Structure of the PWM module testbench

The testbench code is organized using classes as follows:
* A Queue extension to enable parsing message Queues used in both ordinary and FIAT tests
* A signal monitor used in ordinary testing to replace and to some degree extend VHDL attribute usage.  
* A (DUT) Monitor, containing all ordinary checks used in the testbench.
* A Stimuli generator, containing all stimuli generation used in ordinary testing.
* A Fault injector containing all FIAT-tests

Around line 280-300, in between the Stimuli generator and the Fault injector, are two test sequencer methods; one for FIAT-tests and one for ordinary-tests. 
These are the methods that will be started by the cocotb environment to use the methods written within the other classes. 

Central to the FaultInjector is the run method which creates and run through a list of all checks and checking that each error provoked by the FIAT-tests are found. 
Injected faults that are not observed by the ordinary checkers will be reported as an error.

To have both FIAT-tests and ordinary tests run together, using a queue for assertion errors allowes the test to parse errors differently when run in FIAT- or ordinary tests.

[^1]: In GHDL 4.0.0, release does not work properly, thus the FIAT test sequence may have to be moved after the ordinary tests when using this tool (see comments in the code).
