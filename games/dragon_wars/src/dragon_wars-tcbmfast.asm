// ----------------------------------------------------------------------------
// DRAGONWARS-TCBMFAST.PRG
// repackaged loader and intro and utils into a single compressed file
// UTIL can't return because there is no autostart anymore (can be patched)
// note: sectors occupied by UTILS were freed on D64 template
// (whole track 8)
// ----------------------------------------------------------------------------

.print "Assembling DRAGONWARS-TCBMFAST.PRG"

.var DefaultDriveNumber = $08

// ----------------------------------------------------------------------------

//.segmentdef Combined  [outPrg="dragon_wars-repack.prg", segments="Startup,Subs1,TitlePicColorBitmap,Music,IntroLoader,Intro"]
.segmentdef Combined  [outPrg="dragon_wars-tcbmfast.prg", segments="Startup,Subs1LO,Subs1HI,TitlePicColorBitmap,Music,Utils,IntroLoader,Intro,UtilStart,Patch0,TCBMLoaderLow,TCBMLoaderHighLo,TCBMLoaderHighHi,TCBMLoaderHighFix",allowOverlap]

// ----------------------------------------------------------------------------

// can't do it in one piece b/c we need banking procedures at $0700 for ROM calls
// (won't be needed for TCBM2SD)
//.segment Subs1 [start = $0500, max=$50ff]
//.import binary "bins/subs0500.bin"
//dd if=bins/subs0500.bin of=bins/subs050007ff.bin bs=1 count=768
//dd if=bins/subs0500.bin of=bins/subs080050ff.bin bs=1 skip=768

.segment Subs1LO [start = $5100, max=$53ff]
LSUBS0500:
.import binary "bins/subs050007ff.bin"

.segment Subs1HI [start = $0800, max=$50ff]
.import binary "bins/subs080050ff.bin"

// contains
// $3795		DoSectorOp (called from DoBlockOp)
// $37C2		DoGetSector
// $37B4		DoPutSector
// $37CD		DoGetStatus (cmp #1 bo sprawdana jest flaga C, C=0 -- OK)
// $37DD		TrackSecNum (table, 32) az do $37ff=$ff

// ----------------------------------------------------------------------------

.segment TitlePicColorBitmap [start = $5800, max=$6000+8000]
#import "titlepic.asm"

// ----------------------------------------------------------------------------

.segment Music [start = $8000, max=$85ff]
.import binary "bins/music8000.bin"

// ----------------------------------------------------------------------------

.segment Utils [start = $8600, max=$bfff]
LUTILS1000:
.import binary "bins/util1000.bin"

// ----------------------------------------------------------------------------

// 5600 - initial loader
// patched to use TCBM SendByte/GetByte
// parts copied to $FF20
.segment IntroLoader [start = $5600, max=$57ff]
.import binary "boot3.bin"
.var L5600 = $5600	// SendByte
.var L563A = $563A	// GetByte
.var L5681 = $5681	// $01 access changed to 'bit'
.var L56D4 = $56D4	// $01 access changed to 'bit'
.var IRQHandler = $5747 // IRQ handler

// note that $FF3E/$FF3F are used for RAM/ROM selection and can't be part of the code
// $FF20		SendByte
// $FF5A		GetByte
// $FF9F		DoBlockOp	(external entry: from $4178 / $41F9) - MUST BE AT $FF9F
// $FFAF		ConvertBlockTmp
// $FFE4		SendParams
// $FFF9/A		BlockNumTmp
// $FFFB		IOStatus
// $FFFC/D		$0650	? reset
// $FFFE/F		$3725	? irq? (nmi w $fffa/b - nadpisywany tutaj)

// ----------------------------------------------------------------------------

.segment Intro [start = $C000, max=$C31f]
.import binary "boot2.bin"

// calls:
// LABEL { NAME "Copy_LoaderCode_To_FF20"; addr $4e39; COMMENT "Copies code from $5600 to $ff20"; };
// LABEL { NAME "DoSectorOp";      addr $5694; COMMENT "Do operation from DriveOp with block number already converted to track and sector. This must be at 5694(?)"; };
// LABEL { NAME "ConvertBlockTmp"; addr $56EC; COMMENT "Convert from block number to track and sector"; };


// ----------------------------------------------------------------------------

.segment Startup [start = $5400, max=$55ff]
// instead of boot1.s at $1800 (range already occupied by subs1)

// ROM is enabled and screen is off due to Exomizer decruncher

.var LFFBA           = $FFBA
.var LFFBD           = $FFBD
.var LFFC0           = $FFC0
.var LFFE7           = $FFE7

