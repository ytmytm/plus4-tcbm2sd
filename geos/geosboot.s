;
; GEOS BOOT for Plus4 + TCBM2SD
; Maciej 'YTM/Elysium' Witkowiak, 2024, <ytm@elysium.pl>
;
; This is based on disassembled 'GEOS BOOT' for Plus4
; all code related to original 1551 disk driver was removed
;
; Since GEOS Kernal low code ($8C00-$9800) and high ($C000-$FD00) are already in place
; we just use the system routines.
;
; After RESET GEOS Kernal should load 'GEOS BOOT' to $0900 and jump into $0903.

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "jumptab.inc"
.include "diskdrv.inc"

.segment "LOADADDR"
		.word $0900

.segment "CODE"

        .setcpu "6502"

curDeviceP4 	:= $AE

; ----------------------------------------------------------------------------

L07EE		:= $07EE ; Kernal IRQ?

TCBMPortOffs    := $97F8
TriportA        := $FEC0
TriportB        := $FEC1
TriportC        := $FEC2
TriportDDRA     := $FEC3
TriportDDRB     := $FEC4
TriportDDRC     := $FEC5

LC332		:= $C332
LC3B6		:= $C3B6
LFB80		:= $FB80
LF2CE		:= $F2CE

; ----------------------------------------------------------------------------
        jmp     GeosReset                       ; 0900

; ----------------------------------------------------------------------------
        ldx     #$04                            ; 0903
: 	lda     year,x                          ; 0905
        sta     dateCopy,x                      ; 0908
        dex                                     ; 090B
        bpl     :-
	LoadB	$D403, $30			; ???
        jsr     i_MoveData                      ; 0913

        .addr   $9800
        .addr   $1800
        .word   $0800

        jmp     L09CD                           ; 091C

; ----------------------------------------------------------------------------
dateCopy:  .byte   90, 12, 1, 0, 1
; ----------------------------------------------------------------------------
GeosReset:
        sei                                     ; 0924
        ldx     #$FF                            ; 0925
        txs                                     ; 0927
        ldx     #$03                            ; 0928
:	lda     L0BED,x                         ; 092A
        sta     RESET_VECTOR,x                  ; 092D
        dex                                     ; 0930
        bpl     :-
        stx     $FF3F                           ; 0933

        lda     #$30                            ; 0936
        ldx     curDeviceP4                     ; 0938
        cpx     #$08                            ; 093A
        beq     :+
        lda     #$00                            ; 093E
:	sta     TCBMPortOffs                    ; 0940
        eor     #$30                            ; 0943
        sta     TCBMPortOffs+1                  ; 0945

; ----------------------------------------------------------------------------
L09CD:  jsr     i_FillRam                       ; 09CD
	.word	$0C00	; len
	.addr	$8000	; addr
	.byte	$00
; ----------------------------------------------------------------------------
        ldx     #$04                            ; 09D5
:	lda     $C0FB,x                         ; 09D7
        sta     $FFFB,x                         ; 09DA
        lda     dateCopy,x                      ; 09DD
        sta     year,x                          ; 09E0
        dex                                     ; 09E3
        bpl     :-
        sei                                     ; 09E6
        jsr     DoRAMOp                         ; 09E7
        .addr   LF2CE                           ; ROM call to ???
; ----------------------------------------------------------------------------
	LoadW	irqvec, L07EE
        jsr     FirstInit                       ; 09F6
        jsr     LC332                           ; 09F9
        jsr     LFB80                           ; mouse init
	LoadB	$FD10, 0
	LoadB	NUMDRV, 1			; one drive only
	sta	driveType			; 1541/1551
	LoadB	curDeviceP4, 8			; switch current device to 8
	sta	curDrive
	sta interleave
	sta     $FD02                           ; ???
	jsr	SetDevice
	LoadB	$9FF8, $3f			; ???
	LoadB	TCBMPortOffs, $30		; correct offset setup if TCBM:1 is #8 (default)
	LoadB	TCBMPortOffs+1, $00

	jsr		OpenDisk
	beqx	:+
	jmp		err
:

	jsr $C332	; clearscr
	jsr $C39E	; pointer?

	; we could jump to EnterDeskTop here, but that would clear the screen and the message
	;jmp EnterDeskTop
	jsr UseSystemFont
	jsr i_PutString
	.word 10
	.byte 40
	.byte BOLDON, "TCBM2SD disk driver by YTM/Elysium, 2024",0

	LoadB	r0L, 0
	LoadW	r6, DeskTopName
    jsr     GetFile
	bnex	err

	jsr		LC3B6
	LoadB	$8FF8, 0
	sta		r0
	MoveW	fileHeader+O_GHST_VEC, r7		; exec addr from file header
	jmp     StartAppl


.if .defined(debug)
;;;	jsr gfxtest

	lda	#0
	sta     r0L                             ; 0BB9
	LoadW	r6, DeskTopName
        jsr     GetFile                         ; 0BC3
	bnex	err        
;        lda     $8157                           ; 0BC9
;        cmp     #$34                            ; 0BCC
;        bne     L0BB8                           ; 0BCE
;        lda     $8868                           ; 0BD0
;        jsr     SetDevice                       ; 0BD3
        jsr     LC3B6                           ; 0BD6
	LoadB	$8FF8, 0
        sta     r0                              ; 0BDE
	MoveW	$814B, r7
        jmp     StartAppl                       ; 0BEA

	jsr gfxtest
	jmp	EnterDeskTop
.endif

err:
	inc 	$ff19
	jmp 	err


