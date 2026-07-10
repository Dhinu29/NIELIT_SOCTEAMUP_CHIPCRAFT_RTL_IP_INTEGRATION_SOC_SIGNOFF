box 0 0 0 0
drc off
snap int
lef read /apps/vlsi/share/qflow/tech/gscl45nm/gscl45nm.lef
def read and_gate
load and_gate
select top cell
select area labels
setlabel font FreeSans
setlabel size 0.3um
box grow s -[box height]
box grow s 100
select area labels
setlabel rotate 90
setlabel just e
select top cell
box height 100
select area labels
setlabel rotate 270
setlabel just w
select top cell
box width 100
select area labels
setlabel just w
select top cell
box grow w -[box width]
box grow w 100
select area labels
setlabel just e
writeall force and_gate
lef write and_gate 
expand
extract all
ext2spice hierarchy on
ext2spice format ngspice
ext2spice scale off
ext2spice renumber off
ext2spice cthresh infinite
ext2spice rthresh infinite
ext2spice blackbox on
ext2spice subcircuit top auto
ext2spice global off
ext2spice
quit
