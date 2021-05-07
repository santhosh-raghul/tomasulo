`include "fp_multiplier.v"

module top;

	reg [31:0]a, b;
	reg clk;
	wire [31:0]out;
	initial begin
		clk=0;
	end

	always 
		#1 clk=~clk;

	fp_multiplier FP1 (a, b, out,clk);

	initial
	begin

	 a=32'h12;	
	 b = 32'h13;	
		
		#35 $finish();

	end
	initial 
	#35
        $display("%x %x %x \n",a,b,out);

endmodule