package freechips.rocketchip.devices.debug

import Chisel._

// This file was auto-generated from the repository at https://github.com/riscv/riscv-debug-spec.git,
// 'make chisel'

object DMI_RegAddrs {
  /* The address of this register will not change in the future, because it
        contains \Fversion.  It has changed from version 0.11 of this spec.

        This register reports status for the overall debug module
        as well as the currently selected harts, as defined in \Fhasel.

        Harts are nonexistent if they will never be part of this system, no
        matter how long a user waits. Eg. in a simple single-hart system only
        one hart exists, and all others are nonexistent. Debuggers may assume
        that a system has no harts with indexes higher than the first
        nonexistent one.

        Harts are unavailable if they might exist/become available at a later
        time, or if there are other harts with higher indexes than this one. Eg.
        in a multi-hart system some might temporarily be powered down, or a
        system might support hot-swapping harts. Systems with very large number
        of harts may permanently disable some during manufacturing, leaving
        holes in the otherwise continuous hart index space. In order to let the
        debugger discover all harts, they must show up as unavailable even if
        there is no chance of them ever becoming available.
  */
  def DMI_DMSTATUS =  0x11

  /* This register controls the overall debug module
        as well as the currently selected harts, as defined in \Fhasel.

\label{hartsel}
\index{hartsel}
        Throughout this document we refer to \Fhartsel, which is \Fhartselhi
        combined with \Fhartsello. While the spec allows for 20 \Fhartsel bits,
        an implementation may choose to implement fewer than that. The actual
        width of \Fhartsel is called {\tt HARTSELLEN}. It must be at least 0
        and at most 20. A debugger should discover {\tt HARTSELLEN} by writing
        all ones to \Fhartsel (assuming the maximum size) and reading back the
        value to see which bits were actually set.
  */
  def DMI_DMCONTROL =  0x10

  /* This register gives information about the hart currently
      selected by \Fhartsel.

      This register is optional. If it is not present it should
      read all-zero.

      If this register is included, the debugger can do more with
      the Program Buffer by writing programs which
      explicitly access the {\tt data} and/or {\tt dscratch}
      registers.
  */
  def DMI_HARTINFO =  0x12

  /* This register selects which of the 32-bit portion of the hart array mask register
      is accessible in \Rhawindow.

      The hart array mask register provides a mask of all harts controlled by
      the debug module. A hart is part of the currently selected harts if
      the corresponding bit is set in the hart array mask register and
      \Fhasel in \Rdmcontrol is 1, or if the hart is selected by \Fhartsel.
  */
  def DMI_HAWINDOWSEL =  0x14

  /* This register provides R/W access to a 32-bit portion of the
      hart array mask register.
      The position of the window is determined by \Rhawindowsel. I.e. bit 0
      refers to hart $\Rhawindowsel * 32$, while bit 31 refers to hart
      $\Rhawindowsel * 32 + 31$.
  */
  def DMI_HAWINDOW =  0x15

  def DMI_ABSTRACTCS =  0x16

  /* Writes to this register cause the corresponding abstract command to be
        executed.

        Writing while an abstract command is executing causes \Fcmderr to be set.

        If \Fcmderr is non-zero, writes to this register are ignored.

        \begin{commentary}
            \Fcmderr inhibits starting a new command to accommodate debuggers
            that, for performance reasons, send several commands to be executed
            in a row without checking \Fcmderr in between. They can safely do
            so and check \Fcmderr at the end without worrying that one command
            failed but then a later command (which might have depended on the
            previous one succeeding) passed.
        \end{commentary}
  */
  def DMI_COMMAND =  0x17

  /* This register is optional. Including it allows more efficient burst accesses.
      Debugger can attempt to set bits and read them back to determine if the functionality is supported.
  */
  def DMI_ABSTRACTAUTO =  0x18

  /* When {\tt devtreevalid} is set, reading this register returns bits 31:0
      of the Device Tree address. Reading the other {\tt devtreeaddr}
      registers returns the upper bits of the address.

      When system bus mastering is implemented, this must be an
      address that can be used with the System Bus Access module. Otherwise,
      this must be an address that can be used to access the
      Device Tree from the hart with ID 0.

      If {\tt devtreevalid} is 0, then the {\tt devtreeaddr} registers
      hold identifier information which is not
      further specified in this document.

      The Device Tree itself is described in the RISC-V Privileged
      Specification.
  */
  def DMI_DEVTREEADDR0 =  0x19

