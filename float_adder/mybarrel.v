module shiftright(input[7:0] mag,input[23:0] ip,output[23:0] op);//divide by 2
    //if 3 msb have a one, then output is 0
    //wire overflow @5 bits
    wire w_ov;
    wire[23:0]o;//temporary output
    wire[31:0] w_23, w_22, w_21, w_20, w_19, w_18, w_17, w_16, w_15, w_14, w_13, w_12, w_11, w_10, w_9, w_8, w_7, w_6, w_5, w_4, w_3, w_2, w_1, w_0;
    or(w_ov,mag[7],mag[6],mag[5]);

    genvar i;
    generate
    for(i=0;i<=23;i=i+1)begin
        //assign op[i]=o[i] and ~w_ov;
        and(op[i],o[i],~w_ov);
    end

    endgenerate

    assign w_23[0]=ip[23];
    assign w_23[31:1]=31'd0;
    mux32 m23(w_23,mag[4:0],o[23]);
    assign w_22[1:0]=ip[23:22];
    assign w_22[31:2]=30'b0;
    mux32 m22(w_22,mag[4:0],o[22]);
    assign w_21[2:0]=ip[23:21];
    assign w_21[31:3]=29'b0;
    mux32 m21(w_21,mag[4:0],o[21]);
    assign w_20[3:0]=ip[23:20];
    assign w_20[31:4]=28'b0;
    mux32 m20(w_20,mag[4:0],o[20]);
    assign w_19[4:0]=ip[23:19];
    assign w_19[31:5]=27'b0;
    mux32 m19(w_19,mag[4:0],o[19]);
    assign w_18[5:0]=ip[23:18];
    assign w_18[31:6]=26'b0;
    mux32 m18(w_18,mag[4:0],o[18]);
    assign w_17[6:0]=ip[23:17];
    assign w_17[31:7]=25'b0;
    mux32 m17(w_17,mag[4:0],o[17]);
    assign w_16[7:0]=ip[23:16];
    assign w_16[31:8]=24'b0;
    mux32 m16(w_16,mag[4:0],o[16]);
    assign w_15[8:0]=ip[23:15];
    assign w_15[31:9]=23'b0;
    mux32 m15(w_15,mag[4:0],o[15]);
    assign w_14[9:0]=ip[23:14];
    assign w_14[31:10]=22'b0;
    mux32 m14(w_14,mag[4:0],o[14]);
    assign w_13[10:0]=ip[23:13];
    assign w_13[31:11]=21'b0;
    mux32 m13(w_13,mag[4:0],o[13]);
    assign w_12[11:0]=ip[23:12];
    assign w_12[31:12]=20'b0;
    mux32 m12(w_12,mag[4:0],o[12]);
    assign w_11[12:0]=ip[23:11];
    assign w_11[31:13]=19'b0;
    mux32 m11(w_11,mag[4:0],o[11]);
    assign w_10[13:0]=ip[23:10];
    assign w_10[31:14]=18'b0;
    mux32 m10(w_10,mag[4:0],o[10]);
    assign w_9[14:0]=ip[23:9];
    assign w_9[31:15]=17'b0;
    mux32 m9(w_9,mag[4:0],o[9]);
    assign w_8[15:0]=ip[23:8];
    assign w_8[31:16]=16'b0;
    mux32 m8(w_8,mag[4:0],o[8]);
    assign w_7[16:0]=ip[23:7];
    assign w_7[31:17]=15'b0;
    mux32 m7(w_7,mag[4:0],o[7]);
    assign w_6[17:0]=ip[23:6];
    assign w_6[31:18]=14'b0;
    mux32 m6(w_6,mag[4:0],o[6]);
    assign w_5[18:0]=ip[23:5];
    assign w_5[31:19]=13'b0;
    mux32 m5(w_5,mag[4:0],o[5]);
    assign w_4[19:0]=ip[23:4];
    assign w_4[31:20]=12'b0;
    mux32 m4(w_4,mag[4:0],o[4]);
    assign w_3[20:0]=ip[23:3];
    assign w_3[31:21]=11'b0;
    mux32 m3(w_3,mag[4:0],o[3]);
    assign w_2[21:0]=ip[23:2];
    assign w_2[31:22]=10'b0;
    mux32 m2(w_2,mag[4:0],o[2]);
    assign w_1[22:0]=ip[23:1];
    assign w_1[31:23]=9'b0;
    mux32 m1(w_1,mag[4:0],o[1]);
    assign w_0[23:0]=ip[23:0];
    assign w_0[31:24]=8'b0;
    mux32 m0(w_0,mag[4:0],o[0]);

endmodule


