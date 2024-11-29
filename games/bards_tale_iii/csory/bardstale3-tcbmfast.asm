
.print "Assembling BARDSTALE3.PRG"
// if TCBMLoadre and PatchProdos segments are removed from this command you get a boot PRG that you can load & run on an emulator
.segmentdef Combined  [outPrg="bardstale3-tcbmfast.prg", segments="Base,Startup,TCBMLoader,PatchProdos", allowOverlap]

.segment Base [start = $17a7, max=$ffff]
// load loader proper (boot1.s)
.import binary "boot1.bin"

.segment Startup [start = $1700, max=$17a6]
// this was done in the autostart loader (boot0.s)
.pc = $1700
        ldy     #$FF
        sty     $FD16	// ?
        iny
        sty     $6AD8	// ?
        sty     $FF06	// ?
	// rest of the file was being loaded here
        //jsr     $EF3B	// close?
        //jsr     $F211	// ?
        jsr     $F2CE	// restore vectors?

        ldx     #$36
!:      lda     L02C3,x
        sta     $FF40,x
        dex
        bpl     !-
        lda     #$DF
        sta     $FD16
        ldx     #$44
        stx     $FD15
        stx     $4000
        lda     #$45
        sta     $FD15
        sta     $4000
        stx     $FD15
        cpx     $4000
        nop
        nop
        jsr     $213F // patch when expansion present?
        lda     #$FF
        sta     $FD16
//        jmp     $17A7 // start
	jmp	$1A05 // skip over drive code and 1541/51 detect and patch
	// this goes to $1A05, copies $1C00-$1FFF to $C800-$CBFF and loads remaining
	// data using Apple's Prodos format and loader
	// entry point at $C99C ($1D9C)
	// operation code, track and sector in $C99C ($1D9C)
	// $C800-$C999(?) free to use 

L02C3:  ldy     #$0F
L02C5:  lda     $0211,y
        cmp     #$E5
        bne     L02DA
        lda     $0210,y
        cmp     #$F9
        bne     L02DA
        lda     $020F,y
        cmp     #$C5
        beq     L02E6
L02DA:  dey
        bpl     L02C5
        nop
        nop
        txa
        asl
        tay
        rts

        nop
        nop
        nop
L02E6:  ldy     #$00
        sty     $842A
        sty     $842B
        sty     $842C
        sty     $842D
        pla
        pla
        txa
        asl
        tay
        rts

// junk bytes with autostart vector followed in boot0.s


.var DriveOp = $42 	// operation code: 1,2,3
.var BufferVec = $44	// buffer to read/write
.var Track = $C99A	// BlockNumTmp
.var Sector = $C99B	// BlockNumTmp+1

