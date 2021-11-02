#!/usr/bin/env python

import argparse
import binascii
import random
import sys
import tempfile
import time
import os

import targets
import testlib
from testlib import assertEqual, assertNotEqual, assertIn, assertNotIn
from testlib import assertGreater, assertRegexpMatches, assertLess
from testlib import GdbTest, GdbSingleHartTest, TestFailed, assertTrue

MSTATUS_UIE = 0x00000001
MSTATUS_SIE = 0x00000002
MSTATUS_HIE = 0x00000004
MSTATUS_MIE = 0x00000008
MSTATUS_UPIE = 0x00000010
MSTATUS_SPIE = 0x00000020
MSTATUS_HPIE = 0x00000040
MSTATUS_MPIE = 0x00000080
MSTATUS_SPP = 0x00000100
MSTATUS_HPP = 0x00000600
MSTATUS_MPP = 0x00001800
MSTATUS_FS = 0x00006000
MSTATUS_XS = 0x00018000
MSTATUS_MPRV = 0x00020000
MSTATUS_PUM = 0x00040000
MSTATUS_MXR = 0x00080000
MSTATUS_VM = 0x1F000000
MSTATUS32_SD = 0x80000000
MSTATUS64_SD = 0x8000000000000000

# pylint: disable=abstract-method

def ihex_line(address, record_type, data):
    assert len(data) < 128
    line = ":%02X%04X%02X" % (len(data), address, record_type)
    check = len(data)
    check += address % 256
    check += address >> 8
    check += record_type
    for char in data:
        value = ord(char)
        check += value
        line += "%02X" % value
    line += "%02X\n" % ((256-check)%256)
    return line

def ihex_parse(line):
    assert line.startswith(":")
    line = line[1:]
    data_len = int(line[:2], 16)
    address = int(line[2:6], 16)
    record_type = int(line[6:8], 16)
    data = ""
    for i in range(data_len):
        data += "%c" % int(line[8+2*i:10+2*i], 16)
    return record_type, address, data

def readable_binary_string(s):
    return "".join("%02x" % ord(c) for c in s)

class SimpleRegisterTest(GdbTest):
    def check_reg(self, name, alias):
        a = random.randrange(1<<self.hart.xlen)
        b = random.randrange(1<<self.hart.xlen)
        self.gdb.p("$%s=0x%x" % (name, a))
        assertEqual(self.gdb.p("$%s" % alias), a)
        self.gdb.stepi()
        assertEqual(self.gdb.p("$%s" % name), a)
        assertEqual(self.gdb.p("$%s" % alias), a)
        self.gdb.p("$%s=0x%x" % (alias, b))
        assertEqual(self.gdb.p("$%s" % name), b)
        self.gdb.stepi()
        assertEqual(self.gdb.p("$%s" % name), b)
        assertEqual(self.gdb.p("$%s" % alias), b)

    def setup(self):
        # 0x13 is nop
        self.gdb.command("p *((int*) 0x%x)=0x13" % self.hart.ram)
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.hart.ram + 4))
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.hart.ram + 8))
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.hart.ram + 12))
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.hart.ram + 16))
        self.gdb.p("$pc=0x%x" % self.hart.ram)

class SimpleS0Test(SimpleRegisterTest):
    def test(self):
        self.check_reg("s0", "x8")

class SimpleS1Test(SimpleRegisterTest):
    def test(self):
        self.check_reg("s1", "x9")

class SimpleT0Test(SimpleRegisterTest):
    def test(self):
        self.check_reg("t0", "x5")

class SimpleT1Test(SimpleRegisterTest):
    def test(self):
        self.check_reg("t1", "x6")

