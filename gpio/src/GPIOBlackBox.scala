package gpio

import chisel3._
import chisel3.util._
import chisel3.experimental.{IntParam, StringParam}
import common._
import common.axi._

class AXIGPIOBlackBox(
    GPIO_WIDTH: Int = 2
) extends BlackBox(
      Map(
        "C_GPIO_WIDTH" -> IntParam(GPIO_WIDTH),
        "C_ALL_OUTPUTS" -> IntParam(1),
        "C_IS_DUAL" -> IntParam(0),
        "C_ALL_INPUTS" -> IntParam(0)
      )
    ) {
  val io = IO(new Bundle {
    val s_axi_aclk = Input(Clock())
    val s_axi_aresetn = Input(Bool())
    val s_axi_awaddr = Input(UInt(9.W))
    val s_axi_awvalid = Input(Bool())
    val s_axi_awready = Output(Bool())
    val s_axi_wdata = Input(UInt(32.W))
    val s_axi_wstrb = Input(UInt(4.W))
    val s_axi_wvalid = Input(Bool())
    val s_axi_wready = Output(Bool())
    val s_axi_bresp = Output(UInt(2.W))
    val s_axi_bvalid = Output(Bool())
    val s_axi_bready = Input(Bool())
    val s_axi_araddr = Input(UInt(9.W))
    val s_axi_arvalid = Input(Bool())
    val s_axi_arready = Output(Bool())
    val s_axi_rdata = Output(UInt(32.W))
    val s_axi_rresp = Output(UInt(2.W))
    val s_axi_rvalid = Output(Bool())
    val s_axi_rready = Input(Bool())

    val gpio_io_o = Output(UInt(GPIO_WIDTH.W))
  })
}
