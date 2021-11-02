#define DTM_IDCODE                          0x01
/*
* Identifies the release version of this part.
 */
#define DTM_IDCODE_VERSION_OFFSET           28
#define DTM_IDCODE_VERSION_LENGTH           4
#define DTM_IDCODE_VERSION                  (0xfU << DTM_IDCODE_VERSION_OFFSET)
/*
* Identifies the designer's part number of this part.
 */
#define DTM_IDCODE_PARTNUMBER_OFFSET        12
#define DTM_IDCODE_PARTNUMBER_LENGTH        16
#define DTM_IDCODE_PARTNUMBER               (0xffffU << DTM_IDCODE_PARTNUMBER_OFFSET)
/*
* Identifies the designer/manufacturer of this part. Bits 6:0 must be
* bits 6:0 of the designer/manufacturer's Identification Code as
* assigned by JEDEC Standard JEP106. Bits 10:7 contain the modulo-16
* count of the number of continuation characters (0x7f) in that same
* Identification Code.
 */
#define DTM_IDCODE_MANUFID_OFFSET           1
#define DTM_IDCODE_MANUFID_LENGTH           11
#define DTM_IDCODE_MANUFID                  (0x7ffU << DTM_IDCODE_MANUFID_OFFSET)
#define DTM_IDCODE_1_OFFSET                 0
#define DTM_IDCODE_1_LENGTH                 1
#define DTM_IDCODE_1                        (0x1U << DTM_IDCODE_1_OFFSET)
#define DTM_DTMCS                           0x10
/*
* Writing 1 to this bit does a hard reset of the DTM,
* causing the DTM to forget about any outstanding DMI transactions.
* In general this should only be used when the Debugger has
* reason to expect that the outstanding DMI transaction will never
* complete (e.g. a reset condition caused an inflight DMI transaction to
* be cancelled).
 */
#define DTM_DTMCS_DMIHARDRESET_OFFSET       17
#define DTM_DTMCS_DMIHARDRESET_LENGTH       1
#define DTM_DTMCS_DMIHARDRESET              (0x1U << DTM_DTMCS_DMIHARDRESET_OFFSET)
/*
* Writing 1 to this bit clears the sticky error state
* and allows the DTM to retry or complete the previous
* transaction.
 */
#define DTM_DTMCS_DMIRESET_OFFSET           16
#define DTM_DTMCS_DMIRESET_LENGTH           1
#define DTM_DTMCS_DMIRESET                  (0x1U << DTM_DTMCS_DMIRESET_OFFSET)
/*
* This is a hint to the debugger of the minimum number of
* cycles a debugger should spend in
* Run-Test/Idle after every DMI scan to avoid a `busy'
* return code (\Fdmistat of 3). A debugger must still
* check \Fdmistat when necessary.
*
* 0: It is not necessary to enter Run-Test/Idle at all.
*
* 1: Enter Run-Test/Idle and leave it immediately.
*
* 2: Enter Run-Test/Idle and stay there for 1 cycle before leaving.
*
* And so on.
 */
#define DTM_DTMCS_IDLE_OFFSET               12
#define DTM_DTMCS_IDLE_LENGTH               3
#define DTM_DTMCS_IDLE                      (0x7U << DTM_DTMCS_IDLE_OFFSET)
/*
* 0: No error.
*
* 1: Reserved. Interpret the same as 2.
*
* 2: An operation failed (resulted in \Fop of 2).
*
* 3: An operation was attempted while a DMI access was still in
* progress (resulted in \Fop of 3).
 */
#define DTM_DTMCS_DMISTAT_OFFSET            10
#define DTM_DTMCS_DMISTAT_LENGTH            2
#define DTM_DTMCS_DMISTAT                   (0x3U << DTM_DTMCS_DMISTAT_OFFSET)
/*
* The size of \Faddress in \Rdmi.
 */
#define DTM_DTMCS_ABITS_OFFSET              4
#define DTM_DTMCS_ABITS_LENGTH              6
#define DTM_DTMCS_ABITS                     (0x3fU << DTM_DTMCS_ABITS_OFFSET)
/*
* 0: Version described in spec version 0.11.
*
* 1: Version described in spec version 0.13 (and later?), which
* reduces the DMI data width to 32 bits.
*
* 15: Version not described in any available version of this spec.
 */
#define DTM_DTMCS_VERSION_OFFSET            0
#define DTM_DTMCS_VERSION_LENGTH            4
#define DTM_DTMCS_VERSION                   (0xfU << DTM_DTMCS_VERSION_OFFSET)
#define DTM_DMI                             0x11
/*
* Address used for DMI access. In Update-DR this value is used
* to access the DM over the DMI.
 */
#define DTM_DMI_ADDRESS_OFFSET              34
#define DTM_DMI_ADDRESS_LENGTH              abits
#define DTM_DMI_ADDRESS                     (((1L<<abits)-1) << DTM_DMI_ADDRESS_OFFSET)
/*
* The data to send to the DM over the DMI during Update-DR, and
* the data returned from the DM as a result of the previous operation.
 */
#define DTM_DMI_DATA_OFFSET                 2
#define DTM_DMI_DATA_LENGTH                 32
#define DTM_DMI_DATA                        (0xffffffffULL << DTM_DMI_DATA_OFFSET)
/*
* When the debugger writes this field, it has the following meaning:
*
* 0: Ignore \Fdata and \Faddress. (nop)
*
* Don't send anything over the DMI during Update-DR.
* This operation should never result in a busy or error response.
* The address and data reported in the following Capture-DR
* are undefined.
*
* 1: Read from \Faddress. (read)
*
* 2: Write \Fdata to \Faddress. (write)
*
* 3: Reserved.
*
* When the debugger reads this field, it means the following:
*
* 0: The previous operation completed successfully.
*
* 1: Reserved.
*
* 2: A previous operation failed.  The data scanned into \Rdmi in
* this access will be ignored.  This status is sticky and can be
* cleared by writing \Fdmireset in \Rdtmcs.
*
* This indicates that the DM itself responded with an error.
* Note: there are no specified cases in which the DM would
* respond with an error, and DMI is not required to support
* returning errors.
*
* 3: An operation was attempted while a DMI request is still in
* progress. The data scanned into \Rdmi in this access will be
* ignored. This status is sticky and can be cleared by writing
* \Fdmireset in \Rdtmcs. If a debugger sees this status, it
* needs to give the target more TCK edges between Update-DR and
* Capture-DR. The simplest way to do that is to add extra transitions
* in Run-Test/Idle.
*
* (The DTM, DM, and/or component may be in different clock domains,
* so synchronization may be required. Some relatively fixed number of
* TCK ticks may be needed for the request to reach the DM, complete,
* and for the response to be synchronized back into the TCK domain.)
 */
#define DTM_DMI_OP_OFFSET                   0
#define DTM_DMI_OP_LENGTH                   2
#define DTM_DMI_OP                          (0x3ULL << DTM_DMI_OP_OFFSET)
#define CSR_DCSR                            0x7b0
/*
* 0: There is no external debug support.
*
* 4: External debug support exists as it is described in this document.
*
* 15: There is external debug support, but it does not conform to any
* available version of this spec.
 */
#define CSR_DCSR_XDEBUGVER_OFFSET           28
#define CSR_DCSR_XDEBUGVER_LENGTH           4
#define CSR_DCSR_XDEBUGVER                  (0xfU << CSR_DCSR_XDEBUGVER_OFFSET)
/*
* When 1, {\tt ebreak} instructions in Machine Mode enter Debug Mode.
 */
#define CSR_DCSR_EBREAKM_OFFSET             15
#define CSR_DCSR_EBREAKM_LENGTH             1
#define CSR_DCSR_EBREAKM                    (0x1U << CSR_DCSR_EBREAKM_OFFSET)
/*
* When 1, {\tt ebreak} instructions in Supervisor Mode enter Debug Mode.
 */
#define CSR_DCSR_EBREAKS_OFFSET             13
#define CSR_DCSR_EBREAKS_LENGTH             1
#define CSR_DCSR_EBREAKS                    (0x1U << CSR_DCSR_EBREAKS_OFFSET)
/*
* When 1, {\tt ebreak} instructions in User/Application Mode enter
* Debug Mode.
 */
#define CSR_DCSR_EBREAKU_OFFSET             12
#define CSR_DCSR_EBREAKU_LENGTH             1
#define CSR_DCSR_EBREAKU                    (0x1U << CSR_DCSR_EBREAKU_OFFSET)
/*
* 0: Interrupts are disabled during single stepping.
*
* 1: Interrupts are enabled during single stepping.
*
* Implementations may hard wire this bit to 0.
* The debugger must read back the value it
* writes to check whether the feature is supported. If not
* supported, interrupt behavior can be emulated by the debugger.
 */
#define CSR_DCSR_STEPIE_OFFSET              11
#define CSR_DCSR_STEPIE_LENGTH              1
#define CSR_DCSR_STEPIE                     (0x1U << CSR_DCSR_STEPIE_OFFSET)
/*
* 0: Increment counters as usual.
*
* 1: Don't increment any counters while in Debug Mode or on {\tt
* ebreak} instructions that cause entry into Debug Mode.  These
* counters include the {\tt cycle} and {\tt instret} CSRs. This is
* preferred for most debugging scenarios.
*
* An implementation may choose not to support writing to this bit.
* The debugger must read back the value it writes to check whether
* the feature is supported.
 */