class SimpleF18Test(SimpleRegisterTest):
    def check_reg(self, name, alias):
        if self.hart.extensionSupported('F'):
            self.gdb.p_raw("$mstatus=$mstatus | 0x00006000")
            self.gdb.stepi()
            a = random.random()
            b = random.random()
            self.gdb.p_raw("$%s=%f" % (name, a))
            assertLess(abs(float(self.gdb.p_raw("$%s" % alias)) - a), .001)
            self.gdb.stepi()
            assertLess(abs(float(self.gdb.p_raw("$%s" % name)) - a), .001)
            assertLess(abs(float(self.gdb.p_raw("$%s" % alias)) - a), .001)
            self.gdb.p_raw("$%s=%f" % (alias, b))
            assertLess(abs(float(self.gdb.p_raw("$%s" % name)) - b), .001)
            self.gdb.stepi()
            assertLess(abs(float(self.gdb.p_raw("$%s" % name)) - b), .001)
            assertLess(abs(float(self.gdb.p_raw("$%s" % alias)) - b), .001)

            size = self.gdb.p("sizeof($%s)" % name)
            if self.hart.extensionSupported('D'):
                assertEqual(size, 8)
            else:
                assertEqual(size, 4)
        else:
            output = self.gdb.p_raw("$" + name)
            assertEqual(output, "void")
            output = self.gdb.p_raw("$" + alias)
            assertEqual(output, "void")

    def test(self):
        self.check_reg("f18", "fs2")

class SimpleMemoryTest(GdbTest):
    def access_test(self, size, data_type):
        assertEqual(self.gdb.p("sizeof(%s)" % data_type), size)
        a = 0x86753095555aaaa & ((1<<(size*8))-1)
        b = 0xdeadbeef12345678 & ((1<<(size*8))-1)
        addrA = self.hart.ram
        addrB = self.hart.ram + self.hart.ram_size - size
        self.gdb.p("*((%s*)0x%x) = 0x%x" % (data_type, addrA, a))
        self.gdb.p("*((%s*)0x%x) = 0x%x" % (data_type, addrB, b))
        assertEqual(self.gdb.p("*((%s*)0x%x)" % (data_type, addrA)), a)
        assertEqual(self.gdb.p("*((%s*)0x%x)" % (data_type, addrB)), b)

class MemTest8(SimpleMemoryTest):
    def test(self):
        self.access_test(1, 'char')

class MemTest16(SimpleMemoryTest):
    def test(self):
        self.access_test(2, 'short')

class MemTest32(SimpleMemoryTest):
    def test(self):
        self.access_test(4, 'int')

class MemTest64(SimpleMemoryTest):
    def test(self):
        self.access_test(8, 'long long')

# FIXME: I'm not passing back invalid addresses correctly in read/write memory.
#class MemTestReadInvalid(SimpleMemoryTest):
#    def test(self):
#        # This test relies on 'gdb_report_data_abort enable' being executed in
#        # the openocd.cfg file.
#        try:
#            self.gdb.p("*((int*)0xdeadbeef)")
#            assert False, "Read should have failed."
#        except testlib.CannotAccess as e:
#            assertEqual(e.address, 0xdeadbeef)
#        self.gdb.p("*((int*)0x%x)" % self.hart.ram)
#
#class MemTestWriteInvalid(SimpleMemoryTest):
#    def test(self):
#        # This test relies on 'gdb_report_data_abort enable' being executed in
#        # the openocd.cfg file.
#        try:
#            self.gdb.p("*((int*)0xdeadbeef)=8675309")
#            assert False, "Write should have failed."
#        except testlib.CannotAccess as e:
#            assertEqual(e.address, 0xdeadbeef)
#        self.gdb.p("*((int*)0x%x)=6874742" % self.hart.ram)

class MemTestBlock(GdbTest):
    length = 1024
    line_length = 16

    def test(self):
        a = tempfile.NamedTemporaryFile(suffix=".ihex")
        data = ""
        for i in range(self.length / self.line_length):
            line_data = "".join(["%c" % random.randrange(256)
                for _ in range(self.line_length)])
            data += line_data
            a.write(ihex_line(i * self.line_length, 0, line_data))
        a.flush()

        self.gdb.command("shell cat %s" % a.name)
        self.gdb.command("restore %s 0x%x" % (a.name, self.hart.ram))
        increment = 19 * 4
        for offset in range(0, self.length, increment) + [self.length-4]:
            value = self.gdb.p("*((int*)0x%x)" % (self.hart.ram + offset))
            written = ord(data[offset]) | \
                    (ord(data[offset+1]) << 8) | \
                    (ord(data[offset+2]) << 16) | \
                    (ord(data[offset+3]) << 24)
            assertEqual(value, written)

        b = tempfile.NamedTemporaryFile(suffix=".ihex")
        self.gdb.command("dump ihex memory %s 0x%x 0x%x" % (b.name,
            self.hart.ram, self.hart.ram + self.length))
        self.gdb.command("shell cat %s" % b.name)
        for line in b.xreadlines():
            record_type, address, line_data = ihex_parse(line)
            if record_type == 0:
                written_data = data[address:address+len(line_data)]
                if line_data != written_data:
                    raise TestFailed(
                            "Data mismatch at 0x%x; wrote %s but read %s" % (
                                address, readable_binary_string(written_data),
                                readable_binary_string(line_data)))

