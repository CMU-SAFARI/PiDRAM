// See LICENSE.SiFive for license details.

package freechips.rocketchip.subsystem

import Chisel._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util._

// TODO: applies to all caches, for now
case object CacheBlockBytes extends Field[Int](64)

/** L2 Broadcast Hub configuration */
case class BroadcastParams(
  nTrackers:  Int     = 4,
  bufferless: Boolean = false)

case object BroadcastKey extends Field(BroadcastParams())

/** L2 memory subsystem configuration */
case class BankedL2Params(
  nMemoryChannels:  Int = 1,
  nBanksPerChannel: Int = 1,
  coherenceManager: BaseSubsystem => (TLInwardNode, TLOutwardNode, () => Option[Bool]) = { subsystem =>
    implicit val p = subsystem.p
    val BroadcastParams(nTrackers, bufferless) = p(BroadcastKey)
    val bh = LazyModule(new TLBroadcast(subsystem.memBusBlockBytes, nTrackers, bufferless))
    val ww = LazyModule(new TLWidthWidget(subsystem.sbus.beatBytes))
    ww.node :*= bh.node
    (bh.node, ww.node, () => None)
  }) {
  val nBanks = nMemoryChannels*nBanksPerChannel
}

case object BankedL2Key extends Field(BankedL2Params())

/** Parameterization of the memory-side bus created for each memory channel */
case class MemoryBusParams(beatBytes: Int, blockBytes: Int) extends HasTLBusParams

case object MemoryBusKey extends Field[MemoryBusParams]

/** Wrapper for creating TL nodes from a bus connected to the back of each mem channel */
class MemoryBus(params: MemoryBusParams)(implicit p: Parameters) extends TLBusWrapper(params, "memory_bus")(p)
    with HasTLXbarPhy {

  def fromCoherenceManager
      (name: Option[String] = None, buffer: BufferParams = BufferParams.none)
      (gen: => TLNode): TLInwardNode = {
    from("coherence_manager" named name) {
      inwardNode := TLBuffer(buffer) := gen
    }
  }

  def toDRAMController[D,U,E,B <: Data]
      (name: Option[String] = None, buffer: BufferParams = BufferParams.none)
      (gen: => NodeHandle[ TLClientPortParameters,TLManagerPortParameters,TLEdgeIn,TLBundle, D,U,E,B] =
        TLIdentity.gen): OutwardNodeHandle[D,U,E,B] = {
    to("memory_controller" named name) { gen := bufferTo(buffer) }
  }

  def toVariableWidthSlave[D,U,E,B <: Data]
      (name: Option[String] = None, buffer: BufferParams = BufferParams.none)
      (gen: => NodeHandle[TLClientPortParameters,TLManagerPortParameters,TLEdgeIn,TLBundle,D,U,E,B] =
        TLIdentity.gen): OutwardNodeHandle[D,U,E,B] = {
    to("slave" named name) { gen :*= fragmentTo(buffer) }
  }

  def toFixedWidthSlave[D,U,E,B <: Data]
      (name: Option[String] = None, buffer: BufferParams = BufferParams.none)
      (gen: => NodeHandle[TLClientPortParameters,TLManagerPortParameters,TLEdgeIn,TLBundle,D,U,E,B] =
        TLIdentity.gen): OutwardNodeHandle[D,U,E,B] = {
    to("slave" named name) { gen :*= fixedWidthTo(buffer) }
  }

}
