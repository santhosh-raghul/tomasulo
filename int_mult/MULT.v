`include "wallace.v"
module wallace_tb;
    reg [31:0] a, b;
    reg cin,clk;
    wire [63:0] out;
    initial begin
		clk=0;
	end

	always 
		#1 clk=~clk;

    wallace wallace0( a, b, clk, out);
    initial begin

        a = 32'h_operand1;
        b = 32'h_operand2;

    #25 $finish();
    end
		initial
    #25
        $display("%x %x %x \n", a, b, out);

endmodule