class InstantHaltTest(GdbTest):
    def test(self):
        """Assert that reset is really resetting what it should."""
        self.gdb.command("monitor reset halt")
        self.gdb.command("flushregs")
        threads = self.gdb.threads()
        pcs = []
        for t in threads:
            self.gdb.thread(t)
            pcs.append(self.gdb.p("$pc"))
        for pc in pcs:
            assertIn(pc, self.hart.reset_vectors)
        # mcycle and minstret have no defined reset value.
        mstatus = self.gdb.p("$mstatus")
        assertEqual(mstatus & (MSTATUS_MIE | MSTATUS_MPRV |
            MSTATUS_VM), 0)

class InstantChangePc(GdbTest):
    def test(self):
        """Change the PC right as we come out of reset."""
        # 0x13 is nop
        self.gdb.command("monitor reset halt")
        self.gdb.command("flushregs")
        self.gdb.command("p *((int*) 0x%x)=0x13" % self.hart.ram)
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.hart.ram + 4))
        self.gdb.command("p *((int*) 0x%x)=0x13" % (self.hart.ram + 8))
        self.gdb.p("$pc=0x%x" % self.hart.ram)
        self.gdb.stepi()
        assertEqual((self.hart.ram + 4), self.gdb.p("$pc"))
        self.gdb.stepi()
        assertEqual((self.hart.ram + 8), self.gdb.p("$pc"))

class DebugTest(GdbSingleHartTest):
    # Include malloc so that gdb can make function calls. I suspect this malloc
    # will silently blow through the memory set aside for it, so be careful.
    compile_args = ("programs/debug.c", "programs/checksum.c",
            "programs/tiny-malloc.c", "-DDEFINE_MALLOC", "-DDEFINE_FREE")

    def setup(self):
        self.gdb.load()
        self.gdb.b("_exit")

    def exit(self, expected_result=0xc86455d4):
        output = self.gdb.c()
        assertIn("Breakpoint", output)
        assertIn("_exit", output)
        assertEqual(self.gdb.p("status"), expected_result)

class DebugCompareSections(DebugTest):
    def test(self):
        output = self.gdb.command("compare-sections")
        matched = 0
        for line in output.splitlines():
            if line.startswith("Section"):
                assert line.endswith("matched.")
                matched += 1
        assertGreater(matched, 1)

class DebugFunctionCall(DebugTest):
    def test(self):
        self.gdb.b("main:start")
        self.gdb.c()
        assertEqual(self.gdb.p('fib(6)'), 8)
        assertEqual(self.gdb.p('fib(7)'), 13)
        self.exit()

class DebugChangeString(DebugTest):
    def test(self):
        text = "This little piggy went to the market."
        self.gdb.b("main:start")
        self.gdb.c()
        self.gdb.p('fox = "%s"' % text)
        self.exit(0x43b497b8)

class DebugTurbostep(DebugTest):
    def test(self):
        """Single step a bunch of times."""
        self.gdb.b("main:start")
        self.gdb.c()
        self.gdb.command("p i=0")
        last_pc = None
        advances = 0
        jumps = 0
        for _ in range(10):
            self.gdb.stepi()
            pc = self.gdb.p("$pc")
            assertNotEqual(last_pc, pc)
            if last_pc and pc > last_pc and pc - last_pc <= 4:
                advances += 1
            else:
                jumps += 1
            last_pc = pc
        # Some basic sanity that we're not running between breakpoints or
        # something.
        assertGreater(jumps, 1)
        assertGreater(advances, 5)

class DebugExit(DebugTest):
    def test(self):
        self.exit()

