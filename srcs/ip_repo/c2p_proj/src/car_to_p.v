`timescale 1ns / 1ps

module car_to_p
    #(
        parameter NO_ARM_LED = 32,
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
        parameter ADDR_WIDTH = 32
    )

    (
        input wire clock,
        input wire resetn,

        //// AXI-Lite slave 1 interface
        input [31:0]  s1_axi_awaddr,
        input         s1_axi_awvalid,
        output        s1_axi_awready,

        input [31:0]  s1_axi_wdata,
        input [3:0]   s1_axi_wstrb,
        input         s1_axi_wvalid,
        output        s1_axi_wready,

        output [1:0]  s1_axi_bresp,
        output        s1_axi_bvalid,
        input         s1_axi_bready,

        input [31:0]  s1_axi_araddr,
        input         s1_axi_arvalid,
        output        s1_axi_arready,

        output [31:0] s1_axi_rdata,
        output [1:0]  s1_axi_rresp,
        output        s1_axi_rvalid,
        input         s1_axi_rready,

        //// AXI-Lite slave 2 interface
        input [31:0]  s2_axi_awaddr,
        input         s2_axi_awvalid,
        output        s2_axi_awready,

        input [31:0]  s2_axi_wdata,
        input [3:0]   s2_axi_wstrb,
        input         s2_axi_wvalid,
        output        s2_axi_wready,

        output [1:0]  s2_axi_bresp,
        output        s2_axi_bvalid,
        input         s2_axi_bready,

        input [31:0]  s2_axi_araddr,
        input         s2_axi_arvalid,
        output        s2_axi_arready,

        output [31:0] s2_axi_rdata,
        output [1:0]  s2_axi_rresp,
        output        s2_axi_rvalid,
        input         s2_axi_rready,

        //// Master AXI Interface

        // Write Address Channel
        output reg  [ADDR_WIDTH-1:0] m_axi_awaddr,
        output wire                  m_axi_awvalid,
        input  wire                  m_axi_awready,
        
        // Write Data Channel
        output reg  [ DATA_WIDTH   -1:0] m_axi_wdata,
        output wire [(DATA_WIDTH/8)-1:0] m_axi_wstrb,
        output wire                      m_axi_wvalid,
        input  wire                      m_axi_wready,

        // Write Response Channel
        input  wire [1:0] m_axi_bresp,
        input  wire       m_axi_bvalid,
        output wire       m_axi_bready

        // // Read Address Channel
        // output wire [ADDR_WIDTH-1:0] m_axi_araddr,
        // output wire                  m_axi_arvalid,
        // input  wire                  m_axi_arready,

        // // Read Data Channel
        // input  wire [DATA_WIDTH-1:0] m_axi_rdata,
        // input  wire [           1:0] m_axi_rresp,
        // input  wire                  m_axi_rvalid,
        // output wire                  m_axi_rready
    );

    wire inp1_valid;
    wire inp2_valid;
    wire inp_valid;
    assign inp_valid = inp1_valid && inp2_valid;
    wire [(MDIM2 * RGB_SIZE)-1:0]   inp_image;
    wire [(MAP_DIM)-1:0]            map;

    wire out_valid;

    reg  [ADDR_WIDTH-1:0] BRAM_WRITE_ADDR;
    wire [(OUT_DIM) -1:0] out_image;

    reg  [(OUT_DIM) -1:0] m_out_img;

    integer	byte_index;

    wire [2:0]  awprot;
    wire [2:0]  arprot;

    // slave1 - get map and w_addr from microblaze
    slave_ip_v1_0 slave1(
        .map(map),
        // .inp_image(inp_image),
        // .w_addr(m_axi_awaddr),
        .inp1_valid(inp1_valid),
        .s00_axi_aclk(clock),
        .s00_axi_aresetn(resetn),
        .s00_axi_awaddr(s1_axi_awaddr),
        .s00_axi_awprot(awprot),
        .s00_axi_awvalid(s1_axi_awvalid),
        .s00_axi_awready(s1_axi_awready),
        .s00_axi_wdata(s1_axi_wdata),
        .s00_axi_wstrb(s1_axi_wstrb),
        .s00_axi_wvalid(s1_axi_wvalid),
        .s00_axi_wready(s1_axi_wready),
        .s00_axi_bresp(s1_axi_bresp),
        .s00_axi_bvalid(s1_axi_bvalid),
        .s00_axi_bready(s1_axi_bready),
        .s00_axi_araddr(s1_axi_araddr),
        .s00_axi_arprot(arprot),
        .s00_axi_arvalid(s1_axi_arvalid),
        .s00_axi_arready(s1_axi_arready),
        .s00_axi_rdata(s1_axi_rdata),
        .s00_axi_rresp(s1_axi_rresp),
        .s00_axi_rvalid(s1_axi_rvalid),
        .s00_axi_rready(s1_axi_rready)
    );

    // slave2 - get inp_image from SD card block
    slave_ip_v2_0 slave2(
        .inp_image(inp_image),
        .inp2_valid(inp2_valid),
        .s00_axi_aclk(clock),
        .s00_axi_aresetn(resetn),
        .s00_axi_awaddr(s2_axi_awaddr),
        .s00_axi_awprot(awprot),
        .s00_axi_awvalid(s2_axi_awvalid),
        .s00_axi_awready(s2_axi_awready),
        .s00_axi_wdata(s2_axi_wdata),
        .s00_axi_wstrb(s2_axi_wstrb),
        .s00_axi_wvalid(s2_axi_wvalid),
        .s00_axi_wready(s2_axi_wready),
        .s00_axi_bresp(s2_axi_bresp),
        .s00_axi_bvalid(s2_axi_bvalid),
        .s00_axi_bready(s2_axi_bready),
        .s00_axi_araddr(s2_axi_araddr),
        .s00_axi_arprot(arprot),
        .s00_axi_arvalid(s2_axi_arvalid),
        .s00_axi_arready(s2_axi_arready),
        .s00_axi_rdata(s2_axi_rdata),
        .s00_axi_rresp(s2_axi_rresp),
        .s00_axi_rvalid(s2_axi_rvalid),
        .s00_axi_rready(s2_axi_rready)
    );

    assign inp_image = 0; //////////////////////////////////// VERY TMP

    get_map m ( 
        .clock(clock),
        .resetn(resetn),
        // .BRAM_WRITE_ADDR(BRAM_WRITE_ADDR),
        .inp_image(inp_image),
        .map(map),
        .inp_valid(inp1_valid),//////////////////////////////////// VERY TMP
        .out_image(out_image),
        .out_valid(out_valid)
        // .m_axi_awaddr(m_axi_awaddr),
        // .m_axi_awvalid(m_axi_awvalid),
        // .m_axi_awready(m_axi_awready),
        // .m_axi_wdata(m_axi_wdata),
        // .m_axi_wstrb(m_axi_wstrb),
        // .m_axi_wvalid(m_axi_wvalid),
        // .m_axi_wready(m_axi_wready),
        // .m_axi_bresp(m_axi_bresp),
        // .m_axi_bvalid(m_axi_bvalid),
        // .m_axi_bready(m_axi_bready)
    );

    // toggle BRAM write address
    always @(posedge out_valid) begin
        // reset
        if ( ~resetn ) begin
            BRAM_WRITE_ADDR <= BRAM_BASE_ADDR;
        end
        
        // switch between base address and base + offset
        else begin
            if ( BRAM_WRITE_ADDR == BRAM_BASE_ADDR ) BRAM_WRITE_ADDR <= BRAM_BASE_ADDR + BRAM_ADDR_OFF;
            else                                     BRAM_WRITE_ADDR <= BRAM_BASE_ADDR;
        end
    end

    // assigning awaddr
    always @(posedge clock) begin
        // reset
        if ( ~resetn ) begin
            m_axi_awaddr <= BRAM_WRITE_ADDR;
        end
        else begin
            if ( m_reg_wren )
            begin
                m_axi_awaddr[ADDR_WIDTH-1:0] <= m_axi_awaddr + RGB_SIZE; //BRAM_WRITE_ADDR + g * RGB_SIZE;
            end
        end
    end

    // set access permissions
    assign awprot = 3'b010;
    assign arprot = 3'b010;

   //// Master AXI Interface - send data to LED driver

   assign m_axi_wstrb = 4'b1111;
   reg M_AXI_AWVALID;
   reg M_AXI_WVALID;
   reg M_AXI_BREADY;

   assign m_axi_awvalid = M_AXI_AWVALID;
   assign m_axi_wvalid  = M_AXI_WVALID;
   assign m_axi_bready  = M_AXI_BREADY;

   // master interface States
	parameter
		MASTER_I = 1'b0,  // Idle
		MASTER_W = 1'b1;  // Writing
	reg master_state;

	// state transition conditionals
	wire m_idle_to_write;
	wire m_write_to_idle;
	assign m_idle_to_write = out_valid && (master_state == MASTER_I); // start writing once map is complete
	assign m_write_to_idle = m_axi_bready;

    // tracking number of bit shifts in sending data
    reg [7:0] bit_shft_cnt;
    parameter MAX_BIT_SHFT = 'd2; //'d3072; // max num bit shifts for sending data
 	
	// master_state generator
	always @(posedge clock) begin
		
		// reset master_state
		if ( ~resetn ) begin
			master_state <= MASTER_I;
		end

		// transition state from idle to write
		else if ( m_idle_to_write ) begin
			master_state <= MASTER_W;
		end

		// tarnsition state from write to idle

		else if ( m_write_to_idle ) begin
			master_state <= MASTER_I;
		end

		else begin
			master_state <= master_state;
		end

	end

	// master awvalid generator
	always @(posedge clock) begin

		// reset awvalid
		if ( ~resetn ) M_AXI_AWVALID <= 0;
		
		// if idle->write condition is met, set to valid
		else if ( m_idle_to_write ) M_AXI_AWVALID <= 1;

		// if awvalid and awready
		else if ( M_AXI_AWVALID & m_axi_awready ) M_AXI_AWVALID <= 0;

		// any other case
		else M_AXI_AWVALID <= M_AXI_AWVALID;

	end

	// master wvalid generator
	always @(posedge clock) begin

		// reset wvalid
		if ( ~resetn ) M_AXI_WVALID <= 0;

		// if idle->write condition is met, set to valid
		else if ( m_idle_to_write ) M_AXI_WVALID <= 1;

		else if ( M_AXI_WVALID & m_axi_wready ) M_AXI_WVALID <= 0; 

		// any other case
		else M_AXI_WVALID <= M_AXI_WVALID;

	end

	// master bready generator
	always @(posedge clock) begin

		// reset wvalid
		if ( ~resetn ) M_AXI_BREADY <= 0;

		// if idle->write condition is met, set to valid
		else if ( m_axi_bvalid && ~M_AXI_BREADY ) M_AXI_BREADY <= 1;

		// de-assert after a cycle
		else if ( M_AXI_BREADY ) M_AXI_BREADY <= 0;

		// any other case
		else M_AXI_BREADY <= M_AXI_BREADY;

	end

    // assigning wdata

    assign m_reg_wren = out_valid && (~M_AXI_WVALID) && (~M_AXI_AWVALID);

    always @(posedge clock) begin
        // reset
		if ( ~resetn ) begin
            m_axi_wdata <= 0;
        end
        else begin
            if ( m_reg_wren )
            begin
                for ( byte_index = 0; byte_index <= (DATA_WIDTH/8)-1; byte_index = byte_index+1 ) 
                begin
                    if ( m_axi_wstrb[byte_index] == 1 ) begin
                        m_axi_wdata[(byte_index*8) +: 8] <= m_out_img[(byte_index*8) +: 8];
                    end
                end
            end
        end
    end

    // tracking num bit shift in data sent
    always @(posedge clock) begin
        // reset to 0
        if ( ~resetn ) begin
            bit_shft_cnt <= 0;
        end

        // increment num bit shifts when data is being written
        else if ( m_reg_wren ) begin
            if (bit_shft_cnt == MAX_BIT_SHFT) begin
                bit_shft_cnt <= 0;
            end
            else begin
                bit_shft_cnt <= bit_shft_cnt + 1;
            end
        end
    end

    reg [1:0] edge_detector_out_valid;

    // m_out_img generator
    always @(posedge clock) begin
        // reset
		if ( ~resetn ) begin
            m_out_img <= 0;
        end
        else if ((edge_detector_out_valid[0] == 'b0) && (edge_detector_out_valid[1] == 'b1)) begin
            m_out_img <= out_image;
        end
        else if ( m_reg_wren ) begin
            m_out_img[(OUT_DIM-1-32):0] <= m_out_img[(OUT_DIM-1):32];
        end
        else begin
            m_out_img <= m_out_img;
        end
    end

    // edge_detector_out_valid generator
    always @(posedge clock) begin
        // reset
		if ( ~resetn ) begin
            edge_detector_out_valid <= 0;
        end
        else begin
            edge_detector_out_valid[0] <= edge_detector_out_valid[1];
            edge_detector_out_valid[1] <= out_valid;
        end
    end

endmodule