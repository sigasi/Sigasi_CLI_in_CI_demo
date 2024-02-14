// Module pixel_testbench implements a first testbench for the design under test.

module pixel_testbench();
    logic clk;
    reg rst; // @suppress "'logic' should be used instead of 'reg'"
    reg start; // @suppress "'logic' should be used instead of 'reg'"

    logic [11:0] size_x = 40, size_y = 40;
    logic [23:0] count;
    typedef enum {IDLE, RUNNING, READY} t_feeder_states;
    t_feeder_states feeder_state;
    // Feed data into the DUT
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            feeder_state = ID LE;
            pixel_in = 0;
            count = 0;
        end
        else begin
            pixel_in = 0;
            case (feeder_state)
                IDLE:
                if (start) begin
                    feeder_state = RUNNING;
                    pixel_in = input_pixel;
                    count = 1;
                end
                RUNNING:
                if (count < size_x * size_y) begin
                    pixel_in = input_pixel;
                    count += 1;
                end
                else
                    feeder_state = READY;
                    //default : feeder_state = IDLE;
                READY: begin
                    $display("All done");
                    feeder_state = IDLE;
                end
            endcase
        end
    end

    dut_top dut_top_instance (
        .clk(clk),
        .rst(rst),
        .start(start),
        .size_x(size_x),
        .size_y(size_y),
        .pixel_in(pixel_in),
        .pixel_out(pixel_out),
        .pixel_valid(pixel_valid)
    );

    // Clock generator
    always #5 begin
        clk = ~clk;
    end

    // Drive `reset` and `start`
    drive_rst_start drive_rst_start_instance (
        .rst(rst),
        .start(start)
    );

endmodule