class DebugSymbols(DebugTest):
    def test(self):
        self.gdb.b("main")
        self.gdb.b("rot13")
        output = self.gdb.c()
        assertIn(", main ", output)
        output = self.gdb.c()
        assertIn(", rot13 ", output)

class DebugBreakpoint(DebugTest):
    def test(self):
        self.gdb.b("rot13")
        # The breakpoint should be hit exactly 2 times.
        for _ in range(2):
            output = self.gdb.c()
            self.gdb.p("$pc")
            assertIn("Breakpoint ", output)
            assertIn("rot13 ", output)
        self.exit()

class Hwbp1(DebugTest):
    def test(self):
        if self.hart.instruction_hardware_breakpoint_count < 1:
            return 'not_applicable'

        if not self.hart.honors_tdata1_hmode:
            # Run to main before setting the breakpoint, because startup code
            # will otherwise clear the trigger that we set.
            self.gdb.b("main")
            self.gdb.c()

        self.gdb.hbreak("rot13")
        # The breakpoint should be hit exactly 2 times.
        for _ in range(2):
            output = self.gdb.c()
            self.gdb.p("$pc")
            assertRegexpMatches(output, r"[bB]reakpoint")
            assertIn("rot13 ", output)
        self.exit()

class Hwbp2(DebugTest):
    def test(self):
        if self.hart.instruction_hardware_breakpoint_count < 2:
            return 'not_applicable'

        self.gdb.hbreak("main")
        self.gdb.hbreak("rot13")
        # We should hit 3 breakpoints.
        for expected in ("main", "rot13", "rot13"):
            output = self.gdb.c()
            self.gdb.p("$pc")
            assertRegexpMatches(output, r"[bB]reakpoint")
            assertIn("%s " % expected, output)
        self.exit()

class TooManyHwbp(DebugTest):
    def test(self):
        for i in range(30):
            self.gdb.hbreak("*rot13 + %d" % (i * 4))

        output = self.gdb.c()
        assertIn("Cannot insert hardware breakpoint", output)
        # Clean up, otherwise the hardware breakpoints stay set and future
        # tests may fail.
        self.gdb.command("D")

class Registers(DebugTest):
    def test(self):
        # Get to a point in the code where some registers have actually been
        # used.
        self.gdb.b("rot13")
        self.gdb.c()
        self.gdb.c()
        # Try both forms to test gdb.
        for cmd in ("info all-registers", "info registers all"):
            output = self.gdb.command(cmd)
            for reg in ('zero', 'ra', 'sp', 'gp', 'tp'):
                assertIn(reg, output)
            for line in output.splitlines():
                assertRegexpMatches(line, r"^\S")

        #TODO
        # mcpuid is one of the few registers that should have the high bit set
        # (for rv64).
        # Leave this commented out until gdb and spike agree on the encoding of
        # mcpuid (which is going to be renamed to misa in any case).
        #assertRegexpMatches(output, ".*mcpuid *0x80")

        #TODO:
        # The instret register should always be changing.
        #last_instret = None
        #for _ in range(5):
        #    instret = self.gdb.p("$instret")
        #    assertNotEqual(instret, last_instret)
        #    last_instret = instret
        #    self.gdb.stepi()

        self.exit()

class UserInterrupt(DebugTest):
    def test(self):
        """Sending gdb ^C while the program is running should cause it to
        halt."""
        self.gdb.b("main:start")
        self.gdb.c()
        self.gdb.p("i=123")
        self.gdb.c(wait=False)
        time.sleep(2)
        output = self.gdb.interrupt()
        assert "main" in output
        assertGreater(self.gdb.p("j"), 10)
        self.gdb.p("i=0")
        self.exit()

