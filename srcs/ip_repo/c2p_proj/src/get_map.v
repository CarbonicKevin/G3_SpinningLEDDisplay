`timescale 1ns / 1ps

module get_map
    #(  parameter NO_ARM_LED = 32,
        parameter NO_DELTA_INTERVALS = 18, //180,
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
        // input [ADDR_WIDTH-1:0]              BRAM_WRITE_ADDR,
        input [(MDIM2 * RGB_SIZE)-1:0]      inp_image,
        input [(MAP_DIM)-1:0]               map,
        input                               inp_valid,
        output [(OUT_DIM)-1:0]              out_image,
        output wire                         out_valid


        // //// Master AXI Interface

        // // Write Address Channel
        // output reg  [ADDR_WIDTH-1:0] m_axi_awaddr,
        // output wire                  m_axi_awvalid,
        // input  wire                  m_axi_awready,
        
        // // Write Data Channel
        // output reg  [ DATA_WIDTH   -1:0] m_axi_wdata,
        // output wire [(DATA_WIDTH/8)-1:0] m_axi_wstrb,
        // output wire                      m_axi_wvalid,
        // input  wire                      m_axi_wready,

        // // Write Response Channel
        // input  wire [1:0] m_axi_bresp,
        // input  wire       m_axi_bvalid,
        // output wire       m_axi_bready
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

//     // set access permissions
//     assign awprot = 3'b010;
//     assign arprot = 3'b010;

//    //// Master AXI Interface - send data to LED driver

//    assign m_axi_wstrb = 4'b1111;
//    reg M_AXI_AWVALID;
//    reg M_AXI_WVALID;
//    reg M_AXI_BREADY;

//    assign m_axi_awvalid = M_AXI_AWVALID;
//    assign m_axi_wvalid  = M_AXI_WVALID;
//    assign m_axi_bready  = M_AXI_BREADY;

//    // master interface States
// 	parameter
// 		MASTER_I = 1'b0,  // Idle
// 		MASTER_W = 1'b1;  // Writing
// 	reg master_state;

// 	// state transition conditionals
// 	wire m_idle_to_write;
// 	wire m_write_to_idle;
// 	assign m_idle_to_write = tmp_valid && (master_state == MASTER_I); // start writing once map is complete
// 	assign m_write_to_idle = m_axi_bready;

//     // // tracking number of bit shifts in sending data
//     // reg [7:0] bit_shft_cnt;
//     // parameter MAX_BIT_SHFT = 'd2; //'d3072; // max num bit shifts for sending data
 	
// 	// master_state generator
// 	always @(posedge clock) begin
		
// 		// reset master_state
// 		if ( ~resetn ) begin
// 			master_state <= MASTER_I;
// 		end

// 		// transition state from idle to write
// 		else if ( m_idle_to_write ) begin
// 			master_state <= MASTER_W;
// 		end

// 		// tarnsition state from write to idle

// 		else if ( m_write_to_idle ) begin
// 			master_state <= MASTER_I;
// 		end

// 		else begin
// 			master_state <= master_state;
// 		end

// 	end

// 	// master awvalid generator
// 	always @(posedge clock) begin

// 		// reset awvalid
// 		if ( ~resetn ) M_AXI_AWVALID <= 0;
		
// 		// if idle->write condition is met, set to valid
// 		else if ( m_idle_to_write ) M_AXI_AWVALID <= 1;

// 		// if awvalid and awready
// 		else if ( M_AXI_AWVALID & m_axi_awready ) M_AXI_AWVALID <= 0;

// 		// any other case
// 		else M_AXI_AWVALID <= M_AXI_AWVALID;

// 	end

// 	// master wvalid generator
// 	always @(posedge clock) begin

// 		// reset wvalid
// 		if ( ~resetn ) M_AXI_WVALID <= 0;

// 		// if idle->write condition is met, set to valid
// 		else if ( m_idle_to_write ) M_AXI_WVALID <= 1;

// 		else if ( M_AXI_WVALID & m_axi_wready ) M_AXI_WVALID <= 0; 

// 		// any other case
// 		else M_AXI_WVALID <= M_AXI_WVALID;

// 	end

// 	// master bready generator
// 	always @(posedge clock) begin

// 		// reset wvalid
// 		if ( ~resetn ) M_AXI_BREADY <= 0;

// 		// if idle->write condition is met, set to valid
// 		else if ( m_axi_bvalid && ~M_AXI_BREADY ) M_AXI_BREADY <= 1;

// 		// de-assert after a cycle
// 		else if ( M_AXI_BREADY ) M_AXI_BREADY <= 0;

// 		// any other case
// 		else M_AXI_BREADY <= M_AXI_BREADY;

// 	end

//     assign m_reg_wren = (~M_AXI_WVALID) && (~M_AXI_AWVALID) && inp_valid && (~out_valid) && (tmp_valid);
//     // reg [14:0] idx;
//     // genvar i;
//     // genvar g;

//     // generate
//     //     for (g=0; g<(MDIM2); g=g+1) begin
//             // set idx value
//             // always @(posedge clock) begin
//             //     // idx <= (((map[i << $clog2(MAP_ENTRY_SIZE) +:8] << $clog2(MDIM)) + map[((i << $clog2(MAP_ENTRY_SIZE)) + 8)+:8]) << $clog2(MAP_ENTRY_SIZE));
//             // end

//             // update out_valid
//             always @(posedge clock) begin
//                 // reset
//                 if ( ~resetn ) begin
//                     out_valid <= 0;
//                 end
//                 else begin
//                     if      ( ~inp_valid )                              out_valid <= 0;
//                     else if (i == NO_DELTA_INTERVALS * NO_ARM_LED-1)    out_valid <= 1;
//                 end
//             end

//             // assigning awaddr
//             always @(posedge clock) begin
//                 // reset
//                 if ( ~resetn ) begin
//                     m_axi_awaddr <= BRAM_WRITE_ADDR;
//                 end
//                 else begin
//                     if ( m_reg_wren )
//                     begin
//                         m_axi_awaddr[ADDR_WIDTH-1:0] <= m_axi_awaddr + RGB_SIZE; //BRAM_WRITE_ADDR + g * RGB_SIZE;
//                     end
//                 end
//             end

//             // assigning wdata
//             always @(posedge clock) begin
//                 // reset
//                 if ( ~resetn ) begin
//                     m_axi_wdata <= 0;
//                 end
//                 else begin
//                     if ( m_reg_wren )
//                     begin
//                         m_axi_wdata[RGB_SIZE-1:0] <= tmp_out[0 +: RGB_SIZE];
//                         tmp_out[0 +: ((RGB_SIZE-1) * NO_DELTA_INTERVALS * NO_ARM_LED)] <= tmp_out[RGB_SIZE +: ((RGB_SIZE-1) * NO_DELTA_INTERVALS * NO_ARM_LED)];
//                     end
//                 end
//             end

//         // end
//     // endgenerate

//     // // update out_valid
//     // always @(posedge clock) begin
//     //     // reset
// 	// 	if ( ~resetn ) begin
//     //         out_valid <= 0;
//     //     end
//     //     else begin
//     //         if      (~inp_valid)    out_valid <= 0;
//     //         else if (i == MDIM2)    out_valid <= 1; /////// or MDIM2 - 1?
//     //     end
//     // end

//     // incrementing counter
//     always @(posedge clock) begin
//         // reset
// 		if ( ~resetn ) begin
//             i <= 0;
//         end
//         else if ( m_reg_wren ) begin
//             i <= i + 1;
//         end
//         else if ( ~tmp_valid ) begin
//             i <= 0;
//         end
//         else begin
//             i <= i;
//         end
//     end

//     // integer idx = (map[i << $clog2(MAP_ENTRY_SIZE) +:8] << $clog2(MDIM) + map[((i << $clog2(MAP_ENTRY_SIZE)) + 8)+:8]) << $clog2(MAP_ENTRY_SIZE);

//     // // assigning awaddr
//     // always @(posedge clock) begin
//     //     // reset
// 	// 	if ( ~resetn ) begin
//     //         m_axi_awaddr <= BRAM_WRITE_ADDR;
//     //     end
//     //     else begin
//     //         if ( m_reg_wren )
//     //         begin
//     //             m_axi_awaddr[ADDR_WIDTH-1:0] <= BRAM_WRITE_ADDR + idx;
//     //         end
//     //     end
//     // end

//     // // assigning wdata
//     // always @(posedge clock) begin
//     //     // reset
// 	// 	if ( ~resetn ) begin
//     //         m_axi_wdata <= 0;
//     //     end
//     //     else begin
//     //         if ( m_reg_wren )
//     //         begin
//     //             m_axi_wdata[RGB_SIZE-1:0] <= inp_image[idx :+ RGB_SIZE];
//     //         end
//     //     end
//     // end

//     // reg [1:0] edge_detector_out_valid;

//     // // m_out_img generator
//     // always @(posedge clock) begin
//     //     // reset
// 	// 	if ( ~resetn ) begin
//     //         m_out_img <= 0;
//     //     end
//     //     else if ((edge_detector_out_valid[0] == 'b0) && (edge_detector_out_valid[1] == 'b1)) begin
//     //         m_out_img <= out_image;
//     //     end
//     //     else if ( m_reg_wren ) begin
//     //         m_out_img[(MDIM2*MAP_ENTRY_SIZE-1-32):0] <= m_out_img[(MDIM2*MAP_ENTRY_SIZE-1):32];
//     //     end
//     //     else begin
//     //         m_out_img <= m_out_img;
//     //     end
//     // end

//     // // edge_detector_out_valid generator
//     // always @(posedge clock) begin
//     //     // reset
// 	// 	if ( ~resetn ) begin
//     //         edge_detector_out_valid <= 0;
//     //     end
//     //     else begin
//     //         edge_detector_out_valid[0] <= edge_detector_out_valid[1];
//     //         edge_detector_out_valid[1] <= out_valid;
//     //     end
//     // end

endmodule