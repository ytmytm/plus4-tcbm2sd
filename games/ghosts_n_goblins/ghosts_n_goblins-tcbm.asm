
.print "Assembling GHOSTS_N_GOBLINS-TCBM.PRG"
.segmentdef Combined  [outPrg="ghosts_n_goblins-tcbm.prg", segments="Base,PatchDriveType,PatchDetection", allowOverlap]

.segment Base [start = $1001, max=$ffff]
.var data = LoadBinary("ghosts.prg", BF_C64FILE)
.fill data.getSize(), data.get(i)

.segment PatchDetection[]
.pc = $102d "Patch drive type detection"
	jmp $103b	// skip over, executing and putting NOP; NOP; NOP in 1038 would also work

.segment PatchDriveType[]
.pc = $1529 "Force drivetype"
	// XXX TCBM2SD is supported but not detected, force it
	lda $ae		// current device, currdrive
	sta $1043	// drive_number
	lda #$0f	// drive_model = TCBM2SD
	sta $1044
	lda #$02	// drive_interface_type = TCBM
	sta $1046
	nop		// pad
	nop
	nop