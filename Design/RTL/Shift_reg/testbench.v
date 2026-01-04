`timescale 1ns/1ps

module Shift_reg_tb();

parameter WIDTH = 4;

reg clk;
reg rst_n;
reg en;
reg serial_in;
wire serial_out;

// Instantiate DUT
Shift_reg #(WIDTH) DUT (
    .serial_in(serial_in),
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .serial_out(serial_out)
);

// Clock generation
initial clk = 0;
always #5 clk = ~clk;  // 10ns period

initial begin
    // Initialize
    rst_n = 0;
    en = 0;
    serial_in = 0;

    // Apply reset
    #20;
    rst_n = 1;

    // Enable shifting
    #10;
    en = 1;

    // Send serial bits
    serial_in = 1; #10;
    serial_in = 0; #10;
    serial_in = 1; #10;
    serial_in = 1; #10;
    serial_in = 0; #10;

    // Stop simulation
    #50;
    $stop;
end

endmodule