module shiftleft(input[7:0] mag,input[23:0] ipl,output[23:0] op);//divide by 2
    reg[31:0] zeros;
    //if 3 msb have a one, then output is 0
    //wire overflow @5 bits
    wire w_ov;
    wire[0:23] ip;
    wire[23:0]o;//temporary output
    wire[31:0] w_23, w_22, w_21, w_20, w_19, w_18, w_17, w_16, w_15, w_14, w_13, w_12, w_11, w_10, w_9, w_8, w_7, w_6, w_5, w_4, w_3, w_2, w_1, w_0;
    or(w_ov,mag[7],mag[6],mag[5]);

    genvar i;
    generate
    for(i=0;i<=23;i=i+1)begin
        //assign op[i]=o[i] and ~w_ov;
        and(op[i],o[i],~w_ov);
        assign ip[i]=ipl[i];
    end

    endgenerate

    assign w_23[23:0]=ip[0:23];
    assign w_23[31:24]=8'b0;
    mux32 m23(w_23,mag[4:0],o[23]);
    assign w_22[22:0]=ip[0:22];
    assign w_22[31:23]=9'b0;
    mux32 m22(w_22,mag[4:0],o[22]);
    assign w_21[21:0]=ip[0:21];
    assign w_21[31:22]=10'b0;
    mux32 m21(w_21,mag[4:0],o[21]);
    assign w_20[20:0]=ip[0:20];
    assign w_20[31:21]=11'b0;
    mux32 m20(w_20,mag[4:0],o[20]);
    assign w_19[19:0]=ip[0:19];
    assign w_19[31:20]=12'b0;
    mux32 m19(w_19,mag[4:0],o[19]);
    assign w_18[18:0]=ip[0:18];
    assign w_18[31:19]=13'b0;
    mux32 m18(w_18,mag[4:0],o[18]);
    assign w_17[17:0]=ip[0:17];
    assign w_17[31:18]=14'b0;
    mux32 m17(w_17,mag[4:0],o[17]);
    assign w_16[16:0]=ip[0:16];
    assign w_16[31:17]=15'b0;
    mux32 m16(w_16,mag[4:0],o[16]);
    assign w_15[15:0]=ip[0:15];
    assign w_15[31:16]=16'b0;
    mux32 m15(w_15,mag[4:0],o[15]);
    assign w_14[14:0]=ip[0:14];
    assign w_14[31:15]=17'b0;
    mux32 m14(w_14,mag[4:0],o[14]);
    assign w_13[13:0]=ip[0:13];
    assign w_13[31:14]=18'b0;
    mux32 m13(w_13,mag[4:0],o[13]);
    assign w_12[12:0]=ip[0:12];
    assign w_12[31:13]=19'b0;
    mux32 m12(w_12,mag[4:0],o[12]);
    assign w_11[11:0]=ip[0:11];
    assign w_11[31:12]=20'b0;
    mux32 m11(w_11,mag[4:0],o[11]);
    assign w_10[10:0]=ip[0:10];
    assign w_10[31:11]=21'b0;
    mux32 m10(w_10,mag[4:0],o[10]);
    assign w_9[9:0]=ip[0:9];
    assign w_9[31:10]=22'b0;
    mux32 m9(w_9,mag[4:0],o[9]);
    assign w_8[8:0]=ip[0:8];
    assign w_8[31:9]=23'b0;
    mux32 m8(w_8,mag[4:0],o[8]);
    assign w_7[7:0]=ip[0:7];
    assign w_7[31:8]=24'b0;
    mux32 m7(w_7,mag[4:0],o[7]);
    assign w_6[6:0]=ip[0:6];
    assign w_6[31:7]=25'b0;
    mux32 m6(w_6,mag[4:0],o[6]);
    assign w_5[5:0]=ip[0:5];
    assign w_5[31:6]=26'b0;
    mux32 m5(w_5,mag[4:0],o[5]);
    assign w_4[4:0]=ip[0:4];
    assign w_4[31:5]=27'b0;
    mux32 m4(w_4,mag[4:0],o[4]);
    assign w_3[3:0]=ip[0:3];
    assign w_3[31:4]=28'b0;
    mux32 m3(w_3,mag[4:0],o[3]);
    assign w_2[2:0]=ip[0:2];
    assign w_2[31:3]=29'b0;
    mux32 m2(w_2,mag[4:0],o[2]);
    assign w_1[1:0]=ip[0:1];
    assign w_1[31:2]=30'b0;
    mux32 m1(w_1,mag[4:0],o[1]);
    assign w_0[0]=ip[0];
    assign w_0[31:1]=31'b0;
    mux32 m0(w_0,mag[4:0],o[0]);



endmodule


//up, down are inputs 1 means up 0 means down

module mux32(input[31:0]cont,input[4:0]ip,output o);
    wire[1:0] t;
    mux16 mu(cont[31:16],ip[3:0],t[1]);
    mux16 md(cont[15:0],ip[3:0],t[0]);
    mux2 mf(t,ip[4],o);
endmodule


module mux16(input[15:0] cont,input[3:0] ip,output o);
    wire[1:0] t;
    mux8 mu(cont[15:8],ip[2:0],t[1]);
    mux8 md(cont[7:0],ip[2:0],t[0]);
    mux2 mf(t,ip[3],o);

endmodule

module mux8(input[7:0] cont,input[2:0] ip,output o);
    wire[1:0] t;
    mux4 mu(cont[7:4],ip[1:0],t[1]);
    mux4 md(cont[3:0],ip[1:0],t[0]);
    mux2 mf(t,ip[2],o);

endmodule

module mux4(input[3:0] cont,input[1:0] ip,output o);
    wire[1:0] t;
    mux2 mu(cont[3:2],ip[0],t[1]);
    mux2 md(cont[1:0],ip[0],t[0]);
    mux2 mf(t,ip[1],o);

endmodule

module mux2(input[1:0] cont,input ip,output o);

    and(t1,cont[1],ip);
    and(t2,cont[0],~ip);
    or(o,t1,t2);

endmodule