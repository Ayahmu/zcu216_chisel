`timescale 1ns / 1ps

module axis_splitter_128to64x2 (
    input  wire          aclk,
    input  wire          aresetn,

    input  wire [127:0]  s_axis_tdata,
    input  wire          s_axis_tvalid,
    output wire          s_axis_tready,
    input  wire          s_axis_tlast,

    output wire [63:0]   m_axis_a_tdata,
    output wire          m_axis_a_tvalid,
    input  wire          m_axis_a_tready,
    output wire          m_axis_a_tlast,

    output wire [63:0]   m_axis_b_tdata,
    output wire          m_axis_b_tvalid,
    input  wire          m_axis_b_tready,
    output wire          m_axis_b_tlast
);

    assign m_axis_a_tdata = s_axis_tdata[63:0]; 
    assign m_axis_b_tdata = s_axis_tdata[127:64];

    assign m_axis_a_tlast = s_axis_tlast;
    assign m_axis_b_tlast = s_axis_tlast;

    assign s_axis_tready = m_axis_a_tready && m_axis_b_tready;

    assign m_axis_a_tvalid = s_axis_tvalid && m_axis_b_tready;
    assign m_axis_b_tvalid = s_axis_tvalid && m_axis_a_tready;

endmodule