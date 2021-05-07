`include "sixteenBitAdder.v"

module thirtytwoBitAdder(a,b,cin,sum,ca);

input [31:0] a,b;
input cin;

output [31:0] sum;
output ca;

wire c2;

sixteenBitAdder TA_0(a[15:0],b[15:0],cin,sum[15:0],c2);
sixteenBitAdder TA_1(a[31:16],b[31:16],c2,sum[31:16],ca);

endmodule
