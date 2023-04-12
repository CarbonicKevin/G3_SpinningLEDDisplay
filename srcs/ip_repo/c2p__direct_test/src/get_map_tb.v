`timescale 1ns / 1ps

module get_map_tb
    #(  parameter NO_ARM_LED = 32,
        parameter NO_DELTA_INTERVALS = 180,
        parameter MDIM = 5,//64,
        parameter MDIM2 = MDIM * MDIM,//64 * 64,
        parameter MAP_ENTRY_SIZE = 8 * 2,
        parameter RGB_SIZE = 24 )
    ();

    reg  clk;
    reg  reset;
    reg  [(MDIM2 * RGB_SIZE)-1:0] inp_image;
    reg  [(MDIM2 * MAP_ENTRY_SIZE)-1:0] map;
    reg  inp_valid;
    wire out_valid;
    wire [(MDIM2 * RGB_SIZE)-1:0] out_image;

    get_map CUT (.clk(clk), .reset(reset), .inp_image(inp_image), .map(map), .inp_valid(inp_valid), .out_image(out_image), .out_valid(out_valid));

    initial
    begin
//        map[MDIM2*(MAP_ENTRY_SIZE)-1+:MAP_ENTRY_SIZE] = 0;
        map = 0;
        inp_image = 0;
        reset = 1;
        inp_valid = 0;
        #10
        reset = 0;
        #1 inp_valid = 1;
        #1
        $display("inp_image = %h\n", inp_image);
        $display("out_image = %h\n", out_image);
        #1
        inp_image = 0'hFFFFFFFF;
        //for (i=0; i < MDIM*2; i=i+1) begin inp_image[i] = 1; end
        // for (i=MDIM * 32; i < MDIM * 33; i=i+1) begin inp_image[i] = 1; end
        // for (i=MDIM * 24; i < MDIM * 25; i=i+1) begin inp_image[i] = 1; end
        // for (i=MDIM * 40; i < MDIM * 41; i=i+1) begin inp_image[i] = 1; end
        #10
        $display("inp_image = %h\n", inp_image);
        $display("out_image = %h\n", out_image);
    end

    initial
    begin
    
        clk = 1;
        while(1) begin
            #1 clk = ~clk;
        end
    
    end

endmodule
