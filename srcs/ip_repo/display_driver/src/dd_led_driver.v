module dd_led_driver
#(
    // LED definitions
    parameter N_LEDS = 10,

    parameter LED_BRIGHTNESS_0 = 8'h00,
    parameter LED_BRIGHTNESS_1 = 8'h16,
    parameter LED_BRIGHTNESS_2 = 8'h32,
    parameter LED_BRIGHTNESS_3 = 8'h64,

    // Input clock freq, 100 MHz
    parameter CLK_FREQ = 100,

    // time given in nanoseconds
    parameter TIME_RST = 50000,
    parameter TIME_T0H =   400,
    parameter TIME_T0L =   800,
    parameter TIME_T1H =   800,
    parameter TIME_T1L =   400
)

(
    input clock,
    input resetn,
    
    /*
    | 	Array of LED values			  |
    | LED NUMBER	| G   | R   | B   |
    | ...			| ... | ... | ... |
    */ 
    input [(N_LEDS*6)-1:0] led_row,
    
    // data out
    output reg data_tx
);

    localparam N_CYCLES_RST = TIME_RST * CLK_FREQ / 1000;
    localparam N_CYCLES_T0H = TIME_T0H * CLK_FREQ / 1000;
    localparam N_CYCLES_T0L = TIME_T0L * CLK_FREQ / 1000;
    localparam N_CYCLES_T1H = TIME_T1H * CLK_FREQ / 1000;
    localparam N_CYCLES_T1L = TIME_T1L * CLK_FREQ / 1000;

    // led latches
    reg [((N_LEDS-1)*6)-1:0] led_row_latch;  // latch for entire row
    reg [23:0] led_value;                    // latch for single LED value (24 bits, LSB)

    // driver states
    localparam [1:0]
        STATE_RST = 2'b00,  // reset state
        STATE_HTX = 2'b01,  // high transmission state
        STATE_LTX = 2'b10,  // low transmission state
        STATE_IDL = 2'b11;  // idle state
    reg [1:0] state;
    

    // sized to count to rst (oversized)
    reg[$clog2(N_CYCLES_RST)-1:0] N_CYCLES_H;
    reg[$clog2(N_CYCLES_RST)-1:0] N_CYCLES_L;
    reg[$clog2(N_CYCLES_RST)-1:0] counter;

    reg [$clog2(N_LEDS)-1:0] led_idx;  // sized to count to led_idx
    reg [$clog2(000024)-1:0] bit_idx;  // sized to count to 24

    // N_CYCLES generator
    always @( state, led_idx, bit_idx, led_value ) begin

        if ( state == STATE_RST ) begin
            N_CYCLES_H <= 0;
            N_CYCLES_L <= N_CYCLES_RST-1;
        end

        else if ( state == STATE_IDL ) begin
            N_CYCLES_H <= 0;
            N_CYCLES_L <= 0;
        end

        else begin

            case ( led_value[23] )

                0: begin N_CYCLES_H <= N_CYCLES_T0H-1; N_CYCLES_L <= N_CYCLES_T0L-1; end
                1: begin N_CYCLES_H <= N_CYCLES_T1H-1; N_CYCLES_L <= N_CYCLES_T1L-1; end

            endcase

        end

    end

    integer color_idx;
    always @( posedge clock, negedge resetn ) begin

        state <= state;
        led_idx <= led_idx;
        bit_idx <= bit_idx;
        data_tx <= data_tx;
        led_row_latch <= led_row_latch;
        led_value <= led_value;

        if ( resetn == 0 ) begin
            state <= STATE_RST;
            counter <= 0;
            led_idx <= 0;
            bit_idx <= 23;
            data_tx <= 0;
            led_row_latch <= led_row[ (N_LEDS*6)-1 : 6 ];

            // decode first 8 bits and assign to led_value
            for (color_idx=0; color_idx < 3; color_idx=color_idx+1) begin
                case ( led_row[2*color_idx +: 2] )
                    2'b00: led_value[ 8*color_idx +: 8 ] <= LED_BRIGHTNESS_0;
                    2'b01: led_value[ 8*color_idx +: 8 ] <= LED_BRIGHTNESS_1;
                    2'b10: led_value[ 8*color_idx +: 8 ] <= LED_BRIGHTNESS_2;
                    2'b11: led_value[ 8*color_idx +: 8 ] <= LED_BRIGHTNESS_3;
                endcase
            end
        end

        else begin
        
            case ( state )

                STATE_RST: begin

                    counter <= counter+1;

                    // check if enough cycles have passed for reset
                    if ( counter == N_CYCLES_L ) begin
                        state <= STATE_HTX;
                        counter <= 0;
                        data_tx <= 1;
                    end
                end

                STATE_HTX: begin

                    counter <= counter+1;

                    if ( counter == N_CYCLES_H ) begin
                        state <= STATE_LTX;
                        counter <= 0;
                        data_tx <= 0;
                    end
                end

                STATE_LTX: begin

                    casez ( { counter == N_CYCLES_L, bit_idx == 0, led_idx == N_LEDS-1 } )
                        
                        3'b0zz: begin
                            counter <= counter + 1;
                        end
                        
                        3'b10z: begin
                            state <= STATE_HTX;
                            counter <= 0;
                            bit_idx <= bit_idx - 1;
                            data_tx <= 1;
                            led_value <= (led_value << 1);
                        end

                        3'b110: begin
                            state <= STATE_HTX;
                            counter <= 0;
                            led_idx <= led_idx + 1;
                            bit_idx <= 23;
                            data_tx <= 1;
                            led_row_latch <= (led_row_latch >> 6);

                            // decode first 8 bits and assign to led_value
                            for (color_idx=0; color_idx < 3; color_idx=color_idx+1) begin
                                case ( led_row_latch[2*color_idx +: 2] )
                                    2'b00: led_value[ 8*color_idx +: 8 ] <= LED_BRIGHTNESS_0;
                                    2'b01: led_value[ 8*color_idx +: 8 ] <= LED_BRIGHTNESS_1;
                                    2'b10: led_value[ 8*color_idx +: 8 ] <= LED_BRIGHTNESS_2;
                                    2'b11: led_value[ 8*color_idx +: 8 ] <= LED_BRIGHTNESS_3;
                                endcase
                            end
                        end

                        3'b111: begin
                            state <= STATE_IDL;
                            counter <= 0;
                            led_idx <= 0;
                            bit_idx <= 23;
                            data_tx <= 0;
                            led_value <= 0;
                        end
                    endcase
                end
            endcase
        end
    end
endmodule