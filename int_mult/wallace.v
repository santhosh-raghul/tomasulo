`include "partial_products.v"
`include "carry_save_adder.v"
`include "32rdcla.v"

module wallace (
	input [31:0] a,
	input [31:0] b,
	input clk,
	output [63:0] out
);

	wire [31:0][63:0]p_prods;
	integer i;
	
	partial_products pp (a, b, p_prods);

	/*
		The naming convention for the carry save adder modules is: 'l' stands for level
		the first digit after level stands the level in the wallace tree multiplication
		the rest of the digits is an id for the module number in that level.

		For eg: l23 stands for the 3rd carry save adder in level 2.

		u and v stand for the sum and carry outputs of the carry save adder.
	*/

	//The following is for level 1 of wallace tree
	wire [63:0] u_l11, v_l11, u_l12, v_l12, u_l13, v_l13, u_l14, v_l14, u_l15, v_l15, u_l16, v_l16, u_l17, v_l17, u_l18, v_l18, u_l19, v_l19, u_l110, v_l110;
	wire [63:0] u_l11d, v_l11d, u_l12d, v_l12d, u_l13d, v_l13d, u_l14d, v_l14d, u_l15d, v_l15d, u_l16d, v_l16d, u_l17d, v_l17d, u_l18d, v_l18d, u_l19d, v_l19d, u_l110d, v_l110d;

	FA l11 (p_prods[0][63:0], p_prods[1][63:0], p_prods[2][63:0], u_l11d[63:0], v_l11d[63:0]);
	FA l12 (p_prods[3][63:0], p_prods[4][63:0], p_prods[5][63:0], u_l12d[63:0], v_l12d[63:0]);
	FA l13 (p_prods[6][63:0], p_prods[7][63:0], p_prods[8][63:0], u_l13d[63:0], v_l13d[63:0]);
	FA l14 (p_prods[9][63:0], p_prods[10][63:0], p_prods[11][63:0], u_l14d[63:0], v_l14d[63:0]);
	FA l15 (p_prods[12][63:0], p_prods[13][63:0], p_prods[14][63:0], u_l15d[63:0], v_l15d[63:0]);
	FA l16 (p_prods[15][63:0], p_prods[16][63:0], p_prods[17][63:0], u_l16d[63:0], v_l16d[63:0]);
	FA l17 (p_prods[18][63:0], p_prods[19][63:0], p_prods[20][63:0], u_l17d[63:0], v_l17d[63:0]);
	FA l18 (p_prods[21][63:0], p_prods[22][63:0], p_prods[23][63:0], u_l18d[63:0], v_l18d[63:0]);
	FA l19 (p_prods[24][63:0], p_prods[25][63:0], p_prods[26][63:0], u_l19d[63:0], v_l19d[63:0]);
	FA l110 (p_prods[27][63:0], p_prods[28][63:0], p_prods[29][63:0], u_l110d[63:0], v_l110d[63:0]);

	DFF DFF_ul11 [63:0] (u_l11d[63:0],clk,1'b0,u_l11[63:0]);
	DFF DFF_ul12 [63:0] (u_l12d[63:0],clk,1'b0,u_l12[63:0]);
	DFF DFF_ul13 [63:0] (u_l13d[63:0],clk,1'b0,u_l13[63:0]);
	DFF DFF_ul14 [63:0] (u_l14d[63:0],clk,1'b0,u_l14[63:0]);
	DFF DFF_ul15 [63:0] (u_l15d[63:0],clk,1'b0,u_l15[63:0]);
	DFF DFF_ul16 [63:0] (u_l16d[63:0],clk,1'b0,u_l16[63:0]);
	DFF DFF_ul17 [63:0] (u_l17d[63:0],clk,1'b0,u_l17[63:0]);
	DFF DFF_ul18 [63:0] (u_l18d[63:0],clk,1'b0,u_l18[63:0]);
	DFF DFF_ul19 [63:0] (u_l19d[63:0],clk,1'b0,u_l19[63:0]);
	DFF DFF_ul110 [63:0] (u_l110d[63:0],clk,1'b0,u_l110[63:0]);

	DFF DFF_vl11 [63:0] (v_l11d[63:0],clk,1'b0,v_l11[63:0]);
	DFF DFF_vl12 [63:0] (v_l12d[63:0],clk,1'b0,v_l12[63:0]);
	DFF DFF_vl13 [63:0] (v_l13d[63:0],clk,1'b0,v_l13[63:0]);
	DFF DFF_vl14 [63:0] (v_l14d[63:0],clk,1'b0,v_l14[63:0]);
	DFF DFF_vl15 [63:0] (v_l15d[63:0],clk,1'b0,v_l15[63:0]);
	DFF DFF_vl16 [63:0] (v_l16d[63:0],clk,1'b0,v_l16[63:0]);
	DFF DFF_vl17 [63:0] (v_l17d[63:0],clk,1'b0,v_l17[63:0]);
	DFF DFF_vl18 [63:0] (v_l18d[63:0],clk,1'b0,v_l18[63:0]);
	DFF DFF_vl19 [63:0] (v_l19d[63:0],clk,1'b0,v_l19[63:0]);
	DFF DFF_vl110 [63:0] (v_l110d[63:0],clk,1'b0,v_l110[63:0]);





	
	//The following is for level 2 of wallace tree
	wire [63:0] u_l21, v_l21, u_l22, v_l22, u_l23, v_l23, u_l24, v_l24, u_l25, v_l25, u_l26, v_l26, u_l27, v_l27;
	wire [63:0] u_l21d, v_l21d, u_l22d, v_l22d, u_l23d, v_l23d, u_l24d, v_l24d, u_l25d, v_l25d, u_l26d, v_l26d, u_l27d, v_l27d;


	FA l21 (u_l11[63:0], v_l11[63:0], u_l12[63:0], u_l21d[63:0], v_l21d[63:0]);
	FA l22 (v_l12[63:0], u_l13[63:0], v_l13[63:0], u_l22d[63:0], v_l22d[63:0]);
	FA l23 (u_l14[63:0], v_l14[63:0], u_l15[63:0], u_l23d[63:0], v_l23d[63:0]);
	FA l24 (v_l15[63:0], u_l16[63:0], v_l16[63:0], u_l24d[63:0], v_l24d[63:0]);
	FA l25 (u_l17[63:0], v_l17[63:0], u_l18[63:0], u_l25d[63:0], v_l25d[63:0]);
	FA l26 (v_l18[63:0], u_l19[63:0], v_l19[63:0], u_l26d[63:0], v_l26d[63:0]);
	FA l27 (u_l110[63:0], v_l110[63:0], p_prods[30][63:0], u_l27d[63:0], v_l27d[63:0]);

	DFF DFF_ul21 [63:0] (u_l21d[63:0],clk,1'b0,u_l21[63:0]);
	DFF DFF_ul22 [63:0] (u_l22d[63:0],clk,1'b0,u_l22[63:0]);
	DFF DFF_ul23 [63:0] (u_l23d[63:0],clk,1'b0,u_l23[63:0]);
	DFF DFF_ul24 [63:0] (u_l24d[63:0],clk,1'b0,u_l24[63:0]);
	DFF DFF_ul25 [63:0] (u_l25d[63:0],clk,1'b0,u_l25[63:0]);
	DFF DFF_ul26 [63:0] (u_l26d[63:0],clk,1'b0,u_l26[63:0]);
	DFF DFF_ul27 [63:0] (u_l27d[63:0],clk,1'b0,u_l27[63:0]);

	DFF DFF_vl21 [63:0] (v_l21d[63:0],clk,1'b0,v_l21[63:0]);
	DFF DFF_vl22 [63:0] (v_l22d[63:0],clk,1'b0,v_l22[63:0]);
	DFF DFF_vl23 [63:0] (v_l23d[63:0],clk,1'b0,v_l23[63:0]);
	DFF DFF_vl24 [63:0] (v_l24d[63:0],clk,1'b0,v_l24[63:0]);
	DFF DFF_vl25 [63:0] (v_l25d[63:0],clk,1'b0,v_l25[63:0]);
	DFF DFF_vl26 [63:0] (v_l26d[63:0],clk,1'b0,v_l26[63:0]);
	DFF DFF_vl27 [63:0] (v_l27d[63:0],clk,1'b0,v_l27[63:0]);

	
	//The following is for level 3 of wallace tree
	wire [63:0] u_l31, v_l31, u_l32, v_l32, u_l33, v_l33, u_l34, v_l34, u_l35, v_l35;
	wire [63:0] u_l31d, v_l31d, u_l32d, v_l32d, u_l33d, v_l33d, u_l34d, v_l34d, u_l35d, v_l35d;


	FA l31 (u_l21[63:0], v_l21[63:0], u_l22[63:0], u_l31d[63:0], v_l31d[63:0]);
	FA l32 (v_l22[63:0], u_l23[63:0], v_l23[63:0], u_l32d[63:0], v_l32d[63:0]);
	FA l33 (u_l24[63:0], v_l24[63:0], u_l25[63:0], u_l33d[63:0], v_l33d[63:0]);
	FA l34 (v_l25[63:0], u_l26[63:0], v_l26[63:0], u_l34d[63:0], v_l34d[63:0]);
	FA l35 (u_l27[63:0], v_l27[63:0], p_prods[31][63:0], u_l35d[63:0], v_l35d[63:0]);

	DFF DFF_ul31 [63:0] (u_l31d[63:0],clk,1'b0,u_l31[63:0]);
	DFF DFF_ul32 [63:0] (u_l32d[63:0],clk,1'b0,u_l32[63:0]);
	DFF DFF_ul33 [63:0] (u_l33d[63:0],clk,1'b0,u_l33[63:0]);
	DFF DFF_ul34 [63:0] (u_l34d[63:0],clk,1'b0,u_l34[63:0]);
	DFF DFF_ul35 [63:0] (u_l35d[63:0],clk,1'b0,u_l35[63:0]);

	DFF DFF_vl31 [63:0] (v_l31d[63:0],clk,1'b0,v_l31[63:0]);
	DFF DFF_vl32 [63:0] (v_l32d[63:0],clk,1'b0,v_l32[63:0]);
	DFF DFF_vl33 [63:0] (v_l33d[63:0],clk,1'b0,v_l33[63:0]);
	DFF DFF_vl34 [63:0] (v_l34d[63:0],clk,1'b0,v_l34[63:0]);
	DFF DFF_vl35 [63:0] (v_l35d[63:0],clk,1'b0,v_l35[63:0]);

	// The following is for level 4 of wallace tree
	wire [63:0] u_l41, v_l41, u_l42, v_l42, u_l43, v_l43;
	wire [63:0] u_l41d, v_l41d, u_l42d, v_l42d, u_l43d, v_l43d;


	FA l41 (u_l31[63:0], v_l31[63:0], u_l32[63:0], u_l41d[63:0], v_l41d[63:0]);
	FA l42 (v_l32[63:0], u_l33[63:0], v_l33[63:0], u_l42d[63:0], v_l42d[63:0]);
	FA l43 (u_l34[63:0], v_l34[63:0], u_l35[63:0], u_l43d[63:0], v_l43d[63:0]);

	DFF DFF_ul41 [63:0] (u_l41d[63:0],clk,1'b0,u_l41[63:0]);
	DFF DFF_ul42 [63:0] (u_l42d[63:0],clk,1'b0,u_l42[63:0]);
	DFF DFF_ul43 [63:0] (u_l43d[63:0],clk,1'b0,u_l43[63:0]);

	DFF DFF_vl41 [63:0] (v_l41d[63:0],clk,1'b0,v_l41[63:0]);
	DFF DFF_vl42 [63:0] (v_l42d[63:0],clk,1'b0,v_l42[63:0]);
	DFF DFF_vl43 [63:0] (v_l43d[63:0],clk,1'b0,v_l43[63:0]);
	
	// The following is for level 5 of wallace tree
	wire [63:0] u_l51, v_l51, u_l52, v_l52;
	wire [63:0] u_l51d, v_l51d, u_l52d, v_l52d;


	FA l51 (u_l41[63:0], v_l41[63:0], u_l42[63:0], u_l51d[63:0], v_l51d[63:0]);
	FA l52 (v_l42[63:0], u_l43[63:0], v_l43[63:0], u_l52d[63:0], v_l52d[63:0]);

	DFF DFF_ul51 [63:0] (u_l51d[63:0],clk,1'b0,u_l51[63:0]);
	DFF DFF_ul52 [63:0] (u_l52d[63:0],clk,1'b0,u_l52[63:0]);

	DFF DFF_vl51 [63:0] (v_l51d[63:0],clk,1'b0,v_l51[63:0]);
	DFF DFF_vl52 [63:0] (v_l52d[63:0],clk,1'b0,v_l52[63:0]);

	// The following is for level 6 of wallace tree
	wire [63:0] u_l61, v_l61;
	wire [63:0] u_l61d, v_l61d;

	FA l61 (u_l51[63:0], v_l51[63:0], u_l52[63:0], u_l61d[63:0], v_l61d[63:0]);

	DFF DFF_ul61 [63:0] (u_l61d[63:0],clk,1'b0,u_l61[63:0]);
	DFF DFF_vl61 [63:0] (v_l61d[63:0],clk,1'b0,v_l61[63:0]);
	
	// The following is for level 7 of wallace tree
	wire [63:0] u_l71, v_l71;
	wire [63:0] u_l71d, v_l71d;

	FA l71 (u_l61[63:0], v_l61[63:0], v_l52[63:0], u_l71d[63:0], v_l71d[63:0]);

	DFF DFF_ul71 [63:0] (u_l71d[63:0],clk,1'b0,u_l71[63:0]);
	DFF DFF_vl71 [63:0] (v_l71d[63:0],clk,1'b0,v_l71[63:0]);

	// The following is for level 8 of wallace tree
	wire [63:0] u_l81, v_l81;
	wire [63:0] u_l81d, v_l81d;

	FA l81 (u_l71[63:0], v_l71[63:0], v_l35[63:0], u_l81d[63:0], v_l81d[63:0]);

	DFF DFF_ul81 [63:0] (u_l81d[63:0],clk,1'b0,u_l81[63:0]);
	DFF DFF_vl81 [63:0] (v_l81d[63:0],clk,1'b0,v_l81[63:0]);

	// The following is for level 9 of wallace tree
	wire c,cd;
	rdcla l91 (out[31:0], cd, u_l81[31:0], v_l81[31:0], 1'b0, clk);
	//DFF DFF_cin (cd,clk,1'b0,c);
	rdcla l92 (out[63:32], , u_l81[63:32], v_l81[63:32], cd, clk);

endmodule

