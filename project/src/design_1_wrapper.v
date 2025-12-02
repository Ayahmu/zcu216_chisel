//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
//Date        : Thu Nov 28 11:46:51 2024
//Host        : DESKTOP-9VCC9A8 running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (LED0,
    LED1,
    adc2_clk_clk_n,
    adc2_clk_clk_p,
    clk104_clk_spi_mux_sel_tri_o,
    dac2_clk_clk_n,
    dac2_clk_clk_p,
    vin20_v_n,
    vin20_v_p,
    vin22_v_n,
    vin22_v_p,
    vin30_v_n,
    vin30_v_p,
    vout20_v_n,
    vout20_v_p,
    vout22_v_n,
    vout22_v_p,
    vout30_v_n,
    vout30_v_p
   );
  output [0:0]LED0;
  output [0:0]LED1;
  input adc2_clk_clk_n;
  input adc2_clk_clk_p;
  output [1:0]clk104_clk_spi_mux_sel_tri_o;
  input dac2_clk_clk_n;
  input dac2_clk_clk_p;
  input vin20_v_n;
  input vin20_v_p;
  input vin22_v_n;
  input vin22_v_p;
  input vin30_v_n;
  input vin30_v_p;
  output vout20_v_n;
  output vout20_v_p;
  output vout22_v_n;
  output vout22_v_p;  
  output vout30_v_n;
  output vout30_v_p;

  wire pl_clk;
  wire aresetn;
  wire [0:0]LED0;
  wire [0:0]LED1;
  wire adc2_clk_clk_n;
  wire adc2_clk_clk_p;
  wire [1:0]clk104_clk_spi_mux_sel_tri_o;
  wire dac2_clk_clk_n;
  wire dac2_clk_clk_p;
  wire sysref_in_diff_n;
  wire sysref_in_diff_p;
  wire vin20_v_n;
  wire vin20_v_p;
  wire vin22_v_n;
  wire vin22_v_p;  
  wire vin30_v_n;
  wire vin30_v_p;
  wire vout20_v_n;
  wire vout20_v_p;
  wire vout22_v_n;
  wire vout22_v_p;  
  wire vout30_v_n;
  wire vout30_v_p;

  wire [31:0]M_AXI_GPIO_araddr;
  wire [1:0]M_AXI_GPIO_arburst;
  wire [3:0]M_AXI_GPIO_arcache;
  wire [7:0]M_AXI_GPIO_arlen;  
  wire [0:0]M_AXI_GPIO_arlock; 
  wire [2:0]M_AXI_GPIO_arprot; 
  wire [3:0]M_AXI_GPIO_arqos;  
  wire M_AXI_GPIO_arready;     
  wire [2:0]M_AXI_GPIO_arsize; 
  wire [15:0]M_AXI_GPIO_aruser;
  wire M_AXI_GPIO_arvalid;     
  wire [31:0]M_AXI_GPIO_awaddr;
  wire [1:0]M_AXI_GPIO_awburst;
  wire [3:0]M_AXI_GPIO_awcache;
  wire [7:0]M_AXI_GPIO_awlen;  
  wire [0:0]M_AXI_GPIO_awlock; 
  wire [2:0]M_AXI_GPIO_awprot; 
  wire [3:0]M_AXI_GPIO_awqos;  
  wire M_AXI_GPIO_awready;     
  wire [2:0]M_AXI_GPIO_awsize; 
  wire [15:0]M_AXI_GPIO_awuser;
  wire M_AXI_GPIO_awvalid;     
  wire M_AXI_GPIO_bready;      
  wire [1:0]M_AXI_GPIO_bresp;  
  wire M_AXI_GPIO_bvalid;      
  wire [31:0]M_AXI_GPIO_rdata; 
  wire M_AXI_GPIO_rlast;       
  wire M_AXI_GPIO_rready;      
  wire [1:0]M_AXI_GPIO_rresp;  
  wire M_AXI_GPIO_rvalid;      
  wire [31:0]M_AXI_GPIO_wdata; 
  wire M_AXI_GPIO_wlast;       
  wire M_AXI_GPIO_wready;      
  wire [3:0]M_AXI_GPIO_wstrb;  
  wire M_AXI_GPIO_wvalid;      

  design_1 design_1_i
       (.pl_clk(pl_clk),
        .peripheral_aresetn(aresetn),
        .LED0(LED0),
        .LED1(LED1),
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
        
        .M_AXI_GPIO_araddr(M_AXI_GPIO_araddr), 
        .M_AXI_GPIO_arburst(M_AXI_GPIO_arburst),
        .M_AXI_GPIO_arcache(M_AXI_GPIO_arcache),
        .M_AXI_GPIO_arlen(M_AXI_GPIO_arlen),  
        .M_AXI_GPIO_arlock(M_AXI_GPIO_arlock), 
        .M_AXI_GPIO_arprot(M_AXI_GPIO_arprot), 
        .M_AXI_GPIO_arqos(M_AXI_GPIO_arqos),  
        .M_AXI_GPIO_arready(M_AXI_GPIO_arready),
        .M_AXI_GPIO_arsize(M_AXI_GPIO_arsize), 
        .M_AXI_GPIO_aruser(M_AXI_GPIO_aruser), 
        .M_AXI_GPIO_arvalid(M_AXI_GPIO_arvalid),
        .M_AXI_GPIO_awaddr(M_AXI_GPIO_awaddr), 
        .M_AXI_GPIO_awburst(M_AXI_GPIO_awburst),
        .M_AXI_GPIO_awcache(M_AXI_GPIO_awcache),
        .M_AXI_GPIO_awlen(M_AXI_GPIO_awlen),  
        .M_AXI_GPIO_awlock(M_AXI_GPIO_awlock), 
        .M_AXI_GPIO_awprot(M_AXI_GPIO_awprot), 
        .M_AXI_GPIO_awqos(M_AXI_GPIO_awqos),  
        .M_AXI_GPIO_awready(M_AXI_GPIO_awready),
        .M_AXI_GPIO_awsize(M_AXI_GPIO_awsize), 
        .M_AXI_GPIO_awuser(M_AXI_GPIO_awuser), 
        .M_AXI_GPIO_awvalid(M_AXI_GPIO_awvalid),
        .M_AXI_GPIO_bready(M_AXI_GPIO_bready), 
        .M_AXI_GPIO_bresp(M_AXI_GPIO_bresp),  
        .M_AXI_GPIO_bvalid(M_AXI_GPIO_bvalid), 
        .M_AXI_GPIO_rdata(M_AXI_GPIO_rdata),  
        .M_AXI_GPIO_rlast(M_AXI_GPIO_rlast),  
        .M_AXI_GPIO_rready(M_AXI_GPIO_rready), 
        .M_AXI_GPIO_rresp(M_AXI_GPIO_rresp),  
        .M_AXI_GPIO_rvalid(M_AXI_GPIO_rvalid), 
        .M_AXI_GPIO_wdata(M_AXI_GPIO_wdata),  
        .M_AXI_GPIO_wlast(M_AXI_GPIO_wlast),  
        .M_AXI_GPIO_wready(M_AXI_GPIO_wready), 
        .M_AXI_GPIO_wstrb(M_AXI_GPIO_wstrb),  
        .M_AXI_GPIO_wvalid(M_AXI_GPIO_wvalid));
       
    AXIGPIO axigpio_i
         (
          .clock(pl_clk),
          .reset(~aresetn),
          // AW channel
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
          // AR channel
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
          // W channel
          .io_axi_w_ready(M_AXI_GPIO_wready),
          .io_axi_w_valid(M_AXI_GPIO_wvalid),
          .io_axi_w_bits_data(M_AXI_GPIO_wdata),
          .io_axi_w_bits_last(M_AXI_GPIO_wlast),
          .io_axi_w_bits_strb(M_AXI_GPIO_wstrb),
          // R channel
          .io_axi_r_ready(M_AXI_GPIO_rready),
          .io_axi_r_valid(M_AXI_GPIO_rvalid),
          .io_axi_r_bits_data(M_AXI_GPIO_rdata),
          .io_axi_r_bits_last(M_AXI_GPIO_rlast),
          .io_axi_r_bits_resp(M_AXI_GPIO_rresp),
          // B channel
          .io_axi_b_ready(M_AXI_GPIO_bready),
          .io_axi_b_valid(M_AXI_GPIO_bvalid),
          .io_axi_b_bits_resp(M_AXI_GPIO_bresp),
          // GPIO
          .io_gpio(clk104_clk_spi_mux_sel_tri_o)
         );
endmodule
