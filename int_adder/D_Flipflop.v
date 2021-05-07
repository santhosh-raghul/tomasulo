module DFF(D,clk,reset,Q);
	input D; // Data input 
	input clk; // clock input 
	input reset; // reset high level
	output reg Q; // output Q 
	always @(posedge clk or posedge reset) 
	begin
 		if(reset==1'b1)
  		Q <= 1'b0; 
 		else 
  		Q <= D; 
	end 
endmodule 