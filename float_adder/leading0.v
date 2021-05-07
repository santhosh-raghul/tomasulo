`include "recurdouble32.v"
module leading0(input [23:0] a,
                output [7:0] lz);

    //24 bit input add the leading zeros complexity of order log(n)*log(n)
    //3-3-3-3-3-3-3-3 
    //6-6-6-6
    //12-12
    //24
    assign lz[7:5]=3'b0;
    wire[2:0] w3_0, w3_1, w3_2, w3_3, w3_4, w3_5, w3_6, w3_7;
    wire[1:0] s3_0, s3_1, s3_2, s3_3, s3_4, s3_5, s3_6, s3_7;
    wire[2:0] s6_0, s6_1, s6_2, s6_3;
    wire[3:0] s12_0, s12_1;

    assign w3_0[2:0]=a[23:21];
    assign w3_1[2:0]=a[20:18];
    assign w3_2[2:0]=a[17:15];
    assign w3_3[2:0]=a[14:12];
    assign w3_4[2:0]=a[11:9];
    assign w3_5[2:0]=a[8:6];
    assign w3_6[2:0]=a[5:3];
    assign w3_7[2:0]=a[2:0];
    check3 m_c0(w3_0,s3_0,f3_0);
    check3 m_c1(w3_1,s3_1,f3_1);
    check3 m_c2(w3_2,s3_2,f3_2);
    check3 m_c3(w3_3,s3_3,f3_3);
    check3 m_c4(w3_4,s3_4,f3_4);
    check3 m_c5(w3_5,s3_5,f3_5);
    check3 m_c6(w3_6,s3_6,f3_6);
    check3 m_c7(w3_7,s3_7,f3_7);
    // always @*
    // $display("\n 3s%t: %b %b %b %b %b %b %b %b;\n%b %b %b %b %b %b %b %b\n",$time,s3_0, s3_1, s3_2, s3_3, s3_4, s3_5, s3_6, s3_7,f3_0, f3_1, f3_2, f3_3, f3_4, f3_5, f3_6, f3_7);
    
    
    //6s
    check6 m_c8(s3_0,f3_0,s3_1,f3_1,s6_0,f6_0);
    check6 m_c9(s3_2,f3_2,s3_3,f3_3,s6_1,f6_1);
    check6 m_c10(s3_4,f3_4,s3_5,f3_5,s6_2,f6_2);
    check6 m_c11(s3_6,f3_6,s3_7,f3_7,s6_3,f6_3);
    // always @*
    // $display("\n 6s%t: %b %b %b %b;\n",$time,s6_0, s6_1, s6_2, s6_3);
    //12s
    check12 m_c12(s6_0,f6_0,s6_1,f6_1,s12_0,f12_0);
    check12 m_c13(s6_2,f6_2,s6_3,f6_3,s12_1,f12_1);
    // always @*
    // $display("\n 12s%t: %b %b;\n",$time,s12_0, s12_1);
    //24
    check24 m_c14(s12_0,f12_0,s12_1,f12_1,lz[4:0],f24_0);
    

endmodule

module check24(input[3:0] w0,
            input f0,
            input[3:0] w1,
            input f1,
            output [4:0]s,
            output full);
    wire [3:0]s1;
    wire [3:0]s2;
    and(full,f0,f1);
    genvar i;
    for (i=0;i<4;i=i+1)begin
        assign s2[i]=f0*w1[i];
        assign s1[i]=w0[i];
    end

    recurdouble4 countfull(s1,s2 ,s[3:0], s[4], 1'b0);
endmodule


module check12(input[2:0] w0,
            input f0,
            input[2:0] w1,
            input f1,
            output [3:0]s,
            output full);
    wire [3:0]s1;
    wire [3:0]s2;
    assign s1[3]=1'b0;
    assign s2[3]=1'b0;
    and(full,f0,f1);
    genvar i;
    for (i=0;i<3;i=i+1)begin
        assign s2[i]=f0*w1[i];
        assign s1[i]=w0[i];
    end

    recurdouble4 count12(s1,s2 ,s, ovl, 1'b0);
endmodule

module check6(input[1:0] w0,
            input f0,
            input[1:0] w1,
            input f1,
            output [2:0]s,
            output full);

    and (full,f0,f1);
    assign s[0]=((w0[0]^w1[0])*f0)|((!f0)*w0[0]);
    and (c1,w0[0],w1[0]);
    assign s[1]=((w0[1]^w1[1]^c1)*f0)|((!f0)*w0[1]);
    assign s[2]=f0*(w1[1]|w1[0]);//4 means w0 says 3 and atleast 1 in w1


endmodule

module check3(input [2:0] a,output [1:0]count3,output full);
    assign count3[1]=(!a[2])*(!a[1]);
    assign full=count3[1]*(!a[0]);
    assign count3[0]=full|(!a[2])*(a[1]);
endmodule