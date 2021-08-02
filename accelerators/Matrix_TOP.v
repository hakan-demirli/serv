`default_nettype none
module Matrix_TOP #(
    parameter CORE_COUNT = 6,
    parameter SIZE_ROW_MAX = 8,
    parameter SIZE_COLUMN_MAX = 4
)(
    input wire CLOCK_25,
    input wire [31:0]data,
    input wire [12:0]address,
    input wire we,
    output wire [31:0]o_data_rdt
);
    reg [31:0]data_rdt;
    assign o_data_rdt = data_rdt;

    wire rst;
    wire finished;
    wire [4:0]column_adr;
    wire [4:0]row_adr;
    wire [4:0]row_adr_pipe;
    wire [4:0]core_column;
    wire [4:0]core_column_pipe;

    reg [31:0] control_register;
    reg [31:0] first_matrix[(SIZE_ROW_MAX-1):0][(SIZE_COLUMN_MAX-1):0];
    reg [31:0] second_matrix[(SIZE_COLUMN_MAX-1):0][(SIZE_ROW_MAX-1):0];
    reg [31:0] third_matrix[(SIZE_ROW_MAX-1):0][(SIZE_ROW_MAX-1):0];
    wire [31:0] acc[(CORE_COUNT-1):0];
    wire [7:0] size_row;
    wire [7:0] size_column;
    wire start;
    
    assign size_column = control_register[7:0];
    assign size_row = control_register[15:8];
    assign start = control_register[16];
    
    always@(posedge CLOCK_25) begin
        case(address[12:10])
            3'd0: begin
                if(we)
                    control_register <= data;
            end
            3'd1: begin
                if(we)
                    first_matrix[address[9:5]][address[4:0]] <= data;
            end
            3'd2: begin
                if(we)
                    second_matrix[address[9:5]][address[4:0]] <= data;
            end
            3'd3: begin
                data_rdt <= third_matrix[address[9:5]][address[4:0]];
            end
            3'd4: begin
                data_rdt <= finished;
            end
            default: begin
                control_register <= 0;
            end
        endcase
    end

    Matrix_FSM #(
        .CORE_COUNT(CORE_COUNT)
    )ML0(
        .CLOCK_25(CLOCK_25),
        .start(start),
        .size_row(size_row),
        .size_column(size_column),
        .o_rst(rst),
        .o_column_adr(column_adr),
        .o_row_adr(row_adr),
        .o_row_adr_pipe(row_adr_pipe),
        .o_core_column(core_column),
        .o_core_column_pipe(core_column_pipe),
        .o_finished(finished)
    );

    genvar g_i;
    generate
        for (g_i=0; g_i<CORE_COUNT; g_i=g_i+1) begin : MATRIX_CORES
            Matrix_Core ma_core(
                .clk(CLOCK_25),
                .m_rst(rst),
                .a(first_matrix[row_adr][column_adr]),
                .b(second_matrix[column_adr][core_column+g_i]),
                .acc(acc[g_i])
            );
        end 
    endgenerate

    integer g_ii;
    always@(posedge rst) begin
        for (g_ii=0; g_ii<CORE_COUNT; g_ii=g_ii+1) begin : MATRIX_ASSIGN
            third_matrix[row_adr_pipe][core_column_pipe+g_ii] <= acc[g_ii];   
        end 
    end
endmodule