class InterruptTest(GdbSingleHartTest):
    compile_args = ("programs/interrupt.c",)

    def early_applicable(self):
        return self.target.supports_clint_mtime

    def setup(self):
        self.gdb.load()

    def test(self):
        self.gdb.b("main")
        output = self.gdb.c()
        assertIn(" main ", output)
        self.gdb.b("trap_entry")
        output = self.gdb.c()
        assertIn(" trap_entry ", output)
        assertEqual(self.gdb.p("$mip") & 0x80, 0x80)
        assertEqual(self.gdb.p("interrupt_count"), 0)
        # You'd expect local to still be 0, but it looks like spike doesn't
        # jump to the interrupt handler immediately after the write to
        # mtimecmp.
        assertLess(self.gdb.p("local"), 1000)
        self.gdb.command("delete breakpoints")
        for _ in range(10):
            self.gdb.c(wait=False)
            time.sleep(2)
            self.gdb.interrupt()
            interrupt_count = self.gdb.p("interrupt_count")
            local = self.gdb.p("local")
            if interrupt_count > 1000 and \
                    local > 1000:
                return

        assertGreater(interrupt_count, 1000)
        assertGreater(local, 1000)

    def postMortem(self):
        GdbSingleHartTest.postMortem(self)
        self.gdb.p("*((long long*) 0x200bff8)")
        self.gdb.p("*((long long*) 0x2004000)")
        self.gdb.p("interrupt_count")
        self.gdb.p("local")

class MulticoreRegTest(GdbTest):
    compile_args = ("programs/infinite_loop.S", "-DMULTICORE")

    def early_applicable(self):
        return len(self.target.harts) > 1

    def setup(self):
        self.gdb.load()
        for hart in self.target.harts:
            self.gdb.select_hart(hart)
            self.gdb.p("$pc=_start")

    def test(self):
        # Run to main
        for hart in self.target.harts:
            self.gdb.select_hart(hart)
            self.gdb.b("main")
            self.gdb.c()
            assertIn("main", self.gdb.where())
            self.gdb.command("delete breakpoints")

        # Run through the entire loop.
        for hart in self.target.harts:
            self.gdb.select_hart(hart)
            self.gdb.b("main_end")
            self.gdb.c()
            assertIn("main_end", self.gdb.where())

        hart_ids = []
        for hart in self.target.harts:
            self.gdb.select_hart(hart)
            # Check register values.
            hart_id = self.gdb.p("$x1")
            assertNotIn(hart_id, hart_ids)
            hart_ids.append(hart_id)
            for n in range(2, 32):
                value = self.gdb.p("$x%d" % n)
                assertEqual(value, hart_ids[-1] + n - 1)

        # Confirmed that we read different register values for different harts.
        # Write a new value to x1, and run through the add sequence again.

        for hart in self.target.harts:
            self.gdb.select_hart(hart)
            self.gdb.p("$x1=0x%x" % (hart.index * 0x800))
            self.gdb.p("$pc=main_post_csrr")
            self.gdb.c()
        for hart in self.target.harts:
            self.gdb.select_hart(hart)
            assertIn("main", self.gdb.where())
            # Check register values.
            for n in range(1, 32):
                value = self.gdb.p("$x%d" % n)
                assertEqual(value, hart.index * 0x800 + n - 1)

class MulticoreRunHaltStepiTest(GdbTest):
    compile_args = ("programs/multicore.c", "-DMULTICORE")

    def early_applicable(self):
        return len(self.target.harts) > 1

    def setup(self):
        self.gdb.load()
        for hart in self.target.harts:
            self.gdb.select_hart(hart)
            self.gdb.p("$pc=_start")

    def test(self):
        previous_hart_count = [0 for h in self.target.harts]
        previous_interrupt_count = [0 for h in self.target.harts]
        for _ in range(10):
            self.gdb.c(wait=False)
            time.sleep(2)
            self.gdb.interrupt()
            self.gdb.p("$mie")
            self.gdb.p("$mip")
            self.gdb.p("$mstatus")
            self.gdb.p("$priv")
            self.gdb.p("buf", fmt="")
            hart_count = self.gdb.p("hart_count")
            interrupt_count = self.gdb.p("interrupt_count")
            for i, h in enumerate(self.target.harts):
                assertGreater(hart_count[i], previous_hart_count[i])
                assertGreater(interrupt_count[i], previous_interrupt_count[i])
                self.gdb.select_hart(h)
                pc = self.gdb.p("$pc")
                self.gdb.stepi()
                stepped_pc = self.gdb.p("$pc")
                assertNotEqual(pc, stepped_pc)

