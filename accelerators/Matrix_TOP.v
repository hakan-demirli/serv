/* Base Address
ADDRESS  |----LOCAL-----|-GLOBAL--|
         |              |         |
Control  |000 0000 0000 |20000000 |
FM       |001 0000 0000 |20000400 |
SM       |010 0000 0000 |20000800 |
TM       |011 0000 0000 |20000C00 |
Finished |100 0000 0000 |20001000 |
----------------------------------|
Control Reg[24:0]:
  st | smc_s | fmc_s | fmr_s
   1 |   8   |   8   |   8  
*/
`default_nettype none
module Matrix_TOP #(
    parameter F_MATRIX_ROW_SIZE_MAX = 3,
    parameter F_MATRIX_COLUMN_SIZE_MAX = 3,
    parameter S_MATRIX_COLUMN_SIZE_MAX = 3
)(
    input wire i_clk,
    input wire [31:0]data,
    input wire [10:0]address,
    input wire we,
    output wire [31:0]o_data_rdt
);
    reg [31:0]data_rdt;
    assign o_data_rdt = data_rdt;
    
    wire [7:0] fm_adr;
    wire [7:0] sm_adr;
    wire [7:0] t_adr;
    wire finished;
    wire m_rst;

    reg [31:0] first_matrix[((F_MATRIX_ROW_SIZE_MAX*F_MATRIX_COLUMN_SIZE_MAX)-1):0];
    reg [31:0] second_matrix[((F_MATRIX_COLUMN_SIZE_MAX*S_MATRIX_COLUMN_SIZE_MAX)-1):0];
    reg [31:0] third_matrix[((F_MATRIX_ROW_SIZE_MAX*S_MATRIX_COLUMN_SIZE_MAX)-1):0];
    wire [31:0] acc;
    wire [7:0] f_matrix_row_size;
    wire [7:0] f_matrix_column_size;
    wire [7:0] s_matrix_column_size;
    wire start;
    wire run;
    reg [24:0] control_register;

    assign f_matrix_row_size = control_register[7:0];
    assign f_matrix_column_size = control_register[15:8];
    assign s_matrix_column_size = control_register[23:16];
    assign start = control_register[24];

    always@(posedge i_clk) begin
        case(address[10:8])
            3'd0: begin
                if(we)
                    control_register <= data;
            end
            3'd1: begin
                if(we)
                    first_matrix[address[7:0]] <= data;
            end
            3'd2: begin
                if(we)
                    second_matrix[address[7:0]] <= data;
            end
            3'd3: begin
                data_rdt <= third_matrix[address[7:0]];
            end
            3'd4: begin
                data_rdt <= finished;
            end
            default: begin
                control_register <= control_register;
            end
        endcase
    end

    Matrix_FSM FSM_0(
        .i_clk(i_clk),
        .start(start),
        .f_matrix_row_size(f_matrix_row_size),
        .f_matrix_column_size(f_matrix_column_size),
        .s_matrix_column_size(s_matrix_column_size),
        .o_fm_adr(fm_adr),
        .o_sm_adr(sm_adr),
        .o_t_adr(t_adr),
        .finished(finished),
        .m_rst(m_rst),
        .o_run(run)
    );

    reg m_rst_t;
    always@(negedge i_clk) begin
        if(m_rst == 0)
            m_rst_t <= 1;
        else
            m_rst_t <= 0;
    end

    Matrix_Core ma_core(
        .clk(i_clk),
        .m_rst(m_rst_t),
        .run(run),
        .a(first_matrix[fm_adr]),
        .b(second_matrix[sm_adr]),
        .acc(acc)
    );

    reg [7:0] t_adr_p;
    reg [7:0] t_adr_pp;

    always@(negedge i_clk) t_adr_p <= t_adr;
    always@(negedge i_clk) t_adr_pp <= t_adr_p;

    always@(posedge m_rst_t) begin
        third_matrix[t_adr_pp] <= acc;
    end

endmodule

