
// Embedded fastloader for '/BOOT.T2SD' boot file (e.g. file browser)
// by Maciej 'YTM/Elysium' Witkowiak <ytm@elysium.pl>, 2024-09-17

// this is an example of loading the file from disk image using U0<$3f><track><sector> using fastload protocol

.var LORAM = $05F5

	* = $1001

// Basic start
	.byte $0b,$10
	.byte <2024
	.byte >2024
	.byte $9e
	.text "4109"
	.byte $00,$00,$00

start:
        sei
        sta $ff3e				// ROM_SELECT
        cli
	//
	ldx #0
cploop:	lda LOADER_0600,x
	sta LORAM,x
	inx
	bne cploop
cploop2:lda LOADER_0600+$0100,x
	sta LORAM+$0100,x
	inx
	cpx #$80				// about right
	bne cploop2
	// params
	// device number already set
	lda #0					// 0 = load&run, <>0 = load
	sta $d4
	lda #0					// 0 = load to file loadaddr, <>0 load into $2b/2c
	sta $d5
	//
        lda $d5
        cmp #$00
        bne L0607
        lda #$00
        beq L060B
L0607:  lda #$01
L060B:  sta $da

        lda #15					// command
		tay
        ldx $ae					// RAM_FA, current device
        jsr $ffba
        lda #(filenameend-filename)
        ldx #<filename
        ldy #>filename
        jsr $ffbd
		jsr $ffc0								// open -> send command + filename
        lda #$00
        jsr $ff90                               // SETMSG, messages off
        lda #$00
        ldx $2b
        ldy $2c                                 // all this stuff doesn't have to be in loram
        jmp LORAM                               // load and run

filename:
	.text "U0"									// utility command
	.byte %00111111								// fastload utility (load by t&s, not by name)
track:	.byte 1									// track of the first file block
sector:	.byte 0									// sector of the first file block
filenameend:

LOADER_0600:
.pseudopc LORAM {
//        jsr $ffd5
        jsr FastLoad
        //; original CODE
        stx $2d
        sty $2e
        jsr $d888
        lda #$ee
        sta $ff19
        lda #$f1
        sta $ff15
        lda #$c4
        sta $ff12
        lda #$d0
        sta $ff13
        lda #$90
        jsr $ffd2
        jsr $d88b
        lda #$00
        sta $ef
        lda $da
        beq L0659
        jsr $8818
L0659:  jsr $8bbe
        lda $d4
        cmp #$00
        bne L0665
        jmp $8bea
L0665:  jmp $867e

        // adapted from Warpload 1551 with ACK after each data read

.var RAM_VERFCK = $93            // ;VERFCK  Flag:  0 = load,  1 = verify
.var tgt = $9D                   // (2)
.var RAM_LA = $AC
.var RAM_FA = $AE                // ;FA      Current device number
.var RAM_MEMUSS = $B4            // (2) ;MEMUSS  Load ram base

// KERNAL routines without jumptable
.var ICLRCHN = $FFCC // $EF0C             // ;ICLRCHN $FFCC
.var aFFFA = $FFFA		 // ;RESET

// IO

.var aFEF0 = $FEF0              // portA
.var aFEF1 = $FEF1              // portB 1/0
.var aFEF2 = $FEF2              // portC 7/6
.var aFEF3 = $FEF3              // portA DDR
.var aFF06 = $FF06              // like $d011 for screen blank

FastLoad:
        sta RAM_VERFCK                              // ;VERFCK  Flag:  0 = load,  1 = verify

        jsr ICLRCHN                                 // ;ICLRCHN $FFCC

        sei
        lda aFF06                                   // ;preserve FF06 (like $D011, before blank)
        pha
        lda #0
        sta aFF06                                   // ;like $D011, blank screen
        sta aFEF3                                   // ;port A DDR = input first
        sta aFEF0                                   // ;port A (to clear pullups?)
        sta aFEF2                                   // ;DAV=0 - WE ARE READY

        bit aFEF2                                   // ;wait for ACK low
        bmi *-3
        lda aFEF0                                   // ;1st byte = load addr low  // need to flip ACK after this
        sta tgt
        ldx aFEF1                                   // STATUS
        lda #$40                                    // DAV=1 confirm
        sta aFEF2
	txa
        and #%00000011
        beq cont1
	jmp (aFFFA)				    // file not found -> reset

cont1:  bit aFEF2                                   // ;wait for ACK high
        bpl *-3
        lda aFEF0                                   // ;2nd byte = load addr high // need to flip ACK after this
        sta tgt+1
        lda #$00                                    // DAV=0 confirm
        sta aFEF2
        lda aFEF1                                   // STATUS
        and #%00000011
        bne LOADEND                                 // error

        lda $d5                                     // ;check if we load to load addr from file or from $b4/b5 (RAM_MEMUSS)
        beq LOADSTART
        lda RAM_MEMUSS
        sta tgt
        lda RAM_MEMUSS+1
        sta tgt+1

LOADSTART:
        ldy #0
LOADLOOP:
        lda aFEF2                                   // ;wait for ACK low
        bmi *-3
//inc $FF19
        lda aFEF0
        sta (tgt),y
        iny
        ldx aFEF1                                   // STATUS
        lda #$40                                    // DAV=1 confirm
        sta aFEF2
        txa                                         // EOI?
        and #%00000011
        bne LOADEND

        lda aFEF2                                   // ;wait for DAV high
        bpl *-3
//inc $FF19
        lda aFEF0                                   // XXX need to flip ACK after this
        sta (tgt),y
        iny
        ldx aFEF1                                   // STATUS
        lda #$00                                    // DAV=0 confirm
        sta aFEF2
        txa                                         // EOI?
        and #%00000011
        bne LOADEND

        tya
        bne LOADLOOP
        inc tgt+1
        bne LOADLOOP

LOADEND:
        lda #$40                                    // ;$40 = ACK (bit 6) to 1
        sta aFEF2
        pla
        sta aFF06                                   // ;restore FF06 (like $D011), turn off blank
        cli

        tya                                         // adjust end address (Y was already increased so just take care about low byte)
        clc
        adc tgt
        sta tgt
        bcc LOADRET
        inc tgt+1

LOADRET:
        lda #$ff                                    // ;port A to output (a bit delayed after ACK)
        sta aFEF3

        ldx tgt
        ldy tgt+1                                   // ;return end address+1 and C=0=no error
        clc                                         // no error
        rts

        .if (*>LORAM+$0180) { .error "low code too long" }

}
LOADER_0600_END:
