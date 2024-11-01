module Adder(a,b,out);
input [31:0] a,b;
output reg [31:0] out;
always@(*)
begin
 out=a+b;
 end
endmodule 