.segment TCBMLoader[min=$1C00,max=$1D99]
.pc=$1C00
.pseudopc $C800 {
// DriveOp: 1=read, 2=write, 3=get status (0 == success)
	lda DriveOp
	cmp #$03
	bne !+
	lda #0	// status (3), return always success
	clc
	rts
!:	// A=read (1) or write (2)
	// sector from Track&Sector
	// into (BufferVec)
	cmp #2
	beq !+
	jsr ReadBlock
	lda #0
	clc
	rts
!:	jsr WriteBlock
	lda #0
	clc
	rts

/////////////////////////////////////
// adapted from GEOS

.var r4 = BufferVec
.var TriportA        = $FEC0
.var TriportB        = $FEC1
.var TriportC        = $FEC2
.var TriportDDRA     = $FEC3
.var TriportDDRB     = $FEC4
.var TriportDDRC     = $FEC5
.var curDeviceP4     = $AE // curDevice but on C16/116/+4 Kernal ($BA)

cmdLength:	.byte 0

// Send DOS command over channel 15
//; input: y=length

TCBM_SendDOSCommand:
	txa		// preserve x
	pha
	sty		cmdLength
        jsr		GetTCBMPortOffs		// device offset to x
//	lda #$ff            	                // port A to output (a bit delayed after ACK)
//	sta $FEF3
	jsr		TCBM_LISTEN
	lda		#$6F			// command channel
	jsr		TCBM_SECONDARY
	ldy		#0
!:	lda		TCBM2SD_ReadWriteCmd,y
	jsr		TCBM_SENDBYTE
	iny
	cpy		cmdLength
	bne		!-
	jsr		TCBM_UNLISTEN
	// CLOSE
//	jsr		TCBM_LISTEN
//	lda		#$EF			// close command channel
//	jsr		TCBM_SECONDARY

//	lda #$40										; $40 = DAV (bit 6) to 1
//	sta $FEF2

	pla					// restore x
	tax
	rts

TCBM_UNLISTEN:
	lda		#$3F			// UNLISTEN
	.byte $2c

TCBM_LISTEN:
	lda		#$20			// LISTEN
	pha
        lda     #$81    			// this is a command byte
        bne     TCBM_Send

TCBM_SECONDARY:					// send secondary addr ($60 == SECOND after LISTEN and after TALK)
	pha
        lda     #$82    			// this is a second byte
        bne     TCBM_Send

TCBM_SENDBYTE:
	pha
        lda     #$83				// this is a data byte
TCBM_Send:					// send using standard Kernal protocol
        sta TriportA,x
!:	lda TriportC,x
	bmi !-
	pla
	pha
        sta TriportA,x
        lsr TriportC,x
!:	lda TriportC,x
	bpl !-
        lda #0
        sta TriportA,x
        lsr TriportC,x
	pla
	rts

// ----------------------------------------------------------------------------
// 97F8/F9 - filled in by booter with offset to TCBM drive port $30 (#8) or $00 (#9)
GetTCBMPortOffs:
	ldx #$30	// XYX fixed at device #8	$FEF0
	rts

// ----------------------------------------------------------------------------

TCBM2SD_ReadWriteCmd:
	.text "U0"
TCBM2SD_ReadWriteCmd_Oper:
	.byte 0
TCBM2SD_ReadWriteCmd_Track:
	.byte 0
TCBM2SD_ReadWriteCmd_Sector:
	.byte 0
	.byte 1		// number of sectors
TCBM2SD_ReadWriteCmd_End:

TCBM2SD_SendParams:
	sta TCBM2SD_ReadWriteCmd_Oper
	lda Track 
	sta TCBM2SD_ReadWriteCmd_Track
	lda Sector
	sta TCBM2SD_ReadWriteCmd_Sector
	ldy #<(TCBM2SD_ReadWriteCmd_End-TCBM2SD_ReadWriteCmd)
	jmp TCBM_SendDOSCommand

ReadBlock:
	lda #$00		// TCBM2SD read oper
	jsr TCBM2SD_SendParams

	// XYX port offset unused, always device at $FEF0
	lda #0
	sta $FEF3		// port A DDR = input first
	sta $FEF0		// port A (to clear pullups?)
	sta $FEF2		// DAV=0 - WE ARE READY

	tay
ReadBlockLoop:
!:	lda $FEF2               // wait for ACK low
	bmi !-
//inc $FF19
	lda $FEF0
	sta (r4),y
	iny
	ldx $FEF1               // STATUS
	lda #$40                // DAV=1 confirm
	sta $FEF2
	txa                   	// EOI?
	and #%00000011
	bne ReadBlockLoopEnd

!:	lda $FEF2		// wait for ACK high
	bpl !-
//inc $FF19
	lda $FEF0
	sta (r4),y
	iny
	ldx $FEF1               // STATUS
	lda #$00                // DAV=0 confirm
	sta $FEF2
	txa                   	// EOI?
	and #%00000011
	bne ReadBlockLoopEnd

	tya
	bne ReadBlockLoop
//	inc r4H                          	         	; possibly more sectors?
//	bne ReadBlockLoop

ReadBlockLoopEnd:
!:	lda $FEF2	// wait for ACK high
	bpl !-
	lda #$00
	sta $FEF0	// clear data port (just in case it was one of command bytes)
	lda #$ff	// port A to output (a bit delayed after ACK)
	sta $FEF3
	lda #$40	// $40 = DAV (bit 6) to 1
	sta $FEF2

	ldx #0
GetBlk0:
	rts

WriteBlock:
	lda #$02		// TCBM2SD write oper
	jsr TCBM2SD_SendParams

	// port A is already an output
	// DAV is high, ACK is high
	lda #$40                // DAV=1 byte is not ready
	sta $FEF2

	ldy #0
WriteBlockLoop:
	lda (r4),y
	sta $FEF0
	iny
	lda #$00                // DAV=0 byte is ready
	sta $FEF2
!:	lda $FEF2               // wait for ACK low when it's received
	bmi !-
	lda $FEF1               // STATUS
	and #%00000011		// EOI?
	bne WriteBlockLoopEnd
//inc $FF19
	lda (r4),y
	sta $FEF0
	iny
	lda #$40                // DAV=1 byte is ready
	sta $FEF2
!:	lda $FEF2               // wait for ACK high when it's received
	bpl !-
	lda $FEF1               // STATUS
	and #%00000011		// EOI?
	bne WriteBlockLoopEnd
//inc $FF19
	tya
	bne WriteBlockLoop
	// we can send more sectors - but this example saves only one
//	inc r4H											; possibly more sectors?
//	bne WriteBlockLoop

WriteBlockLoopEnd:
!:	lda $FEF2               // wait for ACK high
	bpl !-
	lda #$00
	sta $FEF0		// clear data port (just in case it was one of command bytes)
	lda #$ff            	// port A to output (a bit delayed after ACK)
	sta $FEF3
	lda #$40		// $40 = DAV (bit 6) to 1
	sta $FEF2

	ldx #0
WriteBlockEnd:
	rts

}

.segment PatchProdos[min=$1D9C,max=$1D9E]
.pc=$1D9C
.pseudopc $C99C {
	jmp $C800
}