  def DMI_DEVTREEADDR1 =  0x1a

  def DMI_DEVTREEADDR2 =  0x1b

  def DMI_DEVTREEADDR3 =  0x1c

  /* If there is more than one DM accessible on this DMI, this register
        contains the base address of the next one in the chain, or 0 if this is
        the last one in the chain.
  */
  def DMI_NEXTDM =  0x1d

  /* \Rdatazero through \Rdataeleven are basic read/write registers that may
        be read or changed by abstract commands. \Fdatacount indicates how many
        of them are implemented, starting at \Rsbdatazero, counting up.
        Table~\ref{tab:datareg} shows how abstract commands use these
        registers.

        Accessing these registers while an abstract command is executing causes
        \Fcmderr to be set.

        Attempts to write them while \Fbusy is set does not change their value.

        The values in these registers may not be preserved after an abstract
        command is executed. The only guarantees on their contents are the ones
        offered by the command in question. If the command fails, no
        assumptions can be made about the contents of these registers.
  */
  def DMI_DATA0 =  0x04

  def DMI_DATA11 =  0x0f

  /* \Rprogbufzero through \Rprogbuffifteen provide read/write access to the
        optional program buffer. \Fprogbufsize indicates how many of them are
        implemented starting at \Rprogbufzero, counting up.

        Accessing these registers while an abstract command is executing causes
        \Fcmderr to be set.

        Attempts to write them while \Fbusy is set does not change their value.
  */
  def DMI_PROGBUF0 =  0x20

  def DMI_PROGBUF15 =  0x2f

  /* This register serves as a 32-bit serial port to the authentication
        module.

        When \Fauthbusy is clear, the debugger can communicate with the
        authentication module by reading or writing this register. There is no
        separate mechanism to signal overflow/underflow.
  */
  def DMI_AUTHDATA =  0x30

  /* Each bit in this read-only register indicates whether one specific hart
        is halted or not.

        The LSB reflects the halt status of hart \{hartsel[19:5],5'h0\}, and the
        MSB reflects halt status of hart \{hartsel[19:5],5'h1f\}.
  */
  def DMI_HALTSUM0 =  0x40

  /* Each bit in this read-only register indicates whether any of a group of
        harts is halted or not.

        This register may not be present in systems with fewer than
        33 harts.

        The LSB reflects the halt status of harts \{hartsel[19:10],10'h0\}
        through \{hartsel[19:10],10'h1f\}.
        The MSB reflects the halt status of harts \{hartsel[19:10],10'h3e0\}
        through \{hartsel[19:10],10'h3ff\}.
  */
  def DMI_HALTSUM1 =  0x13

  /* Each bit in this read-only register indicates whether any of a group of
        harts is halted or not.

        This register may not be present in systems with fewer than
        1025 harts.

        The LSB reflects the halt status of harts \{hartsel[19:15],15'h0\}
        through \{hartsel[19:15],15'h3ff\}.
        The MSB reflects the halt status of harts \{hartsel[19:15],15'h7c00\}
        through \{hartsel[19:15],15'h7fff\}.
  */
  def DMI_HALTSUM2 =  0x34

  /* Each bit in this read-only register indicates whether any of a group of
        harts is halted or not.

        This register may not be present in systems with fewer than
        32769 harts.

        The LSB reflects the halt status of harts 20'h0 through 20'h7fff.
        The MSB reflects the halt status of harts 20'hf8000 through 20'hfffff.
  */
  def DMI_HALTSUM3 =  0x35

  /* If \Fsbasize is less than 97, then this register is not present.

        When the system bus master is busy, writes to this register will set
        \Fsbbusyerror and don't do anything else.
  */
  def DMI_SBADDRESS3 =  0x37

  def DMI_SBCS =  0x38

  /* If \Fsbasize is 0, then this register is not present.

        When the system bus master is busy, writes to this register will set
        \Fsbbusyerror and don't do anything else.

        \begin{steps}{If \Fsberror is 0, \Fsbbusyerror is 0, and \Fsbreadonaddr
        is set then writes to this register start the following:}
            \item Set \Fsbbusy.
            \item Perform a bus read from the new value of {\tt sbaddress}.
            \item If the read succeeded and \Fsbautoincrement is set, increment
            {\tt sbaddress}.
            \item Clear \Fsbbusy.
        \end{steps}
  */
  def DMI_SBADDRESS0 =  0x39

