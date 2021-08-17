`default_nettype none
module servant_tb;

   	parameter memfile = "gg.hex";
	parameter memsize = 40192;
	parameter sim = 1;
	parameter with_csr = 1;
	parameter NUM_GPIO = 8;
	parameter ADR_WIDTH_GPIO = 3;
	parameter reset_strategy = "MINI";
	
	parameter CORE_COUNT = 2;
    parameter SIZE_ROW_MAX = 8;
    parameter SIZE_COLUMN_MAX = 8;

   reg wb_clk = 1'b0;
   reg wb_rst = 1'b1;

   wire [NUM_GPIO-1:0]q;

   always  #31 wb_clk <= !wb_clk;
   initial #62 wb_rst <= 1'b0;

   //vlog_tb_utils vtu();

   uart_decoder #(57600) uart_decoder (q[0]);

   servant_sim
	#( .memfile  (memfile),
       .memsize  (memsize),
       .sim      (sim),
       .with_csr (with_csr),
	   .NUM_GPIO(NUM_GPIO),
	   .ADR_WIDTH_GPIO(ADR_WIDTH_GPIO),
	   .reset_strategy(reset_strategy),
	   .CORE_COUNT(CORE_COUNT),
	   .SIZE_ROW_MAX(SIZE_ROW_MAX),
	   .SIZE_COLUMN_MAX(SIZE_COLUMN_MAX))
   dut(wb_clk, wb_rst, q);

endmodule
