module testbench ();
parameter CLKS_PER_BIT = 4;
parameter WIDTH = 8;
wire [7:0] rd_data;
wire serial_data_out;
reg clk;
reg rst_n;
reg wr_en;
reg rd_en;
reg [1:0] wr_addr;
reg [1:0] rd_addr;
reg [7:0] wr_data;

reg [WIDTH+1:0]captured_tx , expected_tx;
integer i;
// Instantiate top_module
top_module #(
    .WIDTH(8),            // Width of data
    .CLKS_PER_BIT(CLKS_PER_BIT)   // Clock cycles per UART bit
) u_top (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .wr_addr(wr_addr),
    .rd_addr(rd_addr),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .serial_data_out(serial_data_out)
);

initial begin
    clk = 0;
    wr_en = 0;
    rd_en = 0;
    wr_addr = 0;
    rd_addr = 0;
    wr_data = 0;
    
    reset;

    // Example: write control register 
    assert_control(8'h01);   // tx_en = 0;

    // Example: write data to transmit
    
    send_data(8'haa);
    assert_control(8'h00);   // tx_en = 0;
    assert_control(8'h01);   // tx_en = 0;
    wait_baud_rate;
    @(negedge clk);
    // Example: read status
    read_status;
    receive_data;
    read_status;

    $stop;
end

// Clock generation
always #10 clk = ~clk;  // 50 MHz clock

task wait_baud_rate;
repeat(10*CLKS_PER_BIT)@(negedge clk);
endtask

task send_data (input [WIDTH-1:0] data);
begin
    wr_en = 1;
    wr_addr = 1;      // DATA_TX_ADDR
    wr_data = data;   // data to send
    @(negedge clk); wr_en = 0;
end
endtask

task assert_control (input [WIDTH-1:0] data);
begin
    wr_en = 1;
    wr_addr = 0;      // DATA_TX_ADDR
    wr_data = data;   // control to write
    @(negedge clk); wr_en = 0;
    
end
endtask

task receive_data;
begin
    rd_en = 1;
    rd_addr = 2;      // DATA_TX_ADDR
    @(negedge clk); 
    @(negedge clk)
    $display("data read is %b" , rd_data);
    rd_en = 0;
end
endtask

task read_status;
begin

    rd_en = 1;
    rd_addr = 3;      // DATA_TX_ADDR
    @(negedge clk); 
    $display("status read is %b" , rd_data);
    rd_en = 0;
end
endtask

task reset;
    begin
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;
    end
endtask

task check_data(input [WIDTH+1:0] captured_tx);
begin
    for(i = 0; i< WIDTH+1; i= i+1)
    begin
    end
end
endtask


endmodule
