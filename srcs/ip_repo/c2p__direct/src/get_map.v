`timescale 1ns / 1ps

module get_map
    #(  parameter NO_ARM_LED = 32,
        parameter NO_DELTA_INTERVALS = 16, //180,
        parameter MDIM = 8,//64, //////////////////////// MUST BE POWER OF 2
        parameter MDIM2 = MDIM * MDIM,
        parameter MAP_ENTRY_SIZE = 8 * 2,
        parameter RGB_SIZE = 8,
        parameter MAP_DIM = NO_DELTA_INTERVALS * NO_ARM_LED * MAP_ENTRY_SIZE,
        parameter OUT_DIM = NO_DELTA_INTERVALS * NO_ARM_LED * RGB_SIZE,
        
        parameter BRAM_BASE_ADDR = 'h00000000,
        parameter BRAM_ADDR_OFF  = 16000,

        // Width of S_AXI data bus
        parameter DATA_WIDTH = 32,
        // Width of S_AXI address bus
        parameter ADDR_WIDTH = 32 )
    (
        input                               clock,
        input                               resetn,
        input  [(MDIM2 * RGB_SIZE)-1:0]     inp_image,
        input  [(MAP_DIM)-1:0]              map,
        input                               inp_valid,
        output [(OUT_DIM)-1:0]              out_image,
        output wire                         out_valid
    );

    // map: 64 x 64 matrix, two entires per element, 8 bits per entry
    // inp_image: 64x64 bit image, RGB 24 bit per pixel, indexed from bottom left upwards
    // out_image: 64x64 bit image, sorted such that each row (_ bits) has pixel pos from centre outwards

    reg [OUT_DIM-1:0] tmp_out;
    reg tmp_valid;
    // reg o_valid;
    //  reg [7:0] x;
    //  reg [7:0] y;

    reg [13:0] i;
    integer idx;

    // set tmp_out
    always @ (posedge clock) begin
        if ( ~resetn ) begin
             tmp_out   = 0;
             tmp_valid = 0;
        end
        else if (inp_valid && ~tmp_valid) begin
            // do mapping
            for (i=0; i<(NO_DELTA_INTERVALS * NO_ARM_LED); i=i+1) begin
                // x = map[i * MAP_ENTRY_SIZE+:8];
                // y = map[(i * MAP_ENTRY_SIZE + 8)+:8];
//                if (i==0) begin $display("x: %8d y: %8d\n", x, y); end
                idx = (map[i * MAP_ENTRY_SIZE+:8] * MDIM + map[(i * MAP_ENTRY_SIZE + 8)+:8]) * MAP_ENTRY_SIZE;
                // write to temp reg
                tmp_out[i * RGB_SIZE +: RGB_SIZE] = inp_image[idx +: RGB_SIZE];                
            end
//            $display("tmp_out: %h\n", tmp_out);
            tmp_valid = 1;
        end
    end

    // assign out_image and out_valid
    assign out_image = tmp_out;
    assign out_valid = tmp_valid;

endmodule