#define CSR_DCSR_STOPCOUNT_OFFSET           10
#define CSR_DCSR_STOPCOUNT_LENGTH           1
#define CSR_DCSR_STOPCOUNT                  (0x1U << CSR_DCSR_STOPCOUNT_OFFSET)
/*
* 0: Increment timers as usual.
*
* 1: Don't increment any hart-local timers while in Debug Mode.
*
* An implementation may choose not to support writing to this bit.
* The debugger must read back the value it writes to check whether
* the feature is supported.
 */
#define CSR_DCSR_STOPTIME_OFFSET            9
#define CSR_DCSR_STOPTIME_LENGTH            1
#define CSR_DCSR_STOPTIME                   (0x1U << CSR_DCSR_STOPTIME_OFFSET)
/*
* Explains why Debug Mode was entered.
*
* When there are multiple reasons to enter Debug Mode in a single
* cycle, the cause with the highest priority is the one written.
*
* 1: An {\tt ebreak} instruction was executed. (priority 3)
*
* 2: The Trigger Module caused a breakpoint exception. (priority 4)
*
* 3: The debugger requested entry to Debug Mode. (priority 2)
*
* 4: The hart single stepped because \Fstep was set. (priority 1)
*
* Other values are reserved for future use.
 */
#define CSR_DCSR_CAUSE_OFFSET               6
#define CSR_DCSR_CAUSE_LENGTH               3
#define CSR_DCSR_CAUSE                      (0x7U << CSR_DCSR_CAUSE_OFFSET)
/*
* When set and not in Debug Mode, the hart will only execute a single
* instruction and then enter Debug Mode.
* If the instruction does not complete due to an exception,
* the hart will immediately enter Debug Mode before executing
* the trap handler, with appropriate exception registers set.
 */
#define CSR_DCSR_STEP_OFFSET                2
#define CSR_DCSR_STEP_LENGTH                1
#define CSR_DCSR_STEP                       (0x1U << CSR_DCSR_STEP_OFFSET)
/*
* Contains the privilege level the hart was operating in when Debug
* Mode was entered. The encoding is described in Table
* \ref{tab:privlevel}.  A debugger can change this value to change
* the hart's privilege level when exiting Debug Mode.
*
* Not all privilege levels are supported on all harts. If the
* encoding written is not supported or the debugger is not allowed to
* change to it, the hart may change to any supported privilege level.
 */
#define CSR_DCSR_PRV_OFFSET                 0
#define CSR_DCSR_PRV_LENGTH                 2
#define CSR_DCSR_PRV                        (0x3U << CSR_DCSR_PRV_OFFSET)
#define CSR_DPC                             0x7b1
#define CSR_DPC_DPC_OFFSET                  0
#define CSR_DPC_DPC_LENGTH                  XLEN
#define CSR_DPC_DPC                         (((1L<<XLEN)-1) << CSR_DPC_DPC_OFFSET)
#define CSR_DSCRATCH0                       0x7b2
#define CSR_DSCRATCH1                       0x7b3
#define CSR_TSELECT                         0x7a0
#define CSR_TSELECT_INDEX_OFFSET            0
#define CSR_TSELECT_INDEX_LENGTH            XLEN
#define CSR_TSELECT_INDEX                   (((1L<<XLEN)-1) << CSR_TSELECT_INDEX_OFFSET)
#define CSR_TDATA1                          0x7a1
/*
* 0: There is no trigger at this \Rtselect.
*
* 1: The trigger is a legacy SiFive address match trigger. These
* should not be implemented and aren't further documented here.
*
* 2: The trigger is an address/data match trigger. The remaining bits
* in this register act as described in \Rmcontrol.
*
* 3: The trigger is an instruction count trigger. The remaining bits
* in this register act as described in \Ricount.
*
* 15: This trigger exists (so enumeration shouldn't terminate), but
* is not currently available.
*
* Other values are reserved for future use.
 */
#define CSR_TDATA1_TYPE_OFFSET              (XLEN-4)
#define CSR_TDATA1_TYPE_LENGTH              4
#define CSR_TDATA1_TYPE                     (0xfULL << CSR_TDATA1_TYPE_OFFSET)
/*
* 0: Both Debug and M Mode can write the {\tt tdata} registers at the
* selected \Rtselect.
*
* 1: Only Debug Mode can write the {\tt tdata} registers at the
* selected \Rtselect.  Writes from other modes are ignored.
*
* This bit is only writable from Debug Mode.
 */
#define CSR_TDATA1_DMODE_OFFSET             (XLEN-5)
#define CSR_TDATA1_DMODE_LENGTH             1
#define CSR_TDATA1_DMODE                    (0x1ULL << CSR_TDATA1_DMODE_OFFSET)
/*
* Trigger-specific data.
 */
#define CSR_TDATA1_DATA_OFFSET              0
#define CSR_TDATA1_DATA_LENGTH              (XLEN - 5)
#define CSR_TDATA1_DATA                     (((1L<<XLEN - 5)-1) << CSR_TDATA1_DATA_OFFSET)
#define CSR_TDATA2                          0x7a2
#define CSR_TDATA2_DATA_OFFSET              0
#define CSR_TDATA2_DATA_LENGTH              XLEN
#define CSR_TDATA2_DATA                     (((1L<<XLEN)-1) << CSR_TDATA2_DATA_OFFSET)
#define CSR_TDATA3                          0x7a3
#define CSR_TDATA3_DATA_OFFSET              0
#define CSR_TDATA3_DATA_LENGTH              XLEN
#define CSR_TDATA3_DATA                     (((1L<<XLEN)-1) << CSR_TDATA3_DATA_OFFSET)
#define CSR_MCONTROL                        0x7a1
#define CSR_MCONTROL_TYPE_OFFSET            (XLEN-4)
#define CSR_MCONTROL_TYPE_LENGTH            4
#define CSR_MCONTROL_TYPE                   (0xfULL << CSR_MCONTROL_TYPE_OFFSET)
#define CSR_MCONTROL_DMODE_OFFSET           (XLEN-5)
#define CSR_MCONTROL_DMODE_LENGTH           1
#define CSR_MCONTROL_DMODE                  (0x1ULL << CSR_MCONTROL_DMODE_OFFSET)
/*
* Specifies the largest naturally aligned powers-of-two (NAPOT) range
* supported by the hardware. The value is the logarithm base 2 of the
* number of bytes in that range.  A value of 0 indicates that only
* exact value matches are supported (one byte range). A value of 63
* corresponds to the maximum NAPOT range, which is $2^{63}$ bytes in
* size.
 */
#define CSR_MCONTROL_MASKMAX_OFFSET         (XLEN-11)
#define CSR_MCONTROL_MASKMAX_LENGTH         6
#define CSR_MCONTROL_MASKMAX                (0x3fULL << CSR_MCONTROL_MASKMAX_OFFSET)
/*
* 0: Perform a match on the virtual address.
*
* 1: Perform a match on the data value loaded/stored, or the
* instruction executed.
 */
#define CSR_MCONTROL_SELECT_OFFSET          19
#define CSR_MCONTROL_SELECT_LENGTH          1
#define CSR_MCONTROL_SELECT                 (0x1ULL << CSR_MCONTROL_SELECT_OFFSET)
/*
* 0: The action for this trigger will be taken just before the
* instruction that triggered it is executed, but after all preceding
* instructions are are committed.
*
* 1: The action for this trigger will be taken after the instruction
* that triggered it is executed. It should be taken before the next
* instruction is executed, but it is better to implement triggers and
* not implement that suggestion than to not implement them at all.
*
* Most hardware will only implement one timing or the other, possibly
* dependent on \Fselect, \Fexecute, \Fload, and \Fstore. This bit
* primarily exists for the hardware to communicate to the debugger
* what will happen. Hardware may implement the bit fully writable, in
* which case the debugger has a little more control.
*
* Data load triggers with \Ftiming of 0 will result in the same load
* happening again when the debugger lets the core run. For data load
* triggers, debuggers must first attempt to set the breakpoint with
* \Ftiming of 1.
*
* A chain of triggers that don't all have the same \Ftiming value
* will never fire (unless consecutive instructions match the
* appropriate triggers).
 */
#define CSR_MCONTROL_TIMING_OFFSET          18
#define CSR_MCONTROL_TIMING_LENGTH          1
#define CSR_MCONTROL_TIMING                 (0x1ULL << CSR_MCONTROL_TIMING_OFFSET)
/*
* Determines what happens when this trigger matches.
*
* 0: Raise a breakpoint exception. (Used when software wants to use
* the trigger module without an external debugger attached.)
*
* 1: Enter Debug Mode. (Only supported when \Fdmode is 1.)
*
* 2: Start tracing.
*
* 3: Stop tracing.
*
* 4: Emit trace data for this match. If it is a data access match,
* emit appropriate Load/Store Address/Data. If it is an instruction
* execution, emit its PC.
*
* Other values are reserved for future use.
 */
#define CSR_MCONTROL_ACTION_OFFSET          12
#define CSR_MCONTROL_ACTION_LENGTH          6
#define CSR_MCONTROL_ACTION                 (0x3fULL << CSR_MCONTROL_ACTION_OFFSET)
/*
* 0: When this trigger matches, the configured action is taken.
*
* 1: While this trigger does not match, it prevents the trigger with
* the next index from matching.
 */
