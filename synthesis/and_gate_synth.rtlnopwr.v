module and_gate (a, b, y);

input a;
input b;
output y;

wire vdd = 1'b1;
wire gnd = 1'b0;

BUFX2 BUFX2_1 ( .A(_0_), .Y(y) );
AND2X2 AND2X2_1 ( .A(a), .B(b), .Y(_0_) );
endmodule
