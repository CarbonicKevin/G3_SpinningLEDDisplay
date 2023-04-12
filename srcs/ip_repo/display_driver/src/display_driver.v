module display_driver
#(
    // Width of S_AXI data bus
    parameter DATA_WIDTH = 32,
    // Width of S_AXI address bus
    parameter ADDR_WIDTH = 32,

    // register array dimensions
    parameter N_ARMS   = 4,   // Num of arms
    parameter N_LEDS   = 32,  // Num LEDs per arm
    parameter N_ANGLES = 16,  // Num of angles

    parameter LED_BRIGHTNESS_0 = 8'h00,
    parameter LED_BRIGHTNESS_1 = 8'h16,
    parameter LED_BRIGHTNESS_2 = 8'h32,
    parameter LED_BRIGHTNESS_3 = 8'h64

)

(

    input wire clock,
    input wire resetn,

    output wire [DATA_WIDTH-1:0] config_register,
    output wire [(N_ARMS/2)-1:0] data_tx,

    // Write Address Channel
    input  wire [ADDR_WIDTH-1:0] s_axi_awaddr,
    input  wire                  s_axi_awvalid,
    output wire                  s_axi_awready,
    
    // Write Data Channel
    input  wire [ DATA_WIDTH   -1:0] s_axi_wdata,
    input  wire [(DATA_WIDTH/8)-1:0] s_axi_wstrb,
    input  wire                      s_axi_wvalid,
    output wire                      s_axi_wready,

    // Write Response Channel
    output wire [1:0] s_axi_bresp,
    output wire       s_axi_bvalid,
    input  wire       s_axi_bready,

    // Read Address Channel
    input  wire [ADDR_WIDTH-1:0] s_axi_araddr,
    input  wire                  s_axi_arvalid,
    output wire                  s_axi_arready,

    // Read Data Channel
    output wire [DATA_WIDTH-1:0] s_axi_rdata,
    output wire [           1:0] s_axi_rresp,
    output wire                  s_axi_rvalid,
    input  wire                  s_axi_rready

);

    wire [(N_ARMS*N_LEDS*6)-1:0] led_data;
    wire led_reset;

    dd_axi_slave #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .N_ARMS(N_ARMS),
        .N_LEDS(N_LEDS),
        .N_ANGLES(N_ANGLES)
    ) 
    dd_reg (
        .S_AXI_ACLK(clock),
        .S_AXI_ARESETN(resetn),

        .S_AXI_AWADDR(s_axi_awaddr),
        .S_AXI_AWVALID(s_axi_awvalid),
        .S_AXI_AWREADY(s_axi_awready),

        .S_AXI_WDATA(s_axi_wdata),
        .S_AXI_WSTRB(s_axi_wstrb),
        .S_AXI_WVALID(s_axi_wvalid),
        .S_AXI_WREADY(s_axi_wready),

        .S_AXI_BRESP(s_axi_bresp),
        .S_AXI_BVALID(s_axi_bvalid),
        .S_AXI_BREADY(s_axi_bready),

        .S_AXI_ARADDR(s_axi_araddr),
        .S_AXI_ARVALID(s_axi_arvalid),
        .S_AXI_ARREADY(s_axi_arready),
        
        .S_AXI_RDATA(s_axi_rdata),
        .S_AXI_RRESP(s_axi_rresp),
        .S_AXI_RVALID(s_axi_rvalid),
        .S_AXI_RREADY(s_axi_rready),
        
        .CONFIG_REGISTER(config_register),
        .LED_DATA(led_data),
        .LED_RESET(led_reset)

    );
    
    genvar i;
    generate
        for ( i = 0; i < N_ARMS; i = i + 2 ) begin
            dd_led_driver #(
                .N_LEDS(2*N_LEDS),
                .LED_BRIGHTNESS_0(LED_BRIGHTNESS_0),
                .LED_BRIGHTNESS_1(LED_BRIGHTNESS_1),
                .LED_BRIGHTNESS_2(LED_BRIGHTNESS_2),
                .LED_BRIGHTNESS_3(LED_BRIGHTNESS_3)
            ) arm( // 2* to account for both sides of led
                .clock(clock),
                .resetn(led_reset),
                .led_row(led_data[i*N_LEDS*6 +: 2*N_LEDS*6]), // 2* to account for both sides of strip
                .data_tx(data_tx[i/2])
            );
        end
    endgenerate

endmodule