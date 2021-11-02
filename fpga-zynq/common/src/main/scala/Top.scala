package zynq

import chisel3._
import freechips.rocketchip.config.{Parameters, Field}
import freechips.rocketchip.devices.tilelink._
import freechips.rocketchip.diplomacy.{LazyModule, LazyModuleImp}
import freechips.rocketchip.subsystem._
import freechips.rocketchip.util.DontTouch
import testchipip._

case object ZynqAdapterBase extends Field[BigInt]

class Top(implicit val p: Parameters) extends Module {
  val address = p(ZynqAdapterBase)
  val config = p(ExtIn)
  val target = Module(LazyModule(new FPGAZynqTop).module)
  val adapter = Module(LazyModule(new ZynqAdapter(address, config)).module)

  require(target.mem_axi4.size == 1)

  val io = IO(new Bundle {
    val ps_axi_slave = Flipped(adapter.axi.cloneType)
    val mem_axi = target.mem_axi4.head.cloneType

    val imo_out_valid = Output(Bool())
    val imo_out_inst  = Output(UInt(128.W))
    val imo_out_ack   = Input(Bool())

    val imo_in_data   = Input(UInt(512.W))
    val imo_in_valid  = Input(Bool()) 
  })

  io.imo_out_valid := target.imoControllerIO.imo_out_valid
  io.imo_out_inst   := target.imoControllerIO.imo_out_inst
  target.imoControllerIO.imo_out_ack := io.imo_out_ack
  target.imoControllerIO.imo_in_data := io.imo_in_data
  target.imoControllerIO.imo_in_valid := io.imo_in_valid

  io.mem_axi <> target.mem_axi4.head
  adapter.axi <> io.ps_axi_slave
  adapter.io.serial <> target.serial
  adapter.io.bdev <> target.bdev

  target.debug := DontCare
  target.tieOffInterrupts()
  target.dontTouchPorts()
  target.reset := adapter.io.sys_reset
}

class FPGAZynqTop(implicit p: Parameters) extends RocketSubsystem
    with HasMasterAXI4MemPort
    with HasSystemErrorSlave
    with HasPeripheryBootROM
    with HasSyncExtInterrupts
    with HasNoDebug
    with HasPeripherySerial
    with HasPeripheryBlockDevice {
  override lazy val module = new FPGAZynqTopModule(this)
}

class FPGAZynqTopModule(outer: FPGAZynqTop) extends RocketSubsystemModuleImp(outer)
    with HasRTCModuleImp
    with HasMasterAXI4MemPortModuleImp
    with HasPeripheryBootROMModuleImp
    with HasExtInterruptsModuleImp
    with HasNoDebugModuleImp
    with HasPeripherySerialModuleImp
    with HasPeripheryBlockDeviceModuleImp
    with DontTouch
