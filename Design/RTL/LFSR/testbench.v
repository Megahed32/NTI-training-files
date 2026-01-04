`timescale 1ns/1ps

module Shift_reg_tb();

parameter WIDTH = 4;

reg clk;
reg rst_n;
reg en;
reg serial_in;
wire [WIDTH-1:0] shift_reg;

// Instantiate DUT
LFSR #(WIDTH) DUT (
    .serial_in(serial_in),
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .shift_reg(shift_reg)
);

// Clock generation
initial clk = 0;
always #5 clk = ~clk;  // 10ns period

initial begin
    // Initialize
    rst_n = 0;
    en = 0;
    serial_in = 0;
    @(negedge clk);

    // Apply reset
    rst_n = 1;
    
    // Enable shifting
    @(negedge clk);
    en = 0;

    // Send serial bits
    serial_in = 1;
     @(negedge clk);
    serial_in = 0;
     @(negedge clk);
    serial_in = 0;
     @(negedge clk);
    serial_in = 1;
     @(negedge clk);
     
     en = 1;
     repeat(30)  @(negedge clk);

    // Stop simulation
    #50;
    $stop;
end

endmodule