#define CSR_MCONTROL_CHAIN_OFFSET           11
#define CSR_MCONTROL_CHAIN_LENGTH           1
#define CSR_MCONTROL_CHAIN                  (0x1ULL << CSR_MCONTROL_CHAIN_OFFSET)
/*
* 0: Matches when the value equals \Rtdatatwo.
*
* 1: Matches when the top M bits of the value match the top M bits of
* \Rtdatatwo. M is XLEN-1 minus the index of the least-significant
* bit containing 0 in \Rtdatatwo.
*
* 2: Matches when the value is greater than (unsigned) or equal to
* \Rtdatatwo.
*
* 3: Matches when the value is less than (unsigned) \Rtdatatwo.
*
* 4: Matches when the lower half of the value equals the lower half
* of \Rtdatatwo after the lower half of the value is ANDed with the
* upper half of \Rtdatatwo.
*
* 5: Matches when the upper half of the value equals the lower half
* of \Rtdatatwo after the upper half of the value is ANDed with the
* upper half of \Rtdatatwo.
*
* Other values are reserved for future use.
 */
#define CSR_MCONTROL_MATCH_OFFSET           7
#define CSR_MCONTROL_MATCH_LENGTH           4
#define CSR_MCONTROL_MATCH                  (0xfULL << CSR_MCONTROL_MATCH_OFFSET)
/*
* When set, enable this trigger in M mode.
 */
#define CSR_MCONTROL_M_OFFSET               6
#define CSR_MCONTROL_M_LENGTH               1
#define CSR_MCONTROL_M                      (0x1ULL << CSR_MCONTROL_M_OFFSET)
/*
* When set, enable this trigger in S mode.
 */
#define CSR_MCONTROL_S_OFFSET               4
#define CSR_MCONTROL_S_LENGTH               1
#define CSR_MCONTROL_S                      (0x1ULL << CSR_MCONTROL_S_OFFSET)
/*
* When set, enable this trigger in U mode.
 */
#define CSR_MCONTROL_U_OFFSET               3
#define CSR_MCONTROL_U_LENGTH               1
#define CSR_MCONTROL_U                      (0x1ULL << CSR_MCONTROL_U_OFFSET)
/*
* When set, the trigger fires on the virtual address or opcode of an
* instruction that is executed.
 */
#define CSR_MCONTROL_EXECUTE_OFFSET         2
#define CSR_MCONTROL_EXECUTE_LENGTH         1
#define CSR_MCONTROL_EXECUTE                (0x1ULL << CSR_MCONTROL_EXECUTE_OFFSET)
/*
* When set, the trigger fires on the virtual address or data of a store.
 */
#define CSR_MCONTROL_STORE_OFFSET           1
#define CSR_MCONTROL_STORE_LENGTH           1
#define CSR_MCONTROL_STORE                  (0x1ULL << CSR_MCONTROL_STORE_OFFSET)
/*
* When set, the trigger fires on the virtual address or data of a load.
 */
#define CSR_MCONTROL_LOAD_OFFSET            0
#define CSR_MCONTROL_LOAD_LENGTH            1
#define CSR_MCONTROL_LOAD                   (0x1ULL << CSR_MCONTROL_LOAD_OFFSET)
#define CSR_ICOUNT                          0x7a1
#define CSR_ICOUNT_TYPE_OFFSET              (XLEN-4)
#define CSR_ICOUNT_TYPE_LENGTH              4
#define CSR_ICOUNT_TYPE                     (0xfULL << CSR_ICOUNT_TYPE_OFFSET)
#define CSR_ICOUNT_DMODE_OFFSET             (XLEN-5)
#define CSR_ICOUNT_DMODE_LENGTH             1
#define CSR_ICOUNT_DMODE                    (0x1ULL << CSR_ICOUNT_DMODE_OFFSET)
/*
* When count is decremented to 0, the trigger fires. Instead of
* changing \Fcount from 1 to 0, it is also acceptable for hardware to
* clear \Fm, \Fs, and \Fu. This allows \Fcount to be hard-wired
* to 1 if this register just exists for single step.
 */
#define CSR_ICOUNT_COUNT_OFFSET             10
#define CSR_ICOUNT_COUNT_LENGTH             14
#define CSR_ICOUNT_COUNT                    (0x3fffULL << CSR_ICOUNT_COUNT_OFFSET)
/*
* When set, every instruction completed or exception taken in M mode decrements \Fcount
* by 1.
 */
#define CSR_ICOUNT_M_OFFSET                 9
#define CSR_ICOUNT_M_LENGTH                 1
#define CSR_ICOUNT_M                        (0x1ULL << CSR_ICOUNT_M_OFFSET)
/*
* When set, every instruction completed or exception taken in S mode decrements \Fcount
* by 1.
 */
#define CSR_ICOUNT_S_OFFSET                 7
#define CSR_ICOUNT_S_LENGTH                 1
#define CSR_ICOUNT_S                        (0x1ULL << CSR_ICOUNT_S_OFFSET)
/*
* When set, every instruction completed or exception taken in U mode decrements \Fcount
* by 1.
 */
#define CSR_ICOUNT_U_OFFSET                 6
#define CSR_ICOUNT_U_LENGTH                 1
#define CSR_ICOUNT_U                        (0x1ULL << CSR_ICOUNT_U_OFFSET)
/*
* Determines what happens when this trigger matches.
*
* 0: Raise a breakpoint exception. (Used when software wants to use the
* trigger module without an external debugger attached.)
*
* 1: Enter Debug Mode. (Only supported when \Fdmode is 1.)
*
* 2: Start tracing.
*
* 3: Stop tracing.
*
* 4: Emit trace data for this match. If it is a data access match,
* emit appropriate Load/Store Address/Data. If it is an instruction
* execution, emit its PC.
*
* Other values are reserved for future use.
 */
#define CSR_ICOUNT_ACTION_OFFSET            0
#define CSR_ICOUNT_ACTION_LENGTH            6
#define CSR_ICOUNT_ACTION                   (0x3fULL << CSR_ICOUNT_ACTION_OFFSET)
#define DMI_DMSTATUS                        0x11
/*
* If 1, then there is an implicit {\tt ebreak} instruction at the
* non-existent word immediately after the Program Buffer. This saves
* the debugger from having to write the {\tt ebreak} itself, and
* allows the Program Buffer to be one word smaller.
*
* This must be 1 when \Fprogbufsize is 1.
 */
#define DMI_DMSTATUS_IMPEBREAK_OFFSET       22
#define DMI_DMSTATUS_IMPEBREAK_LENGTH       1
#define DMI_DMSTATUS_IMPEBREAK              (0x1U << DMI_DMSTATUS_IMPEBREAK_OFFSET)
/*
* This field is 1 when all currently selected harts have been reset but the reset has not been acknowledged.
 */
#define DMI_DMSTATUS_ALLHAVERESET_OFFSET    19
#define DMI_DMSTATUS_ALLHAVERESET_LENGTH    1
#define DMI_DMSTATUS_ALLHAVERESET           (0x1U << DMI_DMSTATUS_ALLHAVERESET_OFFSET)
/*
* This field is 1 when any currently selected hart has been reset but the reset has not been acknowledged.
 */
#define DMI_DMSTATUS_ANYHAVERESET_OFFSET    18
#define DMI_DMSTATUS_ANYHAVERESET_LENGTH    1
#define DMI_DMSTATUS_ANYHAVERESET           (0x1U << DMI_DMSTATUS_ANYHAVERESET_OFFSET)
/*
* This field is 1 when all currently selected harts have acknowledged
* the previous resume request.
 */
#define DMI_DMSTATUS_ALLRESUMEACK_OFFSET    17
#define DMI_DMSTATUS_ALLRESUMEACK_LENGTH    1
#define DMI_DMSTATUS_ALLRESUMEACK           (0x1U << DMI_DMSTATUS_ALLRESUMEACK_OFFSET)
/*
* This field is 1 when any currently selected hart has acknowledged
* the previous resume request.
 */
#define DMI_DMSTATUS_ANYRESUMEACK_OFFSET    16
#define DMI_DMSTATUS_ANYRESUMEACK_LENGTH    1
#define DMI_DMSTATUS_ANYRESUMEACK           (0x1U << DMI_DMSTATUS_ANYRESUMEACK_OFFSET)
/*
* This field is 1 when all currently selected harts do not exist in this system.
 */
#define DMI_DMSTATUS_ALLNONEXISTENT_OFFSET  15
#define DMI_DMSTATUS_ALLNONEXISTENT_LENGTH  1
#define DMI_DMSTATUS_ALLNONEXISTENT         (0x1U << DMI_DMSTATUS_ALLNONEXISTENT_OFFSET)
/*
* This field is 1 when any currently selected hart does not exist in this system.
 */
#define DMI_DMSTATUS_ANYNONEXISTENT_OFFSET  14
#define DMI_DMSTATUS_ANYNONEXISTENT_LENGTH  1
#define DMI_DMSTATUS_ANYNONEXISTENT         (0x1U << DMI_DMSTATUS_ANYNONEXISTENT_OFFSET)
/*
* This field is 1 when all currently selected harts are unavailable.
 */
#define DMI_DMSTATUS_ALLUNAVAIL_OFFSET      13
#define DMI_DMSTATUS_ALLUNAVAIL_LENGTH      1
#define DMI_DMSTATUS_ALLUNAVAIL             (0x1U << DMI_DMSTATUS_ALLUNAVAIL_OFFSET)
/*
* This field is 1 when any currently selected hart is unavailable.
 */
