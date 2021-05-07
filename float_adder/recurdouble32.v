//(a,b)=(0,1)  01-prop 00kil 11gen

module recurdouble32 (a,b_in ,sum, ovl, cin);

	input [31:0] a, b_in;
	input cin;
	output reg [31:0] sum;
	output reg ovl;
	wire[31:0] b;
	genvar i;
    generate
    for(i=0;i<=31;i=i+1)begin
        //assign op[i]=o[i] and ~w_ov;
		assign b[i]= (!cin)*(b_in[i]) + (cin)*(!b_in[i]);
    end

    endgenerate
	wire [32:0] xa, xb;
	wire [32:0] xa_1, xb_1, xa_2, xb_2, xa_4, xb_4, xa_8, xb_8, xa_16, xb_16;
	

	assign xa[0] = cin;
	assign xb[0] = cin;

	always @(*)
	begin

		sum = a^b^xa_16[31:0];
		ovl = xa_16[32];	

	end
	
	pregen pref [32:1] (xb[32:1], xa[32:1], a[31:0], b[31:0]);

	assign xb_1[0] = cin;
	assign xa_1[0] = cin;
	assign xb_2[1:0] = xb_1[1:0];
	assign xa_2[1:0] = xa_1[1:0];
	assign xb_4[3:0] = xb_2[3:0];
	assign xa_4[3:0] = xa_2[3:0];
	assign xb_8[7:0] = xb_4[7:0];
	assign xa_8[7:0] = xa_4[7:0];
	assign xb_16[15:0] = xb_8[15:0];
	assign xa_16[15:0] = xa_8[15:0];

	cargen i1 [32:1] (xb[32:1], xa[32:1], xb[31:0], xa[31:0], xb_1[32:1], xa_1[32:1]);
	cargen i2 [32:2] (xb_1[32:2], xa_1[32:2], xb_1[30:0], xa_1[30:0], xb_2[32:2], xa_2[32:2]);
	cargen i4 [32:4] (xb_2[32:4], xa_2[32:4], xb_2[28:0], xa_2[28:0], xb_4[32:4], xa_4[32:4]);
	cargen i8 [32:8] (xb_4[32:8], xa_4[32:8], xb_4[24:0], xa_4[24:0], xb_8[32:8], xa_8[32:8]);
	cargen i16 [32:16] (xb_8[32:16], xa_8[32:16], xb_8[16:0], xa_8[16:0], xb_16[32:16], xa_16[32:16]);

endmodule

//(a,b)=(0,1)  01-prop 00kil 11gen

module recurdouble8 (a,b_in ,sum, ovl, cin);

	input [7:0] a, b_in;
	input cin;
	output reg [7:0] sum;
	output reg ovl;
	wire[7:0] b;
	genvar i;
    generate
    for(i=0;i<=7;i=i+1)begin
        //assign op[i]=o[i] and ~w_ov;
		assign b[i]= (!cin)*(b_in[i]) + (cin)*(!b_in[i]);
    end

    endgenerate
	wire [8:0] xa, xb;
	wire [8:0] xa_1, xb_1, xa_2, xb_2, xa_4, xb_4;
	

	assign xa[0] = cin;
	assign xb[0] = cin;

	always @(*)
	begin

		sum = a^b^xa_4[7:0];
		ovl = xa_4[8];	

	end
	
	pregen pref [8:1] (xb[8:1], xa[8:1], a[7:0], b[7:0]);

	assign xb_1[0] = cin;
	assign xa_1[0] = cin;
	assign xb_2[1:0] = xb_1[1:0];
	assign xa_2[1:0] = xa_1[1:0];
	assign xb_4[3:0] = xb_2[3:0];
	assign xa_4[3:0] = xa_2[3:0];

    //change pending
	cargen i1 [8:1] (xb[8:1], xa[8:1], xb[7:0], xa[7:0], xb_1[8:1], xa_1[8:1]);
	cargen i2 [8:2] (xb_1[8:2], xa_1[8:2], xb_1[6:0], xa_1[6:0], xb_2[8:2], xa_2[8:2]);
	cargen i4 [8:4] (xb_2[8:4], xa_2[8:4], xb_2[4:0], xa_2[4:0], xb_4[8:4], xa_4[8:4]);

endmodule


module recurdouble4 (a,b_in ,sum, ovl, cin);

	input [3:0] a, b_in;
	input cin;
	output reg [3:0] sum;
	output reg ovl;
	wire[3:0] b;
	genvar i;
    generate
    for(i=0;i<=3;i=i+1)begin
        //assign op[i]=o[i] and ~w_ov;
		assign b[i]= (!cin)*(b_in[i]) + (cin)*(!b_in[i]);
    end

    endgenerate
	wire [4:0] xa, xb;
	wire [4:0] xa_1, xb_1, xa_2, xb_2;
	

	assign xa[0] = cin;
	assign xb[0] = cin;

	always @(*)
	begin

		sum = a^b^xa_2[4:0];
		ovl = xa_2[4];	

	end
	
	pregen pref [4:1] (xb[4:1], xa[4:1], a[3:0], b[3:0]);

	assign xb_1[0] = cin;
	assign xa_1[0] = cin;
	assign xb_2[1:0] = xb_1[1:0];
	assign xa_2[1:0] = xa_1[1:0];

    
	cargen i1 [4:1] (xb[4:1], xa[4:1], xb[3:0], xa[3:0], xb_1[4:1], xa_1[4:1]);
	cargen i2 [4:2] (xb_1[4:2], xa_1[4:2], xb_1[2:0], xa_1[2:0], xb_2[4:2], xa_2[4:2]);

endmodule

module pregen(
	output reg o1, o0,
	input a, b
);
	always @*
	case ({a, b})
		2'b00: begin
			o0 = 1'b0; o1 = 1'b0;
		end
		2'b11: begin
			o0 = 1'b1; o1 = 1'b1;
		end
		default: begin 
			o0 = 1'b0; o1 = 1'b1;
		end
	endcase
	// assign o0=a*b;
	// assign o1=(!a)|(!b);
endmodule

module cargen (input curbb, curba, prevbb, prevba,
output reg obb, oba
);
	always @(*)
	begin
	
		if({curbb, curba} == 2'b00)
			{obb, oba} = 2'b00;
		
		if({curbb, curba} == 2'b11)
			{obb, oba} = 2'b11;

		if({curbb, curba} == 2'b10)
			{obb, oba} = {prevbb, prevba};

	end
	// assign obb=(curba*curbb)+(curba*!curbb)*prevbb;
	// assign oba=(curba*curbb)+(curba*!curbb)*prevba;
endmodule