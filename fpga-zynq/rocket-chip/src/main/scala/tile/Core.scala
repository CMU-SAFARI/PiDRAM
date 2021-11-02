// See LICENSE.SiFive for license details.

package freechips.rocketchip.tile

import Chisel._

import freechips.rocketchip.config._
import freechips.rocketchip.rocket._
import freechips.rocketchip.util._

case object BuildCore extends Field[Parameters => CoreModule with HasCoreIO]
case object XLen extends Field[Int]

// These parameters can be varied per-core
trait CoreParams {
  val bootFreqHz: BigInt
  val useVM: Boolean
  val useUser: Boolean
  val useDebug: Boolean
  val useAtomics: Boolean
  val useAtomicsOnlyForIO: Boolean
  val useCompressed: Boolean
  val mulDiv: Option[MulDivParams]
  val fpu: Option[FPUParams]
  val fetchWidth: Int
  val decodeWidth: Int
  val retireWidth: Int
  val instBits: Int
  val nLocalInterrupts: Int
  val nPMPs: Int
  val nBreakpoints: Int
  val nPerfCounters: Int
  val haveBasicCounters: Boolean
  val misaWritable: Boolean
  val nL2TLBEntries: Int
  val mtvecInit: Option[BigInt]
  val mtvecWritable: Boolean
  val tileControlAddr: Option[BigInt]

  def instBytes: Int = instBits / 8
  def fetchBytes: Int = fetchWidth * instBytes
}

trait HasCoreParameters extends HasTileParameters {
  val coreParams: CoreParams = tileParams.core

  val fLen = coreParams.fpu.map(_.fLen).getOrElse(0)

  val usingMulDiv = coreParams.mulDiv.nonEmpty
  val usingFPU = coreParams.fpu.nonEmpty
  val usingAtomics = coreParams.useAtomics
  val usingAtomicsOnlyForIO = coreParams.useAtomicsOnlyForIO
  val usingAtomicsInCache = usingAtomics && !usingAtomicsOnlyForIO
  val usingCompressed = coreParams.useCompressed

  val retireWidth = coreParams.retireWidth
  val fetchWidth = coreParams.fetchWidth
  val decodeWidth = coreParams.decodeWidth

  val fetchBytes = coreParams.fetchBytes
  val coreInstBits = coreParams.instBits
  val coreInstBytes = coreInstBits/8
  val coreDataBits = xLen max fLen
  val coreDataBytes = coreDataBits/8
  val coreMaxAddrBits = paddrBits max vaddrBitsExtended

  val nBreakpoints = coreParams.nBreakpoints
  val nPMPs = coreParams.nPMPs
  val nPerfCounters = coreParams.nPerfCounters
  val mtvecInit = coreParams.mtvecInit
  val mtvecWritable = coreParams.mtvecWritable

  val coreDCacheReqTagBits = 6
  val dcacheReqTagBits = coreDCacheReqTagBits + log2Ceil(dcacheArbPorts)

  // Print out log of committed instructions and their writeback values.
  // Requires post-processing due to out-of-order writebacks.
  val enableCommitLog = false
}

abstract class CoreModule(implicit val p: Parameters) extends Module
  with HasCoreParameters

abstract class CoreBundle(implicit val p: Parameters) extends ParameterizedBundle()(p)
  with HasCoreParameters

class CoreInterrupts(implicit p: Parameters) extends TileInterrupts()(p) {
  val buserror = coreParams.tileControlAddr.map(a => Bool())
}

trait HasCoreIO extends HasTileParameters {
  implicit val p: Parameters
  val io = new CoreBundle()(p) with HasExternallyDrivenTileConstants {
    val interrupts = new CoreInterrupts().asInput
    val imem  = new FrontendIO
    val dmem = new HellaCacheIO
    val ptw = new DatapathPTWIO().flip
    val fpu = new FPUCoreIO().flip
    val rocc = new RoCCCoreIO().flip
    val trace = Vec(coreParams.retireWidth, new TracedInstruction).asOutput
  }
}
