`ifndef _largeblockimage_svh_
`define _largeblockimage_svh_
`include "class_blockimage.svh"

class largeblockimage extends blockimage;

   function new(integer w, integer h);
      super.new(w, h);
      assert ((w * h) > 1000000) else $error("This image isn't large!");
   endfunction;

endclass
`endif
