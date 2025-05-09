
.print "Assembling GIANA_SISTERS-TCBMFAST.PRG"
.segmentdef Combined  [outPrg="giana_sisters-tcbmfast.prg", segments="Base,PatchDriveType,PatchLoader", allowOverlap]

.segment Base [start = $1001, max=$ffff]
.var data = LoadBinary("giana_sisters.prg", BF_C64FILE)
.fill data.getSize(), data.get(i)

.label io_base = $0700
.label io_tcbmoffs = io_base-1


.segment PatchDriveType[]
.pc = $1446 "Patch drivetype"

	// XXX TCBM2SD / 1551 detect code could be here

	lda $ae			// current device
	cmp #8
	beq !+
	lda #$00		// drive 9
	.byte $2c
!:	lda #$30		// drive 8
	sta io_tcbmoffs

	ldx #0
!:	lda $1680,x
	sta io_base,x
	inx
	bne !-

	clc
	rts	

.segment PatchLoader []
.pc = $1680 "Patch loader for TCBM2SD FASTLOADER"

#import "../tcbm2sdloaderfast.asm"