  /* If \Fsbasize is less than 33, then this register is not present.

        When the system bus master is busy, writes to this register will set
        \Fsbbusyerror and don't do anything else.
  */
  def DMI_SBADDRESS1 =  0x3a

  /* If \Fsbasize is less than 65, then this register is not present.

        When the system bus master is busy, writes to this register will set
        \Fsbbusyerror and don't do anything else.
  */
  def DMI_SBADDRESS2 =  0x3b

  /* If all of the {\tt sbaccess} bits in \Rsbcs are 0, then this register
        is not present.

        Any successful system bus read updates the data in this register.

        If \Fsberror or \Fsbbusyerror both aren't 0 then accesses do nothing.

        If the bus master is busy then accesses set \Fsbbusyerror, and don't do
        anything else.

        \begin{steps}{Writes to this register start the following:}
            \item Set \Fsbbusy.
            \item Perform a bus write of the new value of {\tt sbdata} to {\tt sbaddress}.
            \item If the write succeeded and \Fsbautoincrement is set,
            increment {\tt sbaddress}.
            \item Clear \Fsbbusy.
        \end{steps}

        \begin{steps}{Reads from this register start the following:}
            \item ``Return'' the data.
            \item Set \Fsbbusy.
            \item If \Fsbautoincrement is set, increment {\tt sbaddress}.
            \item If \Fsbreadondata is set, perform another system bus read.
            \item Clear \Fsbbusy.
        \end{steps}

        Only \Rsbdatazero has this behavior. The other {\tt sbdata} registers
        have no side effects. On systems that have buses wider than 32 bits, a
        debugger should access \Rsbdatazero after accessing the other {\tt
        sbdata} registers.
  */
  def DMI_SBDATA0 =  0x3c

  /* If \Fsbaccesssixtyfour and \Fsbaccessonetwentyeight are 0, then this
        register is not present.

        If the bus master is busy then accesses set \Fsbbusyerror, and don't do
        anything else.
  */
  def DMI_SBDATA1 =  0x3d

  /* This register only exists if \Fsbaccessonetwentyeight is 1.

        If the bus master is busy then accesses set \Fsbbusyerror, and don't do
        anything else.
  */
  def DMI_SBDATA2 =  0x3e

  /* This register only exists if \Fsbaccessonetwentyeight is 1.

        If the bus master is busy then accesses set \Fsbbusyerror, and don't do
        anything else.
  */
  def DMI_SBDATA3 =  0x3f

}

class DMSTATUSFields extends Bundle {

  val reserved0 = UInt(9.W)

  /* If 1, then there is an implicit {\tt ebreak} instruction at the
            non-existent word immediately after the Program Buffer. This saves
            the debugger from having to write the {\tt ebreak} itself, and
            allows the Program Buffer to be one word smaller.

            This must be 1 when \Fprogbufsize is 1.
  */
  val impebreak = Bool()

  val reserved1 = UInt(2.W)

  /* This field is 1 when all currently selected harts have been reset but the reset has not been acknowledged.
  */
  val allhavereset = Bool()

  /* This field is 1 when any currently selected hart has been reset but the reset has not been acknowledged.
  */
  val anyhavereset = Bool()

  /* This field is 1 when all currently selected harts have acknowledged
            the previous resume request.
  */
  val allresumeack = Bool()

  /* This field is 1 when any currently selected hart has acknowledged
            the previous resume request.
  */
  val anyresumeack = Bool()

  /* This field is 1 when all currently selected harts do not exist in this system.
  */
  val allnonexistent = Bool()

  /* This field is 1 when any currently selected hart does not exist in this system.
  */
  val anynonexistent = Bool()

  /* This field is 1 when all currently selected harts are unavailable.
  */
  val allunavail = Bool()

  /* This field is 1 when any currently selected hart is unavailable.
  */
  val anyunavail = Bool()

  /* This field is 1 when all currently selected harts are running.
  */
  val allrunning = Bool()

  /* This field is 1 when any currently selected hart is running.
  */
  val anyrunning = Bool()

  /* This field is 1 when all currently selected harts are halted.
  */
  val allhalted = Bool()

  /* This field is 1 when any currently selected hart is halted.
  */
  val anyhalted = Bool()

  /* 0 when authentication is required before using the DM.  1 when the
            authentication check has passed. On components that don't implement
            authentication, this bit must be preset as 1.
  */
  val authenticated = Bool()

