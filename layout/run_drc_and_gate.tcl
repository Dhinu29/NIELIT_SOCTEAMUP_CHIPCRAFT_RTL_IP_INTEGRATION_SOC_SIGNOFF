lef read /apps/vlsi/share/qflow/tech/gscl45nm/gscl45nm.lef
load and_gate
drc on
select top cell
expand
drc check
drc catchup
set dcount [drc list count total]
puts stdout "drc = $dcount"
quit