#define DMI_DMSTATUS_ANYUNAVAIL_OFFSET      12
#define DMI_DMSTATUS_ANYUNAVAIL_LENGTH      1
#define DMI_DMSTATUS_ANYUNAVAIL             (0x1U << DMI_DMSTATUS_ANYUNAVAIL_OFFSET)
/*
* This field is 1 when all currently selected harts are running.
 */
#define DMI_DMSTATUS_ALLRUNNING_OFFSET      11
#define DMI_DMSTATUS_ALLRUNNING_LENGTH      1
#define DMI_DMSTATUS_ALLRUNNING             (0x1U << DMI_DMSTATUS_ALLRUNNING_OFFSET)
/*
* This field is 1 when any currently selected hart is running.
 */
#define DMI_DMSTATUS_ANYRUNNING_OFFSET      10
#define DMI_DMSTATUS_ANYRUNNING_LENGTH      1
#define DMI_DMSTATUS_ANYRUNNING             (0x1U << DMI_DMSTATUS_ANYRUNNING_OFFSET)
/*
* This field is 1 when all currently selected harts are halted.
 */
#define DMI_DMSTATUS_ALLHALTED_OFFSET       9
#define DMI_DMSTATUS_ALLHALTED_LENGTH       1
#define DMI_DMSTATUS_ALLHALTED              (0x1U << DMI_DMSTATUS_ALLHALTED_OFFSET)
/*
* This field is 1 when any currently selected hart is halted.
 */
#define DMI_DMSTATUS_ANYHALTED_OFFSET       8
#define DMI_DMSTATUS_ANYHALTED_LENGTH       1
#define DMI_DMSTATUS_ANYHALTED              (0x1U << DMI_DMSTATUS_ANYHALTED_OFFSET)
/*
* 0 when authentication is required before using the DM.  1 when the
* authentication check has passed. On components that don't implement
* authentication, this bit must be preset as 1.
 */
#define DMI_DMSTATUS_AUTHENTICATED_OFFSET   7
#define DMI_DMSTATUS_AUTHENTICATED_LENGTH   1
#define DMI_DMSTATUS_AUTHENTICATED          (0x1U << DMI_DMSTATUS_AUTHENTICATED_OFFSET)
/*
* 0: The authentication module is ready to process the next
* read/write to \Rauthdata.
*
* 1: The authentication module is busy. Accessing \Rauthdata results
* in unspecified behavior.
*
* \Fauthbusy only becomes set in immediate response to an access to
* \Rauthdata.
 */
#define DMI_DMSTATUS_AUTHBUSY_OFFSET        6
#define DMI_DMSTATUS_AUTHBUSY_LENGTH        1
#define DMI_DMSTATUS_AUTHBUSY               (0x1U << DMI_DMSTATUS_AUTHBUSY_OFFSET)
/*
* 0: \Rdevtreeaddrzero--\Rdevtreeaddrthree hold information which
* is not relevant to the Device Tree.
*
* 1: \Rdevtreeaddrzero--\Rdevtreeaddrthree registers hold the address of the
* Device Tree.
 */
#define DMI_DMSTATUS_DEVTREEVALID_OFFSET    4
#define DMI_DMSTATUS_DEVTREEVALID_LENGTH    1
#define DMI_DMSTATUS_DEVTREEVALID           (0x1U << DMI_DMSTATUS_DEVTREEVALID_OFFSET)
/*
* 0: There is no Debug Module present.
*
* 1: There is a Debug Module and it conforms to version 0.11 of this
* specification.
*
* 2: There is a Debug Module and it conforms to version 0.13 of this
* specification.
*
* 15: There is a Debug Module but it does not conform to any
* available version of this spec.
 */
#define DMI_DMSTATUS_VERSION_OFFSET         0
#define DMI_DMSTATUS_VERSION_LENGTH         4
#define DMI_DMSTATUS_VERSION                (0xfU << DMI_DMSTATUS_VERSION_OFFSET)
#define DMI_DMCONTROL                       0x10
/*
* Writes the halt request bit for all currently selected harts.
* When set to 1, each selected hart will halt if it is not currently
* halted.
*
* Writing 1 or 0 has no effect on a hart which is already halted, but
* the bit must be cleared to 0 before the hart is resumed.
*
* Writes apply to the new value of \Fhartsel and \Fhasel.
 */
#define DMI_DMCONTROL_HALTREQ_OFFSET        31
#define DMI_DMCONTROL_HALTREQ_LENGTH        1
#define DMI_DMCONTROL_HALTREQ               (0x1ULL << DMI_DMCONTROL_HALTREQ_OFFSET)
/*
* Writes the resume request bit for all currently selected harts.
* When set to 1, each selected hart will resume if it is currently
* halted.
*
* The resume request bit is ignored while the halt request bit is
* set.
*
* Writes apply to the new value of \Fhartsel and \Fhasel.
 */
#define DMI_DMCONTROL_RESUMEREQ_OFFSET      30
#define DMI_DMCONTROL_RESUMEREQ_LENGTH      1
#define DMI_DMCONTROL_RESUMEREQ             (0x1ULL << DMI_DMCONTROL_RESUMEREQ_OFFSET)
/*
* This optional field writes the reset bit for all the currently
* selected harts.  To perform a reset the debugger writes 1, and then
* writes 0 to deassert the reset signal.
*
* If this feature is not implemented, the bit always stays 0, so
* after writing 1 the debugger can read the register back to see if
* the feature is supported.
*
* Writes apply to the new value of \Fhartsel and \Fhasel.
 */
#define DMI_DMCONTROL_HARTRESET_OFFSET      29
#define DMI_DMCONTROL_HARTRESET_LENGTH      1
#define DMI_DMCONTROL_HARTRESET             (0x1ULL << DMI_DMCONTROL_HARTRESET_OFFSET)
/*
* Writing 1 to this bit clears the {\tt havereset} bits for
* any selected harts.
*
* Writes apply to the new value of \Fhartsel and \Fhasel.
 */
#define DMI_DMCONTROL_ACKHAVERESET_OFFSET   28
#define DMI_DMCONTROL_ACKHAVERESET_LENGTH   1
#define DMI_DMCONTROL_ACKHAVERESET          (0x1ULL << DMI_DMCONTROL_ACKHAVERESET_OFFSET)
/*
* Selects the  definition of currently selected harts.
*
* 0: There is a single currently selected hart, that selected by \Fhartsel.
*
* 1: There may be multiple currently selected harts -- that selected by \Fhartsel,
* plus those selected by the hart array mask register.
*
* An implementation which does not implement the hart array mask register
* should tie this field to 0. A debugger which wishes to use the hart array
* mask register feature should set this bit and read back to see if the functionality
* is supported.
 */
#define DMI_DMCONTROL_HASEL_OFFSET          26
#define DMI_DMCONTROL_HASEL_LENGTH          1
#define DMI_DMCONTROL_HASEL                 (0x1ULL << DMI_DMCONTROL_HASEL_OFFSET)
/*
* The DM-specific index of the hart to select. This hart is always part of the
* currently selected harts.
 */
#define DMI_DMCONTROL_HARTSEL_OFFSET        16
#define DMI_DMCONTROL_HARTSEL_LENGTH        HARTSELLEN
#define DMI_DMCONTROL_HARTSEL               (((1L<<HARTSELLEN)-1) << DMI_DMCONTROL_HARTSEL_OFFSET)
/*
* This bit controls the reset signal from the DM to the rest of the
* system. The signal should reset every part of the system, including
* every hart, except for the DM and any logic required to access the
* DM.
* To perform a system reset the debugger writes 1,
* and then writes 0
* to deassert the reset.
 */
#define DMI_DMCONTROL_NDMRESET_OFFSET       1
#define DMI_DMCONTROL_NDMRESET_LENGTH       1
#define DMI_DMCONTROL_NDMRESET              (0x1ULL << DMI_DMCONTROL_NDMRESET_OFFSET)
/*
* This bit serves as a reset signal for the Debug Module itself.
*
* 0: The module's state, including authentication mechanism,
* takes its reset values (the \Fdmactive bit is the only bit which can
* be written to something other than its reset value).
*
* 1: The module functions normally.
*
* No other mechanism should exist that may result in resetting the
* Debug Module after power up, including the platform's system reset
* or Debug Transport reset signals.
*
* A debugger may pulse this bit low to get the debug module into a
* known state.
*
* Implementations may use this bit to aid debugging, for example by
* preventing the Debug Module from being power gated while debugging
* is active.
 */
#define DMI_DMCONTROL_DMACTIVE_OFFSET       0
#define DMI_DMCONTROL_DMACTIVE_LENGTH       1
#define DMI_DMCONTROL_DMACTIVE              (0x1ULL << DMI_DMCONTROL_DMACTIVE_OFFSET)
#define DMI_HARTINFO                        0x12
/*
* Number of {\tt dscratch} registers available for the debugger
* to use during program buffer execution, starting from \Rdscratchzero.
* The debugger can make no assumptions about the contents of these
* registers between commands.
 */
