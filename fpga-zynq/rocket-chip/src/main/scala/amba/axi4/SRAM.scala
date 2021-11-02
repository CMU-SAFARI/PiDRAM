// See LICENSE.SiFive for license details.

package freechips.rocketchip.amba.axi4

import Chisel._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.util._

class AXI4RAM(
    address: AddressSet,
    executable: Boolean = true,
    beatBytes: Int = 4,
    devName: Option[String] = None,
    errors: Seq[AddressSet] = Nil)
  (implicit p: Parameters) extends DiplomaticSRAM(address, beatBytes, devName)
{
  val node = AXI4SlaveNode(Seq(AXI4SlavePortParameters(
    Seq(AXI4SlaveParameters(
      address       = List(address) ++ errors,
      resources     = resources,
      regionType    = RegionType.UNCACHED,
      executable    = executable,
      supportsRead  = TransferSizes(1, beatBytes),
      supportsWrite = TransferSizes(1, beatBytes),
      interleavedId = Some(0))),
    beatBytes  = beatBytes,
    minLatency = 1)))

  lazy val module = new LazyModuleImp(this) {
    val (in, _) = node.in(0)
    val mem = makeSinglePortedByteWriteSeqMem(1 << mask.filter(b=>b).size)

    val r_addr = Cat((mask zip (in.ar.bits.addr >> log2Ceil(beatBytes)).toBools).filter(_._1).map(_._2).reverse)
    val w_addr = Cat((mask zip (in.aw.bits.addr >> log2Ceil(beatBytes)).toBools).filter(_._1).map(_._2).reverse)
    val r_sel0 = address.contains(in.ar.bits.addr)
    val w_sel0 = address.contains(in.aw.bits.addr)

    val w_full = RegInit(Bool(false))
    val w_id   = Reg(UInt())
    val w_user = Reg(UInt(width = 1 max in.params.userBits))
    val r_sel1 = Reg(r_sel0)
    val w_sel1 = Reg(w_sel0)

    when (in. b.fire()) { w_full := Bool(false) }
    when (in.aw.fire()) { w_full := Bool(true) }

    when (in.aw.fire()) {
      w_id := in.aw.bits.id
      w_sel1 := w_sel0
      in.aw.bits.user.foreach { w_user := _ }
    }

    val wdata = Vec.tabulate(beatBytes) { i => in.w.bits.data(8*(i+1)-1, 8*i) }
    when (in.aw.fire() && w_sel0) {
      mem.write(w_addr, wdata, in.w.bits.strb.toBools)
    }

    in. b.valid := w_full
    in.aw.ready := in. w.valid && (in.b.ready || !w_full)
    in. w.ready := in.aw.valid && (in.b.ready || !w_full)

    in.b.bits.id   := w_id
    in.b.bits.resp := Mux(w_sel1, AXI4Parameters.RESP_OKAY, AXI4Parameters.RESP_DECERR)
    in.b.bits.user.foreach { _ := w_user }

    val r_full = RegInit(Bool(false))
    val r_id   = Reg(UInt())
    val r_user = Reg(UInt(width = 1 max in.params.userBits))

    when (in. r.fire()) { r_full := Bool(false) }
    when (in.ar.fire()) { r_full := Bool(true) }

    when (in.ar.fire()) {
      r_id := in.ar.bits.id
      r_sel1 := r_sel0
      in.ar.bits.user.foreach { r_user := _ }
    }

    val ren = in.ar.fire()
    val rdata = mem.readAndHold(r_addr, ren)

    in. r.valid := r_full
    in.ar.ready := in.r.ready || !r_full

    in.r.bits.id   := r_id
    in.r.bits.resp := Mux(r_sel1, AXI4Parameters.RESP_OKAY, AXI4Parameters.RESP_DECERR)
    in.r.bits.data := Cat(rdata.reverse)
    in.r.bits.user.foreach { _ := r_user }
    in.r.bits.last := Bool(true)
  }
}

object AXI4RAM
{
  def apply(
    address: AddressSet,
    executable: Boolean = true,
    beatBytes: Int = 4,
    devName: Option[String] = None,
    errors: Seq[AddressSet] = Nil)
  (implicit p: Parameters) =
  {
    val axi4ram = LazyModule(new AXI4RAM(address, executable, beatBytes, devName, errors))
    axi4ram.node
  }
}
