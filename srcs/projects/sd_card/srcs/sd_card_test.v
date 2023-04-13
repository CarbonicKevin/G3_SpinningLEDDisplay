`timescale 1ns / 1 ps

module read_image_v2
    #(
        parameter ADDRESS_OFFSET    =   0,
        parameter READ_INIT_0       =   0,
        parameter READ_INIT_1       =   1,

        parameter READ_STATE_0      =   2,
        parameter READ_STATE_1      =   3,
        
        parameter IN_HEADER         =   4,
        
        parameter R_BYTE            =   5,
        parameter G_BYTE            =   6,
        parameter B_BYTE            =   7,
        
        parameter SEND_TO_BRAM      =   8,
        parameter WAIT_SLAVE_RESP   =   9
    )
    (
        input       CLK100MHZ,
        input       [4:0]BTN,
        input       RST_SYS,
        input       [7:0]SW,
        inout       [3:0]DAT_SD,
        output      RST_SD,
        output      CMD_SD,
        output      SCLK_SD,
        output reg  [7:0] LED,

        /* output      [31:0]S_AXI_AWADDR,     //address master writes to */
        /* output      S_AXI_AWVALID,          //address valid */
        /* input       S_AXI_AWREADY,          //slave tells master address is recieved */
        /* output      [31:0]S_AXI_WDATA,      //master's data */
        /* output      S_AXI_WVALID,           //ditto */
        /* output      [3:0]S_AXI_WSTRB,       //number of bits to write, maybe unused? */
        /* input       S_AXI_WREADY,           //ditto */
        /* input       [7:0]S_AXI_BRESP,       //response from slave, should be 0 */
        /* input       S_AXI_BVALID,           //response from slave is valid */
        /* output      S_AXI_BREADY            //master ready to recieve data. assert with awvalid, and deassert after receiving bresp of 0 */

    );

    /* reg [31:0] s_axi_awaddr; */
    /* reg s_axi_awvalid; */
    /* reg [31:0]s_axi_wdata; */
    /* reg s_axi_wvalid; */
    /* reg [3:0]s_axi_wstrb; */
    /* reg s_axi_bready; */

    wire clk = CLK100MHZ;
    wire spiClk;
    wire spiMiso;
    wire spiMosi;
    wire spiCS;
    wire [7:0] dout;
    wire busy;
    wire [15:0] err;
    wire hs_o;
    wire rst_sys;

    reg [7:0]data;

    reg [4:0] state; 
    reg rd;
//    reg wr;
    reg [7:0] din;
    reg [31:0] adr;
    reg hs_i;
    
    reg rst_sd;
    reg [15:0]bytes_read;
    
    reg [31:0]to_bram;
    reg [1:0]rgb;
    
    /* reg axi_addr_data_done; */
    /* reg axi_resp_done; */

    assign DAT_SD[2] = 1;
    assign DAT_SD[3] = spiCS;
    assign CMD_SD = spiMosi;
    assign rst_sys = ~RST_SYS;
    assign SCLK_SD = spiClk;
    assign spiMiso = DAT_SD[0];
    assign DAT_SD[1] = 1;
    assign RST_SD = rst_sd;

    /* assign S_AXI_AWADDR = s_axi_awaddr; */
    /* assign S_AXI_AWVALID = s_axi_awvalid; */
    /* assign S_AXI_WDATA = s_axi_wdata; */
    /* assign S_AXI_WVALID = s_axi_wvalid; */
    /* assign S_AXI_WSTRB = s_axi_wstrb; */
    /* assign S_AXI_BREADY = s_axi_bready; */


    SdCardCtrl sd_card(
    .clk_i(clk),
    .reset_i(rst_sys),
    .rd_i(rd),
    .wr_i(0),
    .continue_i(0),
    .addr_i(adr),
    .data_i(0),
    .data_o(dout),
    .busy_o(busy),
    .hndShk_i(hs_i),
    .hndShk_o(hs_o),
    .error_o(err),
    .cs_bo(spiCS),
    .sclk_o(spiClk),
    .mosi_o(spiMosi),
    .miso_i(spiMiso)
    );
    
//    initial //read switches on reset to select image (currently supports 8 images)
        /* adr <= (SW[2:0]) * 12800; //first image is at 32'h200, other images at 12800*n + 32'h200, avoiding filesystem header */


    always @( posedge clk ) begin
        if ( rst_sys )
            LED[7:0] <= 0;
        else
        begin
            if ( err != 8'h00 ) LED[7:0] <= 8'hff; //if all lit, error
            LED[7:0] <= to_bram[23:16]  //display some bits from sd_card on the LEDs.
                                        //this will display the last byte from
                                        //the sd card sector
        end
    end

    always @( posedge clk ) begin
        if ( rst_sys ) begin
            state <= READ_INIT_0;
            rd <= 0;
            adr <= 0;
            hs_i <= 0;
            rst_sd <= 1;
            bytes_read <= 0;
            to_bram <= 0;
            rgb <= 0;
        end
        else
            begin
            case (state)
                READ_INIT_0: begin
                    rst_sd <= 0;
                    if ( ~busy ) begin
                        if ( bytes_read < 16'h3036 ) begin
                            adr <= adr + 32'h200;
                            rd <= 1;
                            state <= READ_INIT_1;
                        end
                    end
                end
                READ_INIT_1: begin
                    if ( busy ) begin
                        rd <= 0;
                        state <= READ_STATE_0;
                    end
                end
                READ_STATE_0: begin
                    if ( hs_o ) begin
                        data <= dout;
                        hs_i <= 1;
                        bytes_read <= bytes_read + 1;
                        state <= IN_HEADER;
                    end
                    if ( ~busy ) begin
                        state <= READ_INIT_0;
                    end
                end
                IN_HEADER: begin
                    if ( bytes_read >= 16'h36 ) begin
                        // have bgr, want grb
                        state <= rgb[1] ? (R_BYTE) : (rgb[0] ? G_BYTE : B_BYTE); //assuming little endian
                    end
                    else
                        state <= READ_STATE_1;
                end
                R_BYTE: begin
                    to_bram[15:8] <= data;
                    rgb <= 0;
                    state <= SEND_TO_BRAM;
                end
                G_BYTE: begin
                    to_bram[23:16] <= data;
                    rgb <= rgb + 1;
                    state <= READ_STATE_1;
                end
                B_BYTE: begin
                    to_bram[7:0] <= data;
                    rgb <= rgb + 1;
                    state <= READ_STATE_1;
                end
                SEND_TO_BRAM: begin
                    /// send `to_bram` to bram over axi
                    /* s_axi_awaddr <= bytes_read - 16'h36 + ADDRESS_OFFSET; // subtract address of header so image gets stored at memory location ADDRESS_OFFSET */
                    // subsequent new images will overwrite old image
                    /* s_axi_awvalid <= 1; */
                    /* s_axi_wdata <= to_bram; */
                    /* s_axi_wvalid <= 1; */
                    /* s_axi_wstrb <= 4'b0111; */
                    /* s_axi_bready <= 1; */
                    state <= WAIT_SLAVE_RESP;
                end
                WAIT_SLAVE_RESP: begin
                    /* if ( S_AXI_AWREADY && S_AXI_WREADY ) begin */
                    /*     s_axi_awvalid <= 0; */
                    /*     s_axi_wvalid <= 0; */
                    /*     axi_addr_data_done <= 1; */
                    /* end */
                    /* if ( (S_AXI_BRESP == 0) && (S_AXI_BVALID) ) begin */
                    /*     s_axi_bready <= 0; */
                    /*     axi_resp_done <= 1; */
                    /* end */
                    /* if ( axi_addr_data_done && axi_resp_done ) */
                        state <= READ_STATE_1;
                end
                READ_STATE_1: begin
                    /* axi_addr_data_done <= 0; */
                    /* axi_resp_done <= 0; */
                    if ( ~hs_o ) begin
                        hs_i <= 0;
                        state <= READ_STATE_0;
                    end
                end
            endcase
            end
        end                   
endmodule
