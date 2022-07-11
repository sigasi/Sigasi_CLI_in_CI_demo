module dut_top(
    input        clk, // core clock
    input        rst, // system reset
    input        start, // start DUT (pulse)
    input [11:0] size_x, // image width
    input [11:0] size_y, // image height
    input  [7:0] pixel_in, // pixel in (streaming input)
    output [7:0] pixel_out, // pixel out (streaming output)
    output       pixel_valid // indicates that the output pixel is valid
)

    wire [7:0] pixel_pp;
    wire [7:0] pixel_p0;
    wire [7:0] pixel_pm;
    wire [7:0] pixel_0p;
    wire [7:0] pixel_0m;
    wire [7:0] pixel_mp;
    wire [7:0] pixel_m0;
    wire [7:0] pixel_mm;
    wire start_x;
    wire enable_x;
    wire near_end_x;
    wire start_y;
    wire enable_y;
    wire near_end_y;
    wire idle;
    wire on_edge_x;
    wire on_edge_y;
    wire on_edge_xy;
    wire [15:0] count_x;
    wire [15:0] endval_x;
    wire [15:0] count_y;
    wire [15:0] endval_y;
    localparam extra_at_start = 1'b0;

    counter counter_x_instance (
        .clk(clk),
        .rst(rst),
        .start(start_x),
        .enable(enable_x),
        .endvalue(endval_x),
        .count(count_x),
        .near_end(near_end_x),
        .on_edge(on_edge_x)
    );

    assign endval_x = size_x - 1;
    assign endval_y = size_y - 1;
    assign on_edge_xy = on_edge_x | on_edge_y;

    counter counter_y_instance (
        .clk(clk),
        .rst(rst),
        .start(start_y),
        .enable(enable_y),
        .endvalue(endval_y),
        .count(count_y),
        .near_end(near_end_y),
        .on_edge(on_edge_y)
    );

    dut_engine dut_engine_instance (
        .clk(clk),
        .rst(rst),
        .start(start),
        .extra_at_start(extra_at_start),
        .start_x(start_x),
        .enable_x(enable_x),
        .near_end_x(near_end_x),
        .start_y(start_y),
        .enable_y(enable_y),
        .near_end_y(near_end_y),
        .pixel_valid(pixel_valid),
        .idle(idle)
    );

    dut_core dut_core_instance (
        .pixel_out(pixel_out),
        .pixel_pp(pixel_pp),
        .pixel_p0(pixel_p0),
        .pixel_pm(pixel_pm),
        .pixel_0p(pixel_0p),
        .pixel_0m(pixel_0m),
        .pixel_mp(pixel_mp),
        .pixel_m0(pixel_m0),
        .pixel_mm(pixel_mm),
        .on_edge(on_edge_xy),
        .clock(clk),
        .reset(rst)
    );

    pixelbuffer pixelbuffer_instance (
        .clk(clk),
        .rst(rst),
        .size_x(size_x),
        .pixel_in(pixel_in),
        .pixel_in_valid(1'b1),
        .pixel_pp(pixel_pp),
        .pixel_p0(pixel_p0),
        .pixel_pm(pixel_pm),
        .pixel_0p(pixel_0p),
        .pixel_0m(pixel_0m),
        .pixel_mp(pixel_mp),
        .pixel_m0(pixel_m0),
        .pixel_mm(pixel_mm)
    );

endmodule
