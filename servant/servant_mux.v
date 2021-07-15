 /*
 Taken from: https://github.com/olofk/serv
 
 ****************************************
 Change_log:
 -  12_07_2021__22_01:
	By :https://github.com/hakan-demirli
		parameter sim added as an input
 -  13_07_2021__13_44:
	By :https://github.com/hakan-demirli
		o_wb_gpio_adr variable created to increase the number of GPIO pins
		ADR_WIDTH_GPIO parameter created to change the width of the gpio_adr
		Info:
			GPIO_BASE address is 0x40000000
			There are 8 gpio registers by default, address offset is four
			first gpio address = 0x4000_0004
			...
			seventh gpio address = 0x4000_0018
			eighth gpio address = 0x4000_001C
			To Change the number of Gpio pins edit: ADR_WIDTH_GPIO of servant_mux.v and servant_gpio.v
 ****************************************
 */
/*
    mem = 00
    gpio = 01
    timer = 10
    testcon = 11
 */
`default_nettype none
module servant_mux
  #(parameter sim = 0,
    parameter ADR_WIDTH_GPIO = 3)
  (
   input wire 	      i_clk,
   input wire 	      i_rst,
   input wire [31:0]  i_wb_cpu_adr,
   input wire [31:0]  i_wb_cpu_dat,
   input wire [3:0]   i_wb_cpu_sel,
   input wire 	      i_wb_cpu_we,
   input wire 	      i_wb_cpu_cyc,
   output wire [31:0] o_wb_cpu_rdt,
   output reg 	      o_wb_cpu_ack,

   output wire [31:0] o_wb_mem_adr,
   output wire [31:0] o_wb_mem_dat,
   output wire [3:0]  o_wb_mem_sel,
   output wire 	      o_wb_mem_we,
   output wire 	      o_wb_mem_cyc,
   input wire [31:0]  i_wb_mem_rdt,

   output wire 	      o_wb_gpio_dat,
   output wire 	      o_wb_gpio_we,
   output wire 	      o_wb_gpio_cyc,
   output wire [(ADR_WIDTH_GPIO-1):0]    o_wb_gpio_adr,
   input wire 	      i_wb_gpio_rdt,

   output wire [31:0] o_wb_timer_dat,
   output wire 	      o_wb_timer_we,
   output wire 	      o_wb_timer_cyc,
   input wire [31:0]  i_wb_timer_rdt);

   wire [1:0] 	  s = i_wb_cpu_adr[31:30];

   assign o_wb_cpu_rdt = s[1] ? i_wb_timer_rdt :
			 s[0] ? {31'd0,i_wb_gpio_rdt} : i_wb_mem_rdt;
   always @(posedge i_clk) begin
      o_wb_cpu_ack <= 1'b0;
      if (i_wb_cpu_cyc & !o_wb_cpu_ack)
	o_wb_cpu_ack <= 1'b1;
      if (i_rst)
	o_wb_cpu_ack <= 1'b0;
   end

   assign o_wb_mem_adr = i_wb_cpu_adr;
   assign o_wb_mem_dat = i_wb_cpu_dat;
   assign o_wb_mem_sel = i_wb_cpu_sel;
   assign o_wb_mem_we  = i_wb_cpu_we;
   assign o_wb_mem_cyc = i_wb_cpu_cyc & (s == 2'b00);

   assign o_wb_gpio_dat = i_wb_cpu_dat[0];
   assign o_wb_gpio_we  = i_wb_cpu_we;
   assign o_wb_gpio_cyc = i_wb_cpu_cyc & (s == 2'b01);
   assign o_wb_gpio_adr = i_wb_cpu_adr[ADR_WIDTH_GPIO+1:2];

   assign o_wb_timer_dat = i_wb_cpu_dat;
   assign o_wb_timer_we  = i_wb_cpu_we;
   assign o_wb_timer_cyc = i_wb_cpu_cyc & s[1];

   generate
      if (sim) begin
	 wire sig_en = (i_wb_cpu_adr[31:28] == 4'h8) & i_wb_cpu_cyc & o_wb_cpu_ack;
	 wire halt_en = (i_wb_cpu_adr[31:28] == 4'h9) & i_wb_cpu_cyc & o_wb_cpu_ack;

	 reg [1023:0] signature_file;
	 integer      f = 0;

	 initial
       /* verilator lint_off WIDTH */
	   if ($value$plusargs("signature=%s", signature_file)) begin
	      $display("Writing signature to %0s", signature_file);
	      f = $fopen(signature_file, "w");
	   end
       /* verilator lint_on WIDTH */

	 always @(posedge i_clk)
	    if (sig_en & (f != 0))
	      $fwrite(f, "%c", i_wb_cpu_dat[7:0]);
	    else if(halt_en) begin
	       $display("Test complete");
	       $finish;
	    end
      end
   endgenerate
endmodule
