module and_gate ( gnd, vdd, a, b, y);

input gnd, vdd;
input a;
input b;
output y;

BUFX2 BUFX2_1 ( .gnd(gnd), .vdd(vdd), .A(_0_), .Y(y) );
AND2X2 AND2X2_1 ( .gnd(gnd), .vdd(vdd), .A(a), .B(b), .Y(_0_) );
FILL FILL_0_0_0 ( .vdd(vdd), .gnd(gnd) );
FILL FILL_0_0_1 ( .vdd(vdd), .gnd(gnd) );
FILL FILL_0_0_2 ( .vdd(vdd), .gnd(gnd) );
FILL FILL_0_0_3 ( .vdd(vdd), .gnd(gnd) );
FILL FILL_0_0_0 ( .vdd(vdd), .gnd(gnd) );
FILL FILL_0_0_1 ( .vdd(vdd), .gnd(gnd) );
FILL FILL_0_0_2 ( .vdd(vdd), .gnd(gnd) );
FILL FILL_0_0_3 ( .vdd(vdd), .gnd(gnd) );
endmodule
