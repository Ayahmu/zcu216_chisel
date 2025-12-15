package project_foo

import chisel3._
import chisel3.util._
import chisel3.stage.{ChiselGeneratorAnnotation, ChiselStage}
import firrtl.options.TargetDirAnnotation
import gpio._
import led._
import memory._

object elaborate extends App {
  println("Generating a %s class".format(args(0)))
  val stage = new chisel3.stage.ChiselStage
  val arr = Array("-X", "sverilog", "--full-stacktrace")
  val dir = TargetDirAnnotation("Verilog")

  args(0) match {
    case "Foo" =>
      stage.execute(arr, Seq(ChiselGeneratorAnnotation(() => new Foo()), dir))
    case "AXIGPIO" =>
      stage.execute(
        arr,
        Seq(ChiselGeneratorAnnotation(() => new AXIGPIO()), dir)
      )
    case "LED" =>
      stage.execute(
        arr,
        Seq(ChiselGeneratorAnnotation(() => new LED()), dir)
      )
    case "BRAM" =>
      stage.execute(
        arr,
        Seq(ChiselGeneratorAnnotation(() => new AXIBRAM()), dir)
      )
    case _ => println("Module match failed!")
  }
}
