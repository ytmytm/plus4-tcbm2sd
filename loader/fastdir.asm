// load directory (or any file in fact) via fast protocol
// by Maciej 'YTM/Elysium' Witkowiak <ytm@elysium.pl>, 2024-07-21

// java -jar Kickass.Jar fastdir.asm
// LOAD"FASTDIR.PRG",8,1
// SYSDEC("6000")
// (will hang on very long (>500 files(?) directory because it would overwrite itself) 

	* = $6000 "Fastdir test"

        sei
        sta $ff3e
        cli
	//		// parameter setup
	lda #$08	//device
	sta $d0
	lda #$01
	sta $d1		// filename '$'
	lda #<name
	sta $d2
	lda #>name
	sta $d3
	lda #$01	// load addr
	sta $2b
	lda #$10
	sta $2c
	lda #$01	// 0=load&run, <>0=load
	sta $d4
        lda #$01	// load addr flag (1 to load into $2b/2c)
	//
        cmp #$00
        bne L0607
        ldy #$01
        lda #$00
        jmp L060B
L0607:  ldy #$00
        lda #$01
L060B:  sta $da
        lda #$01
        ldx $d0
        jsr $ffba
        lda $d1
        ldx $d2
        ldy $d3
        jsr $ffbd
        lda #$00
        ldx $2b
        ldy $2c                                 // all this stuff doesn't have to be in loram

        //jsr $ffd5
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

name:	.byte '$'

        // adapted from Warpload 1551 with ACK after each data read

.var RAM_VERFCK = $93            // ;VERFCK  Flag:  0 = load,  1 = verify
.var tgt = $9D                   // (2)
.var RAM_LA = $AC
.var RAM_SA = $AD
.var RAM_FA = $AE                // ;FA      Current device number
.var RAM_MEMUSS = $B4            // (2) ;MEMUSS  Load ram base
.var a05FF = $D8                 // (1) temp storagefor load address flag, can be anywhere

// KERNAL routines without jumptable
.var ICLRCHN = $EF0C             // ;ICLRCHN $FFCC
.var ISENDSA = $F005             // ;SEND SA ; before TALK? and it's not TLKSA
.var ITALK = $EDFA               // ;TALK
.var ITLKSA = $EE1A              // ;TKSA

// IO

.var aFEF0 = $FEF0              // portA
.var aFEF1 = $FEF1              // portB 1/0
.var aFEF2 = $FEF2              // portC 7/6
.var aFEF3 = $FEF3              // portA DDR
.var aFF06 = $FF06              // like $d011 for screen blank

FastLoad:
        sta RAM_VERFCK                              // ;VERFCK  Flag:  0 = load,  1 = verify
        lda RAM_FA                                  // remember device number in LA ;FA      Current device number
        sta RAM_LA                                  // ;LA      Current logical fiie number

        jsr ICLRCHN                                 // ;ICLRCHN $FFCC
        ldx RAM_SA                                  // ;SA      Current seconda.y address
        stx a05FF                                   // ;preserve SA (LOAD address parameter (set in $B4/B5 (RAM_MEMUSS) or from file))
        lda #$60
        sta RAM_SA                                  // ;SA      Current seconda.y address
        jsr ISENDSA                                 // ;SEND SA ; send name with SA=$60
        lda RAM_FA                                  // ;FA      Current device number
        jsr ITALK                                   // ;TALK
        lda #$70                                    // ;SA      Fastload indicator - on channel 16 (treated as channel 0 = LOAD)
        jsr ITLKSA                                  // ;TLKSA

        sei
        lda aFF06                                   // ;preserve FF06 (like $D011, before blank)
        pha
        lda #0
//        sta aFF06                                   // ;like $D011, blank screen
        sta aFEF3                                   // ;port A DDR = input first
        sta aFEF0                                   // ;port A (to clear pullups?)
        sta aFEF2                                   // ;DAV=0 - WE ARE READY

        bit aFEF2                                   // ;wait for ACK low
        bmi *-3
        lda aFEF0                                   // ;1st byte = load addr low  // need to flip ACK after this
        sta tgt
        lda #$40                                    // DAV=1 confirm
        sta aFEF2
        lda aFEF1                                   // STATUS
        and #%00000011
        bne LOADEND                                 // file not found

        bit aFEF2                                   // ;wait for ACK high
        bpl *-3
        lda aFEF0                                   // ;2nd byte = load addr high // need to flip ACK after this
        sta tgt+1
        lda #$00                                    // DAV=0 confirm
        sta aFEF2
        lda aFEF1                                   // STATUS
        and #%00000011
        bne LOADEND                                 // error

        lda a05FF                                   // ;check if we load to load addr from file or from $b4/b5 (RAM_MEMUSS)
        bne LOADSTART
        lda RAM_MEMUSS
        sta tgt
        lda RAM_MEMUSS+1
        sta tgt+1

LOADSTART:
        ldy #0
LOADLOOP:
        lda aFEF2                                   // ;wait for ACK low
        bmi *-3
inc $FF19
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
inc $FF19
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

