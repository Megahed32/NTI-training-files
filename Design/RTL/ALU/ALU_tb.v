`timescale 1ns/1ps

module ALU_tb;

    // Parameters
    parameter DATA_WIDTH = 4;

    // Testbench signals
    reg  [DATA_WIDTH-1:0] A, B;
    reg  [1:0] opcode;
    wire status;
    reg [4:0] Out_expected;
    integer correct_count, Error_count;
    // Instantiate DUT (Device Under Test)
    ALU #(DATA_WIDTH) uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .status(status)
    );
     reg flag;
    initial begin
        correct_count = 0;
        Error_count = 0;
        $monitor ("A = %b  , B = %b  , OPcode = %b , Output = %b at time = %t" , A, B, opcode, uut.Out , $time);
        // Test ADD (opcode = 0)
        A = 4'b0011; B = 4'b0101; opcode = 2'b00; Out_expected = 8;
         #10;
         check_result;
        // Test SUB (opcode = 1)
        A = 4'b1010; B = 4'b0011; opcode = 2'b01; Out_expected = 7;
         #10;
         check_result;
        // Test AND (opcode = 2)
        A = 4'b1100; B = 4'b1010; opcode = 2'b10; Out_expected = 4'b1000;
         #10;
         check_result;
        // Test XOR (opcode = 3)
        A = 4'b1111; B = 4'b0101; opcode = 2'b11; Out_expected = 4'b1010;
         #10;
         check_result;
        // Test status output (result zero)
        A = 4'b0011; B = 4'b0011; opcode = 2'b01000;Out_expected = 4'b0; #10; // 3 - 3 = 0
         check_result;
          #1;
         repeat(20)
         begin
            A = $random;
            B = $random;
            opcode = 0;
            Out_expected = A+B;
            #1;
            check_result;
         end

         repeat(20)
         begin
            A = $random;
            B = $random;
            opcode = 1;
            Out_expected = A-B;
            #1;
            check_result;
            
         end

         repeat(20)
         begin
            A = $random;
            B = $random;
            opcode = 2;
            Out_expected = A&B;
            #1;
            check_result;
         end

         repeat(20)
         begin
            A = $random;
            B = $random;
            opcode = 3;
            Out_expected = A^B;
            #1;
            check_result;
         end

         $display("Correct count = %d , error count = %d",correct_count , Error_count);
        $stop; // end simulation
    end
     

     task check_result;
     
        if(uut.Out == Out_expected)
        begin
         correct_count = correct_count +1 ;
         $display("Success:   Opcode %d    | A= %d | B= %d | Out= %d | Out expected = %d |  Status %b",opcode, A, B, uut.Out, Out_expected, status);
        end
        else
        begin
         Error_count = Error_count +1 ;
         $display("Failed:   Opcode %d    | A= %d | B= %d | Out= %d | Out expected = %d |  Status %b",opcode, A, B, uut.Out, Out_expected, status);
        end
     endtask
endmodule
