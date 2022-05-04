////////////////////////////////////////////////////////////////////////////////
// Welcome!
////////////////////////////////////////////////////////////////////////////////
// You made a great choice installing Sigasi Studio, and now you are ready to
// unlock its power.
//
// This demo file will guide you through your first steps. In about ten
// minutes you will have learned the basics of how Sigasi helps you work
// with Verilog and SystemVerilog files. This tutorial also covers more advanced
// topics, which you can explore at your own pace.
//
// TODO In the (System)Verilog files of this project, follow the comments that
//      are marked 'TODO'.
//
// TODO Double-click the tab of this editor to switch to full screen editing.
////////////////////////////////////////////////////////////////////////////////

module dut_core(
    output logic [7:0] pixel_out,
    input [7:0] pixel_pp,
    input [7:0] pixel_p0,
    input [7:0] pixel_pm,
    input [7:0] pixel_0p,
    input [7:0] pixel_0m,
    input [7:0] pixel_mp,
    input [7:0] pixel_m0,
    input [7:0] pixel_mm,
    input on_edge,
    input clock,
    input reset);

    wire logic signed [15:0] gradx; // X gradient
    wire logic signed [15:0] grady; // Y gradient
    wire logic signed [15:0] gradsq; // XY gradient, squared
    logic signed [9:0] gradx_r; // X gradient, buffered
    logic signed [9:0] grady_r; // Y gradient, buffered

    // Calculate the X, Y and XY(squared) gradients
    assign gradx = (pixel_mp - pixel_pp) + 2 * (pixel_m0 - pixel_p0) + (pixel_mm - pixel_pm);
    assign grady = (pixel_mp - pixel_mm) + 2 * (pixel_0p - pixel_0m) + (pixel_pp - pixel_pm);
    assign gradsq = (gradx_r * gradx_r) + (grady_r * grady_r);

    always @(posedge clock) begin
        gradx_r = gradx;
        grady_r = grady;
    end

    always_ff @(posedge clock) begin
        if (on_edge == 1'b1)
            begin
                pixel_out <= 'b0;
            end
        else
            begin
                pixel_out <= gradsq[15:8];
            end
    end
endmodule

module counter #(WIDTH = 16) (
    input clk,
    input rst,
    input start,
    input enable,
    input [(WIDTH-1):0] endvalue,
    output [(WIDTH-1):0] count,
    output logic near_end,
    output logic on_edge
);

    logic [(WIDTH-1):0] count_val;

    always @(posedge clk) begin
        if (rst == 1'b1)
            begin
                count_val = 'b0;
                near_end = 1'b0;
            end
        else if (start == 1'b1)
            begin
                count_val = 'b0;
                near_end = 1'b0; // assuming that endvalue > 1
            end
        else if (enable == 1'b1 && count_val < endvalue)
        begin
            near_end = (count_val == (endvalue - 2))?1'b1:1'b0;
            count_val += 1;
        end
    end;

    assign count = count_val;

    always @(count, endvalue) begin
        if (count == 0 || count == endvalue)
            on_edge = 1'b1;
        else
            on_edge = 1'b0;
    end

endmodule
