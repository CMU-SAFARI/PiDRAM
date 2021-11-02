// See LICENSE.SiFive for license details.

package freechips.rocketchip.util

import Chisel._
import freechips.rocketchip.config._

case object IncludePSDTest extends Field[Boolean](false)

class PSDTestMode extends Bundle {
  val test_mode       = Bool()
  val test_mode_reset = Bool()
  // TODO: Clocks?
}

trait CanHavePSDTestModeIO {
  implicit val p: Parameters
  val psd = p(IncludePSDTest).option(new PSDTestMode().asInput)
}
