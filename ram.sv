// A naive RAM module without an impementation
module ram #(
	parameter addrwidth = 8,
	parameter datawidth = 8
)
(
	input clk,                                // clock
	input rst,                                // reset
	input [addrwidth-1:0] address,            // address
	input ren,                                // read enable
	input wen,                                // write enable
	input [datawidth-1:0] data_in,            // data in
	output logic [(datawidth-1):0] data_out   // data out
);
	
endmodule
