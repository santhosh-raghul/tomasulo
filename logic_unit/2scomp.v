`include "thirtytwoBitAdder.v"
module comp(input [31:0] inp, output [31:0] out);
wire [31:0]o1;
wire carry;

assign o1[31:0]=~(inp[31:0]);
thirtytwoBitAdder a1(o1,32'd1,1'b0,out,carry);


endmodule

