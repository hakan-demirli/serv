`default_nettype none
module mult_acc_tb();

   localparam CORE_COUNT = 4;
   
   localparam SIZE_ROW_MAX = 10;
   localparam SIZE_COLUMN_MAX = 10;
   
   localparam size_row = 6; // SIMULATION
   localparam size_column = 6; // SIMULATION
   
   wire [1:0]state;
   reg start;
   wire rst;
   wire [4:0]column_adr;
   wire [4:0]row_adr;
	wire [4:0]row_adr_pipe;
   wire [4:0]core_column;
   wire [4:0]core_column_pipe;
   
   reg [31:0] first_matrix[(SIZE_ROW_MAX-1):0][(SIZE_COLUMN_MAX-1):0];
   reg [31:0] second_matrix[(SIZE_COLUMN_MAX-1):0][(SIZE_ROW_MAX-1):0];
   reg [31:0] third_matrix[(SIZE_ROW_MAX-1):0][(SIZE_ROW_MAX-1):0];
   wire [31:0] acc[(CORE_COUNT-1):0];
   
   reg CLOCK_25;
	always #20 CLOCK_25 = ~CLOCK_25;
   
   matmul_top #(
      .CORE_COUNT(CORE_COUNT)
   )ML0(
      .CLOCK_25(CLOCK_25),
      .start(start),
      .o_rst(rst),
      .o_column_adr(column_adr),
      .o_row_adr(row_adr),
      .o_row_adr_pipe(row_adr_pipe),
      .o_core_column(core_column),
      .o_core_column_pipe(core_column_pipe),
      .o_state(state)
   );

   genvar g_i;
   generate
       for (g_i=0; g_i<=CORE_COUNT; g_i=g_i+1) begin : mul_acc_cores
       multiply_accumulate ma_core(
         .clk(CLOCK_25),
         .m_rst(rst),
         .a(first_matrix[row_adr][column_adr]),
         .b(second_matrix[column_adr][core_column+g_i]),
         .acc(acc[g_i])
      );
   end 
   endgenerate
   
   genvar g_ii;
   generate
      for (g_ii=0; g_ii<=CORE_COUNT; g_ii=g_ii+1) begin
            always@(posedge rst) begin
               third_matrix[row_adr_pipe][core_column_pipe+g_ii] <= acc[g_ii];   
            end 
      end
   endgenerate
   
   
   integer ii, kk;
   integer total;
   
   initial begin
      total = 0;
      for (ii = 0; ii <= (size_row-1); ii = ii + 1) begin
         for (kk = 0; kk <= (size_column-1); kk = kk + 1) begin
            #1 total = total + 1;
            #1 first_matrix[ii][kk] = total;
            #1 second_matrix[kk][ii] = total;
         end
      end
      
      #1 CLOCK_25 = 0;
      
      #110 start = 1;
      #210 start = 0;
      #310 start = 1;
      #1100 start = 0;
      #40000 start = 0;
      
      
      $stop;
      
   end
   
      reg [8*8-1:0] mytextsignal;
   always@(state) begin 
       case(state) 
           2'b00: mytextsignal = "IDLE_DOWN";
           2'b01: mytextsignal = "IDLE_UP";
           2'b10: mytextsignal = "DRAW_COL";
           default: mytextsignal = "UNKNOWN";
        endcase
    end
   
endmodule
