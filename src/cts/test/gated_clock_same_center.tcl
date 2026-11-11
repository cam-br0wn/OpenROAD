# Clock gates ga and gb drive interleaved flops (ffa0 ffb0 ffb1 ffa1 in one
# row), so their fanouts have the same center and both gates are moved to the
# same place before the tree is built. Each must stay on the clock.
source "helpers.tcl"

read_liberty Nangate45/Nangate45_typ.lib
read_lef Nangate45/Nangate45.lef
read_def gated_clock_same_center.def

create_clock -period 5 clk

source Nangate45/Nangate45.rc
set_wire_rc -signal -layer metal1
set_wire_rc -clock -layer metal2

clock_tree_synthesis -root_buf CLKBUF_X3 \
  -buf_list CLKBUF_X3

set block [ord::get_db_block]
foreach name {ga gb gc gd} {
  set net [[[$block findInst $name] findITerm CK] getNet]
  if { $net == "NULL" } {
    puts "$name/CK is not connected"
  } else {
    puts "$name/CK is connected"
  }
}
