`default_nettype none
module Matrix_FSM #(
parameter CORE_COUNT = 4
)(
    input wire CLOCK_25,
    input wire start,
    input wire [7:0] f_matrix_row_size,
    input wire [7:0] f_matrix_column_size,
    input wire [7:0] s_matrix_column_size,
    output wire o_rst,
    output wire [4:0]o_column_adr,
    output wire [4:0]o_row_adr,
    output wire [4:0]o_row_adr_pipe,
    output wire [4:0]o_core_column,
    output wire [4:0]o_core_column_pipe,
    output wire o_finished
);

    reg rst;
    reg [4:0]column_adr;
    reg [4:0]row_adr;
    reg [4:0]row_adr_pipe;
    reg [4:0]core_column;
    reg [4:0]core_column_pipe;   
    reg finished;


    assign o_rst = rst;
    assign o_column_adr = column_adr;
    assign o_row_adr = row_adr;
    assign o_row_adr_pipe = row_adr_pipe;
    assign o_core_column = core_column;
    assign o_core_column_pipe = core_column_pipe;
    assign o_finished = finished;
   
// STATE VARIABLES
    reg [2:0]state;
    reg [2:0]state_next;
    localparam IDLE_DOWN = 0;
    localparam COLUMN_MULTIPLY = 1;
    localparam ROW_INCREMENT = 2;
    localparam CORE_COLUMN_INCREMENT = 3;
    localparam IDLE_UP = 4;
   
    always@(negedge rst) begin
        core_column_pipe <=  core_column;
        row_adr_pipe <=  row_adr;
    end
    
    always@(posedge CLOCK_25) begin
        state <= state_next;  // advance to next 
        case(state)
            IDLE_DOWN: begin
                finished <= 1;
                column_adr <= 0;
                row_adr <= 0;
                core_column <= 0;
                rst <= 1;
            end
            COLUMN_MULTIPLY: begin
                finished <= 0;
                column_adr <= column_adr + 1;
                if (column_adr >= 1)
                    rst <= 0;
                else
                    rst <= 1;
                
            end      
            ROW_INCREMENT: begin
                column_adr <= 0;
                row_adr <= row_adr + 1;
            end
            CORE_COLUMN_INCREMENT: begin
                row_adr <= 0;
                rst <= 0;
                core_column <= core_column + (CORE_COUNT);
            end
            IDLE_UP: begin
                column_adr <= 0;
                core_column <= 0;
                rst <= 1;
            end
            default: begin
                finished <= 1;
                column_adr <= 0;
                row_adr <= 0;
                core_column <= 0;
                rst <= 1;
            end
        endcase
    end
    
    always@(*) begin
        case(state)
            IDLE_DOWN: begin
                if (start == 1)
                    state_next <= COLUMN_MULTIPLY;
                else
                    state_next <= IDLE_DOWN;
            end
            COLUMN_MULTIPLY: begin
                if (column_adr == (f_matrix_column_size-2))
                    state_next <= ROW_INCREMENT;
                else
                    state_next <= COLUMN_MULTIPLY;
            end
            ROW_INCREMENT: begin
                if (row_adr == (f_matrix_column_size))
                    state_next <= CORE_COLUMN_INCREMENT;
                else
                    state_next <= COLUMN_MULTIPLY;
            end
            CORE_COLUMN_INCREMENT: begin
                if ((CORE_COUNT + core_column) >= (s_matrix_column_size)) 
                    state_next <= IDLE_UP;
                else
                    state_next <= COLUMN_MULTIPLY;
            end
            IDLE_UP: begin
                if (start == 1)
                    state_next <= IDLE_UP;
                else
                    state_next <= IDLE_DOWN;
            end
            default: state <= IDLE_DOWN;
        endcase
    end
    
    reg [28*8-1:0] mytextsignal;
    always@(state) begin 
        case(state) 
            3'd0: mytextsignal = "IDLE_DOWN";
            3'd1: mytextsignal = "COLUMN_MULTIPLY";
            3'd2: mytextsignal = "ROW_INCREMENT";
            3'd3: mytextsignal = "CORE_COLUMN_INCREMENT";
            3'd4: mytextsignal = "IDLE_UP";
            default: mytextsignal = "UNKNOWN";
        endcase
    end
endmodule
