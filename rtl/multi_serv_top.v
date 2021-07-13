`default_nettype none
module multi_serv_top
  #(parameter NUM = 6)
(
 input wire 	   i_clk,
 input wire 	   i_rst_n,
 input wire [2:0] SW,
 output wire q_real);
 
 wire [NUM:0]	   q;
 wire [NUM:0]   uart_txd;
 assign q_real = (SW == 3'b000) ? q[0] :
					 (SW == 3'b001) ? q[1] :
					 (SW == 3'b010) ? q[2] :
					 (SW == 3'b011) ? q[3] :
					 (SW == 3'b100) ? q[4] :
					 (SW == 3'b101) ? q[5] :
					 q[0] ;
 
	genvar i;
	generate
		 for (i=0; i<=NUM; i=i+1) begin : generate_block_identifier // <-- example block name
		 servive servive1(
			.i_clk(i_clk),
			.i_rst_n(i_rst_n),
			.q(q[i])
		 );
			
	end 
	endgenerate

endmodule