  /* 0: The authentication module is ready to process the next
            read/write to \Rauthdata.

            1: The authentication module is busy. Accessing \Rauthdata results
            in unspecified behavior.

            \Fauthbusy only becomes set in immediate response to an access to
            \Rauthdata.
  */
  val authbusy = Bool()

  val reserved2 = UInt(1.W)

  /* 0: \Rdevtreeaddrzero--\Rdevtreeaddrthree hold information which
            is not relevant to the Device Tree.

            1: \Rdevtreeaddrzero--\Rdevtreeaddrthree registers hold the address of the
            Device Tree.
  */
  val devtreevalid = Bool()

  /* 0: There is no Debug Module present.

            1: There is a Debug Module and it conforms to version 0.11 of this
            specification.

            2: There is a Debug Module and it conforms to version 0.13 of this
            specification.

            15: There is a Debug Module but it does not conform to any
            available version of this spec.
  */
  val version = UInt(4.W)

}

class DMCONTROLFields extends Bundle {

  /* Writes the halt request bit for all currently selected harts.
            When set to 1, each selected hart will halt if it is not currently
            halted.

            Writing 1 or 0 has no effect on a hart which is already halted, but
            the bit must be cleared to 0 before the hart is resumed.

            Writes apply to the new value of \Fhartsel and \Fhasel.
  */
  val haltreq = Bool()

  /* Writes the resume request bit for all currently selected harts.
            When set to 1, each selected hart will resume if it is currently
            halted.

            The resume request bit is ignored while the halt request bit is
            set.

            Writes apply to the new value of \Fhartsel and \Fhasel.
  */
  val resumereq = Bool()

  /* This optional field writes the reset bit for all the currently
            selected harts.  To perform a reset the debugger writes 1, and then
            writes 0 to deassert the reset signal.

            If this feature is not implemented, the bit always stays 0, so
            after writing 1 the debugger can read the register back to see if
            the feature is supported.

            Writes apply to the new value of \Fhartsel and \Fhasel.
  */
  val hartreset = Bool()

  /* Writing 1 to this bit clears the {\tt havereset} bits for
            any selected harts.

            Writes apply to the new value of \Fhartsel and \Fhasel.
  */
  val ackhavereset = Bool()

  val reserved0 = UInt(1.W)

  /* Selects the  definition of currently selected harts.

            0: There is a single currently selected hart, that selected by \Fhartsel.

            1: There may be multiple currently selected harts -- that selected by \Fhartsel,
               plus those selected by the hart array mask register.

            An implementation which does not implement the hart array mask register
            should tie this field to 0. A debugger which wishes to use the hart array
            mask register feature should set this bit and read back to see if the functionality
            is supported.
  */
  val hasel = Bool()

  /* The low 10 bits of \Fhartsel: the DM-specific index of the hart to
            select. This hart is always part of the currently selected harts.
  */
  val hartsello = UInt(10.W)

  /* The high 10 bits of \Fhartsel: the DM-specific index of the hart to
            select. This hart is always part of the currently selected harts.
  */
  val hartselhi = UInt(10.W)

  val reserved1 = UInt(4.W)

  /* This bit controls the reset signal from the DM to the rest of the
            system. The signal should reset every part of the system, including
            every hart, except for the DM and any logic required to access the
            DM.
            To perform a system reset the debugger writes 1,
            and then writes 0
            to deassert the reset.
  */
  val ndmreset = Bool()

  /* This bit serves as a reset signal for the Debug Module itself.

            0: The module's state, including authentication mechanism,
            takes its reset values (the \Fdmactive bit is the only bit which can
            be written to something other than its reset value).

            1: The module functions normally.

            No other mechanism should exist that may result in resetting the
            Debug Module after power up, including the platform's system reset
            or Debug Transport reset signals.

            A debugger may pulse this bit low to get the debug module into a
            known state.

            Implementations may use this bit to aid debugging, for example by
            preventing the Debug Module from being power gated while debugging
            is active.
  */
  val dmactive = Bool()

}

class HARTINFOFields extends Bundle {

  val reserved0 = UInt(8.W)

  /* Number of {\tt dscratch} registers available for the debugger
            to use during program buffer execution, starting from \Rdscratchzero.
            The debugger can make no assumptions about the contents of these
            registers between commands.
  */
  val nscratch = UInt(4.W)

