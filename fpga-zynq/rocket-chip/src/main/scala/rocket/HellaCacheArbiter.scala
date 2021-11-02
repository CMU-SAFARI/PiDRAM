// See LICENSE.Berkeley for license details.
// See LICENSE.SiFive for license details.

package freechips.rocketchip.rocket

import Chisel._
import freechips.rocketchip.config.Parameters

class HellaCacheArbiter(n: Int)(implicit p: Parameters) extends Module
{
  val io = new Bundle {
    val requestor = Vec(n, new HellaCacheIO).flip
    val mem = new HellaCacheIO
  }

  if (n == 1) {
    io.mem <> io.requestor.head
  } else {
    val s1_id = Reg(UInt())
    val s2_id = Reg(next=s1_id)

    io.mem.invalidate_lr := io.requestor.map(_.invalidate_lr).reduce(_||_)
    io.mem.req.valid := io.requestor.map(_.req.valid).reduce(_||_)
    io.requestor(0).req.ready := io.mem.req.ready
    for (i <- 1 until n)
      io.requestor(i).req.ready := io.requestor(i-1).req.ready && !io.requestor(i-1).req.valid

    for (i <- n-1 to 0 by -1) {
      val req = io.requestor(i).req
      def connect_s0() = {
        io.mem.req.bits.cmd := req.bits.cmd
        io.mem.req.bits.typ := req.bits.typ
        io.mem.req.bits.addr := req.bits.addr
        io.mem.req.bits.phys := req.bits.phys
        io.mem.req.bits.tag := Cat(req.bits.tag, UInt(i, log2Up(n)))
        s1_id := UInt(i)
      }
      def connect_s1() = {
        io.mem.s1_kill := io.requestor(i).s1_kill
        io.mem.s1_data := io.requestor(i).s1_data
      }

      if (i == n-1) {
        connect_s0()
        connect_s1()
      } else {
        when (req.valid) { connect_s0() }
        when (s1_id === UInt(i)) { connect_s1() }
      }
    }

    for (i <- 0 until n) {
      val resp = io.requestor(i).resp
      val tag_hit = io.mem.resp.bits.tag(log2Up(n)-1,0) === UInt(i)
      resp.valid := io.mem.resp.valid && tag_hit
      io.requestor(i).s2_xcpt := io.mem.s2_xcpt
      io.requestor(i).ordered := io.mem.ordered
      io.requestor(i).perf := io.mem.perf
      io.requestor(i).s2_nack := io.mem.s2_nack && s2_id === UInt(i)
      resp.bits := io.mem.resp.bits
      resp.bits.tag := io.mem.resp.bits.tag >> log2Up(n)

      io.requestor(i).replay_next := io.mem.replay_next
    }
  }
}