#define DMI_HARTINFO_NSCRATCH_OFFSET        20
#define DMI_HARTINFO_NSCRATCH_LENGTH        4
#define DMI_HARTINFO_NSCRATCH               (0xfU << DMI_HARTINFO_NSCRATCH_OFFSET)
/*
* 0: The {\tt data} registers are shadowed in the hart by CSR
* registers. Each CSR register is XLEN bits in size, and corresponds
* to a single argument, per Table~\ref{tab:datareg}.
*
* 1: The {\tt data} registers are shadowed in the hart's memory map.
* Each register takes up 4 bytes in the memory map.
 */
#define DMI_HARTINFO_DATAACCESS_OFFSET      16
#define DMI_HARTINFO_DATAACCESS_LENGTH      1
#define DMI_HARTINFO_DATAACCESS             (0x1U << DMI_HARTINFO_DATAACCESS_OFFSET)
/*
* If \Fdataaccess is 0: Number of CSR registers dedicated to
* shadowing the {\tt data} registers.
*
* If \Fdataaccess is 1: Number of 32-bit words in the memory map
* dedicated to shadowing the {\tt data} registers.
*
* Since there are at most 12 {\tt data} registers, the value in this
* register must be 12 or smaller.
 */
#define DMI_HARTINFO_DATASIZE_OFFSET        12
#define DMI_HARTINFO_DATASIZE_LENGTH        4
#define DMI_HARTINFO_DATASIZE               (0xfU << DMI_HARTINFO_DATASIZE_OFFSET)
/*
* If \Fdataaccess is 0: The number of the first CSR dedicated to
* shadowing the {\tt data} registers.
*
* If \Fdataaccess is 1: Signed address of RAM where the {\tt data}
* registers are shadowed, to be used to access relative to \Rzero.
 */
#define DMI_HARTINFO_DATAADDR_OFFSET        0
#define DMI_HARTINFO_DATAADDR_LENGTH        12
#define DMI_HARTINFO_DATAADDR               (0xfffU << DMI_HARTINFO_DATAADDR_OFFSET)
#define DMI_HALTSUM                         0x13
#define DMI_HALTSUM_HALT1023_992_OFFSET     31
#define DMI_HALTSUM_HALT1023_992_LENGTH     1
#define DMI_HALTSUM_HALT1023_992            (0x1U << DMI_HALTSUM_HALT1023_992_OFFSET)
#define DMI_HALTSUM_HALT991_960_OFFSET      30
#define DMI_HALTSUM_HALT991_960_LENGTH      1
#define DMI_HALTSUM_HALT991_960             (0x1U << DMI_HALTSUM_HALT991_960_OFFSET)
#define DMI_HALTSUM_HALT959_928_OFFSET      29
#define DMI_HALTSUM_HALT959_928_LENGTH      1
#define DMI_HALTSUM_HALT959_928             (0x1U << DMI_HALTSUM_HALT959_928_OFFSET)
#define DMI_HALTSUM_HALT927_896_OFFSET      28
#define DMI_HALTSUM_HALT927_896_LENGTH      1
#define DMI_HALTSUM_HALT927_896             (0x1U << DMI_HALTSUM_HALT927_896_OFFSET)
#define DMI_HALTSUM_HALT895_864_OFFSET      27
#define DMI_HALTSUM_HALT895_864_LENGTH      1
#define DMI_HALTSUM_HALT895_864             (0x1U << DMI_HALTSUM_HALT895_864_OFFSET)
#define DMI_HALTSUM_HALT863_832_OFFSET      26
#define DMI_HALTSUM_HALT863_832_LENGTH      1
#define DMI_HALTSUM_HALT863_832             (0x1U << DMI_HALTSUM_HALT863_832_OFFSET)
#define DMI_HALTSUM_HALT831_800_OFFSET      25
#define DMI_HALTSUM_HALT831_800_LENGTH      1
#define DMI_HALTSUM_HALT831_800             (0x1U << DMI_HALTSUM_HALT831_800_OFFSET)
#define DMI_HALTSUM_HALT799_768_OFFSET      24
#define DMI_HALTSUM_HALT799_768_LENGTH      1
#define DMI_HALTSUM_HALT799_768             (0x1U << DMI_HALTSUM_HALT799_768_OFFSET)
#define DMI_HALTSUM_HALT767_736_OFFSET      23
#define DMI_HALTSUM_HALT767_736_LENGTH      1
#define DMI_HALTSUM_HALT767_736             (0x1U << DMI_HALTSUM_HALT767_736_OFFSET)
#define DMI_HALTSUM_HALT735_704_OFFSET      22
#define DMI_HALTSUM_HALT735_704_LENGTH      1
#define DMI_HALTSUM_HALT735_704             (0x1U << DMI_HALTSUM_HALT735_704_OFFSET)
#define DMI_HALTSUM_HALT703_672_OFFSET      21
#define DMI_HALTSUM_HALT703_672_LENGTH      1
#define DMI_HALTSUM_HALT703_672             (0x1U << DMI_HALTSUM_HALT703_672_OFFSET)
#define DMI_HALTSUM_HALT671_640_OFFSET      20
#define DMI_HALTSUM_HALT671_640_LENGTH      1
#define DMI_HALTSUM_HALT671_640             (0x1U << DMI_HALTSUM_HALT671_640_OFFSET)
#define DMI_HALTSUM_HALT639_608_OFFSET      19
#define DMI_HALTSUM_HALT639_608_LENGTH      1
#define DMI_HALTSUM_HALT639_608             (0x1U << DMI_HALTSUM_HALT639_608_OFFSET)
#define DMI_HALTSUM_HALT607_576_OFFSET      18
#define DMI_HALTSUM_HALT607_576_LENGTH      1
#define DMI_HALTSUM_HALT607_576             (0x1U << DMI_HALTSUM_HALT607_576_OFFSET)
#define DMI_HALTSUM_HALT575_544_OFFSET      17
#define DMI_HALTSUM_HALT575_544_LENGTH      1
#define DMI_HALTSUM_HALT575_544             (0x1U << DMI_HALTSUM_HALT575_544_OFFSET)
#define DMI_HALTSUM_HALT543_512_OFFSET      16
#define DMI_HALTSUM_HALT543_512_LENGTH      1
#define DMI_HALTSUM_HALT543_512             (0x1U << DMI_HALTSUM_HALT543_512_OFFSET)
#define DMI_HALTSUM_HALT511_480_OFFSET      15
#define DMI_HALTSUM_HALT511_480_LENGTH      1
#define DMI_HALTSUM_HALT511_480             (0x1U << DMI_HALTSUM_HALT511_480_OFFSET)
#define DMI_HALTSUM_HALT479_448_OFFSET      14
#define DMI_HALTSUM_HALT479_448_LENGTH      1
#define DMI_HALTSUM_HALT479_448             (0x1U << DMI_HALTSUM_HALT479_448_OFFSET)
#define DMI_HALTSUM_HALT447_416_OFFSET      13
#define DMI_HALTSUM_HALT447_416_LENGTH      1
#define DMI_HALTSUM_HALT447_416             (0x1U << DMI_HALTSUM_HALT447_416_OFFSET)
#define DMI_HALTSUM_HALT415_384_OFFSET      12
#define DMI_HALTSUM_HALT415_384_LENGTH      1
#define DMI_HALTSUM_HALT415_384             (0x1U << DMI_HALTSUM_HALT415_384_OFFSET)
#define DMI_HALTSUM_HALT383_352_OFFSET      11
#define DMI_HALTSUM_HALT383_352_LENGTH      1
#define DMI_HALTSUM_HALT383_352             (0x1U << DMI_HALTSUM_HALT383_352_OFFSET)
#define DMI_HALTSUM_HALT351_320_OFFSET      10
#define DMI_HALTSUM_HALT351_320_LENGTH      1
#define DMI_HALTSUM_HALT351_320             (0x1U << DMI_HALTSUM_HALT351_320_OFFSET)
#define DMI_HALTSUM_HALT319_288_OFFSET      9
#define DMI_HALTSUM_HALT319_288_LENGTH      1
#define DMI_HALTSUM_HALT319_288             (0x1U << DMI_HALTSUM_HALT319_288_OFFSET)
#define DMI_HALTSUM_HALT287_256_OFFSET      8
#define DMI_HALTSUM_HALT287_256_LENGTH      1
#define DMI_HALTSUM_HALT287_256             (0x1U << DMI_HALTSUM_HALT287_256_OFFSET)
#define DMI_HALTSUM_HALT255_224_OFFSET      7
#define DMI_HALTSUM_HALT255_224_LENGTH      1
#define DMI_HALTSUM_HALT255_224             (0x1U << DMI_HALTSUM_HALT255_224_OFFSET)
#define DMI_HALTSUM_HALT223_192_OFFSET      6
#define DMI_HALTSUM_HALT223_192_LENGTH      1
#define DMI_HALTSUM_HALT223_192             (0x1U << DMI_HALTSUM_HALT223_192_OFFSET)
#define DMI_HALTSUM_HALT191_160_OFFSET      5
#define DMI_HALTSUM_HALT191_160_LENGTH      1
#define DMI_HALTSUM_HALT191_160             (0x1U << DMI_HALTSUM_HALT191_160_OFFSET)
#define DMI_HALTSUM_HALT159_128_OFFSET      4
#define DMI_HALTSUM_HALT159_128_LENGTH      1
#define DMI_HALTSUM_HALT159_128             (0x1U << DMI_HALTSUM_HALT159_128_OFFSET)
#define DMI_HALTSUM_HALT127_96_OFFSET       3
#define DMI_HALTSUM_HALT127_96_LENGTH       1
#define DMI_HALTSUM_HALT127_96              (0x1U << DMI_HALTSUM_HALT127_96_OFFSET)
#define DMI_HALTSUM_HALT95_64_OFFSET        2
#define DMI_HALTSUM_HALT95_64_LENGTH        1
#define DMI_HALTSUM_HALT95_64               (0x1U << DMI_HALTSUM_HALT95_64_OFFSET)
#define DMI_HALTSUM_HALT63_32_OFFSET        1
#define DMI_HALTSUM_HALT63_32_LENGTH        1
#define DMI_HALTSUM_HALT63_32               (0x1U << DMI_HALTSUM_HALT63_32_OFFSET)
#define DMI_HALTSUM_HALT31_0_OFFSET         0
#define DMI_HALTSUM_HALT31_0_LENGTH         1
#define DMI_HALTSUM_HALT31_0                (0x1U << DMI_HALTSUM_HALT31_0_OFFSET)
#define DMI_HAWINDOWSEL                     0x14
#define DMI_HAWINDOWSEL_HAWINDOWSEL_OFFSET  0
#define DMI_HAWINDOWSEL_HAWINDOWSEL_LENGTH  5
#define DMI_HAWINDOWSEL_HAWINDOWSEL         (0x1fU << DMI_HAWINDOWSEL_HAWINDOWSEL_OFFSET)
#define DMI_HAWINDOW                        0x15
#define DMI_HAWINDOW_MASKDATA_OFFSET        0
#define DMI_HAWINDOW_MASKDATA_LENGTH        32
#define DMI_HAWINDOW_MASKDATA               (0xffffffffU << DMI_HAWINDOW_MASKDATA_OFFSET)
#define DMI_ABSTRACTCS                      0x16
/*
* Size of the Program Buffer, in 32-bit words. Valid sizes are 0 - 16.
 */
