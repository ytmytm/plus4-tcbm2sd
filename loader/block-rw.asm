
// Utility commands U0<$00|$02><track><sector><number-of-sectors> examples
// for block-read and block-write commands
//
// by Maciej 'YTM/Elysium' Witkowiak <ytm@elysium.pl>, 2024-09-18

// simple example that reads directory header to the screen ram and $2000 or saves it from $2000
// needs to run within disk image

.var BLOCK_BUFFER = $2000

// IO

.var aFEF0 = $FEF0              // portA
.var aFEF1 = $FEF1              // portB 1/0
.var aFEF2 = $FEF2              // portC 7/6
.var aFEF3 = $FEF3              // portA DDR

.var tgt = $9D  // address vector

// KERNAL routines without jumptable
.var ICLRCHN = $FFCC // $EF0C             // ;ICLRCHN $FFCC

	* = $1001

// Basic start
	.byte $0b,$10
	.byte <2024
	.byte >2024
	.byte $9e
	.text "4109"
	.byte $00,$00,$00

start:

        ldy     #0
!:      lda     StartupTxt,y
        beq     !+
        jsr     $ffd2
        iny
        bne	    !-
!:

MainLoop:
        lda #13
        jsr $ffd2
        lda #'T'
        jsr $ffd2
        lda #':'
        jsr $ffd2
        lda #'$'
        jsr $ffd2
        lda track
        jsr print_hexbyte
        lda #' '
        jsr $ffd2
        lda #'S'
        jsr $ffd2
        lda #':'
        jsr $ffd2
        lda #'$'
        jsr $ffd2
        lda sector
        jsr print_hexbyte
        lda #' '
        jsr $ffd2
        lda #'>'
        jsr $ffd2

        ldy #0
!:      jsr $FFCF               // KERNAL_CHRIN
        sta InputBuffer,y
        iny
        sty InputBufLen
        cmp #13			        // return?
        bne !-                  // no

        lda InputBuffer
        cmp #'R'
        beq ReadBlock
        cmp #'W'
        beq WriteBlock
        cmp #'X'
        beq Exit
        bne MainLoop

Exit:   rts

ReadBlock:
        lda #$00                // command READ
        ldx track
        ldy sector
        jsr send_command
        jsr BlockLoad
        jsr $FFCC
        lda #15
        jsr $FFC3
        jmp MainLoop

WriteBlock:
        lda #$02                // command WRITE
        ldx track
        ldy sector
        jsr send_command
        jsr BlockWrite
        jsr $FFCC
        lda #15
        jsr $FFC3
        jmp MainLoop

print_hexbyte:
        pha
        and #$f0
        lsr
        lsr
        lsr
        lsr
        tax
        lda HexDigits,x
        jsr $ffd2
        pla
        and #$0f
        tax
        lda HexDigits,x
        jmp $ffd2

/////////////////////////////////////////////////////////////////

StartupTxt:
    .byte 147
    .text "BUFFER AT $2000"
    .byte 13
	.text	"R = READ SECTOR TO BUFFER"
    .byte 13
	.text	"W = WRITE SECTOR FROM BUFFER"
    .byte 13
    .text	"X = QUIT PROGRAM"
    .byte 13, 13, 0

HexDigits:
    .text   "0123456789ABCDEF"

/////////////////////////////////////////////////////////////////

send_command:
        sta blockcommand        // $00 = read, $02 = write
        stx track
        sty sector
        lda #15					// command
		tay
        ldx $ae					// RAM_FA, current device
        jsr $ffba
        lda #(filenameend-filename)
        ldx #<filename
        ldy #>filename
        jsr $ffbd
		jsr $ffc0           	// open -> send command + filename

        lda #<BLOCK_BUFFER
        ldx #>BLOCK_BUFFER
        sta tgt
        stx tgt+1

        rts
 
///////////////////////////////////////////////////////

BlockLoad:
        lda #0
        sta aFEF3                                   // ;port A DDR = input first
        sta aFEF0                                   // ;port A (to clear pullups?)
        sta aFEF2                                   // ;DAV=0 - WE ARE READY

        ldy #0
LOADLOOP:
        lda aFEF2                                   // ;wait for ACK low
        bmi *-3
inc $FF19
        lda aFEF0
        sta (tgt),y
        sta $0c00,y                                 // also to screen RAM
        iny
        ldx aFEF1                                   // STATUS
        lda #$40                                    // DAV=1 confirm
        sta aFEF2
        txa                                         // EOI?
        and #%00000011
        bne LOADEND

        lda aFEF2                                   // ;wait for ACK high
        bpl *-3
inc $FF19
        lda aFEF0
        sta (tgt),y
        sta $0c00,y                                 // also to screen RAM
        iny
        ldx aFEF1                                   // STATUS
        lda #$00                                    // DAV=0 confirm
        sta aFEF2
        txa                                         // EOI?
        and #%00000011
        bne LOADEND

        tya
        bne LOADLOOP
        inc tgt+1                                   // possibly more sectors?
        bne LOADLOOP

LOADEND:
        lda #$40                                    // ;$40 = ACK (bit 6) to 1
        sta aFEF2

        lda #$ff                                    // ;port A to output (a bit delayed after ACK)
        sta aFEF3
        rts

///////////////////////////////////////////////////////

BlockWrite:
        // port A is already an output
        // DAV is high, ACK is high
        ldy #0
WRITELOOP:
        lda (tgt),y
        sta aFEF0
        iny
        lda #$00                                    // DAV=0 byte is ready
        sta aFEF2
        lda aFEF2                                   // ;wait for ACK low when it's received
        bmi *-3
        lda aFEF1                                   // STATUS
        and #%00000011                              // EOI?
        bne WRITEEND
inc $FF19
        lda (tgt),y
        sta aFEF0
        iny
        lda #$40                                    // DAV=1 byte is ready
        sta aFEF2
        lda aFEF2                                   // ;wait for ACK high when it's received
        bpl *-3
        lda aFEF1                                   // STATUS
        and #%00000011                              // EOI?
        bne WRITEEND
inc $FF19

        tya
        bne WRITELOOP
                                                    // inc tgt+1 for more sectors - but this example saves only one

WRITEEND:
        lda #$40                                    // ;$40 = DAV (bit 6) to 1
        sta aFEF2
        rts

////////////////////////////////////////////////////////

filename:
        .text "U0"									// utility command
blockcommand:
        .byte $00   							// $00 = read, $02 = write
track:	.byte 18								// track
sector:	.byte 0 								// sector
numsec: .byte 1                                 // number of consecutive blocks to read/write
filenameend:

////////////////////////////////////////////////////////

InputBufLen:
        .byte 0
InputBuffer: