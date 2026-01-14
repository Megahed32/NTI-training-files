module register_file #(parameter WIDTH =8)(clk , arst_n , wr_en, rd_en , wr_addr ,
 rd_addr , wr_data , rd_data , control , 
 busy , done , uart_rx_data , uart_tx_data, valid);

 input clk , arst_n , wr_en , rd_en , busy ,done , valid;
 input [1:0] wr_addr , rd_addr;
 
 input  wire [WIDTH-1:0] wr_data , uart_rx_data;
 output reg  [WIDTH-1:0] rd_data;

 output wire [WIDTH-1:0] control, uart_tx_data;

 

 reg [WIDTH-1:0] data_tx_reg , control_reg , status_reg , data_rx_reg ;

 localparam CONTROL_ADDR = 0 ;
 localparam DATA_TX_ADDR = 1 ;
 localparam STATUS_ADDR  = 2 ;
 localparam DATA_RX_ADDR = 3 ;

 always @(posedge clk or negedge arst_n) begin
    if(!arst_n)
    begin
    rd_data     <=0;
    data_tx_reg <=0;
    control_reg <=0;
    status_reg  <=0;
    data_rx_reg <=0;
    end
    else
    begin
        if(wr_en)
        begin
        case (wr_addr)
            CONTROL_ADDR : 
            begin
                control_reg <= wr_data;
            end
            DATA_TX_ADDR :
            begin
                data_tx_reg <= wr_data;
            end
            default: ;   //rest of registers are read-only
        endcase

        end
        else if(rd_en)
        begin
        case (rd_addr)
            STATUS_ADDR : 
            begin
                rd_data <= status_reg; 
            end
            DATA_RX_ADDR :
            begin
                rd_data <= data_rx_reg;
            end
            default: ;   //rest of registers are write-only
        endcase
        end

        status_reg  <=  {{(WIDTH-2){1'b0}}, busy , done};

        if(valid)
        data_rx_reg <=  uart_rx_data;
    end
    
    
 end
    assign control = control_reg;
    assign uart_tx_data = data_tx_reg;
endmodule