class MulticoreRunAllHaltOne(GdbTest):
    compile_args = ("programs/multicore.c", "-DMULTICORE")

    def early_applicable(self):
        return len(self.target.harts) > 1

    def setup(self):
        self.gdb.select_hart(self.target.harts[0])
        self.gdb.load()
        for hart in self.target.harts:
            self.gdb.select_hart(hart)
            self.gdb.p("$pc=_start")

    def test(self):
        if not self.gdb.one_hart_per_gdb():
            return 'not_applicable'

        # Run harts in reverse order
        for h in reversed(self.target.harts):
            self.gdb.select_hart(h)
            self.gdb.c(wait=False)

        self.gdb.interrupt()
        # Give OpenOCD time to call poll() on both harts, which is what causes
        # the bug.
        time.sleep(1)
        self.gdb.p("buf", fmt="")

class StepTest(GdbTest):
    compile_args = ("programs/step.S", )

    def setup(self):
        self.gdb.load()
        self.gdb.b("main")
        self.gdb.c()

    def test(self):
        main_address = self.gdb.p("$pc")
        if self.hart.extensionSupported("c"):
            sequence = (4, 8, 0xc, 0xe, 0x14, 0x18, 0x22, 0x1c, 0x24, 0x24)
        else:
            sequence = (4, 8, 0xc, 0x10, 0x18, 0x1c, 0x28, 0x20, 0x2c, 0x2c)
        for expected in sequence:
            self.gdb.stepi()
            pc = self.gdb.p("$pc")
            assertEqual("%x" % (pc - main_address), "%x" % expected)

class TriggerTest(GdbTest):
    compile_args = ("programs/trigger.S", )
    def setup(self):
        self.gdb.load()
        self.gdb.b("_exit")
        self.gdb.b("main")
        self.gdb.c()

    def exit(self):
        output = self.gdb.c()
        assertIn("Breakpoint", output)
        assertIn("_exit", output)

class TriggerExecuteInstant(TriggerTest):
    """Test an execute breakpoint on the first instruction executed out of
    debug mode."""
    def test(self):
        main_address = self.gdb.p("$pc")
        self.gdb.command("hbreak *0x%x" % (main_address + 4))
        self.gdb.c()
        assertEqual(self.gdb.p("$pc"), main_address+4)

# FIXME: Triggers aren't quite working yet
#class TriggerLoadAddress(TriggerTest):
#    def test(self):
#        self.gdb.command("rwatch *((&data)+1)")
#        output = self.gdb.c()
#        assertIn("read_loop", output)
#        assertEqual(self.gdb.p("$a0"),
#                self.gdb.p("(&data)+1"))
#        self.exit()

class TriggerLoadAddressInstant(TriggerTest):
    """Test a load address breakpoint on the first instruction executed out of
    debug mode."""
    def test(self):
        self.gdb.command("b just_before_read_loop")
        self.gdb.c()
        read_loop = self.gdb.p("&read_loop")
        read_again = self.gdb.p("&read_again")
        self.gdb.command("rwatch data")
        self.gdb.c()
        # Accept hitting the breakpoint before or after the load instruction.
        assertIn(self.gdb.p("$pc"), [read_loop, read_loop + 4])
        assertEqual(self.gdb.p("$a0"), self.gdb.p("&data"))

        self.gdb.c()
        assertIn(self.gdb.p("$pc"), [read_again, read_again + 4])
        assertEqual(self.gdb.p("$a0"), self.gdb.p("&data"))

# FIXME: Triggers aren't quite working yet
#class TriggerStoreAddress(TriggerTest):
#    def test(self):
#        self.gdb.command("watch *((&data)+3)")
#        output = self.gdb.c()
#        assertIn("write_loop", output)
#        assertEqual(self.gdb.p("$a0"),
#                self.gdb.p("(&data)+3"))
#        self.exit()

class TriggerStoreAddressInstant(TriggerTest):
    def test(self):
        """Test a store address breakpoint on the first instruction executed out
        of debug mode."""
        self.gdb.command("b just_before_write_loop")
        self.gdb.c()
        write_loop = self.gdb.p("&write_loop")
        self.gdb.command("watch data")
        self.gdb.c()
        # Accept hitting the breakpoint before or after the store instruction.
        assertIn(self.gdb.p("$pc"), [write_loop, write_loop + 4])
        assertEqual(self.gdb.p("$a0"), self.gdb.p("&data"))

