// See LICENSE.Berkeley for license details.
// See LICENSE.SiFive for license details.

package freechips.rocketchip.rocket

import Chisel._
import Chisel.ImplicitConversions._
import chisel3.core.withReset
import freechips.rocketchip.config._
import freechips.rocketchip.subsystem._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.tile._
import freechips.rocketchip.util._
import freechips.rocketchip.util.property._
import chisel3.internal.sourceinfo.SourceInfo

class FrontendReq(implicit p: Parameters) extends CoreBundle()(p) {
  val pc = UInt(width = vaddrBitsExtended)
  val speculative = Bool()
}

class FrontendExceptions extends Bundle {
  val pf = new Bundle {
    val inst = Bool()
  }
  val ae = new Bundle {
    val inst = Bool()
  }
}

class FrontendResp(implicit p: Parameters) extends CoreBundle()(p) {
  val btb = new BTBResp
  val pc = UInt(width = vaddrBitsExtended)  // ID stage PC
  val data = UInt(width = fetchWidth * coreInstBits)
  val mask = Bits(width = fetchWidth)
  val xcpt = new FrontendExceptions
  val replay = Bool()
}

class FrontendPerfEvents extends Bundle {
  val acquire = Bool()
  val tlbMiss = Bool()
}

class FrontendIO(implicit p: Parameters) extends CoreBundle()(p) {
  val req = Valid(new FrontendReq)
  val sfence = Valid(new SFenceReq)
  val resp = Decoupled(new FrontendResp).flip
  val btb_update = Valid(new BTBUpdate)
  val bht_update = Valid(new BHTUpdate)
  val ras_update = Valid(new RASUpdate)
  val flush_icache = Bool(OUTPUT)
  val npc = UInt(INPUT, width = vaddrBitsExtended)
  val perf = new FrontendPerfEvents().asInput
}

class Frontend(val icacheParams: ICacheParams, hartid: Int)(implicit p: Parameters) extends LazyModule {
  lazy val module = new FrontendModule(this)
  val icache = LazyModule(new ICache(icacheParams, hartid))
  val masterNode = icache.masterNode
  val slaveNode = icache.slaveNode
}

class FrontendBundle(val outer: Frontend) extends CoreBundle()(outer.p)
    with HasExternallyDrivenTileConstants {
  val cpu = new FrontendIO().flip
  val ptw = new TLBPTWIO()
  val errors = new ICacheErrors
}

