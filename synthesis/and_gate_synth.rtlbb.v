module and_gate (a, b, y);

input a;
input b;
output y;

BUFX2 BUFX2_1 ( .A(_0_), .Y(y) );
AND2X2 AND2X2_1 ( .A(a), .B(b), .Y(_0_) );
endmodule