  val reserved1 = UInt(3.W)

  /* 0: The {\tt data} registers are shadowed in the hart by CSR
            registers. Each CSR register is XLEN bits in size, and corresponds
            to a single argument, per Table~\ref{tab:datareg}.

            1: The {\tt data} registers are shadowed in the hart's memory map.
            Each register takes up 4 bytes in the memory map.
  */
  val dataaccess = Bool()

  /* If \Fdataaccess is 0: Number of CSR registers dedicated to
            shadowing the {\tt data} registers.

            If \Fdataaccess is 1: Number of 32-bit words in the memory map
            dedicated to shadowing the {\tt data} registers.

            Since there are at most 12 {\tt data} registers, the value in this
            register must be 12 or smaller.
  */
  val datasize = UInt(4.W)

  /* If \Fdataaccess is 0: The number of the first CSR dedicated to
            shadowing the {\tt data} registers.

            If \Fdataaccess is 1: Signed address of RAM where the {\tt data}
            registers are shadowed, to be used to access relative to \Rzero.
  */
  val dataaddr = UInt(12.W)

}

class HAWINDOWSELFields extends Bundle {

  val reserved0 = UInt(17.W)

  val hawindowsel = UInt(15.W)

}

class HAWINDOWFields extends Bundle {

  val maskdata = UInt(32.W)

}

class ABSTRACTCSFields extends Bundle {

  val reserved0 = UInt(3.W)

  /* Size of the Program Buffer, in 32-bit words. Valid sizes are 0 - 16.
  */
  val progbufsize = UInt(5.W)

  val reserved1 = UInt(11.W)

  /* 1: An abstract command is currently being executed.

            This bit is set as soon as \Rcommand is written, and is
            not cleared until that command has completed.
  */
  val busy = Bool()

  val reserved2 = UInt(1.W)

  /* Gets set if an abstract command fails. The bits in this field remain set until
            they are cleared by writing 1 to them. No abstract command is
            started until the value is reset to 0.

            0 (none): No error.

            1 (busy): An abstract command was executing while \Rcommand,
            \Rabstractcs, \Rabstractauto was written, or when one
            of the {\tt data} or {\tt progbuf} registers was read or written.

            2 (not supported): The requested command is not supported. A
            command that is not supported while the hart is running may be
            supported when it is halted.

            3 (exception): An exception occurred while executing the command
            (eg. while executing the Program Buffer).

            4 (halt/resume): An abstract command couldn't execute because the
            hart wasn't in the expected state (running/halted).

            7 (other): The command failed for another reason.
  */
  val cmderr = UInt(3.W)

  val reserved3 = UInt(4.W)

  /* Number of {\tt data} registers that are implemented as part of the
            abstract command interface. Valid sizes are 0 - 12.
  */
  val datacount = UInt(4.W)

}

class COMMANDFields extends Bundle {

  /* The type determines the overall functionality of this
            abstract command.
  */
  val cmdtype = UInt(8.W)

  /* This field is interpreted in a command-specific manner,
            described for each abstract command.
  */
  val control = UInt(24.W)

}

class ABSTRACTAUTOFields extends Bundle {

  /* When a bit in this field is 1, read or write accesses to the corresponding {\tt progbuf} word
          cause the command in \Rcommand to be executed again.
  */
  val autoexecprogbuf = UInt(16.W)

  val reserved0 = UInt(4.W)

  /* When a bit in this field is 1, read or write accesses to the corresponding {\tt data} word
          cause the command in \Rcommand to be executed again.
  */
  val autoexecdata = UInt(12.W)

}

class DEVTREEADDR0Fields extends Bundle {

  val addr = UInt(32.W)

}

class NEXTDMFields extends Bundle {

  val addr = UInt(32.W)

}

class DATA0Fields extends Bundle {

  val data = UInt(32.W)

}

class PROGBUF0Fields extends Bundle {

  val data = UInt(32.W)

}

class AUTHDATAFields extends Bundle {

  val data = UInt(32.W)

}

class HALTSUM0Fields extends Bundle {

  val haltsum0 = UInt(32.W)

}

class HALTSUM1Fields extends Bundle {

  val haltsum1 = UInt(32.W)

}

class HALTSUM2Fields extends Bundle {

  val haltsum2 = UInt(32.W)

}

class HALTSUM3Fields extends Bundle {

  val haltsum3 = UInt(32.W)

}

