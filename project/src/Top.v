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
    input  adc3_clk_clk_n,
    input  adc3_clk_clk_p,
    input  dac3_clk_clk_n,
    input  dac3_clk_clk_p,
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
  wire        pl_ps_irq;
  wire        clk_adc2;
  wire        clk_dac2;
  wire        clk104_aresetn;
  wire        ddr4_ui_clk;
  wire        ddr4_ui_aresetn;

  wire trigger_internal_sig;
  
  wire [31:0] S_AXIS_30_tdata;
  wire        S_AXIS_30_tready;
  wire        S_AXIS_30_tvalid;

  wire [31:0] M_AXIS_30_tdata;
  wire        M_AXIS_30_tvalid;
  wire        M_AXIS_30_tready;

  wire [127:0] trig_out_tdata;
  wire         trig_out_tvalid;
  wire         trig_out_tready;

  wire [63:0] split_a_tdata;
  wire        split_a_tvalid;
  wire        split_a_tready;

  wire [63:0] split_b_tdata;
  wire        split_b_tvalid;
  wire        split_b_tready;
  
  wire [31:0] M_AXI_DMA_araddr;
  wire [2:0]  M_AXI_DMA_arprot;
  wire        M_AXI_DMA_arready;
  wire        M_AXI_DMA_arvalid;
  wire [31:0] M_AXI_DMA_awaddr;
  wire [2:0]  M_AXI_DMA_awprot;
  wire        M_AXI_DMA_awready;
  wire        M_AXI_DMA_awvalid;
  wire        M_AXI_DMA_bready;
  wire [1:0]  M_AXI_DMA_bresp;
  wire        M_AXI_DMA_bvalid;
  wire [31:0] M_AXI_DMA_rdata;
  wire        M_AXI_DMA_rready;
  wire [1:0]  M_AXI_DMA_rresp;
  wire        M_AXI_DMA_rvalid;
  wire [31:0] M_AXI_DMA_wdata;
  wire        M_AXI_DMA_wready;
  wire [3:0] M_AXI_DMA_wstrb;
  wire        M_AXI_DMA_wvalid;
  
  wire [63:0] S_AXI_01_araddr;
  wire [1:0]  S_AXI_01_arburst;
  wire [3:0]  S_AXI_01_arcache;
  wire [7:0]  S_AXI_01_arlen;
  wire        S_AXI_01_arlock;
  wire [2:0]  S_AXI_01_arprot;
  wire [3:0]  S_AXI_01_arqos;
  wire        S_AXI_01_arready;
  wire [2:0]  S_AXI_01_arsize;
  wire        S_AXI_01_arvalid;
  wire [127:0] S_AXI_01_rdata;
  wire        S_AXI_01_rlast;
  wire        S_AXI_01_rready;
  wire [1:0]  S_AXI_01_rresp;
  wire        S_AXI_01_rvalid;
  wire [63:0] S_AXI_01_awaddr = 64'b0;
  wire [1:0]  S_AXI_01_awburst = 2'b0;
  wire [3:0]  S_AXI_01_awcache = 4'b0;
  wire [7:0]  S_AXI_01_awlen = 8'b0;
  wire        S_AXI_01_awlock = 1'b0;
  wire [2:0]  S_AXI_01_awprot = 3'b0;
  wire [3:0]  S_AXI_01_awqos = 4'b0;
  wire        S_AXI_01_awready;
  wire [2:0]  S_AXI_01_awsize = 3'b0;
  wire        S_AXI_01_awvalid = 1'b0;
  wire        S_AXI_01_bready = 1'b0;
  wire [1:0]  S_AXI_01_bresp;
  wire        S_AXI_01_bvalid;
  wire [31:0] S_AXI_01_wdata = 32'b0;
  wire        S_AXI_01_wlast = 1'b0;
  wire        S_AXI_01_wready;
  wire [3:0]  S_AXI_01_wstrb = 4'b0;
  wire        S_AXI_01_wvalid = 1'b0;  
  
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

  wire [127:0] dma_axis_tdata;
  wire [15:0]  dma_axis_tkeep;
  wire         dma_axis_tlast;
  wire         dma_axis_tvalid;
  wire         dma_axis_tready;

  wire [127:0] fifo_axis_tdata;
  wire [15:0]  fifo_axis_tkeep;
  wire         fifo_axis_tlast;
  wire         fifo_axis_tvalid;
  wire         fifo_axis_tready;

  AXIDMA axidma_i (
      .clock                (pl_clk),
      .reset                (!pl_aresetn),
      .io_m_axi_mm2s_aclk   (ddr4_ui_clk),

      .io_ctrl_aw_ready     (M_AXI_DMA_awready),
      .io_ctrl_aw_valid     (M_AXI_DMA_awvalid),
      .io_ctrl_aw_bits_addr (M_AXI_DMA_awaddr[9:0]),
      .io_ctrl_aw_bits_burst(2'b01),
      .io_ctrl_aw_bits_cache(4'b0),
      .io_ctrl_aw_bits_lock (1'b0),
      .io_ctrl_aw_bits_prot (M_AXI_DMA_awprot),
      .io_ctrl_aw_bits_qos  (4'b0),
      .io_ctrl_aw_bits_region(4'b0),
      .io_ctrl_aw_bits_size (3'b010),
      
      .io_ctrl_ar_ready     (M_AXI_DMA_arready),
      .io_ctrl_ar_valid     (M_AXI_DMA_arvalid),
      .io_ctrl_ar_bits_addr (M_AXI_DMA_araddr[9:0]),
      .io_ctrl_ar_bits_burst(2'b01),
      .io_ctrl_ar_bits_cache(4'b0),
      .io_ctrl_ar_bits_lock (1'b0),
      .io_ctrl_ar_bits_prot (M_AXI_DMA_arprot),
      .io_ctrl_ar_bits_qos  (4'b0),
      .io_ctrl_ar_bits_region(4'b0),
      .io_ctrl_ar_bits_size (3'b010),

      .io_ctrl_w_ready      (M_AXI_DMA_wready),
      .io_ctrl_w_valid      (M_AXI_DMA_wvalid),
      .io_ctrl_w_bits_data  (M_AXI_DMA_wdata),
      .io_ctrl_w_bits_last  (1'b1),
      .io_ctrl_w_bits_strb  (M_AXI_DMA_wstrb),

      .io_ctrl_r_valid      (M_AXI_DMA_rvalid),
      .io_ctrl_r_ready      (M_AXI_DMA_rready),
      .io_ctrl_r_bits_data  (M_AXI_DMA_rdata),
      .io_ctrl_r_bits_last  (),   
      .io_ctrl_r_bits_resp  (M_AXI_DMA_rresp),

      .io_ctrl_b_valid      (M_AXI_DMA_bvalid),
      .io_ctrl_b_ready      (M_AXI_DMA_bready),
      .io_ctrl_b_bits_resp  (M_AXI_DMA_bresp),

      .io_mem_rd_ar_ready     (S_AXI_01_arready),
      .io_mem_rd_ar_valid     (S_AXI_01_arvalid),
      .io_mem_rd_ar_bits_addr (S_AXI_01_araddr),
      .io_mem_rd_ar_bits_len  (S_AXI_01_arlen),
      .io_mem_rd_ar_bits_size (S_AXI_01_arsize),
      .io_mem_rd_ar_bits_burst(S_AXI_01_arburst),
      .io_mem_rd_ar_bits_lock (S_AXI_01_arlock),
      .io_mem_rd_ar_bits_cache(S_AXI_01_arcache),
      .io_mem_rd_ar_bits_prot (S_AXI_01_arprot),

      .io_mem_rd_r_ready      (S_AXI_01_rready),
      .io_mem_rd_r_valid      (S_AXI_01_rvalid),
      .io_mem_rd_r_bits_data  (S_AXI_01_rdata),
      .io_mem_rd_r_bits_resp  (S_AXI_01_rresp),
      .io_mem_rd_r_bits_last  (S_AXI_01_rlast),

      .io_stream_ready        (dma_axis_tready),
      .io_stream_valid        (dma_axis_tvalid),
      .io_stream_bits_data    (dma_axis_tdata),
      .io_stream_bits_keep    (dma_axis_tkeep),
      .io_stream_bits_last    (dma_axis_tlast),

      .io_irq                 (pl_ps_irq)
  );

  AXISDataFIFO axis_fifo_i (
      .clock                (ddr4_ui_clk),
      .reset                (!ddr4_ui_aresetn),
      
      .io_s_aclk            (ddr4_ui_clk),
      .io_m_aclk            (clk_dac2),
      .io_resetn            (ddr4_ui_aresetn),

      .io_s_axis_ready      (dma_axis_tready),
      .io_s_axis_valid      (dma_axis_tvalid),
      .io_s_axis_bits_tdata (dma_axis_tdata),
      .io_s_axis_bits_tkeep (dma_axis_tkeep),
      .io_s_axis_bits_tlast (dma_axis_tlast),

      .io_m_axis_ready      (fifo_axis_tready),
      .io_m_axis_valid      (fifo_axis_tvalid),
      .io_m_axis_bits_tdata (fifo_axis_tdata),
      .io_m_axis_bits_tkeep (fifo_axis_tkeep),
      .io_m_axis_bits_tlast (fifo_axis_tlast)
  );

  axis_axis_trigger_start #(
      .DATA_WIDTH(128)
  ) trigger_inst (
      .aclk(clk_dac2),
      .aresetn(clk104_aresetn),

      .s_data_tdata (fifo_axis_tdata),
      .s_data_tvalid(fifo_axis_tvalid),
      .s_data_tready(fifo_axis_tready),
      .s_data_tlast (fifo_axis_tlast),

      .m_data_tdata (trig_out_tdata),
      .m_data_tvalid(trig_out_tvalid),
      .m_data_tready(trig_out_tready),

      .trigger_in(trigger_in) 
  );

  axis_splitter_128to64x2 splitter_inst (
      .aclk(clk_dac2),
      .aresetn(clk104_aresetn),

      .s_axis_tdata (trig_out_tdata),
      .s_axis_tvalid(trig_out_tvalid),
      .s_axis_tready(trig_out_tready),
      .s_axis_tlast (fifo_axis_tlast),

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
      .pl_ps_irq(pl_ps_irq), 
      .clk_adc2(clk_adc2),
      .clk_dac2(clk_dac2),
      .clk104_aresetn(clk104_aresetn),
      .ddr4_ui_clk(ddr4_ui_clk),
      .ddr4_ui_aresetn(ddr4_ui_aresetn),

      .adc2_clk_clk_n(adc2_clk_clk_n),
      .adc2_clk_clk_p(adc2_clk_clk_p),
      .dac2_clk_clk_n(dac2_clk_clk_n),
      .dac2_clk_clk_p(dac2_clk_clk_p),      
      .adc3_clk_clk_n(adc3_clk_clk_n),
      .adc3_clk_clk_p(adc3_clk_clk_p),
      .dac3_clk_clk_n(dac3_clk_clk_n),
      .dac3_clk_clk_p(dac3_clk_clk_p),
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
      
      .M_AXI_DMA_araddr (M_AXI_DMA_araddr),
      .M_AXI_DMA_arprot (M_AXI_DMA_arprot),
      .M_AXI_DMA_arready(M_AXI_DMA_arready),
      .M_AXI_DMA_arvalid(M_AXI_DMA_arvalid),
      .M_AXI_DMA_awaddr (M_AXI_DMA_awaddr),
      .M_AXI_DMA_awprot (M_AXI_DMA_awprot),
      .M_AXI_DMA_awready(M_AXI_DMA_awready),
      .M_AXI_DMA_awvalid(M_AXI_DMA_awvalid),
      .M_AXI_DMA_bready (M_AXI_DMA_bready),
      .M_AXI_DMA_bresp  (M_AXI_DMA_bresp),
      .M_AXI_DMA_bvalid (M_AXI_DMA_bvalid),
      .M_AXI_DMA_rdata  (M_AXI_DMA_rdata),
      .M_AXI_DMA_rready (M_AXI_DMA_rready),
      .M_AXI_DMA_rresp  (M_AXI_DMA_rresp),
      .M_AXI_DMA_rvalid (M_AXI_DMA_rvalid),
      .M_AXI_DMA_wdata  (M_AXI_DMA_wdata),
      .M_AXI_DMA_wready (M_AXI_DMA_wready),
      .M_AXI_DMA_wstrb  (M_AXI_DMA_wstrb),
      .M_AXI_DMA_wvalid (M_AXI_DMA_wvalid),

      .S_AXI_01_araddr  (S_AXI_01_araddr),
      .S_AXI_01_arburst (S_AXI_01_arburst),
      .S_AXI_01_arcache (S_AXI_01_arcache),
      .S_AXI_01_arlen   (S_AXI_01_arlen),
      .S_AXI_01_arlock  (S_AXI_01_arlock),
      .S_AXI_01_arprot  (S_AXI_01_arprot),
      .S_AXI_01_arqos   (S_AXI_01_arqos),
      .S_AXI_01_arready (S_AXI_01_arready),
      .S_AXI_01_arsize  (S_AXI_01_arsize),
      .S_AXI_01_arvalid (S_AXI_01_arvalid),
      .S_AXI_01_rdata   (S_AXI_01_rdata),
      .S_AXI_01_rlast   (S_AXI_01_rlast),
      .S_AXI_01_rready  (S_AXI_01_rready),
      .S_AXI_01_rresp   (S_AXI_01_rresp),
      .S_AXI_01_rvalid  (S_AXI_01_rvalid),
      
      .S_AXI_01_awaddr  (S_AXI_01_awaddr),
      .S_AXI_01_awburst (S_AXI_01_awburst),
      .S_AXI_01_awcache (S_AXI_01_awcache),
      .S_AXI_01_awlen   (S_AXI_01_awlen),
      .S_AXI_01_awlock  (S_AXI_01_awlock),
      .S_AXI_01_awprot  (S_AXI_01_awprot),
      .S_AXI_01_awqos   (S_AXI_01_awqos),
      .S_AXI_01_awready (S_AXI_01_awready),
      .S_AXI_01_awsize  (S_AXI_01_awsize),
      .S_AXI_01_awvalid (S_AXI_01_awvalid),
      .S_AXI_01_bready  (S_AXI_01_bready),
      .S_AXI_01_bresp   (S_AXI_01_bresp),
      .S_AXI_01_bvalid  (S_AXI_01_bvalid),
      .S_AXI_01_wdata   (S_AXI_01_wdata),
      .S_AXI_01_wlast   (S_AXI_01_wlast),
      .S_AXI_01_wready  (S_AXI_01_wready),
      .S_AXI_01_wstrb   (S_AXI_01_wstrb),
      .S_AXI_01_wvalid  (S_AXI_01_wvalid),

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
      dma_valid_d <= fifo_axis_tvalid;
  end

  assign trigger_internal_sig = fifo_axis_tvalid & (~dma_valid_d);
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
