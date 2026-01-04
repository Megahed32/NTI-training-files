module alu_sva (
    input logic        clk,
    input logic        reset,

    // inputs
    input logic        valid_in,
    input logic        cin,
    input logic [3:0]  a,
    input logic [3:0]  b,
    input logic [3:0]  ctl,

    // outputs
    input logic        valid_out,
    input logic        carry,
    input logic        zero,
    input logic [3:0]  alu,
    input logic [4:0]  pkt_num
);


    // -------------------------------------------------
    // Reset handling
    // -------------------------------------------------
    default disable iff (reset);

    // -------------------------------------------------
    // ASSERTIONS (you fill in)
    // -------------------------------------------------

   
    property p_example;
        
    endproperty

    a_example:
        assert property (p_example);
  

endmodule

