`include "logic.v"
module top;

reg [2:0]sel;
reg [31:0] a, b;
wire [31:0] out;

logic_u u1(a,b,sel,out);

initial
begin

sel=3'd_operation;
a = 32'h_operand1 ;
b = 32'h_operand2 ;

#100 $finish();
end

initial 
#100 $display("%x %x %x \n", a, b, out);
endmodule