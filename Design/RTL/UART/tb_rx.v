`timescale 1ns/1ps

module UART_rx_tb;

  // Parameters
  parameter CLKS_PER_BIT = 4;        // for 9600 baud @ 50MHz
  parameter CLK_PERIOD   = 20;          // 50 MHz clock = 20 ns

  // DUT signals
  reg        clk;
  reg        arst_n;
  reg        rx;
  wire [7:0] data_sipo;
  wire       done;

  // Instantiate DUT
  UART_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
  ) DUT (
    .rx(rx),
    .clk(clk),
    .arst_n(arst_n),
    .data_sipo(data_sipo),
    .done(done)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // Reset
  initial begin
    arst_n = 0;
    rx     = 1;   // Idle state for UART
    #(10*CLK_PERIOD);
    arst_n = 1;
  end

  // -------------------------------------------------------
  // Task: send one UART byte (LSB-first)
  // -------------------------------------------------------
  task send_byte;
    input [7:0] data;
    integer i;
    begin
      // Start bit
      rx = 0;
      #(CLKS_PER_BIT * CLK_PERIOD);

      // Data bits
      for (i = 0; i < 8; i = i + 1) begin
        rx = data[i];
        #(CLKS_PER_BIT * CLK_PERIOD);
      end

      // Stop bit
      rx = 1;
      #(CLKS_PER_BIT * CLK_PERIOD);
    end
  endtask

  // Test stimulus
  initial begin
    @(posedge arst_n);
    #(20*CLK_PERIOD);

    $display("Sending byte 0xA5...");
    send_byte(8'hA5);

    wait(done == 1);
    $display("DONE asserted! Received = %h", data_sipo);

    #(50*CLK_PERIOD);

    $finish;
  end

endmodule
