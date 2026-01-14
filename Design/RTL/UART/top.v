module top #(
    parameter WIDTH = 8,
    parameter CLKS_PER_BIT = 5208
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        wr_en,
    input  wire        rd_en,
    input  wire [1:0]  wr_addr,
    // input  wire [1:0]  rd_addr,
    input  wire [WIDTH-1:0] wr_data,
    output wire [WIDTH-1:0] rd_data,
    output wire        serial_data_out
);

    wire done_tx , done_rx;
    wire [WIDTH-1:0] uart_tx_data;
    wire [WIDTH-1:0] control;

    // Instantiate register_file
    register_file #(.WIDTH(WIDTH)) u_reg_file (
        .clk(clk),
        .arst_n(rst_n),
        .wr_en(!wr_en),
        .rd_en(!rd_en),
        .wr_addr(wr_addr),
        .rd_addr(wr_addr),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .control(control),
        .busy(0),
        .done(done_tx),
        .uart_rx_data(0),
        .uart_tx_data(uart_tx_data),
        .valid(done_rx)
    );

    // Instantiate UART_tx
    UART_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) u_uart_tx (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en(control[0]),        // example: use LSB of control register to enable TX
        .data_in(uart_tx_data),
        .serial_data_out(serial_data_out),
        .done(done)                    // we can ignore UART internal done here if not needed
    );

    // Instantiate UART_rx
    UART_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) u_uart_rx (
        .rx(serial_data_out),       // loopback for testing
        .clk(clk),
        .arst_n(rst_n),
        .data_sipo(),               // not used in this top module
        .done()                     // we can ignore UART internal done here if not needed
    );

endmodule