class SBADDRESS3Fields extends Bundle {

  /* Accesses bits 127:96 of the physical address in {\tt sbaddress} (if
            the system address bus is that wide).
  */
  val address = UInt(32.W)

}

class SBCSFields extends Bundle {

  /* 0: The System Bus interface conforms to mainline drafts of this
            spec older than 1 January, 2018.

            1: The System Bus interface conforms to this version of the spec.

            Other values are reserved for future versions.
  */
  val sbversion = UInt(3.W)

  val reserved0 = UInt(6.W)

  /* Set when the debugger attempts to read data while a read is in
            progress, or when the debugger initiates a new access while one is
            already in progress (while \Fsbbusy is set). It remains set until
            it's explicitly cleared by the debugger.

            While this field is non-zero, no more system bus accesses can be
            initiated by the debug module.
  */
  val sbbusyerror = Bool()

  /* When 1, indicates the system bus master is busy. (Whether the
            system bus itself is busy is related, but not the same thing.) This
            bit goes high immediately when a read or write is requested for any
            reason, and does not go low until the access is fully completed.

            To avoid race conditions, debuggers must not try to clear \Fsberror
            until they read \Fsbbusy as 0.
  */
  val sbbusy = Bool()

  /* When 1, every write to \Rsbaddresszero automatically triggers a
            system bus read at the new address.
  */
  val sbreadonaddr = Bool()

  /* Select the access size to use for system bus accesses.

            0: 8-bit

            1: 16-bit

            2: 32-bit

            3: 64-bit

            4: 128-bit

            If \Fsbaccess has an unsupported value when the DM starts a bus
            access, the access is not performed and \Fsberror is set to 3.
  */
  val sbaccess = UInt(3.W)

  /* When 1, {\tt sbaddress} is incremented by the access size (in
            bytes) selected in \Fsbaccess after every system bus access.
  */
  val sbautoincrement = Bool()

  /* When 1, every read from \Rsbdatazero automatically triggers a
            system bus read at the (possibly auto-incremented) address.
  */
  val sbreadondata = Bool()

  /* When the debug module's system bus
            master causes a bus error, this field gets set. The bits in this
            field remain set until they are cleared by writing 1 to them.
            While this field is non-zero, no more system bus accesses can be
            initiated by the debug module.

            0: There was no bus error.

            1: There was a timeout.

            2: A bad address was accessed.

            3: There was some other error (eg. alignment).
  */
  val sberror = UInt(3.W)

  /* Width of system bus addresses in bits. (0 indicates there is no bus
            access support.)
  */
  val sbasize = UInt(7.W)

  /* 1 when 128-bit system bus accesses are supported.
  */
  val sbaccess128 = Bool()

  /* 1 when 64-bit system bus accesses are supported.
  */
  val sbaccess64 = Bool()

  /* 1 when 32-bit system bus accesses are supported.
  */
  val sbaccess32 = Bool()

  /* 1 when 16-bit system bus accesses are supported.
  */
  val sbaccess16 = Bool()

  /* 1 when 8-bit system bus accesses are supported.
  */
  val sbaccess8 = Bool()

}

class SBADDRESS0Fields extends Bundle {

  /* Accesses bits 31:0 of the physical address in {\tt sbaddress}.
  */
  val address = UInt(32.W)

}

class SBADDRESS1Fields extends Bundle {

  /* Accesses bits 63:32 of the physical address in {\tt sbaddress} (if
            the system address bus is that wide).
  */
  val address = UInt(32.W)

}

class SBADDRESS2Fields extends Bundle {

  /* Accesses bits 95:64 of the physical address in {\tt sbaddress} (if
            the system address bus is that wide).
  */
  val address = UInt(32.W)

}

class SBDATA0Fields extends Bundle {

  /* Accesses bits 31:0 of {\tt sbdata}.
  */
  val data = UInt(32.W)

}

class SBDATA1Fields extends Bundle {

  /* Accesses bits 63:32 of {\tt sbdata} (if the system bus is that
            wide).
  */
  val data = UInt(32.W)

}

class SBDATA2Fields extends Bundle {

  /* Accesses bits 95:64 of {\tt sbdata} (if the system bus is that
            wide).
  */
  val data = UInt(32.W)

}

class SBDATA3Fields extends Bundle {

  /* Accesses bits 127:96 of {\tt sbdata} (if the system bus is that
            wide).
  */
  val data = UInt(32.W)

}

