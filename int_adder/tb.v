`include "32rdcla.v"
module rdcla32_tb;
    reg [31:0] a, b;
    reg cin,clk;
    wire [31:0] sum;
    wire cout;

    initial begin
		clk=0;
	end

	always 
		#1 clk=~clk;

    rdcla rdcla0(sum, cout, a, b, cin, clk);
    initial begin
		    cin = 1'b0 ;
        a = 32'hd2d6fc38 ;
        b = 32'hb7a9a5b8 ;
    #100 $finish();
    end
    initial 
    #100
        $display("%x %x %x \n", a, b, sum);
endmodule