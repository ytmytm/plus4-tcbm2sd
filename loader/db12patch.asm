
// Patch directory_browser_v1_2.prg for fastload protocol for tcbm2sd
// by Maciej 'YTM/Elysium' Witkowiak <ytm@elysium.pl>, 2024-07-12

.segmentdef Combined  [outPrg="db12b.prg", segments="Base,Patch1", allowOverlap]

.segment Base [start = $1001, max=$3000]
	.var data = LoadBinary("directory_browser_v1_2.prg", BF_C64FILE)
	.fill data.getSize(), data.get(i)

///////////////////////////////////////////

.var LORAM = $05F5

.segment Patch1 []
		* = $25e7 "Patch loader"

        lda #<LOADER_0600                       // source
        sta $D8
        lda #>LOADER_0600
        sta $D9
        lda #<LORAM                             // target
        sta $DA
        lda #>LORAM
        sta $DB
        ldx #<(LOADER_0600_END-LOADER_0600)     // length
        ldy #>(LOADER_0600_END-LOADER_0600)
        jsr $25c0                               // copying routine (just before this one)
        sei
        sta $ff3e
        cli
        lda $d5
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
        jsr $ff90                               // SETMSG
        lda #$00
        ldx $2b
        ldy $2c                                 // all this stuff doesn't have to be in loram
        jmp LORAM                               // load and run

