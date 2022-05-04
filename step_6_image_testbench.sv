`timescale 1ns/100ps
`include "class_blockimage.svh"
`include "class_imageserializer.svh"

// Standardized header of my.compa.ny
//
// (c) 2022 MyCo Inc. All rites reversed.
// 
// Top-level testbench of the Imaginary Project
//
// Author: *Sigasi Team*
module image_testbench();
	logic clk = 1'b0;              // Test clock
	wire rst;                      // Test reset
	wire start;                    // Trigger the design under test
	logic running;                 // Indicates that the test is running
	localparam width  = 80;        // Image width (pixels)
	localparam height = 60;        // Image height (pixels)
	wire [7:0] pixel_out;          // Pixel produced by the design under test
	wire pixel_valid;              // Indicates that the data on `pixel_out` is valid
	imageserializer image_stream;  // The input image, accessible as a stream of pixels 
	logic [7:0] pixel_in;          // Input pixel for the design under test

	// Clock generator
	always #5 begin
		clk = ~clk;
	end

	// Initialize the source image
	initial begin
		blockimage img;
		img = new(width, height);
		image_stream = new(img);
	end

	// Feed data into the DUT 
	always @(posedge clk) begin
		if (start | running) begin
			if (image_stream.hasPixel()) begin
				running = 1'b1;
				pixel_in = image_stream.getPixel();
			end
			else
				running = 1'b0;
		end
		else
			pixel_in = 1'b0;
	end

	// Driver block for reset and start indication
	drive_rst_start drive_rst_start_instance (
		.rst(rst),
		.start(start)
	);

	// DUT instance
	dut_top dut_top_instance (
		.clk(clk),
		.rst(rst),
		.start(start),
		.size_x(width),
		.size_y(height),
		.pixel_in(pixel_in),
		.pixel_out(pixel_out),
		.pixel_valid(pixel_valid)
	);

endmodule
