
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

    .print	". plus/4 TCBM2SD fast loader (no exodecrunch support)"
    .namespace iolib {
    .namespace plus4tcbm_standard {
    .pseudopc io_base {

    jmp	startload
    jmp	readbyte
    jmp	writebyte
    jmp	hardsync
    jmp	sync
init:
readbyte:
	rts

// Send DOS command over channel 15

// in: ports setup correctly
// X=io_addr offset, not modified, A/Y changed
TCBM_SendDOSCommand:
	jsr		TCBM_LISTEN
	lda		#$6F				// command channel
	jsr		TCBM_SECONDARY
	ldy		#0
!:	lda		command,y
	jsr		TCBM_SENDBYTE
	iny
	cpy		#<(commandend-command)
	bne		!-
	// fall through to TCBM_UNLISTEN
sync:
hardsync:
TCBM_UNLISTEN:
	lda		#$3F				// UNLISTEN
	.byte $2c
TCBM_LISTEN:
	lda		#$20				// LISTEN
	pha
        lda     #$81    			// this is a command byte
        bne     TCBM_Send
TCBM_SECONDARY:						// send secondary addr ($60 == SECOND after LISTEN and after TALK)
	pha
        lda     #$82    			// this is a second byte
        bne     TCBM_Send
writebyte:
TCBM_SENDBYTE:
	pha
        lda     #$83				// this is a data byte
TCBM_Send:							// send using standard Kernal protocol
        sta padta,x
!:	lda pcdta,x
	bmi !-
	pla
	pha
        sta padta,x
        lsr pcdta,x
!:	lda pcdta,x
	bpl !-
        lda #0
        sta padta,x
        lsr pcdta,x
	pla
	rts

startload:
	stx filename
	sty filename+1
	ldx io_tcbmoffs
	jsr TCBM_SendDOSCommand
	lda #0
	sta padir,x // port A input
	sta pcdta,x // DAV=0 we are ready

!:	lda pcdta,x // wait for ACK low
	bmi !-
	lda padta,x // loadaddr lo
	sta ptr
	lda pbdta,x // STATUS
	tay
	lda #$40
	sta pcdta,x // DAV=1, confirm
	tya
	and #%00000011
	beq cont1
loaderror:
loadend:
	lda #$40	// DAV=1
	sta pcdta,x
	lda #$ff
	sta padir,x
	ldx filename
	ldy filename
	sec
	rts

cont1:
!:	lda pcdta,x // wait for ACK hi
	bpl !-
	lda padta,x // loadaddr hi
	sta ptr+1
	lda pbdta,x // STATUS
	tay
	lda #$00
	sta pcdta,x // DAV=0, confirm
	tya
	and #%00000011
	bne loaderror

// loadstart
	ldy #0
loadloop:
	// even: BMI+$40
!:	lda pcdta,x // wait for ACK low
	bmi !-
	lda padta,x
	sta (ptr),y
	iny
	lda pbdta,x // STATUS
	sta io_bitbuff
	lda #$40
	sta pcdta,x // DAV=1, confirm
	lda io_bitbuff
	and #%00000011
	bne eof
	// odd: BPL+$00
!:	lda pcdta,x // wait for ACK hi
	bpl !-
	lda padta,x
	sta (ptr),y
	iny
	lda pbdta,x // STATUS
	sta io_bitbuff
	lda #$00
	sta pcdta,x // DAV=0, confirm
	lda io_bitbuff
	and #%00000011
	bne eof
	tya
	bne loadloop
	inc ptr+1
	bne loadloop
eof:
	jsr loadend
	clc
	rts

command:
    .text "U0"	// burst command
    .byte %00011111 // fastload utility (filename)
filename:	// followed by name
    .byte 0, 0
commandend:

.if(*>io_base + $100) {
    .error "Build too long: $" + toHexString(*-io_base-$100, 4)
} else {
    .print ". . space remaining: $" + toHexString($100-(* - io_base), 4)
}

}
}
}
