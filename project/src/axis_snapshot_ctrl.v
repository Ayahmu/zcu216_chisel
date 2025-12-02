`timescale 1ns / 1ps

module axis_axis_trigger_start #(
    parameter DATA_WIDTH      = 16,    // DMA/DAC 数据位宽 (例如 32, 128, 256)
    parameter TRIG_DATA_WIDTH = 16,    // Trigger源(ADC) 数据位宽
    parameter SAMPLE_WIDTH    = 16,    // 单个采样点的位宽 (通常是16位)
    parameter THRESHOLD       = 5000   // 触发阈值 (有符号数)
)(
    input  wire                       aclk,
    input  wire                       aresetn,

    // ---------------------------------------------------------
    // 1. Data Stream (被控制的数据流: DMA -> DAC)
    // ---------------------------------------------------------
    input  wire [DATA_WIDTH-1:0]      s_data_tdata,
    input  wire                       s_data_tvalid,
    output reg                        s_data_tready, // 控制 DMA
    input  wire                       s_data_tlast,  // DMA 结束标志

    output reg  [DATA_WIDTH-1:0]      m_data_tdata,
    output reg                        m_data_tvalid,
    input  wire                       m_data_tready, // DAC 准备好

    // ---------------------------------------------------------
    // 2. Trigger Stream (触发源: ADC -> 本模块)
    // ---------------------------------------------------------
    input  wire [TRIG_DATA_WIDTH-1:0] s_trig_tdata,
    input  wire                       s_trig_tvalid,
    output wire                       s_trig_tready  // 我们必须一直 Ready 以消耗数据
);

    // 状态机
    localparam STATE_IDLE = 2'd0;
    localparam STATE_RUN  = 2'd1;
    
    reg [1:0] state;

    // 触发检测信号
    wire trigger_hit;
    
    // ---------------------------------------------------------
    // 触发逻辑核心
    // ---------------------------------------------------------
    // 假设 ADC 数据是 16位有符号数。
    // 如果 TRIG_DATA_WIDTH > 16 (例如 128位包含8个采样点)，
    // 简便起见，这里只检测第一个采样点 [15:0]。
    // 如果需要检测所有并行采样点，需要用 for loop 或 reduction operator。
    
    wire signed [SAMPLE_WIDTH-1:0] current_sample;
    assign current_sample = s_trig_tdata[SAMPLE_WIDTH-1:0];

    // 只有当：
    // 1. ADC 数据有效 (s_trig_tvalid)
    // 2. ADC 数值超标 (阈值判断)
    // 3. DMA 数据已到达门口 (s_data_tvalid) <-- 新增条件
    assign trigger_hit = s_trig_tvalid && 
                         ($signed(current_sample) > $signed(THRESHOLD)) && 
                         s_data_tvalid;

    // ---------------------------------------------------------
    // Trigger 通道流控
    // ---------------------------------------------------------
    // 我们必须始终拉高 Ready，否则前面的 ADC AXI-Stream FIFO 会满，
    // 导致我们读到的数据是"旧"数据，延迟巨大。
    // 我们只"看"数据，不"存"数据，看完就丢。
    assign s_trig_tready = 1'b1; 

    // ---------------------------------------------------------
    // 主状态机
    // ---------------------------------------------------------
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            state <= STATE_IDLE;
        end else begin
            case (state)
                STATE_IDLE: begin
                    // 如果检测到阈值触发
                    if (trigger_hit) begin
                        state <= STATE_RUN;
                    end
                end

                STATE_RUN: begin
                    // 保持透传，直到 DMA 发送完最后一个数据包 (TLAST)
                    // 并且握手成功
                    if (s_data_tvalid && s_data_tready && s_data_tlast) begin
                        state <= STATE_IDLE;
                    end
                end
            endcase
        end
    end

    // ---------------------------------------------------------
    // Data 通道输出逻辑 (组合逻辑 MUX)
    // ---------------------------------------------------------
    always @(*) begin
        // 默认值
        s_data_tready = 1'b0;
        m_data_tvalid = 1'b0;
        m_data_tdata  = {DATA_WIDTH{1'b0}};

        case (state)
            STATE_IDLE: begin
                // 阻断 DMA (Backpressure)
                s_data_tready = 1'b0;
                // 阻断 DAC (Sending Silence)
                m_data_tvalid = 1'b0; 
                m_data_tdata  = {DATA_WIDTH{1'b0}}; // 输出 0
            end

            STATE_RUN: begin
                // 透传模式 (Pass-through)
                m_data_tvalid = s_data_tvalid;
                s_data_tready = m_data_tready;
                m_data_tdata  = s_data_tdata;
            end
        endcase
    end

endmodule