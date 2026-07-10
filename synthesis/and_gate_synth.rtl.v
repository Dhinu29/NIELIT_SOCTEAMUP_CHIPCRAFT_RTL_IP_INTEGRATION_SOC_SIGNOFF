module and_gate ( gnd, vdd, a, b, y);

input gnd, vdd;
input a;
input b;
output y;

BUFX2 BUFX2_1 ( .gnd(gnd), .vdd(vdd), .A(_0_), .Y(y) );
AND2X2 AND2X2_1 ( .gnd(gnd), .vdd(vdd), .A(a), .B(b), .Y(_0_) );
endmodule
