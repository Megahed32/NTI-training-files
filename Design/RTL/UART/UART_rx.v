module UART_rx #(
    parameter CLKS_PER_BIT = 5208  // for baud rate of 9600 at 50 Mhz
)
(
    input wire rx , clk , arst_n,
    output reg [7:0] data_sipo,
    output reg done , error ;
);
    // edge detector signals
    reg rx_reg ;
    wire start;

    // counters
    localparam CLKS_PER_BIT_SAMPLING = $rtoi($ceil(1.5 * CLKS_PER_BIT)); 
    reg [$clog2(CLKS_PER_BIT_SAMPLING)-1:0] baud_counter;
    reg [2:0] bit_counter;
//states

  localparam IDLE    = 0;
  localparam START   = 1;
  localparam RX_DATA = 2;
  localparam STOP    = 3;
  localparam ERR     = 4;
  localparam DONE    = 5;

  reg [2:0] cs ,ns;

  //state registers
  always @(posedge clk or negedge arst_n) begin
    if(!arst_n)
    begin
        cs <= IDLE;
    end
    else
    begin
        cs <= ns;
    end
  end

//next state logic

    always @(*) begin
    case (cs)
      IDLE :   ns = (start) ? START : IDLE;

      START :  ns = (baud_counter < (1.5*(CLKS_PER_BIT)-1)) ? START : RX_DATA;

      RX_DATA: ns = ((bit_counter == 7) && (baud_counter == CLKS_PER_BIT-1)) ?  STOP: RX_DATA ;


      STOP   : ns = (baud_counter < CLKS_PER_BIT-1) ? STOP : (rx)? DONE: ERR;

      DONE   : ns = IDLE;

      ERR    : ns = ERR;

      default: ns = IDLE;
    endcase
    end

//output logic
    
    always @(posedge clk or negedge arst_n) begin
    if(!arst_n)
    begin
        data_sipo <= 0 ;
        baud_counter <= 0;
        bit_counter  <= 0;
        done <= 0 ;
        error <= 0 ;
    end
    else
    begin
        case (cs)
      START : 
      begin

        if(baud_counter < (1.5*(CLKS_PER_BIT)-1))
          baud_counter <= baud_counter + 1;

        else
        begin
            baud_counter <= 0;
        end  
        done <= 0 ;
        error <= 0;
      end


      RX_DATA: 
      begin
        if(baud_counter == 0)
        data_sipo[bit_counter] <= rx;
        if(baud_counter < CLKS_PER_BIT-1)
          baud_counter <= baud_counter + 1;
          else
          begin
             baud_counter <= 0;
             bit_counter <= bit_counter + 1; 
          end
          done <= 0 ;
          error <= 0;
      end  


      STOP   : 
      begin
        if(baud_counter <(CLKS_PER_BIT)-1)
          baud_counter <= baud_counter + 1;
        else
        begin
            baud_counter <= 0;
        end  
        done <= 0 ;
      end
        DONE:
        begin
            done <= 1 ;
        end
        ERR: 
        begin
            error <= 1 ;
        end
      default: 
      begin 
        done <= 0 ;
        error <= 0;
      end
    endcase


    end

    
end




//edge detector
//detects start condition on rx_line
    
    always @(posedge clk or negedge arst_n) 
    begin
        if(!arst_n)
        begin
            rx_reg <= 0 ;
        end
        else
        begin
            rx_reg <= rx;
        end
    end

    assign start = (!rx & rx_reg);
endmodule