class TriggerDmode(TriggerTest):
    def early_applicable(self):
        return self.hart.honors_tdata1_hmode

    def check_triggers(self, tdata1_lsbs, tdata2):
        dmode = 1 << (self.hart.xlen-5)

        triggers = []

        if self.hart.xlen == 32:
            xlen_type = 'int'
        elif self.hart.xlen == 64:
            xlen_type = 'long long'
        else:
            raise NotImplementedError

        dmode_count = 0
        i = 0
        for i in range(16):
            tdata1 = self.gdb.p("((%s *)&data)[%d]" % (xlen_type, 2*i))
            if tdata1 == 0:
                break
            tdata2 = self.gdb.p("((%s *)&data)[%d]" % (xlen_type, 2*i+1))

            if tdata1 & dmode:
                dmode_count += 1
            else:
                assertEqual(tdata1 & 0xffff, tdata1_lsbs)
                assertEqual(tdata2, tdata2)

        assertGreater(i, 1)
        assertEqual(dmode_count, 1)

        return triggers

    def test(self):
        self.gdb.command("hbreak write_load_trigger")
        self.gdb.b("clear_triggers")
        self.gdb.p("$pc=write_store_trigger")
        output = self.gdb.c()
        assertIn("write_load_trigger", output)
        self.check_triggers((1<<6) | (1<<1), 0xdeadbee0)
        output = self.gdb.c()
        assertIn("clear_triggers", output)
        self.check_triggers((1<<6) | (1<<0), 0xfeedac00)

class RegsTest(GdbTest):
    compile_args = ("programs/regs.S", )
    def setup(self):
        self.gdb.load()
        self.gdb.b("main")
        self.gdb.b("handle_trap")
        self.gdb.c()

class WriteGprs(RegsTest):
    def test(self):
        regs = [("x%d" % n) for n in range(2, 32)]

        self.gdb.p("$pc=write_regs")
        for i, r in enumerate(regs):
            self.gdb.p("$%s=%d" % (r, (0xdeadbeef<<i)+17))
        self.gdb.p("$x1=data")
        self.gdb.command("b all_done")
        output = self.gdb.c()
        assertIn("Breakpoint ", output)

        # Just to get this data in the log.
        self.gdb.command("x/30gx data")
        self.gdb.command("info registers")
        for n in range(len(regs)):
            assertEqual(self.gdb.x("data+%d" % (8*n), 'g'),
                    ((0xdeadbeef<<n)+17) & ((1<<self.hart.xlen)-1))

class WriteCsrs(RegsTest):
    def test(self):
        # As much a test of gdb as of the simulator.
        self.gdb.p("$mscratch=0")
        self.gdb.stepi()
        assertEqual(self.gdb.p("$mscratch"), 0)
        self.gdb.p("$mscratch=123")
        self.gdb.stepi()
        assertEqual(self.gdb.p("$mscratch"), 123)

        self.gdb.p("$pc=write_regs")
        self.gdb.p("$x1=data")
        self.gdb.command("b all_done")
        self.gdb.command("c")

        assertEqual(123, self.gdb.p("$mscratch"))
        assertEqual(123, self.gdb.p("$x1"))
        assertEqual(123, self.gdb.p("$csr832"))

class DownloadTest(GdbTest):
    def setup(self):
        # pylint: disable=attribute-defined-outside-init
        length = min(2**10, self.hart.ram_size - 2048)
        self.download_c = tempfile.NamedTemporaryFile(prefix="download_",
                suffix=".c", delete=False)
        self.download_c.write("#include <stdint.h>\n")
        self.download_c.write(
                "unsigned int crc32a(uint8_t *message, unsigned int size);\n")
        self.download_c.write("uint32_t length = %d;\n" % length)
        self.download_c.write("uint8_t d[%d] = {\n" % length)
        self.crc = 0
        assert length % 16 == 0
        for i in range(length / 16):
            self.download_c.write("  /* 0x%04x */ " % (i * 16))
            for _ in range(16):
                value = random.randrange(1<<8)
                self.download_c.write("0x%02x, " % value)
                self.crc = binascii.crc32("%c" % value, self.crc)
            self.download_c.write("\n")
        self.download_c.write("};\n")
        self.download_c.write("uint8_t *data = &d[0];\n")
        self.download_c.write(
                "uint32_t main() { return crc32a(data, length); }\n")
        self.download_c.flush()

        if self.crc < 0:
            self.crc += 2**32

        self.binary = self.target.compile(self.hart, self.download_c.name,
                "programs/checksum.c")
        self.gdb.command("file %s" % self.binary)

    def test(self):
        self.gdb.load()
        self.gdb.command("b _exit")
        self.gdb.c(timeout=60)
        assertEqual(self.gdb.p("status"), self.crc)
        os.unlink(self.download_c.name)