#define DMI_ABSTRACTCS_PROGBUFSIZE_OFFSET   24
#define DMI_ABSTRACTCS_PROGBUFSIZE_LENGTH   5
#define DMI_ABSTRACTCS_PROGBUFSIZE          (0x1fU << DMI_ABSTRACTCS_PROGBUFSIZE_OFFSET)
/*
* 1: An abstract command is currently being executed.
*
* This bit is set as soon as \Rcommand is written, and is
* not cleared until that command has completed.
 */
#define DMI_ABSTRACTCS_BUSY_OFFSET          12
#define DMI_ABSTRACTCS_BUSY_LENGTH          1
#define DMI_ABSTRACTCS_BUSY                 (0x1U << DMI_ABSTRACTCS_BUSY_OFFSET)
/*
* Gets set if an abstract command fails. The bits in this field remain set until
* they are cleared by writing 1 to them. No abstract command is
* started until the value is reset to 0.
*
* 0 (none): No error.
*
* 1 (busy): An abstract command was executing while \Rcommand,
* \Rabstractcs, \Rabstractauto was written, or when one
* of the {\tt data} or {\tt progbuf} registers was read or written.
*
* 2 (not supported): The requested command is not supported. A
* command that is not supported while the hart is running may be
* supported when it is halted.
*
* 3 (exception): An exception occurred while executing the command
* (eg. while executing the Program Buffer).
*
* 4 (halt/resume): An abstract command couldn't execute because the
* hart wasn't in the expected state (running/halted).
*
* 7 (other): The command failed for another reason.
 */
#define DMI_ABSTRACTCS_CMDERR_OFFSET        8
#define DMI_ABSTRACTCS_CMDERR_LENGTH        3
#define DMI_ABSTRACTCS_CMDERR               (0x7U << DMI_ABSTRACTCS_CMDERR_OFFSET)
/*
* Number of {\tt data} registers that are implemented as part of the
* abstract command interface. Valid sizes are 0 - 12.
 */
#define DMI_ABSTRACTCS_DATACOUNT_OFFSET     0
#define DMI_ABSTRACTCS_DATACOUNT_LENGTH     4
#define DMI_ABSTRACTCS_DATACOUNT            (0xfU << DMI_ABSTRACTCS_DATACOUNT_OFFSET)
#define DMI_COMMAND                         0x17
/*
* The type determines the overall functionality of this
* abstract command.
 */
#define DMI_COMMAND_CMDTYPE_OFFSET          24
#define DMI_COMMAND_CMDTYPE_LENGTH          8
#define DMI_COMMAND_CMDTYPE                 (0xffU << DMI_COMMAND_CMDTYPE_OFFSET)
/*
* This field is interpreted in a command-specific manner,
* described for each abstract command.
 */
#define DMI_COMMAND_CONTROL_OFFSET          0
#define DMI_COMMAND_CONTROL_LENGTH          24
#define DMI_COMMAND_CONTROL                 (0xffffffU << DMI_COMMAND_CONTROL_OFFSET)
#define DMI_ABSTRACTAUTO                    0x18
/*
* When a bit in this field is 1, read or write accesses to the corresponding {\tt progbuf} word
* cause the command in \Rcommand to be executed again.
 */
#define DMI_ABSTRACTAUTO_AUTOEXECPROGBUF_OFFSET 16
#define DMI_ABSTRACTAUTO_AUTOEXECPROGBUF_LENGTH 16
#define DMI_ABSTRACTAUTO_AUTOEXECPROGBUF    (0xffffU << DMI_ABSTRACTAUTO_AUTOEXECPROGBUF_OFFSET)
/*
* When a bit in this field is 1, read or write accesses to the corresponding {\tt data} word
* cause the command in \Rcommand to be executed again.
 */
#define DMI_ABSTRACTAUTO_AUTOEXECDATA_OFFSET 0
#define DMI_ABSTRACTAUTO_AUTOEXECDATA_LENGTH 12
#define DMI_ABSTRACTAUTO_AUTOEXECDATA       (0xfffU << DMI_ABSTRACTAUTO_AUTOEXECDATA_OFFSET)
#define DMI_DEVTREEADDR0                    0x19
#define DMI_DEVTREEADDR0_ADDR_OFFSET        0
#define DMI_DEVTREEADDR0_ADDR_LENGTH        32
#define DMI_DEVTREEADDR0_ADDR               (0xffffffffU << DMI_DEVTREEADDR0_ADDR_OFFSET)
#define DMI_DEVTREEADDR1                    0x1a
#define DMI_DEVTREEADDR2                    0x1b
#define DMI_DEVTREEADDR3                    0x1c
#define DMI_DATA0                           0x04
#define DMI_DATA0_DATA_OFFSET               0
#define DMI_DATA0_DATA_LENGTH               32
#define DMI_DATA0_DATA                      (0xffffffffU << DMI_DATA0_DATA_OFFSET)
#define DMI_DATA11                          0x0f
#define DMI_PROGBUF0                        0x20
#define DMI_PROGBUF0_DATA_OFFSET            0
#define DMI_PROGBUF0_DATA_LENGTH            32
#define DMI_PROGBUF0_DATA                   (0xffffffffU << DMI_PROGBUF0_DATA_OFFSET)
#define DMI_PROGBUF15                       0x2f
#define DMI_AUTHDATA                        0x30
#define DMI_AUTHDATA_DATA_OFFSET            0
#define DMI_AUTHDATA_DATA_LENGTH            32
#define DMI_AUTHDATA_DATA                   (0xffffffffU << DMI_AUTHDATA_DATA_OFFSET)
#define DMI_SBADDRESS3                      0x37
/*
* Accesses bits 127:96 of the physical address in {\tt sbaddress} (if
* the system address bus is that wide).
 */
#define DMI_SBADDRESS3_ADDRESS_OFFSET       0
#define DMI_SBADDRESS3_ADDRESS_LENGTH       32
#define DMI_SBADDRESS3_ADDRESS              (0xffffffffU << DMI_SBADDRESS3_ADDRESS_OFFSET)
#define DMI_SBCS                            0x38
/*
* 0: The System Bus interface conforms to mainline drafts of this
* spec older than 1 January, 2018.
*
* 1: The System Bus interface conforms to this version of the spec.
*
* Other values are reserved for future versions.
 */
#define DMI_SBCS_SBVERSION_OFFSET           29
#define DMI_SBCS_SBVERSION_LENGTH           3
#define DMI_SBCS_SBVERSION                  (0x7U << DMI_SBCS_SBVERSION_OFFSET)
/*
* Set when the debugger attempts to read data while a read is in
* progress, or when the debugger initiates a new access while one is
* already in progress (while \Fsbbusy is set). It remains set until
* it's explicitly cleared by the debugger.
*
* While this field is non-zero, no more system bus accesses can be
* initiated by the debug module.
 */
#define DMI_SBCS_SBBUSYERROR_OFFSET         22
#define DMI_SBCS_SBBUSYERROR_LENGTH         1
#define DMI_SBCS_SBBUSYERROR                (0x1U << DMI_SBCS_SBBUSYERROR_OFFSET)
/*
* When 1, indicates the system bus master is busy. (Whether the
* system bus itself is busy is related, but not the same thing.) This
* bit goes high immediately when a read or write is requested for any
* reason, and does not go low until the access is fully completed.
*
* To avoid race conditions, debuggers must not try to clear \Fsberror
* until they read \Fsbbusy as 0.
 */
