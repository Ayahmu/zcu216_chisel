`timescale 1ns / 1ps

module axis_axis_trigger_start #(
    parameter DATA_WIDTH      = 16,
    parameter TRIG_DATA_WIDTH = 16,
    parameter SAMPLE_WIDTH    = 16,
    parameter THRESHOLD       = 5000
)(
    input  wire                       aclk,
    input  wire                       aresetn,

    input  wire [DATA_WIDTH-1:0]      s_data_tdata,
    input  wire                       s_data_tvalid,
    output reg                        s_data_tready,
    input  wire                       s_data_tlast,

    output reg  [DATA_WIDTH-1:0]      m_data_tdata,
    output reg                        m_data_tvalid,
    input  wire                       m_data_tready,

    input  wire [TRIG_DATA_WIDTH-1:0] s_trig_tdata,
    input  wire                       s_trig_tvalid,
    output wire                       s_trig_tready
);

    localparam STATE_IDLE = 2'd0;
    localparam STATE_RUN  = 2'd1;
    
    reg [1:0] state;

    wire trigger_hit;
    
    wire signed [SAMPLE_WIDTH-1:0] current_sample;
    assign current_sample = s_trig_tdata[SAMPLE_WIDTH-1:0];

    assign trigger_hit = s_trig_tvalid && 
                         ($signed(current_sample) > $signed(THRESHOLD)) && 
                         s_data_tvalid;

    assign s_trig_tready = 1'b1; 

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            state <= STATE_IDLE;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (trigger_hit) begin
                        state <= STATE_RUN;
                    end
                end

                STATE_RUN: begin
                    if (s_data_tvalid && s_data_tready && s_data_tlast) begin
                        state <= STATE_IDLE;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        s_data_tready = 1'b0;
        m_data_tvalid = 1'b0;
        m_data_tdata  = {DATA_WIDTH{1'b0}};

        case (state)
            STATE_IDLE: begin
                s_data_tready = 1'b0;
                m_data_tvalid = 1'b0; 
                m_data_tdata  = {DATA_WIDTH{1'b0}};
            end

            STATE_RUN: begin
                m_data_tvalid = s_data_tvalid;
                s_data_tready = m_data_tready;
                m_data_tdata  = s_data_tdata;
            end
        endcase
    end

endmodule