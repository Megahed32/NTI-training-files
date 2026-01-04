interface alu_interface(input logic clk , reset);
    

    // inputs 
    logic valid_in , cin ;
    logic [3:0] a , b , ctl;

    //outputs

    logic valid_out , carry , zero ;
    logic [3:0] alu ;
    logic [4:0] pkt_num;

endinterface //alu_interface