module dd_axi_slave

# (

    // Width of S_AXI data bus
    parameter DATA_WIDTH = 32,
    // Width of S_AXI address bus
    parameter ADDR_WIDTH = 32,

    // register array dimensions
    parameter N_ARMS = 4,       // number of arms
    parameter N_LEDS = 32,      // number of LEDs per armm
    parameter N_ANGLES = 16     // number of angles (rows of LED values)

)

(

    input wire S_AXI_ACLK,
    input wire S_AXI_ARESETN,

    // Write Address Channel
    input  wire [ADDR_WIDTH-1:0] S_AXI_AWADDR,
    input  wire                  S_AXI_AWVALID,
    output wire                  S_AXI_AWREADY,
    
    // Write Data Channel
    input  wire [ DATA_WIDTH   -1:0] S_AXI_WDATA,
    input  wire [(DATA_WIDTH/8)-1:0] S_AXI_WSTRB,
    input  wire                      S_AXI_WVALID,
    output wire                      S_AXI_WREADY,

    // Write Response Channelnext_angle
    output wire [1:0] S_AXI_BRESP,
    output wire       S_AXI_BVALID,
    input  wire       S_AXI_BREADY,

    // Read Address Channel
    input  wire [ADDR_WIDTH-1:0] S_AXI_ARADDR,
    input  wire                  S_AXI_ARVALID,
    output wire                  S_AXI_ARREADY,

    // Read Data Channel
    output wire [DATA_WIDTH-1:0] S_AXI_RDATA,
    output wire [           1:0] S_AXI_RRESP,
    output wire                  S_AXI_RVALID,
    input  wire                  S_AXI_RREADY,

    output wire [DATA_WIDTH-1:0] CONFIG_REGISTER,
    output wire [(N_ARMS*N_LEDS*6)-1:0] LED_DATA,
    output wire LED_RESET
    
);

    // AXI4LITE signals
    reg [ ADDR_WIDTH-1:0] axi_awaddr;
    reg                   axi_awready;
    reg                   axi_wready;
    reg [            1:0] axi_bresp;
    reg                   axi_bvalid;
    reg [ ADDR_WIDTH-1:0] axi_araddr;
    reg                   axi_arready;
    reg [ DATA_WIDTH-1:0] axi_rdata;
    reg [            1:0] axi_rresp;
    reg                   axi_rvalid;

    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;

    // AXI_AWREADY, aw_en Logic
    reg aw_en; // aw enable - if 0 then processing write
    always @( posedge S_AXI_ACLK ) begin

        // Implement axi_awready generation
        // axi_awready is asserted for one S_AXI_ACLK clock cycle when both
        // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
        // de-asserted when reset is low.

        if ( S_AXI_ARESETN == 1'b0 ) begin
            axi_awready <= 1'b0;
            aw_en <= 1'b1;
        end

        else begin
            if ( ~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en ) begin

                // slave is ready to accept write address when 
                // there is a valid write address and write data
                // on the write address and data bus. This design 
                // expects no outstanding transactions. 

                axi_awready <= 1'b1;
                aw_en <= 1'b0;
            end
            
            else if ( S_AXI_BREADY && axi_bvalid ) begin
                axi_awready <= 1'b0;
                aw_en <= 1'b1;
            end
            
            else begin
                axi_awready <= 1'b0;
                aw_en <= aw_en;
            end
        end 
    end

    // AXI_AWADDR latching
    always @( posedge S_AXI_ACLK ) begin
        if ( S_AXI_ARESETN == 1'b0 ) begin
            axi_awaddr <= 0;
        end
        
        else begin    
            if ( ~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en ) begin 
                axi_awaddr <= S_AXI_AWADDR;
            end
        end 
    end       

    // AXI_WREADY logic
    always @( posedge S_AXI_ACLK ) begin

        // Implement axi_wready generation
        // axi_wready is asserted for one S_AXI_ACLK clock cycle when both
        // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
        // de-asserted when reset is low. 

        if ( S_AXI_ARESETN == 1'b0 ) begin
            axi_wready <= 1'b0;
        end

        else begin    
            if ( ~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en ) begin
                
                // slave is ready to accept write data when 
                // there is a valid write address and write data
                // on the write address and data bus. This design 
                // expects no outstanding transactions. 

                axi_wready <= 1'b1;
            end

            else begin
                axi_wready <= 1'b0;
            end
        end
    end

    // DEFINE CONFIG SPACE
    localparam CONFIG_SIZE = DATA_WIDTH;
    reg [15:00] cur_angle;
    reg [07:00] next_angle;
    reg [07:00] write_done;

    assign CONFIG_REGISTER [31:16] = cur_angle;
    assign CONFIG_REGISTER [15:08] = next_angle;
    assign CONFIG_REGISTER [07:00] = write_done;
    
    assign LED_RESET = S_AXI_ARESETN & ~next_angle;

    // DEFINE WRITE ARRAY - is written to via AXI
    localparam ROW_SIZE   = N_LEDS*6;
    localparam ARRAY_SIZE = N_ANGLES*ROW_SIZE;
    reg [ARRAY_SIZE-1:0] write_array;

    // DEFINE LATCH ARRAY - saves values of write array on read
    reg [ARRAY_SIZE-1:0] latch_array;

    // DEFINE SHIFT ARRAY - is read by LED drivers
    genvar arm_idx;
    genvar led_idx;
    localparam PHASE_OFFSET = N_ANGLES / N_ARMS;
    reg [ARRAY_SIZE-1:0] shift_array;

    // assign LED_DATA output
    for ( arm_idx=0; arm_idx < N_ARMS; arm_idx=arm_idx+2 ) begin
        // assuming data recieved from nikoo are rows of radial strips
        // i.e. if total led len is 64, 32 bit rows per angle, starting from led closest to center
        // need to re-organize leds for correct order

        // first 32 leds need to be reversed in order
        for ( led_idx=0; led_idx < N_LEDS; led_idx=led_idx+1 ) begin
            assign LED_DATA[ (arm_idx*ROW_SIZE)+(led_idx*6) +: 6 ] = shift_array[ ((arm_idx/2)*PHASE_OFFSET*ROW_SIZE)+((N_LEDS-led_idx-1)*6) +: 6 ];
        end

        // opposing phase 32 leds don't need to be reversed
        assign LED_DATA[ ((arm_idx+1)*ROW_SIZE) +: ROW_SIZE ] = shift_array[ ((arm_idx/2)*PHASE_OFFSET*ROW_SIZE)+(ARRAY_SIZE/2) +: ROW_SIZE ];

    end

    // write wires and states
    localparam TRIMED_DATA_WIDTH = DATA_WIDTH-(2*(DATA_WIDTH/8));
    localparam ADDR_LSB = $clog2(DATA_WIDTH/8);
    localparam ADDR_MSB = $clog2((CONFIG_SIZE+DATA_WIDTH)/8);
    wire [ADDR_MSB-1:ADDR_LSB] waddr_data_idx;
    assign waddr_data_idx = axi_awaddr[ADDR_MSB:ADDR_LSB];

    integer byte_idx;

    // Write Handling
    always @( posedge S_AXI_ACLK ) begin
        
        // default values for each clock cycle
        write_done  <= 'b0;
        next_angle  <= 'b0;
        cur_angle   <= cur_angle;
        write_array <= write_array;
        latch_array <= latch_array;
        shift_array <= shift_array;

        // reset
        if ( S_AXI_ARESETN == 1'b0 ) begin
            cur_angle   <= 'b0;
            write_array <= 'b0;
            latch_array <= 'b0;
            shift_array <= 'b0;
        end

        // if write ready
        if ( axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID ) begin
        
            // Handle configuration register writes
            if ( waddr_data_idx == 'b0 ) begin
            
                // write to write_done
                if ( S_AXI_WSTRB[0] && (S_AXI_WDATA[07:00] == 'h01) ) begin
                    write_done <= 'b1;
                    latch_array <= write_array; // latch write array
                    write_array <= 'b0;         // clear write array 
                end
                
                // write to next_angle
                if ( S_AXI_WSTRB[1] && (S_AXI_WDATA[15:08] != 'h00) ) begin

                    next_angle <= S_AXI_WDATA[15:08];

                    // if finished one loop or given sync signal
                    if ( (S_AXI_WDATA[15:12] == 'h1) || (cur_angle >= N_ANGLES-1) ) begin
                        cur_angle   <= 'b0;  // reset cur_angle
                        shift_array <= latch_array;  // shift latch array to read array
                    end

                    // if not finished a loop
                    else begin
                        //  shift shift_array
                        shift_array[ARRAY_SIZE-ROW_SIZE +: ROW_SIZE] <= shift_array[0 +: ROW_SIZE];
                        shift_array[0 +: ARRAY_SIZE-ROW_SIZE] <= shift_array[ROW_SIZE +: ARRAY_SIZE-ROW_SIZE];
                        cur_angle <= cur_angle + 1;
                    end
                end
            end

            // Handle write array writes
            if ( waddr_data_idx == 'b1 ) begin

                // shift array to lsb
                write_array[0 +: ARRAY_SIZE-TRIMED_DATA_WIDTH] <= write_array[TRIMED_DATA_WIDTH +: ARRAY_SIZE-TRIMED_DATA_WIDTH];
                
                // write to msb of array
                for ( byte_idx=0; byte_idx<4; byte_idx=byte_idx + 1 ) begin
                    write_array[ARRAY_SIZE-TRIMED_DATA_WIDTH+(byte_idx*6) +: 6] <= {6{S_AXI_WSTRB[byte_idx]}} & S_AXI_WDATA[(byte_idx*8) +: 6];
                end
            end
        end
    end

    // Implement write response logic generation
    // The write response and response valid signals are asserted by the slave 
    // when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
    // This marks the acceptance of address and indicates the status of 
    // write transaction.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_bvalid  <= 0;
          axi_bresp   <= 2'b0;
        end 
      else
        begin    
          if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
            begin
                // indicates a valid write response is available
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b0; // 'OKAY' response 
            end                   // work error responses in future
          else
            begin
              if (S_AXI_BREADY && axi_bvalid) 
                //check if bready is asserted while bvalid is high) 
                //(there is a possibility that bready is always asserted high)   
                begin
                    axi_bvalid <= 1'b0; 
                end  
            end
        end
    end   

    always @( posedge S_AXI_ACLK ) begin

        // Implement axi_arready generation
        // axi_arready is asserted for one S_AXI_ACLK clock cycle when
        // S_AXI_ARVALID is asserted. axi_awready is 
        // de-asserted when reset (active low) is asserted. 
        // The read address is also latched when S_AXI_ARVALID is 
        // asserted. axi_araddr is reset to zero on reset assertion.
    
       if ( S_AXI_ARESETN == 1'b0 ) begin
            axi_arready <= 1'b0;
            axi_araddr  <= 32'b0;
        end 
        else begin    
            if (~axi_arready && S_AXI_ARVALID)
                begin
                    // indicates that the slave has acceped the valid read address
                    axi_arready <= 1'b1;
                    // Read address latching
                    axi_araddr  <= S_AXI_ARADDR;
                end
            else
                begin
                    axi_arready <= 1'b0;
                end
        end 
    end       

    always @( posedge S_AXI_ACLK ) begin

        // Implement axi_arvalid generation
        // axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
        // S_AXI_ARVALID and axi_arready are asserted. The slave registers 
        // data are available on the axi_rdata bus at this instance. The 
        // assertion of axi_rvalid marks the validity of read data on the 
        // bus and axi_rresp indicates the status of read transaction.axi_rvalid 
        // is deasserted on reset (active low). axi_rresp and axi_rdata are 
        // cleared to zero on reset (active low).  

        if ( S_AXI_ARESETN == 1'b0 ) begin
            axi_rvalid <= 0;
            axi_rresp  <= 0;
        end 
        else begin    
          if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
            begin
                // Valid read data is available at the read data bus
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b0; // 'OKAY' response
            end   
          else if (axi_rvalid && S_AXI_RREADY)
            begin
                // Read data is accepted by the master
                axi_rvalid <= 1'b0;
            end                
        end
    end    

    // Implement memory mapped register select and read logic generation
    // Slave register read enable is asserted when valid address is available
    // and the slave is ready to accept the read address.
    wire slv_reg_rden;
    assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

    // Output register or memory read data
    always @( posedge S_AXI_ACLK ) begin
        if ( S_AXI_ARESETN == 1'b0 ) begin
            axi_rdata  <= 0;
        end 
        else begin    
            // When there is a valid read address (S_AXI_ARVALID) with 
            // acceptance of read address by the slave (axi_arready), 
            // output the read data - always config register
            if (slv_reg_rden) begin
                axi_rdata <= CONFIG_REGISTER;     // register read data
            end   
        end
    end    

endmodule