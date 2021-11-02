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

object IMOControllerConsts
{
  def size = 0x10000
}

class IMOControllerIO
{
  val imo_out_valid = Bool(OUTPUT)
  val imo_out_inst  = UInt(OUTPUT, 128.W)
  val imo_out_ack   = Bool(INPUT)

  val imo_in_data   = UInt(INPUT, 512.W)
  val imo_in_valid  = Bool(INPUT)
}

case class IMOControllerParams(baseAddress: BigInt = 0x04000000, intStages: Int = 0)
{
  def address = AddressSet(baseAddress, IMOControllerConsts.size-1)
}

case object IMOControllerKey extends Field(IMOControllerParams())

class IMOController(params: IMOControllerParams, beatBytes: Int)(implicit p: Parameters) extends LazyModule
{
  import IMOControllerConsts._

  val device = new SimpleDevice("IMOController", Seq("riscv,imoController0")) {
    override val alwaysExtended = true
  }

  val node = TLRegisterNode(
    address   = Seq(params.address),
    device    = device,
    beatBytes = beatBytes)

  lazy val module = new LazyModuleImp(this) {

    val io = IO(new Bundle {
      val imo_out_valid = Bool(OUTPUT)
      val imo_out_inst  = UInt(OUTPUT, 128.W)
      val imo_out_ack   = Bool(INPUT)

      val imo_in_data   = UInt(INPUT, 512.W)
      val imo_in_valid  = Bool(INPUT)
    })

    val inst_lower  = RegInit(UInt(0, 64.W))
    val inst_upper  = RegInit(UInt(0, 64.W))    
    val exec_flags  = RegInit(UInt(0, 64.W))
    val data_dw0    = RegInit(UInt(0, 64.W))
    val data_dw1    = RegInit(UInt(0, 64.W))
    val data_dw2    = RegInit(UInt(0, 64.W))
    val data_dw3    = RegInit(UInt(0, 64.W))
    val data_dw4    = RegInit(UInt(0, 64.W))
    val data_dw5    = RegInit(UInt(0, 64.W))
    val data_dw6    = RegInit(UInt(0, 64.W))
    val data_dw7    = RegInit(UInt(0, 64.W))

    val s_idle :: s_req :: Nil = Enum(2)
    val state = RegInit(s_idle)

    io.imo_out_valid := state === s_req
    io.imo_out_inst  := Cat(inst_upper, inst_lower)

    when(state === s_idle){
      when(~io.imo_out_ack)
      {
        when(exec_flags === 1.U){
          state       := s_req
          exec_flags  := 0.U
        }
      }
    }.elsewhen(state === s_req){
      when(io.imo_out_ack){
        state       := s_idle
        exec_flags  := 2.U
      }
    }
    
    when(io.imo_in_valid)
    {
      data_dw0 := io.imo_in_data(63,0)
      data_dw1 := io.imo_in_data(127,64)
      data_dw2 := io.imo_in_data(191,128)
      data_dw3 := io.imo_in_data(255,192)
      data_dw4 := io.imo_in_data(319,256)
      data_dw5 := io.imo_in_data(383,320)
      data_dw6 := io.imo_in_data(447,384)
      data_dw7 := io.imo_in_data(511,448)
    }

    node.regmap(
      0x00 -> Seq(RegField(64, inst_upper)),
      0x08 -> Seq(RegField(64, inst_lower)),
      0x10 -> Seq(RegField(64, exec_flags)),
      0x18 -> Seq(RegField(64, data_dw0)),
      0x20 -> Seq(RegField(64, data_dw1)),
      0x28 -> Seq(RegField(64, data_dw2)),
      0x30 -> Seq(RegField(64, data_dw3)),
      0x38 -> Seq(RegField(64, data_dw4)),
      0x40 -> Seq(RegField(64, data_dw5)),
      0x48 -> Seq(RegField(64, data_dw6)),
      0x50 -> Seq(RegField(64, data_dw7))
    )
  }
}

/** Trait that will connect a IMOController to a subsystem */
trait HasPeripheryIMOController { this: BaseSubsystem =>
  val imoController = LazyModule(new IMOController(p(IMOControllerKey), pbus.beatBytes))
  pbus.toVariableWidthSlave(Some("imoh")) { imoController.node }
}
