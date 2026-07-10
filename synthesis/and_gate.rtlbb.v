module and_gate (a, b, y);

input a;
input b;
output y;

BUFX2 BUFX2_1 ( .A(_0_), .Y(y) );
AND2X2 AND2X2_1 ( .A(a), .B(b), .Y(_0_) );
FILL FILL_0_0_0 ( );
FILL FILL_0_0_1 ( );
FILL FILL_0_0_2 ( );
FILL FILL_0_0_3 ( );
FILL FILL_0_0_0 ( );
FILL FILL_0_0_1 ( );
FILL FILL_0_0_2 ( );
FILL FILL_0_0_3 ( );
endmodule