#class MprvTest(GdbTest):
#    compile_args = ("programs/mprv.S", )
#    def setup(self):
#        self.gdb.load()
#
#    def test(self):
#        """Test that the debugger can access memory when MPRV is set."""
#        self.gdb.c(wait=False)
#        time.sleep(0.5)
#        self.gdb.interrupt()
#        output = self.gdb.command("p/x *(int*)(((char*)&data)-0x80000000)")
#        assertIn("0xbead", output)

class PrivTest(GdbTest):
    compile_args = ("programs/priv.S", )
    def setup(self):
        # pylint: disable=attribute-defined-outside-init
        self.gdb.load()

        misa = self.hart.misa
        self.supported = set()
        if misa & (1<<20):
            self.supported.add(0)
        if misa & (1<<18):
            self.supported.add(1)
        if misa & (1<<7):
            self.supported.add(2)
        self.supported.add(3)

class PrivRw(PrivTest):
    def test(self):
        """Test reading/writing priv."""
        # Disable physical memory protection by allowing U mode access to all
        # memory.
        try:
            self.gdb.p("$pmpcfg0=0xf")  # TOR, R, W, X
            self.gdb.p("$pmpaddr0=0x%x" %
                    ((self.hart.ram + self.hart.ram_size) >> 2))
        except testlib.CouldNotFetch:
            # PMP registers are optional
            pass

        # Leave the PC at _start, where the first 4 instructions should be
        # legal in any mode.
        for privilege in range(4):
            self.gdb.p("$priv=%d" % privilege)
            self.gdb.stepi()
            actual = self.gdb.p("$priv")
            assertIn(actual, self.supported)
            if privilege in self.supported:
                assertEqual(actual, privilege)

class PrivChange(PrivTest):
    def test(self):
        """Test that the core's privilege level actually changes."""

        if 0 not in self.supported:
            return 'not_applicable'

        self.gdb.b("main")
        self.gdb.c()

        # Machine mode
        self.gdb.p("$priv=3")
        main_address = self.gdb.p("$pc")
        self.gdb.stepi()
        assertEqual("%x" % self.gdb.p("$pc"), "%x" % (main_address+4))

        # User mode
        self.gdb.p("$priv=0")
        self.gdb.stepi()
        # Should have taken an exception, so be nowhere near main.
        pc = self.gdb.p("$pc")
        assertTrue(pc < main_address or pc > main_address + 0x100)

parsed = None
def main():
    parser = argparse.ArgumentParser(
            description="Test that gdb can talk to a RISC-V target.",
            epilog="""
            Example command line from the real world:
            Run all RegsTest cases against a physical FPGA, with custom openocd command:
            ./gdbserver.py --freedom-e300 --server_cmd "$HOME/SiFive/openocd/src/openocd -s $HOME/SiFive/openocd/tcl -d" Simple
            """)
    targets.add_target_options(parser)

    testlib.add_test_run_options(parser)

    # TODO: remove global
    global parsed   # pylint: disable=global-statement
    parsed = parser.parse_args()
    target = targets.target(parsed)
    testlib.print_log_names = parsed.print_log_names

    module = sys.modules[__name__]

    return testlib.run_all_tests(module, target, parsed)

# TROUBLESHOOTING TIPS
# If a particular test fails, run just that one test, eg.:
# ./gdbserver.py MprvTest.test_mprv
# Then inspect gdb.log and spike.log to see what happened in more detail.

if __name__ == '__main__':
    sys.exit(main())