Startup:
		sei
		cld
		ldx #$ff
		txs
		lda $ae									// current drive number
		bne !+
		lda #DefaultDriveNumber 				// default drive number
		sta $ae
!:

L185B:  jsr     LFFE7
        jsr     L18A7
        jsr     L189A
        sei
        ldx     #$14
!:      cpx     $FF1D
        bne     !-
        dex
        bne     !-

// we're loading binary boot3.bin so we need to apply the patch
// to use TCBM SendByte/GetByte
// XXX this is still fixed to device #8 (offsets)
        ldx     #$1B
// Patch loader (to C000) for TCBM comm instead of serial (C300 and 5600)
!:		lda     L18BB,x
        sta     L5600,x					// SendByte
        lda     L18D1,x
        sta     L563A,x					// GetByte
        dex
        bpl 	!-
		lda		#$24					// $01 access changed to 'bit'
		sta		L5681
		sta		L56D4

// now we can overwrite low RAM
		ldx #0
!:		lda LSUBS0500,x
		sta $0500,x
		lda LSUBS0500+$0100,x
		sta $0600,x
		lda LSUBS0500+$0200,x
		sta $0700,x
		inx
		bne !-

		lda #<IRQHandler // $5747
		sta $FFFE
		lda #>IRQHandler
		sta $FFFF
		sta $FF3F								// enable RAM

		jsr UtilStartPatch
		jsr TitlepicStart
		// skip TITLEPIC/MUSIC/SUBS1/parts of intro loader
		jmp $C02A

// ----------------------------------------------------------------------------
L189A:  ldx     #<L18ED
        ldy     #>L18ED
        lda     #$0C
        jsr     LFFBD
        lda     #$0F
        bne     L18B2
L18A7:  lda     #$02
        ldx     #<L18F9
        ldy     #>L18F9
        jsr     LFFBD
        lda     #$02
L18B2:  tay
        ldx     $ae
        jsr     LFFBA
        jmp     LFFC0

// ----------------------------------------------------------------------------
// SendByte/GetByte (TCBM) patched into $5600, later copied to $FF20

L18BB:  sta     $FEE0
!:      bit     $FEE2
        bmi     !-
        asl     $FEE2
!:      bit     $FEE2
        bpl     !-
        lda     #$40
        sta     $FEE2
        rts

L18D1:  inc     $FEE3
!:      bit     $FEE2
        bmi     !-
        asl     $FEE2
        lda     $FEE0
!:      bit     $FEE2
        bpl     !-
        ldy     #$40
        sty     $FEE2
        dec     $FEE3
        rts

// ----------------------------------------------------------------------------
// Block-Execute command
L18ED:  .text   "B-E 2 0 18 "
L18F8:  .text   "8" // 8 for TCBM, 2 for IEC
// set buffer
L18F9:  .text   "#0"

// ----------------------------------------------------------------------------
TitlepicStart:
        lda     #$D4                            // 1001
        sta     $FF13                           // 1003
        lda     #$18                            // 1006
        sta     $FF07                           // 1008
        sta     $FF12                           // 100B
        lda     #$58                            // 100E
        sta     $FF14                           // 1010
        ldx     #$00                            // 1013
        stx     $FF15                           // 1026
        stx     $FF19                           // 103D
        lda     #$3B                            // 1055
        sta     $FF06                           // 1057
        lda     #$D1                            // 105A
        sta     $FF16                           // 105C
        rts                                     // 105F

// ----------------------------------------------------------------------------
// patch boot2.s to not load UTILS, but jump into UtilStart
UtilStartPatch:
		lda #$4c
		sta $c052
		lda #<UtilStart
		sta $c053
		lda #>UtilStart
		sta $c054
		rts

// ----------------------------------------------------------------------------

.segment UtilStart [start = $c320, max=$c4ff]
UtilStart:
		// copy down UTILS from $8600 to $1000
		lda #<LUTILS1000
		sta $02
		lda #>LUTILS1000
		sta $03
		lda #$00
		sta $04
		sta $FF06		// screen off
		lda #$10
		sta $05
		ldy #0
!:		lda ($02),y
		sta ($04),y
		iny
		bne !-
		inc $03
		inc $05
		lda $05
		cmp #$29		// utils end at $28A0
		bne !-
		jmp $1000		// start it

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------

.segment Patch0[min=$4e39,max=$4e3c]

	.pc=$4e39 "Patch0 ($4E39-$4E3C)"

	// skip over part that copies loader to $FF20
	sei
	jmp $4E5F

