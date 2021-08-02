`default_nettype none
module Matrix_FSM #(
parameter CORE_COUNT = 4
)(
    input wire CLOCK_25,
    input wire start,
    input wire [7:0] size_column,
    input wire [7:0] size_row,
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
    reg [1:0]state;
    reg [1:0]state_next;
    localparam IDLE_DOWN = 0;
    localparam IDLE_UP = 1;
    localparam DRAW_COL = 2;
   
    always@(negedge rst) begin
        core_column_pipe <=  core_column;
        row_adr_pipe <=  row_adr;
    end
    
    always@(posedge CLOCK_25) begin
        state <= state_next;  // advance to next 
        case(state)
            DRAW_COL: begin
                finished <= 1;
                if(column_adr == (size_column-1)) begin
                    column_adr <= 0;
                    if (row_adr == (size_row-1)) begin
                        row_adr <= 0;
                        rst <= 0;
                        if ( (CORE_COUNT + core_column) < (size_column))
                            core_column <= core_column + (CORE_COUNT);
                        else
                            core_column <= core_column;
                    end
                    else
                        row_adr <= row_adr + 1;
                end
                else begin
                    column_adr <= column_adr + 1;
                    if (column_adr >= 1)
                        rst <= 0;
                    else
                        rst <= 1;
                end
            end
            IDLE_DOWN: begin
                finished <= 1;
                column_adr <= 0;
                row_adr <= 0;
                core_column <= 0;
                rst <= 1;
            end
            IDLE_UP: begin
                finished <= 0;
                column_adr <= 0;
                row_adr <= 0;
                core_column <= 0;
                rst <= 1;
            end
            default: begin
                column_adr <= 0;
                row_adr <= 0;
                rst <= 1;
            end
        endcase
    end

    always@(*) begin
        case(state)
            IDLE_DOWN: begin
                if (start == 1)
                    state_next <= DRAW_COL;
                else
                    state_next <= IDLE_DOWN;
            end
            DRAW_COL: begin
                if(column_adr == (size_column-1) && row_adr == (size_row-1))begin
                    if ((CORE_COUNT + core_column) >= (size_column))
                        state_next <= IDLE_UP;
                    else
                        state_next <= DRAW_COL;
                end
                else
                    state_next <= DRAW_COL;
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
endmodule
