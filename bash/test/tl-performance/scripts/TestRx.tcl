#source scripts/qed_debugfs_if.tcl
#set_bdf 04:00.00
#dbgConfig -block pglue_b 9 -trigger {bglue_b {1 eq 0 0x40}}
#dbgStart
#after 10000
#dbgDump DebugBus.dmp
#reg write 0x3940 0xFFFFFF01
profile -v Profile

