// ----------------------------------------------------------------------------
// DRAGONWARS-REPACK.PRG
// repackaged loader and intro into a single compressed file
// UTIL can't return because there is no autostart anymore (can be patched)
// ----------------------------------------------------------------------------


.print "Assembling DRAGONWARS-REPACK.PRG"

.var DefaultDriveNumber = $08

// ----------------------------------------------------------------------------

//.segmentdef Combined  [outPrg="dragon_wars-repack.prg", segments="Startup,Subs1,TitlePicColorBitmap,Music,IntroLoader,Intro"]
.segmentdef Combined  [outPrg="dragon_wars-repack.prg", segments="Startup,Subs1LO,Subs1HI,TitlePicColorBitmap,Music,IntroLoader,Intro"]

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

// ----------------------------------------------------------------------------

.segment TitlePicColorBitmap [start = $5800, max=$6000+8000]
#import "titlepic.asm"

// ----------------------------------------------------------------------------

.segment Music [start = $8000, max=$85ff]
.import binary "bins/music8000.bin"

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

// ----------------------------------------------------------------------------

.segment Intro [start = $C000, max=$C3ff]
.import binary "boot2.bin"

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