#define DMI_SBCS_SBBUSY_OFFSET              21
#define DMI_SBCS_SBBUSY_LENGTH              1
#define DMI_SBCS_SBBUSY                     (0x1U << DMI_SBCS_SBBUSY_OFFSET)
/*
* When 1, every write to \Rsbaddresszero automatically triggers a
* system bus read at the new address.
 */
#define DMI_SBCS_SBREADONADDR_OFFSET        20
#define DMI_SBCS_SBREADONADDR_LENGTH        1
#define DMI_SBCS_SBREADONADDR               (0x1U << DMI_SBCS_SBREADONADDR_OFFSET)
/*
* Select the access size to use for system bus accesses.
*
* 0: 8-bit
*
* 1: 16-bit
*
* 2: 32-bit
*
* 3: 64-bit
*
* 4: 128-bit
*
* If \Fsbaccess has an unsupported value when the DM starts a bus
* access, the access is not performed and \Fsberror is set to 3.
 */
#define DMI_SBCS_SBACCESS_OFFSET            17
#define DMI_SBCS_SBACCESS_LENGTH            3
#define DMI_SBCS_SBACCESS                   (0x7U << DMI_SBCS_SBACCESS_OFFSET)
/*
* When 1, {\tt sbaddress} is incremented by the access size (in
* bytes) selected in \Fsbaccess after every system bus access.
 */
#define DMI_SBCS_SBAUTOINCREMENT_OFFSET     16
#define DMI_SBCS_SBAUTOINCREMENT_LENGTH     1
#define DMI_SBCS_SBAUTOINCREMENT            (0x1U << DMI_SBCS_SBAUTOINCREMENT_OFFSET)
/*
* When 1, every read from \Rsbdatazero automatically triggers a
* system bus read at the (possibly auto-incremented) address.
 */
#define DMI_SBCS_SBREADONDATA_OFFSET        15
#define DMI_SBCS_SBREADONDATA_LENGTH        1
#define DMI_SBCS_SBREADONDATA               (0x1U << DMI_SBCS_SBREADONDATA_OFFSET)
/*
* When the debug module's system bus
* master causes a bus error, this field gets set. The bits in this
* field remain set until they are cleared by writing 1 to them.
* While this field is non-zero, no more system bus accesses can be
* initiated by the debug module.
*
* 0: There was no bus error.
*
* 1: There was a timeout.
*
* 2: A bad address was accessed.
*
* 3: There was some other error (eg. alignment).
 */
#define DMI_SBCS_SBERROR_OFFSET             12
#define DMI_SBCS_SBERROR_LENGTH             3
#define DMI_SBCS_SBERROR                    (0x7U << DMI_SBCS_SBERROR_OFFSET)
/*
* Width of system bus addresses in bits. (0 indicates there is no bus
* access support.)
 */
#define DMI_SBCS_SBASIZE_OFFSET             5
#define DMI_SBCS_SBASIZE_LENGTH             7
#define DMI_SBCS_SBASIZE                    (0x7fU << DMI_SBCS_SBASIZE_OFFSET)
/*
* 1 when 128-bit system bus accesses are supported.
 */
#define DMI_SBCS_SBACCESS128_OFFSET         4
#define DMI_SBCS_SBACCESS128_LENGTH         1
#define DMI_SBCS_SBACCESS128                (0x1U << DMI_SBCS_SBACCESS128_OFFSET)
/*
* 1 when 64-bit system bus accesses are supported.
 */
#define DMI_SBCS_SBACCESS64_OFFSET          3
#define DMI_SBCS_SBACCESS64_LENGTH          1
#define DMI_SBCS_SBACCESS64                 (0x1U << DMI_SBCS_SBACCESS64_OFFSET)
/*
* 1 when 32-bit system bus accesses are supported.
 */
#define DMI_SBCS_SBACCESS32_OFFSET          2
#define DMI_SBCS_SBACCESS32_LENGTH          1
#define DMI_SBCS_SBACCESS32                 (0x1U << DMI_SBCS_SBACCESS32_OFFSET)
/*
* 1 when 16-bit system bus accesses are supported.
 */
#define DMI_SBCS_SBACCESS16_OFFSET          1
#define DMI_SBCS_SBACCESS16_LENGTH          1
#define DMI_SBCS_SBACCESS16                 (0x1U << DMI_SBCS_SBACCESS16_OFFSET)
/*
* 1 when 8-bit system bus accesses are supported.
 */
#define DMI_SBCS_SBACCESS8_OFFSET           0
#define DMI_SBCS_SBACCESS8_LENGTH           1
#define DMI_SBCS_SBACCESS8                  (0x1U << DMI_SBCS_SBACCESS8_OFFSET)
#define DMI_SBADDRESS0                      0x39
/*
* Accesses bits 31:0 of the physical address in {\tt sbaddress}.
 */
#define DMI_SBADDRESS0_ADDRESS_OFFSET       0
#define DMI_SBADDRESS0_ADDRESS_LENGTH       32
#define DMI_SBADDRESS0_ADDRESS              (0xffffffffU << DMI_SBADDRESS0_ADDRESS_OFFSET)
#define DMI_SBADDRESS1                      0x3a
/*
* Accesses bits 63:32 of the physical address in {\tt sbaddress} (if
* the system address bus is that wide).
 */
#define DMI_SBADDRESS1_ADDRESS_OFFSET       0
#define DMI_SBADDRESS1_ADDRESS_LENGTH       32
#define DMI_SBADDRESS1_ADDRESS              (0xffffffffU << DMI_SBADDRESS1_ADDRESS_OFFSET)
#define DMI_SBADDRESS2                      0x3b
/*
* Accesses bits 95:64 of the physical address in {\tt sbaddress} (if
* the system address bus is that wide).
 */
#define DMI_SBADDRESS2_ADDRESS_OFFSET       0
#define DMI_SBADDRESS2_ADDRESS_LENGTH       32
#define DMI_SBADDRESS2_ADDRESS              (0xffffffffU << DMI_SBADDRESS2_ADDRESS_OFFSET)
#define DMI_SBDATA0                         0x3c
/*
* Accesses bits 31:0 of {\tt sbdata}.
 */
#define DMI_SBDATA0_DATA_OFFSET             0
#define DMI_SBDATA0_DATA_LENGTH             32
#define DMI_SBDATA0_DATA                    (0xffffffffU << DMI_SBDATA0_DATA_OFFSET)
#define DMI_SBDATA1                         0x3d
/*
* Accesses bits 63:32 of {\tt sbdata} (if the system bus is that
* wide).
 */
#define DMI_SBDATA1_DATA_OFFSET             0
#define DMI_SBDATA1_DATA_LENGTH             32
#define DMI_SBDATA1_DATA                    (0xffffffffU << DMI_SBDATA1_DATA_OFFSET)
#define DMI_SBDATA2                         0x3e
/*
* Accesses bits 95:64 of {\tt sbdata} (if the system bus is that
* wide).
 */
#define DMI_SBDATA2_DATA_OFFSET             0
#define DMI_SBDATA2_DATA_LENGTH             32
#define DMI_SBDATA2_DATA                    (0xffffffffU << DMI_SBDATA2_DATA_OFFSET)
#define DMI_SBDATA3                         0x3f
/*
* Accesses bits 127:96 of {\tt sbdata} (if the system bus is that
* wide).
 */
#define DMI_SBDATA3_DATA_OFFSET             0
#define DMI_SBDATA3_DATA_LENGTH             32
#define DMI_SBDATA3_DATA                    (0xffffffffU << DMI_SBDATA3_DATA_OFFSET)
#define SHORTNAME                           0x123
/*
* Description of what this field is used for.
 */
#define SHORTNAME_FIELD_OFFSET              0
#define SHORTNAME_FIELD_LENGTH              8
#define SHORTNAME_FIELD                     (0xffU << SHORTNAME_FIELD_OFFSET)
#define AC_ACCESS_REGISTER                  None
/*
* This is 0 to indicate Access Register Command.
 */
#define AC_ACCESS_REGISTER_CMDTYPE_OFFSET   24
#define AC_ACCESS_REGISTER_CMDTYPE_LENGTH   8
#define AC_ACCESS_REGISTER_CMDTYPE          (0xffU << AC_ACCESS_REGISTER_CMDTYPE_OFFSET)
/*
* 2: Access the lowest 32 bits of the register.
*
* 3: Access the lowest 64 bits of the register.
*
* 4: Access the lowest 128 bits of the register.
*
* If \Fsize specifies a size larger than the register's actual size,
* then the access must fail. If a register is accessible, then reads of \Fsize
* less than or equal to the register's actual size must be supported.
 */
#define AC_ACCESS_REGISTER_SIZE_OFFSET      20
#define AC_ACCESS_REGISTER_SIZE_LENGTH      3
#define AC_ACCESS_REGISTER_SIZE             (0x7U << AC_ACCESS_REGISTER_SIZE_OFFSET)
/*
* When 1, execute the program in the Program Buffer exactly once
* after performing the transfer, if any.
 */
#define AC_ACCESS_REGISTER_POSTEXEC_OFFSET  18
#define AC_ACCESS_REGISTER_POSTEXEC_LENGTH  1
#define AC_ACCESS_REGISTER_POSTEXEC         (0x1U << AC_ACCESS_REGISTER_POSTEXEC_OFFSET)
/*
* 0: Don't do the operation specified by \Fwrite.
*
* 1: Do the operation specified by \Fwrite.
*
* This bit can be used to just execute the Program Buffer without
* having to worry about placing valid values into \Fsize or \Fregno.
 */
