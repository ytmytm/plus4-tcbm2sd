

    .label  io_bitbuff	= $b7
    .label  io_loadptr  = $9e
    .label  io_loadflag = $9d

.label ptr = io_loadptr

.label	tcbm_8		= $fef0
.label	tcbm_9		= $fec0
.namespace tcbm {
    .label	data	= tcbm_9 + 0
    //  Bit1    status 1
    //  Bit0    status 0
    .label	status	= tcbm_9 + 1
    //  Bit7    DAV
    //  Bit6    ACK
    .label	handshake	= tcbm_9 + 2
    // 1=out// 0=in
    .label	data_dir	= tcbm_9 + 3
    .label	status_dir	= tcbm_9 + 4
    .label	handshake_dir	= tcbm_9 + 5
}

.label	tia	= tcbm_9
.label	padta	= tia
.label	pbdta	= tia+1
.label	pcdta	= tia+2
.label	padir	= tia+3
.label	pbdir	= tia+4
.label	pcdir	= tia+5

    .print	". plus/4 TCBM2SD loader with readbyte for decruncher"
    .namespace iolib {
    .namespace plus4tcbm_standard {
    .pseudopc io_base {

    jmp	startload	// 0
    jmp	readbyte	// 3
    jmp	writebyte	// 6
    jmp	hardsync	// 9
    jmp	sync		// c
init:			// f + 1 == $10
	rts		// init must be empty ($0210 is called from exodecruncher)
// $0210
openfilename:		// like startload, but only open the file
	stx filename
	sty filename+1
	ldx io_tcbmoffs
	jmp openfile

sync:
writebyte:
hardsync:
	lda #0
	sta io_bitbuff
	ldx io_tcbmoffs
	jmp TCBM_UNLISTEN

readbyte:
	// eof flag from previous run?
	ldx io_tcbmoffs
	lda io_bitbuff
	beq !+
	jsr eof
	sec
	rts
	// no, continue
!:	jsr TCBM_GETBYTE
	clc
	rts

// Send DOS command over channel 15
// in: ports setup correctly
// X=io_addr offset, not modified, A/Y changed
//TCBM_SendDOSCommand:
//	lda #$6F	// command channel
//	.byte $2c
TCBM_OPEN:
	lda #$F0	// OPEN
	pha
	jsr		TCBM_LISTEN
	pla
	jsr		TCBM_SECONDARY
	ldy		#0
!:	lda		command,y
	jsr		TCBM_SENDBYTE
	iny
	cpy		#<(commandend-command)
	bne		!-
	// fall through to TCBM_UNLISTEN
TCBM_UNLISTEN:
	lda		#$3F				// UNLISTEN
	.byte $2c
TCBM_UNTALK:
	lda		#$5F				// UNTALK
	.byte $2c
TCBM_LISTEN:
	lda		#$20				// LISTEN
	.byte $2c
TCBM_TALK:
	lda		#$40				// TALK
	pha
        lda     #$81    			// this is a command byte
        bne     TCBM_Send
TCBM_SECONDARY:						// send secondary addr ($60 == SECOND after LISTEN and after TALK)
	pha
        lda     #$82    			// this is a second byte
        bne     TCBM_Send
TCBM_SENDBYTE:
	pha
        lda     #$83				// this is a data byte
TCBM_Send:							// send using standard Kernal protocol
        sta padta,x
!:	lda pcdta,x
	bmi !-
	pla
	pha
	jmp TCBM_Common

// X=offset
TCBM_GETBYTE:	// EC96
	lda #$84
	sta padta,x
!:	lda pcdta,x
	bmi !-
	lda #0
	sta padir,x	// input
	sta pcdta,x	// clear ACK
!:	lda pcdta,x
	bpl !-
	lda pbdta,x	// STATUS
	and #3
	sta io_bitbuff
	lda padta,x
	pha
	lsr pcdta,x	// set ACK
!:	lda pcdta,x
	bmi !-
	lda #$ff
	sta padir,x	// output
	lda #0
TCBM_Common:
        sta padta,x
        lsr pcdta,x
!:	lda pcdta,x
	bpl !-
        lda #0		// needed by TCBM_Send
        sta padta,x
        lsr pcdta,x
	pla
	clc
	rts

openfile:
	jsr TCBM_OPEN
	lda pbdta,x	// STATUS
	and #3
	sta io_bitbuff
	beq !+
	sec
	rts
!:	jsr TCBM_TALK
	lda #$60			// SECOND 0
	jmp TCBM_SECONDARY

eof:	jsr TCBM_UNTALK
	// maybe UNLISTEN is enough?
	jsr TCBM_LISTEN
	lda #$E0			// CLOSE 0
	jsr TCBM_SECONDARY
	jsr TCBM_UNLISTEN
	clc
	rts

startload:
	jsr openfilename
	bcc !+
	rts
!:	jsr $0374
!:	jsr TCBM_GETBYTE
	sta (ptr),y
	lda io_bitbuff
	beq !+
	jmp eof
!:	iny
	bne !--
	inc ptr+1
	bne !--

command:
filename:	// followed by name
    .byte 0, 0
    .byte '*'
commandend:

.if(*>io_base + $100) {
    .error "Build too long: $" + toHexString(*-io_base-$100, 4)
} else {
    .print ". . space remaining: $" + toHexString($100-(* - io_base), 4)
}

}
}
}

// startload if it could fit in
/*
.if (0==1) {
startload:
	jsr openfilename
	bcc !+
	rts
!:	jsr TCBM_GETBYTE
	sta ptr
	jsr TCBM_GETBYTE
	sta ptr+1
	ldy #0
!:	jsr TCBM_GETBYTE
	sta (ptr),y
	lda io_bitbuff
	beq !+
	jmp eof
!:	iny
	bne !--
	inc ptr+1
	bne !--
}
*/
