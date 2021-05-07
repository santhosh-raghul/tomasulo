`include "wallace.v"
`include "adder_8bit.v"
module fp_multiplier(input [31:0] a,input [31:0] b,output [31:0]out,input clk);

	wire S3,overflow;
	wire [47:0] productd,wallace_out,product;
	wire [7:0] exponent1,exponent2d,exponent2;
	wire [15:0] trim;
	wire [22:0] prod;
	wire [31:0] out1,out2,out3,out1d,out2d,out3d,outd;

	//sign of output is xor output
	xor (S3,a[31],b[31]);

	//stage-1-10 wallace multiplication of mantissa parts
	//multiplying mantissa parts
	wallace w1({8'b0,1'b1,a[22:0]},{8'b0,1'b1,b[22:0]},clk,{trim,productd});
	DFF DFF1[47:0] (productd[47:0],clk,1'b0,product[47:0]);
	assign overflow=product[47];
	assign wallace_out=product;
	
	//exponent part will pass through this dff after addition before mantissa mult is over
	//adding exponents(and overflow if any) and subtracting 127 from it
	adder_8bit adder1(a[30:23],b[30:23],overflow,exponent1);
	adder_8bit subtract_127(exponent1,8'b10000000,1'b1,exponent2);
	DFF DFF2 [7:0]( exponent2d[7:0],clk,1'b0,exponent2[7:0]);
	//selecting 23 bits based on overflow
	shifter_1bit shift [22:0] (prod[22:0],overflow, wallace_out[45:23], wallace_out[46:24]);

	//stage-11 
	assign out1d={S3,exponent2,prod};
	DFF DFF3 [31:0] (out1d,clk,1'b0,out1);
	//stage-12
	check_zero check1(out2d,a,b,out1); //zero multiplication case
	DFF DFF4 [31:0] (out2d,clk,1'b0,out2);
	//stage-13
	check_inf check2(out3d,a,b,out2); //multiplication with infinity
	DFF DFF5 [31:0] (out3d,clk,1'b0,out3);
	//stage-14
	check_nan check3(outd,a,b,out3); //zero*infinity case
	DFF DFF6 [31:0] (outd,clk,1'b0,out);
	

endmodule

//selecting 23 bits based on overflow
module shifter_1bit(output prod,input overflow,input out1,input out2);
	
	assign prod = (!overflow & out1) | (overflow & out2);

endmodule

//multiplication by 0
module check_zero(output [31:0] out,input [31:0] a,	input [31:0] b,	input [31:0] prod);
	
	//if exponent part is all-zeroes
	wire is_zero = ((|a[30:23]) & (|b[30:23]));		// if zero => is_zero=0
	assign out = (prod & {32{is_zero}}) | (32'b0_00000000_00000000000000000000000 & {32{!is_zero}});

endmodule

//multiplication by infinity
module check_inf(output [31:0] out,input [31:0] a,	input [31:0] b,input [31:0] prod);

	//if exponent part is all-ones
	wire is_inf = ((&a[30:23]) | (&b[30:23]));		// if inf => is_inf=1
	assign out = (prod & {32{!is_inf}}) | ({a[31] ^ b[31], 31'b11111111_00000000000000000000000} & {32{is_inf}});

endmodule

//zero*infinity=NaN
module check_nan(output [31:0] out,input [31:0] a,	input [31:0] b,	input [31:0] prod);

	//exponent of a number is all-ones and other is all-zeroes
	wire is_nan = ((&a[30:23]) & !(|b[30:23])) || (!(|a[30:23]) & (&b[30:23]));		// if nan => is_nan = 1
	assign out = (prod & {32{!is_nan}}) | ({32'b0_11111111_11111111111111111111111} & {32{is_nan}});

endmodule