#define AC_ACCESS_REGISTER_TRANSFER_OFFSET  17
#define AC_ACCESS_REGISTER_TRANSFER_LENGTH  1
#define AC_ACCESS_REGISTER_TRANSFER         (0x1U << AC_ACCESS_REGISTER_TRANSFER_OFFSET)
/*
* When \Ftransfer is set:
* 0: Copy data from the specified register into {\tt arg0} portion
* of {\tt data}.
*
* 1: Copy data from {\tt arg0} portion of {\tt data} into the
* specified register.
 */
#define AC_ACCESS_REGISTER_WRITE_OFFSET     16
#define AC_ACCESS_REGISTER_WRITE_LENGTH     1
#define AC_ACCESS_REGISTER_WRITE            (0x1U << AC_ACCESS_REGISTER_WRITE_OFFSET)
/*
* Number of the register to access, as described in
* Table~\ref{tab:regno}.
* \Rdpc may be used as an alias for PC if this command is
* supported on a non-halted hart.
 */
#define AC_ACCESS_REGISTER_REGNO_OFFSET     0
#define AC_ACCESS_REGISTER_REGNO_LENGTH     16
#define AC_ACCESS_REGISTER_REGNO            (0xffffU << AC_ACCESS_REGISTER_REGNO_OFFSET)
#define AC_QUICK_ACCESS                     None
/*
* This is 1 to indicate Quick Access command.
 */
#define AC_QUICK_ACCESS_CMDTYPE_OFFSET      24
#define AC_QUICK_ACCESS_CMDTYPE_LENGTH      8
#define AC_QUICK_ACCESS_CMDTYPE             (0xffU << AC_QUICK_ACCESS_CMDTYPE_OFFSET)
#define VIRT_PRIV                           virtual
/*
* Contains the privilege level the hart was operating in when Debug
* Mode was entered. The encoding is described in Table
* \ref{tab:privlevel}, and matches the privilege level encoding from
* the RISC-V Privileged ISA Specification. A user can write this
* value to change the hart's privilege level when exiting Debug Mode.
 */
#define VIRT_PRIV_PRV_OFFSET                0
#define VIRT_PRIV_PRV_LENGTH                2
#define VIRT_PRIV_PRV                       (0x3U << VIRT_PRIV_PRV_OFFSET)
#define DMI_SERCS                           0x34
/*
* Number of supported serial ports.
 */
#define DMI_SERCS_SERIALCOUNT_OFFSET        28
#define DMI_SERCS_SERIALCOUNT_LENGTH        4
#define DMI_SERCS_SERIALCOUNT               (0xfU << DMI_SERCS_SERIALCOUNT_OFFSET)
/*
* Select which serial port is accessed by \Rserrx and \Rsertx.
 */
#define DMI_SERCS_SERIAL_OFFSET             24
#define DMI_SERCS_SERIAL_LENGTH             3
#define DMI_SERCS_SERIAL                    (0x7U << DMI_SERCS_SERIAL_OFFSET)
#define DMI_SERCS_ERROR7_OFFSET             23
#define DMI_SERCS_ERROR7_LENGTH             1
#define DMI_SERCS_ERROR7                    (0x1U << DMI_SERCS_ERROR7_OFFSET)
#define DMI_SERCS_VALID7_OFFSET             22
#define DMI_SERCS_VALID7_LENGTH             1
#define DMI_SERCS_VALID7                    (0x1U << DMI_SERCS_VALID7_OFFSET)
#define DMI_SERCS_FULL7_OFFSET              21
#define DMI_SERCS_FULL7_LENGTH              1
#define DMI_SERCS_FULL7                     (0x1U << DMI_SERCS_FULL7_OFFSET)
#define DMI_SERCS_ERROR6_OFFSET             20
#define DMI_SERCS_ERROR6_LENGTH             1
#define DMI_SERCS_ERROR6                    (0x1U << DMI_SERCS_ERROR6_OFFSET)
#define DMI_SERCS_VALID6_OFFSET             19
#define DMI_SERCS_VALID6_LENGTH             1
#define DMI_SERCS_VALID6                    (0x1U << DMI_SERCS_VALID6_OFFSET)
#define DMI_SERCS_FULL6_OFFSET              18
#define DMI_SERCS_FULL6_LENGTH              1
#define DMI_SERCS_FULL6                     (0x1U << DMI_SERCS_FULL6_OFFSET)
#define DMI_SERCS_ERROR5_OFFSET             17
#define DMI_SERCS_ERROR5_LENGTH             1
#define DMI_SERCS_ERROR5                    (0x1U << DMI_SERCS_ERROR5_OFFSET)
#define DMI_SERCS_VALID5_OFFSET             16
#define DMI_SERCS_VALID5_LENGTH             1
#define DMI_SERCS_VALID5                    (0x1U << DMI_SERCS_VALID5_OFFSET)
#define DMI_SERCS_FULL5_OFFSET              15
#define DMI_SERCS_FULL5_LENGTH              1
#define DMI_SERCS_FULL5                     (0x1U << DMI_SERCS_FULL5_OFFSET)
#define DMI_SERCS_ERROR4_OFFSET             14
#define DMI_SERCS_ERROR4_LENGTH             1
#define DMI_SERCS_ERROR4                    (0x1U << DMI_SERCS_ERROR4_OFFSET)
#define DMI_SERCS_VALID4_OFFSET             13
#define DMI_SERCS_VALID4_LENGTH             1
#define DMI_SERCS_VALID4                    (0x1U << DMI_SERCS_VALID4_OFFSET)
#define DMI_SERCS_FULL4_OFFSET              12
#define DMI_SERCS_FULL4_LENGTH              1
#define DMI_SERCS_FULL4                     (0x1U << DMI_SERCS_FULL4_OFFSET)
#define DMI_SERCS_ERROR3_OFFSET             11
#define DMI_SERCS_ERROR3_LENGTH             1
#define DMI_SERCS_ERROR3                    (0x1U << DMI_SERCS_ERROR3_OFFSET)
#define DMI_SERCS_VALID3_OFFSET             10
#define DMI_SERCS_VALID3_LENGTH             1
#define DMI_SERCS_VALID3                    (0x1U << DMI_SERCS_VALID3_OFFSET)
#define DMI_SERCS_FULL3_OFFSET              9
#define DMI_SERCS_FULL3_LENGTH              1
#define DMI_SERCS_FULL3                     (0x1U << DMI_SERCS_FULL3_OFFSET)
#define DMI_SERCS_ERROR2_OFFSET             8
#define DMI_SERCS_ERROR2_LENGTH             1
#define DMI_SERCS_ERROR2                    (0x1U << DMI_SERCS_ERROR2_OFFSET)
#define DMI_SERCS_VALID2_OFFSET             7
#define DMI_SERCS_VALID2_LENGTH             1
#define DMI_SERCS_VALID2                    (0x1U << DMI_SERCS_VALID2_OFFSET)
#define DMI_SERCS_FULL2_OFFSET              6
#define DMI_SERCS_FULL2_LENGTH              1
#define DMI_SERCS_FULL2                     (0x1U << DMI_SERCS_FULL2_OFFSET)
#define DMI_SERCS_ERROR1_OFFSET             5
#define DMI_SERCS_ERROR1_LENGTH             1
#define DMI_SERCS_ERROR1                    (0x1U << DMI_SERCS_ERROR1_OFFSET)
#define DMI_SERCS_VALID1_OFFSET             4
#define DMI_SERCS_VALID1_LENGTH             1
#define DMI_SERCS_VALID1                    (0x1U << DMI_SERCS_VALID1_OFFSET)
#define DMI_SERCS_FULL1_OFFSET              3
#define DMI_SERCS_FULL1_LENGTH              1
#define DMI_SERCS_FULL1                     (0x1U << DMI_SERCS_FULL1_OFFSET)
/*
* 1 when the debugger-to-core queue for serial port 0 has
* over or underflowed. This bit will remain set until it is reset by
* writing 1 to this bit.
 */
#define DMI_SERCS_ERROR0_OFFSET             2
#define DMI_SERCS_ERROR0_LENGTH             1
#define DMI_SERCS_ERROR0                    (0x1U << DMI_SERCS_ERROR0_OFFSET)
/*
* 1 when the core-to-debugger queue for serial port 0 is not empty.
 */
#define DMI_SERCS_VALID0_OFFSET             1
#define DMI_SERCS_VALID0_LENGTH             1
#define DMI_SERCS_VALID0                    (0x1U << DMI_SERCS_VALID0_OFFSET)
/*
* 1 when the debugger-to-core queue for serial port 0 is full.
 */
#define DMI_SERCS_FULL0_OFFSET              0
#define DMI_SERCS_FULL0_LENGTH              1
#define DMI_SERCS_FULL0                     (0x1U << DMI_SERCS_FULL0_OFFSET)
#define DMI_SERTX                           0x35
#define DMI_SERTX_DATA_OFFSET               0
#define DMI_SERTX_DATA_LENGTH               32
#define DMI_SERTX_DATA                      (0xffffffffU << DMI_SERTX_DATA_OFFSET)
#define DMI_SERRX                           0x36
#define DMI_SERRX_DATA_OFFSET               0
#define DMI_SERRX_DATA_LENGTH               32
#define DMI_SERRX_DATA                      (0xffffffffU << DMI_SERRX_DATA_OFFSET)
