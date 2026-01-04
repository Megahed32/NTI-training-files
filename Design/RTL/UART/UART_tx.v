module UART_tx #(      
      parameter CLKS_PER_BIT = 5208    // clk dvided by baudrate 
                                      // for baudrate of 9600 frequency 50Mhz
) 
(
   input  wire       clk, rst_n, tx_en,
   input  wire [7:0] data_in,
   output wire       serial_data_out,
   output reg        done
);

// FSM states

localparam   IDLE    = 0;
localparam   START   = 1;
localparam   DATA_TX = 2;
localparam   STOP    = 3;



reg serial_data_reg;
reg [2:0] data_count;
reg [$clog2(CLKS_PER_BIT)-1:0] clk_count;
reg [1:0] cs, ns;

assign serial_data_out = serial_data_reg;

// State register
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cs <= IDLE;
    else
        cs <= ns;
end

// Next state logic
always @(*) begin
    case (cs)
      IDLE :   ns = (!tx_en) ? START : IDLE;

      START :  ns = (clk_count < CLKS_PER_BIT-1) ? START : DATA_TX;

      DATA_TX: ns = ((data_count == 7) && (clk_count == CLKS_PER_BIT-1)) ?  STOP: DATA_TX ;

      STOP   : ns = (clk_count < CLKS_PER_BIT-1) ? STOP : IDLE;

      default: ns = IDLE;
    endcase
end

// State output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        serial_data_reg <= 1;
        data_count <= 0;
        clk_count  <= 0;
    end else begin
        case (cs)
          IDLE: begin
              serial_data_reg <= 1; // line idle high
              data_count <= 0;
              clk_count  <= 0;
          end

          START: begin
              serial_data_reg <= 0; // start bit
              if (clk_count < CLKS_PER_BIT-1)
                  clk_count <= clk_count + 1;
              else
                  clk_count <= 0;
          end

          DATA_TX: begin
              serial_data_reg <= data_in[data_count];
              if (clk_count < CLKS_PER_BIT-1)
                  clk_count <= clk_count + 1;
              else begin
                  clk_count  <= 0;
                  data_count <= data_count + 1;
              end
          end

          STOP: begin
              serial_data_reg <= 1; // stop bit
              if (clk_count < CLKS_PER_BIT-1)
                  clk_count <= clk_count + 1;
              else
                  clk_count <= 0;
          end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        done <= 0 ;
    end
    else
    begin
        if(cs == STOP)
        done <= 1;
        else 
        done <= 0;
    end
end

endmodule
