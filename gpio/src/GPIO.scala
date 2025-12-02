package gpio

import chisel3._
import chisel3.util._
import chisel3.experimental.{IntParam, StringParam}
import common._
import common.storage._
import common.axi._

class AXIL_GPIO
    extends AXIL(
      ADDR_WIDTH = 9,
      DATA_WIDTH = 32
    ) {}

class AXIGPIO(
    GPIO_WIDTH: Int = 2,
    IP_INSTANCE_NAME: String = "axi_gpio_spi_mux"
) extends Module {

  val io = IO(new Bundle {
    val axi = Flipped(new AXIL_GPIO)
    val gpio = Output(UInt(GPIO_WIDTH.W))
  })

  def getTCL() = {
    val s1 =
      s"\ncreate_ip -name axi_gpio -vendor xilinx.com -library ip -version 2.0 -module_name ${IP_INSTANCE_NAME}\n"

    var s2 = s"set_property -dict [list "
    s2 += s"CONFIG.C_GPIO_WIDTH {${GPIO_WIDTH}} "
    s2 += s"CONFIG.C_ALL_OUTPUTS {1} " // 勾选 All Outputs
    s2 += s"CONFIG.C_IS_DUAL {0} " // 未勾选 Dual Channel
    s2 += s"CONFIG.C_ALL_INPUTS {0} " // 未勾选 All Inputs
    s2 += s"CONFIG.C_DOUT_DEFAULT {0x00000000} " // Default Output Value
    s2 += s"CONFIG.C_TRI_DEFAULT {0xFFFFFFFF} " // Default Tri State Value

    s2 += s"] [get_ips ${IP_INSTANCE_NAME}]\n"

    println(s1 + s2)
  }

  getTCL();

  io.axi.b.bits.user := 0.U
  io.axi.r.bits.user := 0.U

  val ip = Module(new AXIGPIOBlackBox(GPIO_WIDTH))

  ip.io.s_axi_aclk := clock
  ip.io.s_axi_aresetn := !reset.asBool

  ip.io.s_axi_awaddr := io.axi.aw.bits.addr
  ip.io.s_axi_awvalid := io.axi.aw.valid
  io.axi.aw.ready := ip.io.s_axi_awready

  ip.io.s_axi_wdata := io.axi.w.bits.data
  ip.io.s_axi_wstrb := io.axi.w.bits.strb
  ip.io.s_axi_wvalid := io.axi.w.valid
  io.axi.w.ready := ip.io.s_axi_wready

  io.axi.b.bits.resp := ip.io.s_axi_bresp
  io.axi.b.valid := ip.io.s_axi_bvalid
  ip.io.s_axi_bready := io.axi.b.ready
  io.axi.b.bits.id := 0.U

  ip.io.s_axi_araddr := io.axi.ar.bits.addr
  ip.io.s_axi_arvalid := io.axi.ar.valid
  io.axi.ar.ready := ip.io.s_axi_arready

  io.axi.r.bits.data := ip.io.s_axi_rdata
  io.axi.r.bits.resp := ip.io.s_axi_rresp
  io.axi.r.valid := ip.io.s_axi_rvalid
  ip.io.s_axi_rready := io.axi.r.ready
  io.axi.r.bits.id := 0.U
  io.axi.r.bits.last := 1.U

  io.gpio := ip.io.gpio_io_o
}
