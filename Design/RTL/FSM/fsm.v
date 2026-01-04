module fsm (
    input clk ,rst_n,
    input a,b, 
    output wire y0 , y1);

//states
localparam S0 = 0;
localparam S1 = 1;
localparam S2 = 2;

//state registers
reg [1:0] cs , ns;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        cs <= S0 ;
    end
    else 
    begin
        cs <= ns;
    end
end


//next state logic 
always @(*) 
begin
    case (cs)


       S0 :
       begin
       if(!a)
       begin
         ns = S0;
       end
       else if(a & b)
       begin
        ns = S2;
       end
       else
       begin
        ns = S1;
       end
       end


       S1 :
       begin
       if(!a)
       begin
         ns = S1;
       end
       else if(a)
       begin
        ns = S0;
       end
       end


       S2 :
       begin
       ns = S0;
       end

        default: 
        begin
       ns = S0;
        end
    endcase
end


//Output Logic

assign y0 = (cs == S0)&&(a&b);
assign y1 = (cs == S0)||(cs == S1);

endmodule