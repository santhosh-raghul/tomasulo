module leading_zero(input [23:0] a,
                output [23:0] tempsum_mantissa);

	integer q;
	always @(*) begin
		q = 24;
			while (q>=0 && lz[q] == 0) begin
				q -= 1;
			end
			
			//first 1 is found at qth index, so left shift 24-q times
			q = 24-q;
	end
	
		shiftleft m_slmantissa(q[7:0],a,tempsum_mantissa);
endmodule