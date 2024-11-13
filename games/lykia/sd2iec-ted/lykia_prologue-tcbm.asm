
.print "Assembling LYKIA-PROLOGUE-TCBM.PRG"
.segmentdef Combined  [outPrg="lykia_prologue-tcbm.prg", segments="Base,PatchDriveType,PatchLoader,PatchExo0,PatchExo", allowOverlap]

.segment Base [start = $1001, max=$ffff]
.var data = LoadBinary("boot0.bin", BF_C64FILE)
.fill data.getSize(), data.get(i)

.label io_base = $0200
.label io_tcbmoffs = $02FF

// $0300-$0314
.segment PatchExo0[min=$75f6,max=$75f6-$300+$314]
.pc = $75F6
.pseudopc $0300 {
	jsr $0210
	tsx
	stx $038e	// needed?
	jmp $0319
}

// $0371-$038c
.segment PatchExo[min=$7667,max=$7667-$371+$38c]
.pc = $7667
.pseudopc $0371 {
// patch data read from exodecruncher
	jsr $0203
	bcc $0369
	bcs $036a
// $0379
// plug in part of startload so that we don't go over $0100 bytes for loader
startload_part2:
	jsr iolib.plus4tcbm_standard.TCBM_GETBYTE
	sta.zp ptr
	jsr iolib.plus4tcbm_standard.TCBM_GETBYTE
	sta.zp ptr+1
	ldy #0
	rts
}

.segment PatchDriveType[]
.pc = $6000 "Patch drivetype"

	// XXX TCBM2SD / 1551 detect code could be here

	ldx #0
!:	lda $68ee,x
	sta io_base,x
	inx
	bne !-

	ldx #0
!:	lda $75f6,x
	sta $0300,x
	inx
	bne !-

	ldx #$76
!:	lda $76f6,x
	sta $0400,x
	dex
	cpx #$ff
	bne !-

	lda $ae			// current device
	cmp #8
	beq !+
	lda #$00		// drive 9
	.byte $2c
!:	lda #$30		// drive 8
	sta io_tcbmoffs

	jsr $020f		// init for compliance

	lda #0
	sta.zp io_bitbuff

	clc
	rts	

.segment PatchLoader []
.pc = $68ee "Patch loader for TCBM2SD"

#import "tcbm2sdloaderbyte.asm"
