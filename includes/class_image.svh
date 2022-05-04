`ifndef _image_svh_
`define _image_svh_

// Virtual class image represents an image.
virtual class image;
	// returns the width of the image
	virtual function integer getWidth();
		getWidth = 0;
	endfunction

	// returns the height of the image
	virtual function integer getHeigth();
		getHeigth = 0;
	endfunction
	
	// returns the pixel at the specified location
	virtual function integer getPixel(integer x, integer y);
		getPixel = 0;
	endfunction
endclass;

`endif
