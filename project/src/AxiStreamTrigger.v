`timescale 1ns / 1ps

module AXIS_PULSE_GEN #(
    parameter DATA_WIDTH    = 16,     
    parameter WAVE_PERIOD   = 4096,   
    parameter PULSE_WIDTH   = 64,     
    parameter PULSE_AMPLITUDE = 32000 
)(
    input  wire                   aclk,
    input  wire                   aresetn,

    output wire [DATA_WIDTH-1:0]  m_axis_tdata,
    output wire                   m_axis_tvalid,
    input  wire                   m_axis_tready,
    output wire                   m_axis_tlast,
    
    output wire                   trigger_out
);

    reg [31:0]                    sample_cnt;
    
    reg signed [DATA_WIDTH-1:0]   axis_data_reg;
//    reg                           trigger_reg;

    assign m_axis_tvalid = aresetn; 
    assign m_axis_tlast  = (sample_cnt == WAVE_PERIOD - 1) && m_axis_tvalid && m_axis_tready;
    assign m_axis_tdata  = axis_data_reg;
    
//    assign trigger_out   = trigger_reg;

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            sample_cnt    <= 0;
            axis_data_reg <= 0;
//            trigger_reg   <= 1'b0;
        end else begin
            if (m_axis_tready) begin
                
                if (sample_cnt >= WAVE_PERIOD - 1) begin
                    sample_cnt <= 0;
                end else begin
                    sample_cnt <= sample_cnt + 1;
                end

                if (sample_cnt < PULSE_WIDTH) begin
                    axis_data_reg <= $signed(PULSE_AMPLITUDE);
//                    trigger_reg   <= 1'b1; 
                end 
                else begin
                    axis_data_reg <= 16'sd0;
//                    trigger_reg   <= 1'b0;
                end
                
            end
        end
    end
    
    localparam CLK_FREQ = 100_000_000;
    localparam LED_PERIOD = CLK_FREQ;
    localparam LED_TOGGLE_POINT = CLK_FREQ / 2;

    reg [26:0] led_cnt;
    reg        led_reg;

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            led_cnt <= 0;
            led_reg <= 0;
        end else begin
            if (led_cnt >= LED_PERIOD - 1) begin
                led_cnt <= 0;
            end else begin
                led_cnt <= led_cnt + 1;
            end

            if (led_cnt < LED_TOGGLE_POINT) begin
                led_reg <= 1'b1;
            end else begin
                led_reg <= 1'b0;
            end
        end
    end

    assign trigger_out = led_reg;

endmodule