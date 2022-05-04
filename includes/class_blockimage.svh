`ifndef _blockimage_svh_
`define _blockimage_svh_
`include "class_image.svh"

class blockimage extends image;
	// TODO "Class Hierarchy navigation"
	//      From the Class Hierarchy view, one can double-click on any class,
	//      method or field to navigate to the definition of the item in the
	//      editor.
	//
	//      Single-click on `smallblockimage` in the hierarchy and then double-click
	//      on constructor `new()`.
	
	integer width;  // image width
	integer heigth; // image height

	function new(integer w = 20, integer h = 20);
		this.width  = w;
		this.heigth = h;
	endfunction;

	// returns the width of the image
	function integer getWidth();
		getWidth = this.width;
	endfunction;

	// returns the height of the image
	function integer getHeigth();
		getHeigth = this.heigth;
	endfunction;

	// returns the pixel at the specified location
	function integer getPixel(integer x, integer y);
		integer wherex, wherey;
		// generate an image with a 10x10 checkered pattern
		wherex = (x / (this.width  / 10)) % 2; // even or odd rectangle horizontally
		wherey = (y / (this.heigth / 10)) % 2; // even or odd rectangle vertically
		getPixel = (wherex == wherey) ? 255 : 0; // 
	endfunction;
endclass;

`include "class_smallblockimage.svh"
`include "class_largeblockimage.svh"
`endif
