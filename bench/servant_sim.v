`default_nettype none
module servant_sim
  #(parameter NUM_GPIO = 8,
    parameter ADR_WIDTH_GPIO = 3,
    parameter memfile = "zephyr_hello.hex",
    parameter memsize = 8192,
    parameter reset_strategy = "MINI",
    parameter sim = 0,
    parameter with_csr = 1,
    parameter CORE_COUNT = 3,
    parameter SIZE_ROW_MAX = 8,
    parameter SIZE_COLUMN_MAX = 8)
  (input wire  wb_clk,
   input wire  wb_rst,
   output wire [NUM_GPIO-1:0] q);
 


   reg [1023:0] firmware_file;
   initial
     if ($value$plusargs("firmware=%s", firmware_file)) begin
	$display("Loading RAM from %0s", firmware_file);
	$readmemh(firmware_file, dut.ram.mem);
     end

   servant
     #(.memfile  (memfile),
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
