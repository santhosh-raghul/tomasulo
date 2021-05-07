`include "subtractor.v"
`include "mybarrel.v"
`include "leading0.v"


`include "32rdcla.v"
//`include "recurdouble32.v"
//convert to the same exponent
//figure out which 
//step2 is to take care of the sign; if both are positive
// or if both are negative then just add
// else convert the negative number to 2's complement
// if answer is negative convert it.



//NAN is not acceptable
// all 0 is a zero
// x 255 0 is infinity
// it is written for only normalised numbers

module fpadd(input[31:0] a,
            input[31:0] b,
            output[31:0] finalsum,input clk);
    wire [31:0] finalsum_ss,finalsum_ds;
    wire [7:0] shia, shib,max,maxd,shiad, shibd;
    wire [4:0] shifta,shiftb;
    wire [23:0]temp_a,temp_b;
    wire [31:0]tempshift_a,tempshift_b,tempshift_ad,tempshift_bd;
    wire [31:0] sum_ab,sum_ba,sum_abd,sum_bad,finalsumd;
    wire addorsub;
    xor (addorsub,a[31],b[31]);
    //wire ova,ovb;//check overflow at 31 as limit for shifting

    //stage-1 exponent subtraction
    subtract m_subexp(a[30:23],b[30:23],shiad,shibd,maxd,ca);
    DFF DFF1 [7:0] (shiad,clk,1'b0,shia);
    DFF DFF2 [7:0] (shibd,clk,1'b0,shib);
    DFF DFF5 [7:0] (maxd,clk,1'b0,max);
    //barrel shift
    assign temp_a[23]=1'b1;
    assign temp_b[23]=1'b1;
    assign temp_a[22:0]=a[22:0];
    assign temp_b[22:0]=b[22:0];
    assign tempshift_a[31:24]=7'b0;
    assign tempshift_b[31:24]=7'b0;

    //stage-2 mantissa shifting
    //change the barrel shift to proper level
    shiftright m_shiftinga(shia,temp_a,tempshift_ad[23:0]);
    shiftright m_shiftingb(shib,temp_b,tempshift_bd[23:0]);

    DFF DFF3 [23:0] (tempshift_ad[23:0],clk,1'b0,tempshift_a[23:0]);
    DFF DFF4 [23:0] (tempshift_bd[23:0],clk,1'b0,tempshift_b[23:0]);

    //stage-3,4,5,6,7,8 in rdcla (6 stage rdcla)
    rdcla m_arithab(tempshift_a,tempshift_b,sum_abd, ovl_ab, addorsub,clk);
    rdcla m_arithba(tempshift_b,tempshift_a,sum_bad, ovl_ba, addorsub,clk);
    DFF DFF6 [31:0] (sum_abd,clk,1'b0,sum_ab);
    DFF DFF7 [31:0] (sum_bad,clk,1'b0,sum_ba);

    //stage-9 choosing correct sum and passing to op
    samesign m_ss(a,ovl_ab,sum_ab,sum_ba,addorsub,max,finalsum_ss);
    diffsign m_ds(a,ovl_ab,sum_ab,sum_ba,addorsub,max,finalsum_ds);
    genvar i;
    for(i=0;i<=31;i=i+1)begin
        assign finalsumd[i]=((!addorsub)*finalsum_ss[i])|((addorsub)*finalsum_ds[i]);
    end
    DFF DFF8 [31:0](finalsumd,clk,1'b0,finalsum);


endmodule

module samesign(input[31:0] a,
                input ovl_ab,
                input[31:0] sum_ab,
                input[31:0] sum_ba,
                input addorsub,
                input [7:0] max,
                output[31:0] finalsum);
    //if same sign
    wire[7:0] expone;
    assign expone=8'd1;
    wire [7:0] finalexp;
    //add exponent with one if the number has sum[24] is set
    recurdouble8 m_finexp(max,expone,finalexp,ovl_exp,1'b0);
    genvar i;
    generate
    for(i=0;i<23;i=i+1)begin
        //if no ovl 23:0 is directly mapped else 24:1
		assign finalsum[i]= ((!sum_ab[24])*(sum_ab[i]) )|( (sum_ab[24])*(sum_ab[i+1])*(!ovl_exp));
    end
    endgenerate

    assign finalsum[31]=a[31];
    generate
    for(i=23;i<31;i=i+1)begin
        assign finalsum[i]=(max[i-23]*(!sum_ab[24])+(sum_ab[24])*finalexp[i-23])+ovl_exp;
    end
    endgenerate

endmodule

module diffsign(input[31:0] a,
                input ovl_ab,
                input[31:0] sum_ab,
                input[31:0] sum_ba,
                input addorsub,
                input [7:0] max,
                output[31:0] finalsum);
    wire [23:0] finalmantissa;
    wire [31:0] tempsum,tempsum_mantissa,tempsum_mantissad;
    genvar i;
    generate
    for(i=0;i<=23;i=i+1)begin
        assign finalmantissa[i]=(ovl_ab*sum_ab[i])|(!ovl_ab*sum_ba[i]);
    end
    endgenerate
    wire [7:0] shiftmag;
    //if we took the difference then we may have to reduce the exponent
    //sum_ab or sum_ba shud have the correct difference, after getting the correct value
    //calculate the leading 0s for the last 24 bits(23:0)
    //calculate leading zeros
    leading0 m_lc0(finalmantissa,shiftmag);
    shiftleft m_slmantissa(shiftmag,finalmantissa[23:0],tempsum_mantissa[23:0]);
    //leading_zero lead1(finalmantissa,tempsum_mantissa[23:0]);
    //DFF DFF9 [31:0] (tempsum_mantissad,clk,1'b0,tempsum_mantissa);
    assign tempsum[22:0]=tempsum_mantissa[22:0];
    recurdouble8 m_exp_correction(max,shiftmag,tempsum[30:23],ovl_exp,1'b1);


    assign finalsum[31]=ovl_exp*(((!addorsub)*a[31])+((addorsub)*((ovl_ab)*a[31]+(!ovl_ab)*(!a[31]))));
    for(i=0;i<31;i=i+1)begin
        assign finalsum[i]=ovl_exp*tempsum[i];
    end


endmodule