// 2601
LOADER_0600:
.pseudopc LORAM {
        //;jsr $ffd5
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

.var RAM_STATUS = $90
.var RAM_VERFCK = $93            // ;VERFCK  Flag:  0 = load,  1 = verify
.var tgt = $9D                   // (2)
.var RAM_LA = $AC
.var RAM_SA = $AD
.var RAM_FA = $AE                // ;FA      Current device number
.var RAM_FNADR = $AF             // (2) ;FNADDR  Vector to filename
.var RAM_MEMUSS = $B4            // (2) ;MEMUSS  Load ram base
.var a05FF = LORAM-1             // temp storagefor load address flag, can be anywhere
.var a07DF = $07DF

.var RAM_RLUDES = $07D9          // ;RLUDES  Indirect routine downloaded

.var eF160 = $F160               // ;print "SEARCHING"
.var eF27C = $F27C               // ;print ERROR, ?LOAD ERROR?
.var eF189 = $F189               // ;print "LOADING"
// KERNAL routines without jumptable
.var ICLRCHN = $EF0C             // ;ICLRCHN $FFCC
.var ISENDSA = $F005             // ;SEND SA ; before TALK? and it's not TLKSA
.var ITALK = $EDFA               // ;TALK
.var ITLKSA = $EE1A              // ;TKSA
.var IACPTR = $EC8B              // ;ACPTR (receive)
.var ILISTEN = $EE2C             // ;LISTEN $FFB1
.var ISECOND = $EE4D             // ;SECOND $FF93
.var IIECOUT = $ECDF             // ;IECOUT (send) $FFA8
.var ROM_UNLSN = $FFAE           // ;UNLISTEN

// IO

.var aFEF0 = $FEF0              // portA
.var aFEF1 = $FEF1              // portB 1/0
.var aFEF2 = $FEF2              // portC 7/6
.var aFEF3 = $FEF3              // portA DDR
.var aFF06 = $FF06              // like $d011 for screen blank


b101B:	jmp $FFD5                                   // ROM load
FastLoad:
        sta RAM_VERFCK                              // ;VERFCK  Flag:  0 = load,  1 = verify
        lda RAM_FA                                  // ;FA      Current device number
        cmp #$04                                    // XXX don't have to check for tape, but have to remember current dev when browser was started - it will be tcbm2sd device
        bcc b101B                                   // ;less than 4 - tape
        lda #RAM_FNADR                              // ;filename at ($AF/$B0)
        sta a07DF
        ldy #$00                                    // XXX this is not a LOAD wedge, '$' won't be loaded this way
        jsr RAM_RLUDES                              // ;RLUDES  Indirect routine downloaded
        cmp #'$'                                    // ;if '$' then ROM load
        beq b101B
        lda RAM_FA                                  // remember device number in LA ;FA      Current device number
        sta RAM_LA                                  // ;LA      Current logical fiie number
        jsr eF160                                   // ;print "SEARCHING" XXX but messages are disabled

// XXX try to read one byte from file - drive ROM will find it and report error if not found; SPEED DOS does the same thing
        jsr ICLRCHN                                 // ;ICLRCHN $FFCC
        ldx RAM_SA                                  // ;SA      Current seconda.y address
        stx a05FF                                   // ;preserve SA (LOAD address parameter (set in $B4/B5 (RAM_MEMUSS) or from file))
        lda #$60
        sta RAM_SA                                  // ;SA      Current seconda.y address
        jsr ISENDSA                                 // ;SEND SA ; before TALK? and it's not TLKSA
        lda RAM_FA                                  // ;FA      Current device number
        jsr ITALK                                   // ;TALK
        lda #$70                                  // ;SA      Current seconda.y address
        jsr ITLKSA                                  // ;TLKSA

// XXX BUG ; note: NO UNTALK after ITALK
//        jmp eF27C                                   // ;print ERROR, ?LOAD ERROR? XXX but messages are disabled

b1060:
//        jsr eF189                                   // ;print "LOADING" XXX but messages are disabled

// XXX should switch to full ram configuratio here?

// loader preparation starts here: I/O
        sei
        lda aFF06                                   // ;preserve FF06 (like $D011, before blank)
        pha
        lda #0
//XXX   sta aFF06                                   // ;like $D011, blank screen
        sta aFEF3                                   // ;port A DDR = input first
        sta aFEF0                                   // ;port A (to clear pullups?)
        sta aFEF2                                   // ;DAV=0 - WE ARE READY
sta $0c00
sta $7c00
//
//inc $FF19
//jmp *-3
//
// XXX what is the status here? DAV must be high because we wait for LOW, ACK was just set to be low, status must be set to 00 by device before setting DAV low
//

        bit aFEF2                                   // ;wait for ACK low
        bmi *-3
inc $FF19
inc $0c00
inc $7c00
        lda aFEF0                                   // ;1st byte = load addr low  // need to flip ACK after this
        sta tgt
sta $0c01
sta $7c01
        lda #$40                                    // DAV=1 confirm
        sta aFEF2
        lda aFEF1
        and #%00000011
// enable after removing debug stuff        bne LOADEND                                 // file not found
        beq aCont
        jmp LOADEND

aCont:
        bit aFEF2                                   // ;wait for ACK high
        bpl *-3
inc $FF19
inc $0c00
inc $7c00
        lda aFEF0                                   // ;2nd byte = load addr high // need to flip ACK after this
        sta tgt+1
sta $0c02
sta $7c02
        lda #$00                                    // DAV=0 confirm
        sta aFEF2
        lda aFEF1
        and #%00000011
        bne LOADEND                                 // error

        lda a05FF                                   // ;check if we load to load addr from file or from $b4/b5 (RAM_MEMUSS)
        bne LOADSTART
        lda RAM_MEMUSS
        sta tgt
        lda RAM_MEMUSS+1
        sta tgt+1

LOADSTART:  // XXX this is probably a bug - LDY #0 here is offet by (tgt) but at the end it's stored to tgt as lowbyte - it should be added to (tgt) instead
        ldy #0
LOADLOOP:
        lda aFEF2                                   // ;wait for ACK low
        bmi *-3
inc $FF19
inc $0c00
inc $7c00
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
inc $0c00
inc $7c00
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
inc $0c02
inc $7c02
        inc tgt+1
        bne LOADLOOP

LOADEND:
        lda #$ff                                    // ;port A to output
        sta aFEF3
        lda #$40                                    // ;$40 = ACK (bit 6) to 1
        sta aFEF2
        pla
        sta aFF06                                   // ;restore FF06 (like $D011), turn off blank
        cli
        tya
        clc
        adc tgt
        sta tgt
        bcc LOADRET
        inc tgt+1
lda tgt
sta $7c03
lda tgt+1
sta $7c04

LOADRET:
        // close channel 0
        lda RAM_FA                                  // ;FA      Current device number
        jsr $FFB1                                   // ;direct to FFB1 ROM_LISTEN
        lda #$E0                                    // ;second CLOSE #0
        jsr $FF93                                   // ;direct to FF93 ROM_SECOND
        jsr ROM_UNLSN                               // ;$FFAE UNLSN   Send UNLISTEN out serial bus or DMA disk

        ldx tgt
        ldy tgt+1                                   // ;return end address+1 and C=0=no error
        clc                                         // no error
        rts


        // safe at least up to $07CC
        .if (*>$07CC) { .error "low code too long, exceeds $07CC" }

}
LOADER_0600_END:
