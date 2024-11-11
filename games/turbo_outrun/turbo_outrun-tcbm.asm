
.print "Assembling TURBO_OUTRUN-TCBM.PRG"
.segmentdef Combined  [outPrg="turbo_outrun-tcbm.prg", segments="Base,PatchStartup", allowOverlap]


.segment Base [start = $1001, max=$ffff]
.var data = LoadBinary("boot.bin", BF_C64FILE)
.fill data.getSize(), data.get(i)

.label io_base = $0700
//.label io_tcbmoffs = io_base-1
.label io_tcbmoffs = io_base+$ff

.segment PatchStartup[]
.pc = $1010
	// XXX TCBM2SD / 1551 detect code could be here

	sei

	ldx #0
!:	lda tcbm_loader,x
	sta io_base,x
	inx
	bne !-

!:	lda $21a3,x
	sta $0600,x
	inx
	bne !-

	lda $ae			// current device
	cmp #8
	beq !+
	lda #$00		// drive 9
	.byte $2c
!:	lda #$30		// drive 8
	sta io_tcbmoffs

	jmp $0600

tcbm_loader:
#import "../tcbm2sdloader.asm"
