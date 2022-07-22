module dut_engine (
    input clk,
    input rst,
    input start,
    input extra_at_start,
    output logic start_x,
    output logic enable_x,
    input near_end_x,
    output logic start_y,
    output logic enable_y,
    input near_end_y,
    output logic pixel_valid,
    output logic idle
);

    typedef enum {waiting, startup_row1, startup_row2, calculate, finish_row_1, finish_row_2} states_t;
    states_t state

    always @(posedge clk) begin
        if (rst == 1'b1)
            begin
                state = waiting;
                start_x = 1'b0;
                enable_x = 1'b0;
                start_y = 1'b0;
                enable_y = 1'b0;
                pixel_valid = 1'b0;
            end else
            begin
                case (state)

                    waiting : begin
                        start_x = 1'b0;
                        enable_x = 1'b0;
                        start_y = 1'b0;
                        enable_y = 1'b0;
                        pixel_valid = 1'b0;

                        if (start == 1'b1) begin
                            state = startup_row1; // received start
                            start_x = 1'b1;
                            enable_x = 1'b1;
                        end
                    end

                    startup_row1 : begin
                        start_x = 1'b0;
                        if (near_end_x == 1'b1) begin
                            start_x = 1'b1;
                            if (extra_at_start == 1'b1) begin
                                state = startup_row2; // extra line at start
                            end
                            else begin
                                state = calculate;
                            end
                        end
                    end

                    startup_row2 : begin
                        start_x = 1'b0;
                        if (near_end_x == 1'b1) begin
                            state = calculate;
                            start_x = 1'b1;
                            start_y = 1'b1;
                            enable_y = 1'b1;
                        end
                    end

                    calculate: begin
                        start_x = 1'b0;
                        start_y = 1'b0;
                        enable_y = 1'b0;
                        pixel_valid = 1'b1;
                        if (near_end_x == 1'b1) begin
                            start_x = 1'b1;
                            enable_y = 1'b1;
                        end
                        if (near_end_y == 1'b1 && near_end_x == 1'b1) begin
                            state = finish_row_1; // main calculation done
                            start_x = 1'b1;
                            enable_y = 1'b1;
                        end
                    end

                    finish_row_1 : begin
                        start_x = 1'b0;
                        enable_y = 1'b0;
                        if (near_end_x == 1'b1) begin
                            if (extra_at_start == 1'b0) begin
                                state = finish_row_2; // extra line at end
                                start_x = 1'b1;
                            end
                            else begin
                                enable_x = 1'b0;
                                pixel_valid = 1'b0;
                                state = waiting; // all done
                            end
                        end
                    end

                    finish_row_2 : begin
                        start_x = 1'b0;
                        if (near_end_x == 1'b1) begin
                            enable_x = 1'b0;
                            pixel_valid = 1'b0;
                            state = waiting; // edit the label
                        end
                    end
                endcase
            end
    end

    assign idle = (state == waiting);

endmodule
