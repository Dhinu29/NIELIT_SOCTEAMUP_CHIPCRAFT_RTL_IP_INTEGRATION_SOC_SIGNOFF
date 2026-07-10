*SPICE netlist created from BLIF module and_gate by blif2BSpice
.include /apps/vlsi/share/qflow/tech/gscl45nm/gscl45nm.sp
.subckt and_gate vdd gnd a b y 
XBUFX2_1 vdd gnd _0_ y BUFX2
XAND2X2_1 vdd gnd a b _0_ AND2X2
XFILL_0_0_0 gnd vdd FILL
XFILL_0_0_1 gnd vdd FILL
XFILL_0_0_2 gnd vdd FILL
XFILL_0_0_3 gnd vdd FILL
.ends and_gate
 
