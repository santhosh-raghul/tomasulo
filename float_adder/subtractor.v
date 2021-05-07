`include "eightBitAdder.v"
module subtract(input[7:0]a,
                input[7:0]b,
                output[7:0]shifta,
                output[7:0]shiftb,
                output[7:0] max,
                output co);

    //if a is greater than b
    //127+exp form
    wire b1;
    wire [7:0]s;
    wire [7:0]twos;
    wire [7:0]ze;
    eightBitAdder diff(a, b, 1'b1, s, co);
    // rippeaddersub diff(a[3:0], b[3:0], s[3:0], b1,1'b1);
    // rippeaddersub final(a[7:4],b[7:4],s[7:4], co,b1);
    //if co is one implies a>=b
    //else a<b and the number has to be converted
    assign ze=8'b0;
    eightBitAdder twoc(ze, s, 1'b1, twos, cot);
    // rippeaddersub twoc(ze[3:0], s[3:0], twos[3:0], b1t,1'b1);
    // rippeaddersub twocfinal(ze[7:4],s[7:4],twos[7:4], cot,b1t);

    genvar i;
    generate
    for(i=0;i<=7;i=i+1)begin
        assign shifta[i]=~co&twos[i];
        assign shiftb[i]=co&s[i];
        assign t1=co&a[i];
        assign t2=~co&b[i];
        assign max[i]=t1|t2;
    end

    endgenerate

endmodule

