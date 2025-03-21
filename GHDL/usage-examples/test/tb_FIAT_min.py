import cocotb
from cocotb import start_soon
from cocotb.clock import Clock
from cocotb.handle import Force, Release
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge, Edge, ReadOnly, ReadWrite
from cocotb.queue import Queue 
from cocotb.utils import get_sim_time

#UTILITY METHODS
async def reset(dut):
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0    

async def reset_and_wait(dut, value):
    await ReadOnly()
    while(dut.count.value != 0):
        await RisingEdge(dut.clk)
        await ReadOnly()
    await ReadWrite()
    await reset(dut)
    while(dut.count.value != value):
        await RisingEdge(dut.clk)
        await ReadOnly()
    await FallingEdge(dut.clk)
    
async def clear_queue(queue):
    while (queue.qsize() > 0):  
        await queue.get()    

#CONSTANTS
MAX_CHECK = "Max"
EQ_CHECK = "Equivalence"
PERIOD_NS = 10;

#FIAT METHODS
async def parse_queue(dut, messageQueue, FIAT_method):
    if messageQueue.empty():
        raise AssertionError("{FIAT} error injected, but none found - queue empty".format(FIAT=FIAT_method))
    while (messageQueue.qsize() > 0):    
        msg = await messageQueue.get()
        if msg[0] == FIAT_method:
            dut._log.info(
                "FIAT OK: {FIAT} error found @ {time}ns, count={count}, behavioral model = {TBC}".format(
                    FIAT = msg[0], time = msg[1], count = msg[2],TBC = msg[3]))
            await clear_queue(messageQueue)
            return      
    raise AssertionError("{FIAT} error injected but not found, other errors reported".format(FIAT=FIAT_method))

async def FIAT_max_BB(dut, messageQueue):       
    dut.count.value = Force(5)
    await RisingEdge(dut.clk)
    dut.count.value = Release()
    await RisingEdge(dut.clk)
    await parse_queue(dut, messageQueue, MAX_CHECK)

async def FIAT_max_WB(dut, messageQueue):
    dut.r_count.value = Force(6)
    await RisingEdge(dut.clk)
    dut.r_count.value = Release()
    await RisingEdge(dut.clk)
    await parse_queue(dut, messageQueue, MAX_CHECK)

# ORDINARY METHODS 
class Dut_Monitor:
    def __init__(self, dut, messageQueue):
        self.tQcount = 0   
        start_soon(self.behavioral_model(dut))
        start_soon(self.checks(dut, messageQueue))    
    
    async def behavioral_model(self, dut):
        while(1):
            await RisingEdge(dut.clk)
            if dut.reset.value == 0:
                self.tQcount = (self.tQcount+1)%5
                continue
            self.tQcount = 0     

    async def checks(self, dut, messageQueue):
        await FallingEdge(dut.reset)
        while(1):
            await Edge(dut.clk)
            await ReadOnly()
            assertions = [
                (int(dut.count.value) < 5, MAX_CHECK), 
                (dut.count.value == self.tQcount, EQ_CHECK)]
            for i in assertions: 
                try: assert i[0], i[1]
                except AssertionError as ae:
                    msg = (
                        str(ae).splitlines()[0], 
                        get_sim_time('ns'), 
                        int(dut.count.value), 
                        self.tQcount)
                    await messageQueue.put(msg)

@cocotb.test()
async def main_test(dut):
    messageQueue = Queue()
    start_soon(Clock(dut.clk, PERIOD_NS, 'ns').start())
    dut.reset.value = 1
    await ClockCycles(dut.clk, 2)
    DMON = Dut_Monitor(dut, messageQueue)
    await reset_and_wait(dut, 2)
    await FIAT_max_BB(dut, messageQueue)
    await reset_and_wait(dut, 3)
    await FIAT_max_WB(dut, messageQueue)
    await reset_and_wait(dut, 4)
    await clear_queue(messageQueue)
    assert messageQueue.qsize() == 0, "There are ordinary errors..."
