module adder_8bit (a,b,cin,sum);

	input [7:0] a,b;
	input cin;
	output [7:0] sum;
	wire [7:0] partial_sum;

	wire [8:0] carry, p, carry_1, p_1, carry_2, p_2, carry_4, p_4;
	
	assign carry[0] = cin;
	assign p[0] = 0;
	
	kpg_initial initializing_kpg [8:1] (a[7:0], b[7:0], p[8:1], carry[8:1]);

	assign p_1[0] = cin;
	assign carry_1[0] = cin;
	assign p_2[1:0] = p_1[1:0];
	assign carry_2[1:0] = carry_1[1:0];
	assign p_4[3:0] = p_2[3:0];
	assign carry_4[3:0] = carry_2[3:0];

	kpg_ iteration_1 [8:1] (p[8:1], carry[8:1], p[7:0], carry[7:0], p_1[8:1], carry_1[8:1]);
	kpg_ iteration_2 [8:2] (p_1[8:2], carry_1[8:2], p_1[6:0], carry_1[6:0], p_2[8:2], carry_2[8:2]);
	kpg_ iteration_4 [8:4] (p_2[8:4], carry_2[8:4], p_2[4:0], carry_2[4:0], p_4[8:4], carry_4[8:4]);

	assign partial_sum = a^b;
	assign sum[7:0] = partial_sum[7:0]^carry_4[7:0];

endmodule

module kpg_initial (
	input a, b,
	output reg p, carry
);
	always @*
	case ({a, b})
		2'b00: begin
			p = 1'b0; carry = 1'b0;
		end
		2'b11: begin
			p = 1'b0; carry = 1'b1;
		end
		default: begin 
			p = 1'b1; carry = 1'bx;
		end
	endcase

endmodule

module kpg_ (
	input current_p, current_carry, from_p, from_carry,
	output reg final_p, final_carry
);
	always @(*)
	begin
	
		if({current_p, current_carry} == 2'b00)
			{final_p, final_carry} = 2'b00;
		
		else if({current_p, current_carry} == 2'b01)
			{final_p, final_carry} = 2'b01;

		else
			{final_p, final_carry} = {from_p, from_carry};

	end

endmodule