// note that $FF3E/$FF3F are used for RAM/ROM selection and can't be part of the code
// $FF20		SendByte 
// $FF5A		GetByte
// $FF9F		DoBlockOp	(external entry: from $4178 / $41F9) - MUST BE AT $FF9F
// $FFAF		ConvertBlockTmp
// $FFE4		SendParams
// $FFF9/A		BlockNumTmp
// $FFFB		IOStatus
// $FFFC/D		$0650	? reset
// $FFFE/F		$3725	? irq? (nmi w $fffa/b - nadpisywany tutaj)

// wolne: bez SendByte/GetByte,SendParams
// zostaje: DoBlockOp,ConvertBlockTmp,BlockNumTmp,IOStatus
// $FF20-$FF3D
// $FF40-$FF9E
// $FFA1-$FFF8

// wolne: $3745-$37DC

// $3795		DoSectorOp (called from DoBlockOp)
// $37C2		DoGetSector
// $37B4		DoPutSector
// $37CD		DoGetStatus (cmp #1 bo sprawdana jest flaga C, C=0 -- OK)
// $37DD		TrackSecNum (table, 32) az do $37ff=$ff


.var DriveOp = $d5 	// operation code, 1=read, 2=write, 3=get status byte
.var BufferVec = $d6	// buffer to read/write
.var BlockNum = $d8	// operation block number
.var tmpbyte = $ff // temporary byte

.var BlockNumTmp = $FFF9	// BlockNumTmp
.var Track = $FFF9	// BlockNumTmp
.var Sector = $FFFA	// BlockNumTmp+1 (BlockNum)
.var IOStatus = $FFFB	// IOStatus

.segment TCBMLoaderLow[min=$3745,max=$37dc]
//.segment TCBMLoaderLow[min=$3745,max=$38ff]

	.pc=$3745 "TCBMLoaderLow ($3745-$37DC)"

/////////////////////////////////////
// adapted from GEOS

.var r4 = BufferVec
.var TriportA        = $FEC0+$30 // fixed at device #8
.var TriportB        = $FEC1+$30
.var TriportC        = $FEC2+$30
.var TriportDDRA     = $FEC3+$30
.var TriportDDRB     = $FEC4+$30
.var TriportDDRC     = $FEC5+$30

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

ReadBlockLoopEnd:
WriteBlockLoopEnd:
!:	lda $FEF2	// wait for ACK high
	bpl !-
	lda #$00
	sta $FEF0	// clear data port (just in case it was one of command bytes)
	lda #$ff	// port A to output (a bit delayed after ACK)
	sta $FEF3
	lda #$40	// $40 = DAV (bit 6) to 1
	sta $FEF2
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
	beq WriteBlockLoopEnd

.segment TCBMLoaderHighLo[min=$ff20,max=$ff3d]
	.pc=$ff20 "TCBMLoaderHighLo ($FF20-$FF3D)"
DoSectorOp:
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

.segment TCBMLoaderHighHi[min=$ff40,max=$ff9e]
	.pc=$ff40 "TCBMLoaderHighHi ($FF40-$FF9E)"

TCBM2SD_SendParams:
	sta TCBM2SD_ReadWriteCmd_Oper
	lda Track 
	sta TCBM2SD_ReadWriteCmd_Track
	lda Sector
	sta TCBM2SD_ReadWriteCmd_Sector
//	jmp TCBM_SendDOSCommand

// Send DOS command over channel 15
//; input: y=length

TCBM_SendDOSCommand:
	jsr		TCBM_LISTEN
	lda		#$6F			// command channel
	jsr		TCBM_SECONDARY
	ldy		#0
!:	lda		TCBM2SD_ReadWriteCmd,y
	jsr		TCBM_SENDBYTE
	iny
	cpy		#<(TCBM2SD_ReadWriteCmd_End-TCBM2SD_ReadWriteCmd)
	bne		!-
	//jmp		TCBM_UNLISTEN

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
        sta TriportA
!:	lda TriportC
	bmi !-
	pla
	pha
        sta TriportA
        lsr TriportC
!:	lda TriportC
	bpl !-
        lda #0
        sta TriportA
        lsr TriportC
	pla
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


.segment TCBMLoaderHighFix[min=$ff9f,max=$ffae]
	.pc=$ff9f "TCBMLoaderHighFix ($FF9F-$FFAE)"
// called externally, MUST be at $ff9f
DoBlockOp:
	lda BlockNum
	sta BlockNumTmp+1
	lda BlockNum+1
	sta BlockNumTmp
	jsr $ffaf		// ConvertBlockTmp, uses table at $37dd
	jmp DoSectorOp

// XXX must add whole missing code for ConvertBlockTmp here ($ffaf), uses table at $37dd
// (if ConvertBlockTmp saves to TCBM2SD_ReadWriteCmd_Track/Sector more bytes can be saved)
