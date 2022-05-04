`ifndef _smallblockimage_svh_
`define _smallblockimage_svh_
`include "class_blockimage.svh"

class smallblockimage extends blockimage;

	function new(integer w, integer h);
		// TODO "Navigate back"
		//      Return to file `step_6_image_testbench.sv` by ether clicking
		//      its tab in the editor, or by pressing **Alt+Left** twice.
		super.new(w, h);
		assert ((w * h) < 10000) else $error("This image isn't small!");
	endfunction;

endclass
`endif