class FrontendModule(outer: Frontend) extends LazyModuleImp(outer)
    with HasCoreParameters
    with HasL1ICacheParameters {
  val io = IO(new FrontendBundle(outer))
  implicit val edge = outer.masterNode.edges.out(0)
  val icache = outer.icache.module
  require(fetchWidth*coreInstBytes == outer.icacheParams.fetchBytes)

  val tlb = Module(new TLB(true, log2Ceil(fetchBytes), nTLBEntries))
  val fq = withReset(reset || io.cpu.req.valid) { Module(new ShiftQueue(new FrontendResp, 5, flow = true)) }

  val s0_valid = io.cpu.req.valid || !fq.io.mask(fq.io.mask.getWidth-3)
  val s1_valid = RegNext(s0_valid)
  val s1_pc = Reg(UInt(width=vaddrBitsExtended))
  val s1_speculative = Reg(Bool())
  val s2_valid = RegInit(false.B)
  val s2_pc = RegInit(t = UInt(width = vaddrBitsExtended), alignPC(io.reset_vector))
  val s2_btb_resp_valid = if (usingBTB) Reg(Bool()) else false.B
  val s2_btb_resp_bits = Reg(new BTBResp)
  val s2_btb_taken = s2_btb_resp_valid && s2_btb_resp_bits.taken
  val s2_tlb_resp = Reg(tlb.io.resp)
  val s2_xcpt = s2_tlb_resp.ae.inst || s2_tlb_resp.pf.inst
  val s2_speculative = Reg(init=Bool(false))
  val s2_partial_insn_valid = RegInit(false.B)
  val s2_partial_insn = Reg(UInt(width = coreInstBits))
  val wrong_path = Reg(Bool())

  val s1_base_pc = ~(~s1_pc | (fetchBytes - 1))
  val ntpc = s1_base_pc + fetchBytes.U
  val predicted_npc = Wire(init = ntpc)
  val predicted_taken = Wire(init = Bool(false))

  val s2_replay = Wire(Bool())
  s2_replay := (s2_valid && !fq.io.enq.fire()) || RegNext(s2_replay && !s0_valid, true.B)
  val npc = Mux(s2_replay, s2_pc, predicted_npc)

  s1_pc := io.cpu.npc
  // consider RVC fetches across blocks to be non-speculative if the first
  // part was non-speculative
  val s0_speculative =
    if (usingCompressed) s1_speculative || s2_valid && !s2_speculative || predicted_taken
    else Bool(true)
  s1_speculative := Mux(io.cpu.req.valid, io.cpu.req.bits.speculative, Mux(s2_replay, s2_speculative, s0_speculative))

  val s2_redirect = Wire(init = io.cpu.req.valid)
  s2_valid := false
  when (!s2_replay) {
    s2_valid := !s2_redirect
    s2_pc := s1_pc
    s2_speculative := s1_speculative
    s2_tlb_resp := tlb.io.resp
  }

  io.ptw <> tlb.io.ptw
  tlb.io.req.valid := !s2_replay
  tlb.io.req.bits.vaddr := s1_pc
  tlb.io.req.bits.passthrough := Bool(false)
  tlb.io.req.bits.sfence := io.cpu.sfence
  tlb.io.req.bits.size := log2Ceil(coreInstBytes*fetchWidth)

  icache.io.hartid := io.hartid
  icache.io.req.valid := s0_valid
  icache.io.req.bits.addr := io.cpu.npc
  icache.io.invalidate := io.cpu.flush_icache
  icache.io.s1_paddr := tlb.io.resp.paddr
  icache.io.s2_vaddr := s2_pc
  icache.io.s1_kill := s2_redirect || tlb.io.resp.miss || s2_replay
  icache.io.s2_kill := s2_speculative && !s2_tlb_resp.cacheable || s2_xcpt
  icache.io.s2_prefetch := s2_tlb_resp.prefetchable

  fq.io.enq.valid := RegNext(s1_valid) && s2_valid && (icache.io.resp.valid || !s2_tlb_resp.miss && icache.io.s2_kill)
  fq.io.enq.bits.pc := s2_pc
  io.cpu.npc := alignPC(Mux(io.cpu.req.valid, io.cpu.req.bits.pc, npc))

  fq.io.enq.bits.data := icache.io.resp.bits.data
  fq.io.enq.bits.mask := UInt((1 << fetchWidth)-1) << s2_pc.extract(log2Ceil(fetchWidth)+log2Ceil(coreInstBytes)-1, log2Ceil(coreInstBytes))
  fq.io.enq.bits.replay := icache.io.resp.bits.replay || icache.io.s2_kill && !icache.io.resp.valid && !s2_xcpt
  fq.io.enq.bits.btb := s2_btb_resp_bits
  fq.io.enq.bits.btb.taken := s2_btb_taken
  fq.io.enq.bits.xcpt := s2_tlb_resp
  when (icache.io.resp.valid && icache.io.resp.bits.ae) { fq.io.enq.bits.xcpt.ae.inst := true }

  if (usingBTB) {
    val btb = Module(new BTB)
    btb.io.flush := false
    btb.io.req.valid := false
    btb.io.req.bits.addr := s1_pc
    btb.io.btb_update := io.cpu.btb_update
    btb.io.bht_update := io.cpu.bht_update
    btb.io.ras_update.valid := false
    btb.io.bht_advance.valid := false
    when (!s2_replay) {
      btb.io.req.valid := !s2_redirect
      s2_btb_resp_valid := btb.io.resp.valid
      s2_btb_resp_bits := btb.io.resp.bits
    }
    when (btb.io.resp.valid && btb.io.resp.bits.taken) {
      predicted_npc := btb.io.resp.bits.target.sextTo(vaddrBitsExtended)
      predicted_taken := Bool(true)
    }

    val s2_base_pc = ~(~s2_pc | (fetchBytes-1))
    val taken_idx = Wire(UInt())
    val after_idx = Wire(UInt())
    val useRAS = Wire(init=false.B)
    val updateBTB = Wire(init=false.B)

    def scanInsns(idx: Int, prevValid: Bool, prevBits: UInt, prevTaken: Bool): Bool = {
      def insnIsRVC(bits: UInt) = bits(1,0) =/= 3
      val prevRVI = prevValid && !insnIsRVC(prevBits)
      val valid = fq.io.enq.bits.mask(idx) && !prevRVI
      val bits = fq.io.enq.bits.data(coreInstBits*(idx+1)-1, coreInstBits*idx)
      val rvc = insnIsRVC(bits)
      val rviBits = Cat(bits, prevBits)
      val rviBranch = rviBits(6,0) === Instructions.BEQ.value.asUInt()(6,0)
      val rviJump = rviBits(6,0) === Instructions.JAL.value.asUInt()(6,0)
      val rviJALR = rviBits(6,0) === Instructions.JALR.value.asUInt()(6,0)
      val rviReturn = rviJALR && !rviBits(7) && BitPat("b00?01") === rviBits(19,15)
      val rviCall = (rviJALR || rviJump) && rviBits(7)
      val rvcBranch = bits === Instructions.C_BEQZ || bits === Instructions.C_BNEZ
      val rvcJAL = Bool(xLen == 32) && bits === Instructions.C_JAL
      val rvcJump = bits === Instructions.C_J || rvcJAL
      val rvcImm = Mux(bits(14), new RVCDecoder(bits).bImm.asSInt, new RVCDecoder(bits).jImm.asSInt)
      val rvcJR = bits === Instructions.C_MV && bits(6,2) === 0
      val rvcReturn = rvcJR && BitPat("b00?01") === bits(11,7)
      val rvcJALR = bits === Instructions.C_ADD && bits(6,2) === 0
      val rvcCall = rvcJAL || rvcJALR
      val rviImm = Mux(rviBits(3), ImmGen(IMM_UJ, rviBits), ImmGen(IMM_SB, rviBits))
      val taken =
        prevRVI && (rviJump || rviJALR || rviBranch && s2_btb_resp_bits.bht.taken) ||
        valid && (rvcJump || rvcJALR || rvcJR || rvcBranch && s2_btb_resp_bits.bht.taken)
      val predictReturn = btb.io.ras_head.valid && (prevRVI && rviReturn || valid && rvcReturn)
      val predictJump = prevRVI && rviJump || valid && rvcJump
      val predictBranch = s2_btb_resp_bits.bht.taken && (prevRVI && rviBranch || valid && rvcBranch)

      when (s2_valid && s2_btb_resp_valid && s2_btb_resp_bits.bridx === idx && valid && !rvc) {
        // The BTB has predicted that the middle of an RVI instruction is
        // a branch! Flush the BTB and the pipeline.
        btb.io.flush := true
        fq.io.enq.bits.replay := true
        wrong_path := true
        ccover(wrong_path, "BTB_NON_CFI_ON_WRONG_PATH", "BTB predicted a non-branch was taken while on the wrong path")
      }

      when (!prevTaken) {
        taken_idx := idx
        after_idx := idx + 1
        btb.io.ras_update.valid := fq.io.enq.fire() && !wrong_path && (prevRVI && (rviCall || rviReturn) || valid && (rvcCall || rvcReturn))
        btb.io.ras_update.bits.cfiType := Mux(Mux(prevRVI, rviReturn, rvcReturn), CFIType.ret,
                                          Mux(Mux(prevRVI, rviCall, rvcCall), CFIType.call,
                                          Mux(Mux(prevRVI, rviBranch, rvcBranch), CFIType.branch,
                                          CFIType.jump)))

        when (!s2_btb_taken) {
          when (fq.io.enq.fire() && taken && !predictBranch && !predictJump && !predictReturn) {
            wrong_path := true
          }
          when (s2_valid && predictReturn) {
            useRAS := true
          }
          when (s2_valid && (predictBranch || predictJump)) {
            val pc = s2_base_pc | (idx*coreInstBytes)
            val npc =
              if (idx == 0) pc.asSInt + Mux(prevRVI, rviImm -& 2.S, rvcImm)
              else Mux(prevRVI, pc - coreInstBytes, pc).asSInt + Mux(prevRVI, rviImm, rvcImm)
            predicted_npc := npc.asUInt
          }
        }
        when (prevRVI && rviBranch || valid && rvcBranch) {
          btb.io.bht_advance.valid := fq.io.enq.fire() && !wrong_path
          btb.io.bht_advance.bits := s2_btb_resp_bits
        }
        when (!s2_btb_resp_valid && (predictBranch && s2_btb_resp_bits.bht.strongly_taken || predictJump || predictReturn)) {
          updateBTB := true
        }
      }

      if (idx == fetchWidth-1) {
        when (fq.io.enq.fire()) {
          s2_partial_insn_valid := false
          when (valid && !prevTaken && !rvc) {
            s2_partial_insn_valid := true
            s2_partial_insn := bits | 0x3
          }
        }
        prevTaken || taken
      } else {
        scanInsns(idx + 1, valid, bits, prevTaken || taken)
      }
    }

    when (!io.cpu.btb_update.valid) {
      val fetch_bubble_likely = !fq.io.mask(1)
      btb.io.btb_update.valid := fq.io.enq.fire() && !wrong_path && fetch_bubble_likely && updateBTB
      btb.io.btb_update.bits.prediction.entry := UInt(tileParams.btb.get.nEntries)
      btb.io.btb_update.bits.isValid := true
      btb.io.btb_update.bits.cfiType := btb.io.ras_update.bits.cfiType
      btb.io.btb_update.bits.br_pc := s2_base_pc | (taken_idx << log2Ceil(coreInstBytes))
      btb.io.btb_update.bits.pc := s2_base_pc
    }

    btb.io.ras_update.bits.returnAddr := s2_base_pc + (after_idx << log2Ceil(coreInstBytes))

    val taken = scanInsns(0, s2_partial_insn_valid, s2_partial_insn, false.B)
    when (useRAS) {
      predicted_npc := btb.io.ras_head.bits
    }
    when (fq.io.enq.fire() && (s2_btb_taken || taken)) {
      s2_partial_insn_valid := false
    }
    when (!s2_btb_taken) {
      when (taken) {
        fq.io.enq.bits.btb.bridx := taken_idx
        fq.io.enq.bits.btb.taken := true
        fq.io.enq.bits.btb.entry := UInt(tileParams.btb.get.nEntries)
        when (fq.io.enq.fire()) { s2_redirect := true }
      }
    }

    assert(!s2_partial_insn_valid || fq.io.enq.bits.mask(0))
    when (s2_redirect) { s2_partial_insn_valid := false }
    when (io.cpu.req.valid) { wrong_path := false }
  }

  io.cpu.resp <> fq.io.deq

  // performance events
  io.cpu.perf := icache.io.perf
  io.cpu.perf.tlbMiss := io.ptw.req.fire()
  io.errors := icache.io.errors

  def alignPC(pc: UInt) = ~(~pc | (coreInstBytes - 1))

  def ccover(cond: Bool, label: String, desc: String)(implicit sourceInfo: SourceInfo) =
    cover(cond, s"FRONTEND_$label", "Rocket;;" + desc)
}

/** Mix-ins for constructing tiles that have an ICache-based pipeline frontend */
trait HasICacheFrontend extends CanHavePTW { this: BaseTile =>
  val module: HasICacheFrontendModule
  val frontend = LazyModule(new Frontend(tileParams.icache.get, hartId))
  tlMasterXbar.node := frontend.masterNode
  connectTLSlave(frontend.slaveNode, tileParams.core.fetchBytes)
  nPTWPorts += 1
}

trait HasICacheFrontendModule extends CanHavePTWModule {
  val outer: HasICacheFrontend
  ptwPorts += outer.frontend.module.io.ptw
}
