`include "2scomp.v"
module logic_u (a, b, select,out);
input [31:0] a,b;
input [2:0] select;
output [31:0] out;

wire [31:0] out1,out2,out3,out4,out5,out6,out7,out8;

assign out1 = a&b;
assign out2[31:0] = a[31:0] | b[31:0];
assign out3 = ~a & ~b;
assign out4 = ~a | ~b;
assign out5 = a^b;
assign out6 = ~(a^b);
assign out7 = ~a;
comp x1(a,out8);
mux x2(select[2],select[1],select[0],out1,out2,out3,out4,out5,out6,out7,out8,out);

endmodule

module mux(x,y,z,out1,out2,out3,out4,out5,out6,out7,out8,out);
input x,y,z;
input [31:0] out1,out2,out3,out4,out5,out6,out7,out8;
output [31:0] out;

wire [31:0] s0,s1,s2;
assign s0 = {32{x}};
assign s1 = {32{y}};
assign s2 = {32{z}};

wire [31:0] b1,b2,b3,b4,b5,b6,b7,b8;
and a1 [31:0](b1[31:0],~s0[31:0],~s1[31:0],~s2[31:0],out1[31:0]);
and a2 [31:0](b2[31:0],~s0[31:0],~s1[31:0],s2[31:0],out2[31:0]);
and a3 [31:0](b3[31:0],~s0[31:0],s1[31:0],~s2[31:0],out3[31:0]);
and a4 [31:0](b4[31:0],~s0[31:0],s1[31:0],s2[31:0],out4[31:0]);
and a5 [31:0](b5[31:0],s0[31:0],~s1[31:0],~s2[31:0],out5[31:0]);
and a6 [31:0](b6[31:0],s0[31:0],~s1[31:0],s2[31:0],out6[31:0]);
and a7 [31:0](b7[31:0],s0[31:0],s1[31:0],~s2[31:0],out7[31:0]);
and a8 [31:0](b8[31:0],s0[31:0],s1[31:0],s2[31:0],out8[31:0]);
or a9 [31:0] (out[31:0],b1[31:0],b2[31:0],b3[31:0],b4[31:0],b5[31:0],b6[31:0],b7[31:0],b8[31:0]);
endmodule