; ----------------------------------------------------------------------------
L0BED:  .addr   GeosReset                       ; 0BED
        .addr   InterruptVec                    ; 0BEF

; ----------------------------------------------------------------------------
InterruptVec:
        rti                                     ; 0B22

DeskTopName:
        .byte   "DESK TOP"                      ; 0B6B
        .byte   $00                             ; 0B73
;

;----------------------------
.if .defined(debug)
waitkey:
	inc $ff19
	jsr GetNextChar
	beq waitkey
	rts

gfxtest:
	jsr UseSystemFont

	jsr i_PutString
	.word 0
	.byte 10
	.byte "OpenDisk (18,0)", 0
	jsr waitkey
	jsr OpenDisk
	beqx :+
	jmp err
:

	jsr i_PutString
	.word 0
	.byte 20
	.byte "Readfile (6,$12)", 0
	jsr waitkey

	LoadW r7, $3000
	LoadW r2, $ffff
	LoadB r1L, 6
	LoadW r1H, $12
	jsr ReadFile
	beqx :+
	jmp err
:



	jsr i_PutString
	.word 0
	.byte 20
	.byte "GetBlock (19,5)", 0
	jsr waitkey
	LoadB r1L, 19
	LoadB r1H, 5
	LoadW r4, diskBlkBuf
	jsr GetBlock
	beqx :+
	jmp err
:

	jsr i_PutString
	.word 0
	.byte 30
	.byte "GetBlock (17,10)", 0
	jsr waitkey
	LoadB r1L, 17
	LoadB r1H, 10
	LoadW r4, diskBlkBuf
	jsr GetBlock
	beqx :+
	jmp err
:

	jsr i_PutString
	.word 0
	.byte 40
	.byte "Get1stDirEntry (18,1)", 0
	jsr waitkey
	jsr Get1stDirEntry
	beqx :+
	jmp err
:
	MoveW r5, a0
	jsr waitkey
	jsr i_PutString
	.word 0
	.byte 50
	.byte "name:", 0
	ldy #11
	lda #0
	sta (a0),y

	ldy #3
	sty a1L
:	ldy a1L
	lda (a0),y
	beq :+
	jsr PutChar
	inc a1L
	bne :-
:

	jsr i_PutString
	.word 0
	.byte 60
	.byte "GetNxtDirEntry (18,1)", 0
	jsr waitkey
	MoveW a0, r5
	jsr GetNxtDirEntry
	beqx :+
	jmp err
:
	MoveW r5, a0
	jsr waitkey
	jsr i_PutString
	.word 0
	.byte 70
	.byte "name:", 0
	ldy #11
	lda #0
	sta (a0),y

	ldy #3
	sty a1L
:	ldy a1L
	lda (a0),y
	beq :+
	jsr PutChar
	inc a1L
	bne :-
:

	jsr i_PutString
	.word 0
	.byte 80
	.byte "GetNxtDirEntry (18,1)", 0
	jsr waitkey
	LoadW r5, $80e0
	jsr GetNxtDirEntry
	beqx :+
	jmp err
:
	MoveW r5, a0
	jsr waitkey
	jsr i_PutString
	.word 0
	.byte 90
	.byte "name:", 0
	ldy #11
	lda #0
	sta (a0),y

	ldy #3
	sty a1L
:	ldy a1L
	lda (a0),y
	beq :+
	jsr PutChar
	inc a1L
	bne :-
:

	jsr i_PutString
	.word 0
	.byte 100
	.byte "Findfile (18,1)", 0
	jsr waitkey
	LoadW	r6, DeskTopName
        jsr     FindFile                         ; 0BC3
	beqx :+
	jmp err
:

PushW r1
PushW r5
PushW r6

	jsr i_PutString
	.word 0
	.byte 110
	.byte "found, get fhdrinfo", 0
	jsr waitkey
	LoadW r9, dirEntryBuf
	jsr GetFHdrInfo
	beqx :+
	jmp err
:

	jsr i_PutString
	.word 0
	.byte 120
	.byte "found ", 0

	LoadW a0, $8161
	LoadB a1L, 0
:	ldy a1L
	lda (a0),y
	beq :+
	jsr PutChar
	inc a1L
	bne :-
:

	jsr waitkey

	jsr i_PutString
	.word 0
	.byte 130
	.byte "LdFile", 0

PopW r6
PopW r5
PopW r1
LoadW r9, dirEntryBuf
LoadB r0L, 0
LoadB $886b, 0
LoadW $886C, $3000
	jsr LdFile
	beqx :+
	jmp err
:

	jsr i_PutString
	.word 0
	.byte 140
	.byte "loaded ", 0


	ldx #0
:
	lda $9600,x
	sta $1600,x
	lda $9700,x
	sta $1700,x
	lda $c100,x
	sta $1800,x
	lda $c200,x
	sta $1900,x
	lda $8000,x
	sta $2000,x
	lda $8100,x
	sta $2100,x
	lda $8200,x
	sta $2200,x
	lda $8300,x
	sta $2300,x
	lda $8400,x
	sta $2400,x
	inx
	bne :-

jmp Panic

	jsr i_PutString
	.word 0
	.byte 130
	.byte "LdApplic", 0

PopW r6
PopW r5
PopW r1
LoadW r9, dirEntryBuf
LoadB r0L, 0

	jsr LdApplic

	jsr i_PutString
	.word 0
	.byte 140
	.byte "ok", 0

	jsr waitkey

	LoadB	$8FF8, 0
        sta     r0                              ; 0BDE
	MoveW	$814B, r7
        jmp     StartAppl                       ; 0BEA

	rts

.endif
