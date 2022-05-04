// Module pixelbuffer implements a buffer to contain 2 pixel rows + 3 pixels of the image.
// Pixels arrive into the buffer in a streaming mode. A 3x3 pixel window (without the
// central pixel) is offered at the output.
//
// This is a **behavioral** implementation, **not suitable for synthesis**.
module pixelbuffer (
// TODO "Quick fix"
//      The next line of code has an error marker icon with a lightbulb. That means that
//      Sigasi Studio has one or more **Quick Fixes** which are suggestions on how to solve
//      the problem.
//      Place your mouse pointer over the error-with-lightbulb icon to see the error message.
//      Click on the icon to open the Quick Fixes pop-up, and double-click the suggested
//      solution "Add 'includes' to include paths." to accept it.

`include "pixelbuffer.svh"

// TODO "Preprocessor view"
//      Place the mouse pointer over `pixelbuffer.svh` in the line above until the
//      hover pop-up shows and click **Open Preprocessor View**. The Preprocessor view
//      opens in the window under the editor.
//          * Note that constants in the module interface are replaced with their values.
//          * Note that anything you select in the editor gets highlighted in the Preprocessor view.
//          * Note that anything you select in the Preprocessor view gets highlighted in the editor.
//      Now press and hold **Ctrl** and click on `pixelbuffer.svh` above to open
//      the included file.

	input clk, rst,                              // core clock and synchronous reset
	input [11:0] size_x,                         // image width
	input [(`PIXBUF_WIDTH-1):0] pixel_in,        // input pixel
	input pixel_in_valid,                        // incoming pixel is valid
	output logic [(`PIXBUF_WIDTH-1):0] pixel_pp, // 3x3 pixel window: upper right
	output logic [(`PIXBUF_WIDTH-1):0] pixel_p0, // 3x3 pixel window: middle right
	output logic [(`PIXBUF_WIDTH-1):0] pixel_pm, // 3x3 pixel window: bottom right
	output logic [(`PIXBUF_WIDTH-1):0] pixel_0p, // 3x3 pixel window: upper middle
	output logic [(`PIXBUF_WIDTH-1):0] pixel_0m, // 3x3 pixel window: lower middle
	output logic [(`PIXBUF_WIDTH-1):0] pixel_mp, // 3x3 pixel window: upper left
	output logic [(`PIXBUF_WIDTH-1):0] pixel_m0, // 3x3 pixel window: middle left
	output logic [(`PIXBUF_WIDTH-1):0] pixel_mm  // 3x3 pixel window: bottom left
);

	// TODO "External tools"
	//      If you have an external tool e.g. a simulator or linter, you can:
	//      * automatically compile your design every time when you save a file in Sigasi Studio
	//      * view compilation errors and warnings in Sigasi Studio's editor and Problems view
	//      * run a simulation from Sigasi Studio.
	//      Detailed information is available on https://insights.sigasi.com/manual/tools/

	integer i;                   // loop variable
	integer size_x_int;          // integer value of image width
	assign  size_x_int = size_x; // convert to integer

	logic [(`PIXBUF_WIDTH-1):0] memory[(`PIXBUF_DEPTH-1):0]; // behavioral pixel memory model
	always @(posedge clk) begin
		if (rst == 1'b1)
			for (i=(`PIXBUF_DEPTH-1); i>=0; i = i - 1)
				memory[i] = 'b0;
		else if (pixel_in_valid == 1'b1)
		begin
			for (i=(`PIXBUF_DEPTH-1); i>0; i = i - 1)
				memory[i] = memory[i - 1];
			memory[0] = pixel_in;
		end
	end

	always @(*) begin
		pixel_pp = memory[0];
		pixel_0p = memory[1];
		pixel_mp = memory[2];
		pixel_p0 = memory[     size_x_int  + 0];
		pixel_m0 = memory[     size_x_int  + 2];
		pixel_pm = memory[(2 * size_x_int) + 0];
		pixel_0m = memory[(2 * size_x_int) + 1];
		pixel_mm = memory[(2 * size_x_int) + 2];
	end

	wire [12:0] address;
	wire ren, wen;
	wire [7:0] data_in, data_out;
	
	// TODO "Documentation view"
	//      Right-click anywhere in the editor and select **Show in > Documentation**.
	//      Look through the documentation view, you'll see
	//      * the module description (taken from comments right before the module definition),
	//      * module ports (with descriptions taken from comments on the same line as the port),
	//      * instantiations (with a description from comments right before it)
    //      Sigasi Studio's manual documents how comments are associated with objects:
    //        https://insights.sigasi.com/manual/documentation/#comment-association
	//
	//	    Edit the comments below and note that the Documentation view gets
	//      updated as you type.
	//      Close the Documentation view when you're done.
	
	// This is a (so far) unused instantiation of a RAM module.
	//
	// Feel free to edit *here* and observe the documentation view.
    //
    // * _Note that_ [markdown](https://insights.sigasi.com/manual/documentation/#comment-markup-with-markdown)
    // * is **available** to format `your text`!
	ram #(
	.addrwidth(13),
	.datawidth(8)
	) ram_instance (
		.clk(clk),
		.rst(rst),
		.address(address),
		.ren(ren),
		.wen(wen),
		.data_in(data_in),
		.data_out(data_out)
	);

	// TODO "Dependencies view"
	//      Right-click anywhere in the editor and select **Show in > Dependencies**.
	//      The dependencies view opens and shows how design files depend on
	//      each other.
	//
	//      In the Dependencies view, double-click the `step_4_pixel_testbench.sv` box
	//      to open the relevant file in the editor.

endmodule
