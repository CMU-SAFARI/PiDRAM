// See LICENSE.SiFive for license details.

package freechips.rocketchip.devices.tilelink

import Chisel._
import freechips.rocketchip.config.{Field, Parameters}
import freechips.rocketchip.subsystem.BaseSubsystem
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.interrupts._
import freechips.rocketchip.util._
import scala.math.{min,max}

object CLINTConsts
{
  def msipOffset(hart: Int) = hart * msipBytes
  def timecmpOffset(hart: Int) = 0x4000 + hart * timecmpBytes
  def timeOffset = 0xbff8
  def msipBytes = 4
  def timecmpBytes = 8
  def size = 0x10000
  def timeWidth = 64
  def ipiWidth = 32
  def ints = 2
}

case class CLINTParams(baseAddress: BigInt = 0x02000000, intStages: Int = 0)
{
  def address = AddressSet(baseAddress, CLINTConsts.size-1)
}

case object CLINTKey extends Field(CLINTParams())

class CLINT(params: CLINTParams, beatBytes: Int)(implicit p: Parameters) extends LazyModule
{
  import CLINTConsts._

  // clint0 => at most 4095 devices
  val device = new SimpleDevice("clint", Seq("riscv,clint0")) {
    override val alwaysExtended = true
  }

  val node = TLRegisterNode(
    address   = Seq(params.address),
    device    = device,
    beatBytes = beatBytes)

  val intnode = IntNexusNode(
    sourceFn = { _ => IntSourcePortParameters(Seq(IntSourceParameters(ints, Seq(Resource(device, "int"))))) },
    sinkFn   = { _ => IntSinkPortParameters(Seq(IntSinkParameters())) },
    outputRequiresInput = false)

  lazy val module = new LazyModuleImp(this) {
    require (intnode.edges.in.size == 0, "CLINT only produces interrupts; it does not accept them")

    val io = IO(new Bundle {
      val rtcTick = Bool(INPUT)
    })

    val time = RegInit(UInt(0, width = timeWidth))
    when (io.rtcTick) { time := time + UInt(1) }

    val nTiles = intnode.out.size
    val timecmp = Seq.fill(nTiles) { Reg(UInt(width = timeWidth)) }
    val ipi = Seq.fill(nTiles) { RegInit(UInt(0, width = 1)) }

    val (intnode_out, _) = intnode.out.unzip
    intnode_out.zipWithIndex.foreach { case (int, i) =>
      int(0) := ShiftRegister(ipi(i)(0), params.intStages) // msip
      int(1) := ShiftRegister(time.asUInt >= timecmp(i).asUInt, params.intStages) // mtip
    }

    /* 0000 msip hart 0
     * 0004 msip hart 1
     * 4000 mtimecmp hart 0 lo
     * 4004 mtimecmp hart 0 hi
     * 4008 mtimecmp hart 1 lo
     * 400c mtimecmp hart 1 hi
     * bff8 mtime lo
     * bffc mtime hi
     */

    node.regmap(
      0                -> RegFieldGroup ("msip", Some("MSIP Bits"), ipi.zipWithIndex.map{ case (r, i) =>
        RegField(ipiWidth, r, RegFieldDesc(s"msip_$i", s"MSIP bit for Hart $i", reset=Some(0)))}),
      timecmpOffset(0) -> timecmp.zipWithIndex.flatMap{ case (t, i) => RegFieldGroup(s"mtimecmp_$i", Some(s"MTIMECMP for hart $i"),
          RegField.bytes(t, Some(RegFieldDesc(s"mtimecmp_$i", "", reset=None))))},
      timeOffset       -> RegFieldGroup("mtime", Some("Timer Register"),
        RegField.bytes(time, Some(RegFieldDesc("mtime", "", reset=Some(0), volatile=true))))
    )
  }
}

/** Trait that will connect a CLINT to a subsystem */
trait HasPeripheryCLINT { this: BaseSubsystem =>
  val clint = LazyModule(new CLINT(p(CLINTKey), pbus.beatBytes))
  pbus.toVariableWidthSlave(Some("clint")) { clint.node }
}
