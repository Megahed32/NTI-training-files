interface intf(input clk);
    logic re;
    logic en;
    logic rst;
    logic [3:0] addr;       
    logic [31:0] data_in;  
    logic [31:0] data_out;      
    logic valid_out;     
    
endinterface //intf