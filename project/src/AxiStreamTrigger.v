`timescale 1ns / 1ps

module axis_pulse_gen #(
    parameter DATA_WIDTH    = 16,     // 数据位宽 (RFDC通常为16)
    parameter WAVE_PERIOD   = 4096,   // 周期总长度 (比如 4096 个点)
    parameter PULSE_WIDTH   = 64,     // 脉冲持续时长 (n个周期)
    parameter PULSE_AMPLITUDE = 32000 // 脉冲的幅度 (最大正值附近)
)(
    input  wire                   aclk,
    input  wire                   aresetn,

    // AXIS 接口 (接 RFDC)
    output wire [DATA_WIDTH-1:0]  m_axis_tdata,
    output wire                   m_axis_tvalid,
    input  wire                   m_axis_tready,
    output wire                   m_axis_tlast
);

    // 计数器
    reg [31:0]                    sample_cnt;
    
    // 用于输出的数据寄存器
    reg signed [DATA_WIDTH-1:0]   axis_data_reg;

    // --------------------------------------------------------
    // 逻辑实现
    // --------------------------------------------------------

    // 1. AXIS 握手信号
    // 复位完成后，只要对方(RFDC)准备好，我们就一直有效
    assign m_axis_tvalid = aresetn; 

    // 2. TLAST 信号
    // 在周期的最后一个点拉高 (可选，对无限流 DAC 不影响功能，但符合规范)
    assign m_axis_tlast  = (sample_cnt == WAVE_PERIOD - 1) && m_axis_tvalid && m_axis_tready;

    // 3. 数据输出连线
    assign m_axis_tdata  = axis_data_reg;

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            sample_cnt    <= 0;
            axis_data_reg <= 0;
        end else begin
            // 只有当 RFDC 准备好接收时，计数器才走动
            if (m_axis_tready) begin
                
                // --- 计数器逻辑 ---
                if (sample_cnt >= WAVE_PERIOD - 1) begin
                    sample_cnt <= 0;
                end else begin
                    sample_cnt <= sample_cnt + 1;
                end

                // --- 脉冲生成逻辑 ---
                // 如果计数器在 [0, PULSE_WIDTH) 范围内，输出高电平脉冲
                if (sample_cnt < PULSE_WIDTH) begin
                    axis_data_reg <= $signed(PULSE_AMPLITUDE); // 发送高电平 (比如 32000)
                end 
                // 否则，输出 0 (静默)
                else begin
                    axis_data_reg <= 16'sd0;                   // 发送 0
                end
                
            end
        end
    end

endmodule