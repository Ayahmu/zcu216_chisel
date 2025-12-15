`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2025 12:14:23 PM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top (
    output [0:0] LED0,
    output [0:0] LED1,
    output [1:0] clk104_clk_spi_mux_sel_tri_o,
    
    output [0:0] trigger_out_sma,
    output [0:0] trigger_out_loop,
    input  [0:0] trigger_in,
    
    input  adc2_clk_clk_n,
    input  adc2_clk_clk_p,
    input  dac2_clk_clk_n,
    input  dac2_clk_clk_p,
    input  vin20_v_n,
    input  vin20_v_p,
    input  vin22_v_n,
    input  vin22_v_p,
    input  vin30_v_n,
    input  vin30_v_p,
    output vout20_v_n,
    output vout20_v_p,
    output vout22_v_n,
    output vout22_v_p,
    output vout30_v_n,
    output vout30_v_p,
    
    input           c0_sys_clk_n,
    input           c0_sys_clk_p,
    output          c0_ddr4_act_n,
    output [16:0]   c0_ddr4_adr,     
    output [1:0]    c0_ddr4_ba,      
    output [1:0]    c0_ddr4_bg,      
    output [0:0]    c0_ddr4_ck_c,    
    output [0:0]    c0_ddr4_ck_t,
    output [0:0]    c0_ddr4_cke,     
    output [1:0]    c0_ddr4_cs_n,    
    inout  [3:0]    c0_ddr4_dm_n,    
    inout  [31:0]   c0_ddr4_dq,      
    inout  [3:0]    c0_ddr4_dqs_c,   
    inout  [3:0]    c0_ddr4_dqs_t,
    output [0:0]    c0_ddr4_odt,     
    output          c0_ddr4_reset_n  
    
);

  wire        pl_clk;
  wire        pl_aresetn;
  wire        clk_adc2;
  wire        clk_dac2;
  wire        clk104_aresetn;
  
  wire trigger_internal_sig;
  
  wire [31:0] S_AXIS_30_tdata;
  wire        S_AXIS_30_tready;
  wire        S_AXIS_30_tvalid;

  wire [31:0] M_AXIS_RF_tdata;
  wire        M_AXIS_RF_tvalid;
  wire        M_AXIS_RF_tready;
  wire        M_AXIS_RF_tlast;
  wire [3:0]  M_AXIS_RF_tkeep;

  wire [31:0] M_AXIS_30_tdata;
  wire        M_AXIS_30_tvalid;
  wire        M_AXIS_30_tready;

  wire [31:0] trig_out_tdata;
  wire        trig_out_tvalid;
  wire        trig_out_tready;

  wire [15:0] split_a_tdata;
  wire        split_a_tvalid;
  wire        split_a_tready;

  wire [15:0] split_b_tdata;
  wire        split_b_tvalid;
  wire        split_b_tready;
    
  wire [31:0] M_AXI_GPIO_araddr;
  wire [ 1:0] M_AXI_GPIO_arburst;
  wire [ 3:0] M_AXI_GPIO_arcache;
  wire [ 7:0] M_AXI_GPIO_arlen;
  wire [ 0:0] M_AXI_GPIO_arlock;
  wire [ 2:0] M_AXI_GPIO_arprot;
  wire [ 3:0] M_AXI_GPIO_arqos;
  wire        M_AXI_GPIO_arready;
  wire [ 2:0] M_AXI_GPIO_arsize;
  wire [15:0] M_AXI_GPIO_aruser;
  wire        M_AXI_GPIO_arvalid;
  wire [31:0] M_AXI_GPIO_awaddr;
  wire [ 1:0] M_AXI_GPIO_awburst;
  wire [ 3:0] M_AXI_GPIO_awcache;
  wire [ 7:0] M_AXI_GPIO_awlen;
  wire [ 0:0] M_AXI_GPIO_awlock;
  wire [ 2:0] M_AXI_GPIO_awprot;
  wire [ 3:0] M_AXI_GPIO_awqos;
  wire        M_AXI_GPIO_awready;
  wire [ 2:0] M_AXI_GPIO_awsize;
  wire [15:0] M_AXI_GPIO_awuser;
  wire        M_AXI_GPIO_awvalid;
  wire        M_AXI_GPIO_bready;
  wire [ 1:0] M_AXI_GPIO_bresp;
  wire        M_AXI_GPIO_bvalid;
  wire [31:0] M_AXI_GPIO_rdata;
  wire        M_AXI_GPIO_rlast;
  wire        M_AXI_GPIO_rready;
  wire [ 1:0] M_AXI_GPIO_rresp;
  wire        M_AXI_GPIO_rvalid;
  wire [31:0] M_AXI_GPIO_wdata;
  wire        M_AXI_GPIO_wlast;
  wire        M_AXI_GPIO_wready;
  wire [ 3:0] M_AXI_GPIO_wstrb;
  wire        M_AXI_GPIO_wvalid;

  axis_axis_trigger_start #(
      .DATA_WIDTH(32)
  ) trigger_inst (
      .aclk(clk_dac2),
      .aresetn(clk104_aresetn),

      .s_data_tdata (M_AXIS_RF_tdata),
      .s_data_tvalid(M_AXIS_RF_tvalid),
      .s_data_tready(M_AXIS_RF_tready),
      .s_data_tlast (M_AXIS_RF_tlast),

      .m_data_tdata (trig_out_tdata),
      .m_data_tvalid(trig_out_tvalid),
      .m_data_tready(trig_out_tready),

      .trigger_in(trigger_in) 
  );

  axis_splitter_32to16x2 splitter_inst (
      .aclk(clk_dac2),
      .aresetn(clk104_aresetn),

      .s_axis_tdata (trig_out_tdata),
      .s_axis_tvalid(trig_out_tvalid),
      .s_axis_tready(trig_out_tready),
      .s_axis_tlast (M_AXIS_RF_tlast),

      .m_axis_a_tdata (split_a_tdata),
      .m_axis_a_tvalid(split_a_tvalid),
      .m_axis_a_tready(split_a_tready),
      .m_axis_a_tlast (),

      .m_axis_b_tdata (split_b_tdata),
      .m_axis_b_tvalid(split_b_tvalid),
      .m_axis_b_tready(split_b_tready),
      .m_axis_b_tlast ()
  );

  design_1 design_1_i (
      .pl_clk(pl_clk),
      .pl_aresetn(pl_aresetn),
      .clk_adc2(clk_adc2),
      .clk_dac2(clk_dac2),
      .clk104_aresetn(clk104_aresetn),

      .adc2_clk_clk_n(adc2_clk_clk_n),
      .adc2_clk_clk_p(adc2_clk_clk_p),
      .dac2_clk_clk_n(dac2_clk_clk_n),
      .dac2_clk_clk_p(dac2_clk_clk_p),
      .vin20_v_n(vin20_v_n),
      .vin20_v_p(vin20_v_p),
      .vin22_v_n(vin22_v_n),
      .vin22_v_p(vin22_v_p),
      .vin30_v_n(vin30_v_n),
      .vin30_v_p(vin30_v_p),
      .vout20_v_n(vout20_v_n),
      .vout20_v_p(vout20_v_p),
      .vout22_v_n(vout22_v_n),
      .vout22_v_p(vout22_v_p),
      .vout30_v_n(vout30_v_n),
      .vout30_v_p(vout30_v_p),

      .c0_sys_clk_n(c0_sys_clk_n),
      .c0_sys_clk_p(c0_sys_clk_p),
      .c0_ddr4_act_n (c0_ddr4_act_n),
      .c0_ddr4_adr   (c0_ddr4_adr),
      .c0_ddr4_ba    (c0_ddr4_ba),
      .c0_ddr4_bg    (c0_ddr4_bg),
      .c0_ddr4_ck_c  (c0_ddr4_ck_c),
      .c0_ddr4_ck_t  (c0_ddr4_ck_t),
      .c0_ddr4_cke   (c0_ddr4_cke),
      .c0_ddr4_cs_n  (c0_ddr4_cs_n),
      .c0_ddr4_dm_n  (c0_ddr4_dm_n),
      .c0_ddr4_dq    (c0_ddr4_dq),
      .c0_ddr4_dqs_c (c0_ddr4_dqs_c),
      .c0_ddr4_dqs_t (c0_ddr4_dqs_t),
      .c0_ddr4_odt   (c0_ddr4_odt),
      .c0_ddr4_reset_n (c0_ddr4_reset_n),
      
      .M_AXIS_RF_tdata (M_AXIS_RF_tdata),
      .M_AXIS_RF_tvalid(M_AXIS_RF_tvalid),
      .M_AXIS_RF_tready(M_AXIS_RF_tready),
      .M_AXIS_RF_tlast (M_AXIS_RF_tlast),
      .M_AXIS_RF_tkeep (M_AXIS_RF_tkeep),

      .S_AXIS_20_tdata (split_a_tdata),
      .S_AXIS_20_tvalid(split_a_tvalid),
      .S_AXIS_20_tready(split_a_tready),

      .S_AXIS_22_tdata (split_b_tdata),
      .S_AXIS_22_tvalid(split_b_tvalid),
      .S_AXIS_22_tready(split_b_tready),

      .S_AXIS_30_tdata(S_AXIS_30_tdata),  
      .S_AXIS_30_tready(S_AXIS_30_tready), 
      .S_AXIS_30_tvalid(S_AXIS_30_tvalid),

      .M_AXIS_30_tdata (M_AXIS_30_tdata),
      .M_AXIS_30_tvalid(M_AXIS_30_tvalid),
      .M_AXIS_30_tready(M_AXIS_30_tready),

      .M_AXI_GPIO_araddr (M_AXI_GPIO_araddr),
      .M_AXI_GPIO_arburst(M_AXI_GPIO_arburst),
      .M_AXI_GPIO_arcache(M_AXI_GPIO_arcache),
      .M_AXI_GPIO_arlen  (M_AXI_GPIO_arlen),
      .M_AXI_GPIO_arlock (M_AXI_GPIO_arlock),
      .M_AXI_GPIO_arprot (M_AXI_GPIO_arprot),
      .M_AXI_GPIO_arqos  (M_AXI_GPIO_arqos),
      .M_AXI_GPIO_arready(M_AXI_GPIO_arready),
      .M_AXI_GPIO_arsize (M_AXI_GPIO_arsize),
      .M_AXI_GPIO_aruser (M_AXI_GPIO_aruser),
      .M_AXI_GPIO_arvalid(M_AXI_GPIO_arvalid),
      .M_AXI_GPIO_awaddr (M_AXI_GPIO_awaddr),
      .M_AXI_GPIO_awburst(M_AXI_GPIO_awburst),
      .M_AXI_GPIO_awcache(M_AXI_GPIO_awcache),
      .M_AXI_GPIO_awlen  (M_AXI_GPIO_awlen),
      .M_AXI_GPIO_awlock (M_AXI_GPIO_awlock),
      .M_AXI_GPIO_awprot (M_AXI_GPIO_awprot),
      .M_AXI_GPIO_awqos  (M_AXI_GPIO_awqos),
      .M_AXI_GPIO_awready(M_AXI_GPIO_awready),
      .M_AXI_GPIO_awsize (M_AXI_GPIO_awsize),
      .M_AXI_GPIO_awuser (M_AXI_GPIO_awuser),
      .M_AXI_GPIO_awvalid(M_AXI_GPIO_awvalid),
      .M_AXI_GPIO_bready (M_AXI_GPIO_bready),
      .M_AXI_GPIO_bresp  (M_AXI_GPIO_bresp),
      .M_AXI_GPIO_bvalid (M_AXI_GPIO_bvalid),
      .M_AXI_GPIO_rdata  (M_AXI_GPIO_rdata),
      .M_AXI_GPIO_rlast  (M_AXI_GPIO_rlast),
      .M_AXI_GPIO_rready (M_AXI_GPIO_rready),
      .M_AXI_GPIO_rresp  (M_AXI_GPIO_rresp),
      .M_AXI_GPIO_rvalid (M_AXI_GPIO_rvalid),
      .M_AXI_GPIO_wdata  (M_AXI_GPIO_wdata),
      .M_AXI_GPIO_wlast  (M_AXI_GPIO_wlast),
      .M_AXI_GPIO_wready (M_AXI_GPIO_wready),
      .M_AXI_GPIO_wstrb  (M_AXI_GPIO_wstrb),
      .M_AXI_GPIO_wvalid (M_AXI_GPIO_wvalid)
  );

  AXIGPIO axigpio_i (
      .clock(pl_clk),
      .reset(~pl_aresetn),
      // AW
      .io_axi_aw_ready(M_AXI_GPIO_awready),
      .io_axi_aw_valid(M_AXI_GPIO_awvalid),
      .io_axi_aw_bits_addr(M_AXI_GPIO_awaddr[8:0]),
      .io_axi_aw_bits_burst(M_AXI_GPIO_awburst),
      .io_axi_aw_bits_cache(M_AXI_GPIO_awcache),
      .io_axi_aw_bits_lock(M_AXI_GPIO_awlock),
      .io_axi_aw_bits_prot(M_AXI_GPIO_awprot),
      .io_axi_aw_bits_qos(M_AXI_GPIO_awqos),
      .io_axi_aw_bits_region(4'b0000),
      .io_axi_aw_bits_size(M_AXI_GPIO_awsize),
      // AR
      .io_axi_ar_ready(M_AXI_GPIO_arready),
      .io_axi_ar_valid(M_AXI_GPIO_arvalid),
      .io_axi_ar_bits_addr(M_AXI_GPIO_araddr[8:0]),
      .io_axi_ar_bits_burst(M_AXI_GPIO_arburst),
      .io_axi_ar_bits_cache(M_AXI_GPIO_arcache),
      .io_axi_ar_bits_lock(M_AXI_GPIO_arlock),
      .io_axi_ar_bits_prot(M_AXI_GPIO_arprot),
      .io_axi_ar_bits_qos(M_AXI_GPIO_arqos),
      .io_axi_ar_bits_region(4'b0000),
      .io_axi_ar_bits_size(M_AXI_GPIO_arsize),
      // W
      .io_axi_w_ready(M_AXI_GPIO_wready),
      .io_axi_w_valid(M_AXI_GPIO_wvalid),
      .io_axi_w_bits_data(M_AXI_GPIO_wdata),
      .io_axi_w_bits_last(M_AXI_GPIO_wlast),
      .io_axi_w_bits_strb(M_AXI_GPIO_wstrb),
      // R
      .io_axi_r_ready(M_AXI_GPIO_rready),
      .io_axi_r_valid(M_AXI_GPIO_rvalid),
      .io_axi_r_bits_data(M_AXI_GPIO_rdata),
      .io_axi_r_bits_last(M_AXI_GPIO_rlast),
      .io_axi_r_bits_resp(M_AXI_GPIO_rresp),
      // B
      .io_axi_b_ready(M_AXI_GPIO_bready),
      .io_axi_b_valid(M_AXI_GPIO_bvalid),
      .io_axi_b_bits_resp(M_AXI_GPIO_bresp),
      // GPIO Pin
      .io_gpio(clk104_clk_spi_mux_sel_tri_o)
  );

  LED led_i (
      .io_CLK (clk_adc2),
      .io_CLK1(clk_dac2),
      .io_LED0(LED0),
      .io_LED1(LED1)
  );

  reg dma_valid_d;
 
  always @(posedge clk_dac2) begin
      dma_valid_d <= M_AXIS_RF_tvalid;
  end

  assign trigger_internal_sig = M_AXIS_RF_tvalid & (~dma_valid_d);

//  AXIS_PULSE_GEN axis_pulse_gen_i (
//       .aclk(clk_dac2),          
//       .aresetn(clk104_aresetn),
//       .trigger_out(trigger_internal_sig)
//   ); 

  assign trigger_out_sma  = trigger_internal_sig;
  assign trigger_out_loop = trigger_internal_sig;

  ila_trig ila_inst (
      .clk(clk_dac2), 
      .probe0 (trigger_internal_sig),
      .probe1 (trigger_in),
      .probe2 (split_a_tdata), 
      .probe3 (split_a_tvalid),
      .probe4 (split_a_tready),

      .probe5 (split_b_tdata), 
      .probe6 (split_b_tvalid),
      .probe7 (split_b_tready) 
  );
endmodule
