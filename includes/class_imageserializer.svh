`ifndef _imageserializer_svh_
`define _imageserializer_svh_

`include "class_image.svh"

class imageserializer;
	image img;
	integer posx = 0, posy = -1;

	function new(image i);
		img = i;
	endfunction;

	// Resets the stream to the first pixel
	function void reset();
		posx = 0;
		posy = -1;
	endfunction;

	// Indicates whether this image has more pixels
	function bit hasPixel();
		hasPixel = ((posx < img.getWidth - 1) || (posy < img.getHeigth - 1));
	endfunction;

	// Returns the next pixel of the image
	function integer getPixel();
		if (posy < img.getHeigth - 1)
			posy++;
		else if (posx < img.getWidth - 1) begin
			posx++;
			posy = 0;
		end
		// no protection against reading past the end - keep returning the last pixel
		getPixel = img.getPixel(posx, posy);
	endfunction;
endclass;
`endif
