;
; GEOS disk driver for TCBM2SD
; Maciej 'YTM/Elysium' Witkowiak, 2024, <ytm@elysium.pl>
;
; Based on disassembled 1551 disk driver
;
; This driver is fixed to device #8
; This driver uses fast protocol for block read/write within disk images: 'U0'+<oper>+<track>+<sector>+<number of blocks>
; - oper = $00 (read) or $02 (write)
; - track and sector bytes
; - number of blocks to read/write = 1 (always a single block)
;
; Notes about original code:
; - 1551 loads drive code from 'TDISK*' file, that saved precious space here, but every disk must have this file present
;   (DeskTop could just put it on track 18 as a part of GEOS disk format)
; - TCBM_SendDOSCommand and other TCBM_* functions next to it use standard TCBM protocol to communicate with DOS without Kernal
;   - using LSR to copy DAV bit (input) to ACK (output) is clever
; - the last jump in the jump table goes to 'Add2' instead of AllocateBlock like on C64/128
; - $97F8 holds offsets to TCBM device ports indexed by drive number
; - parts of low GEOS Kernal code are present here:
;   - _ReadFile/_WriteFile (vectors at $97FA/B $97FC/D)
;   - serial number ($97FE/F)
;   - 'Add2' through $9048 jump table
; - InitForIO/DoneWithIO never accessed, disabled already in the GEOS jumptabel
; - a lot of remaining code identical with 1541 disk driver

        .setcpu "6502"

.include "const.inc"
.include "geossym.inc"
.include "geosmac.inc"
.include "jumptab.inc"

z8b := $8b

verifyFlag		:= $8867

TriportA        := $FEC0
TriportB        := $FEC1
TriportC        := $FEC2
TriportDDRA     := $FEC3
TriportDDRB     := $FEC4
TriportDDRC     := $FEC5

curDeviceP4	:= $AE ; curDevice but on C16/116/+4 Kernal ($BA)

.segment "LOADADDR"
	.word $9000	; DISK_BASE

.segment "CODE"

; ----------------------------------------------------------------------------
_InitForIO:
        .addr   __InitDoneForIO                 ; 9000	; not used: LDX #0:RTS in jumptable at $c25c
_DoneWithIO:
        .addr   __InitDoneForIO                 ; 9002	; not used: LDX #0:RTS in jumptable at $c25f
_ExitTurbo:
        .addr   __ExitTurbo                     ; 9004
_PurgeTurbo:
        .addr   __PurgeTurbo                    ; 9006
_EnterTurbo:
        .addr   __EnterTurbo                    ; 9008
_ChangeDiskDevice:
        .addr   __ChangeDiskDevice              ; 900A
_NewDisk:
        .addr   __NewDisk                       ; 900C
_ReadBlock:
        .addr   __ReadBlock                     ; 900E
_WriteBlock:
        .addr   __WriteBlock                    ; 9010
_VerWriteBlock:
        .addr   __VerWriteBlock                 ; 9012
_OpenDisk:
        .addr   __OpenDisk                      ; 9014
_GetBlock:
        .addr   __GetBlock                      ; 9016
_PutBlock:
        .addr   __PutBlock                      ; 9018
_GetDirHead:
        .addr   __GetDirHead                    ; 901A
_PutDirHead:
        .addr   __PutDirHead                    ; 901C
_GetFreeDirBlk:
        .addr   __GetFreeDirBlk                 ; 901E
_CalcBlksFree:
        .addr   __CalcBlksFree                  ; 9020
_FreeBlock:
        .addr   __FreeBlock                     ; 9022
_SetNextFree:
        .addr   __SetNextFree                   ; 9024
_FindBAMBit:
        .addr   __FindBAMBit                    ; 9026
_NxtBlkAlloc:
        .addr   __NxtBlkAlloc                   ; 9028
_BlkAlloc:
        .addr   __BlkAlloc                      ; 902A
_ChkDkGEOS:
        .addr   __ChkDkGEOS                     ; 902C
_SetGEOSDisk:
        .addr   __SetGEOSDisk                   ; 902E
; ----------------------------------------------------------------------------
Get1stDirEntry:
        jmp     _Get1stDirEntry                 ; 9030

; ----------------------------------------------------------------------------
GetNxtDirEntry:
        jmp     _GetNxtDirEntry                 ; 9033

; ----------------------------------------------------------------------------
GetBorder:
        jmp     _GetBorder                      ; 9036

; ----------------------------------------------------------------------------
AddDirBlock:
        jmp     _AddDirBlock                    ; 9039

; ----------------------------------------------------------------------------
ReadBuff:
        jmp     _ReadBuff                       ; 903C

; ----------------------------------------------------------------------------
WriteBuff:
        jmp     _WriteBuff                      ; 903F

; ----------------------------------------------------------------------------
SendTSBytes:
        jmp     _SendTSBytes                    ; 9042

; ----------------------------------------------------------------------------
CheckErrors:
        jmp     _CheckErrors                    ; 9045

; ----------------------------------------------------------------------------
AllocateBlock:
        jmp     Add2		                    ; 9048	; XXX not AllocateBlock but Add2 ; used at $d793, $d7a9

; ----------------------------------------------------------------------------
borderFlag:  .byte   $00                             ; borderFlag
cmdLength:	.byte 0
; ----------------------------------------------------------------------------

; Send DOS command over channel 15
; input: (z8b), y=length

TCBM_SendDOSCommand:
		txa							; preserve x
		pha
		sty		cmdLength
        jsr		GetTCBMPortOffs		; device offset to x
;	lda #$ff            	                        ; port A to output (a bit delayed after ACK)
;	sta $FEF3
		jsr		TCBM_LISTEN
		lda		#$6F				; command channel
		jsr		TCBM_SECONDARY
		ldy		#0
:		lda		(z8b),y
		jsr		TCBM_SENDBYTE
		iny
		cpy		cmdLength
		bne		:-
		jsr		TCBM_UNLISTEN
		; CLOSE
;		jsr		TCBM_LISTEN
;		lda		#$EF				; close command channel
;		jsr		TCBM_SECONDARY

;	lda #$40										; $40 = DAV (bit 6) to 1
;	sta $FEF2

		pla							; restore x
		tax
		rts

TCBM_UNLISTEN:
		lda		#$3F				; UNLISTEN
		.byte $2c

TCBM_LISTEN:
		lda		#$20				; LISTEN
		pha
        lda     #$81    			; this is a command byte
        bne     TCBM_Send

TCBM_SECONDARY:						; send secondary addr ($60 == SECOND after LISTEN and after TALK)
		pha
        lda     #$82    			; this is a second byte
        bne     TCBM_Send

TCBM_SENDBYTE:
		pha
        lda     #$83				; this is a data byte
TCBM_Send:							; send using standard Kernal protocol
        sta TriportA,x
:		lda TriportC,x
		bmi :-
		pla
		pha
        sta TriportA,x
        lsr TriportC,x
:		lda TriportC,x
		bpl :-
        lda #0
        sta TriportA,x
        lsr TriportC,x
		pla
		rts

; ----------------------------------------------------------------------------
; 97F8/F9 - filled in by booter with offset to TCBM drive port $30 (#8) or $00 (#9)
GetTCBMPortOffs:
	ldx #$30	; XYX fix at device #8	$FEF0
	rts

	pha                                     ; 90AC
	ldx curDrive
	lda TCBMPortOffs-8,x
	tax
	pla
	rts

; ----------------------------------------------------------------------------
__ChangeDiskDevice:
	ldx #0		; XYX do nothing
	rts
	; or do something
	and #$09
	sta Cmd_ChangeDiskDeviceNum
	LoadW z8b, Cmd_ChangeDiskDevice
	ldy #<(Cmd_ChangeDiskDeviceEnd-Cmd_ChangeDiskDeviceNum)
	jsr TCBM_SendDOSCommand

	; set new devnum
	ldx Cmd_ChangeDiskDeviceNum
	stx curDrive
	stx curDeviceP4
	ldx #0
	rts

Cmd_ChangeDiskDevice:
	.byte "U0>"
Cmd_ChangeDiskDeviceNum:
	.byte 8
Cmd_ChangeDiskDeviceEnd:

; ----------------------------------------------------------------------------
__EnterTurbo:
;	lda curDrive
;	jsr SetDevice

_SendTSBytes:		; not used
_CheckErrors:		; not used
__PurgeTurbo:
__ExitTurbo:
__NewDisk:
	ldx #0
	rts

; ----------------------------------------------------------------------------
__BlkAlloc:
	ldy #1
	sty r3L
	dey
	sty r3H
__NxtBlkAlloc:
	PushW r9
	PushW r3
	LoadW r3, $00fe
	ldx #r2
	ldy #r3
	jsr Ddiv
	lda r8L
	beq :+
	inc r2L
	bne :+
	inc r2H
:
	LoadW r5, curDirHead
	jsr __CalcBlksFree
	PopW r3
	ldx #INSUFF_SPACE
	CmpW r2, r4
	beq :+
	bcs BlkAlc4
:
	MoveW r6, r4
	MoveW r2, r5
BlkAlc2:
	jsr	__SetNextFree
	bnex BlkAlc4
	ldy #0
	lda r3L
	sta (r4),y
	iny
	lda r3H
	sta (r4),y
	AddVW 2, r4
	lda r5L
	bne @X
	dec r5H
@X:	dec r5L
	lda r5L
	ora r5H
	bne BlkAlc2
	ldy #0
	tya
	sta (r4),y
	iny
	lda r8L
	bne :+
	lda #$fe
:
	clc
	adc #1
	sta (r4),y
	ldx #0
BlkAlc4:
	PopW r9
	rts

; ----------------------------------------------------------------------------
SetDirHead:
	LoadB r1L, DIR_TRACK
	LoadB r1H, 0
	sta r4L
	LoadB r4H, (>curDirHead)
	rts

; ----------------------------------------------------------------------------
_Get1stDirEntry:
	LoadB r1L, DIR_TRACK
	LoadB r1H, 1
	;MoveW curDirHead, r1			; get t&s from directory header
	jsr _ReadBuff
	LoadW r5, diskBlkBuf+FRST_FILE_ENTRY
	LoadB borderFlag, 0
	rts

; ----------------------------------------------------------------------------
_GetNxtDirEntry:
	ldx #0
	ldy #0
	AddVW $20, r5
	CmpWI r5, diskBlkBuf+$ff
	bcc GNDirEntry1
	ldy #$ff
	MoveW diskBlkBuf, r1
	bne GNDirEntry0
	lda borderFlag
	bne GNDirEntry1
	LoadB borderFlag, $ff
	jsr _GetBorder
	bnex GNDirEntry1
	tya
	bne GNDirEntry1
GNDirEntry0:
	jsr _ReadBuff
	ldy #0
	LoadW r5, diskBlkBuf+FRST_FILE_ENTRY
GNDirEntry1:
	rts

; ----------------------------------------------------------------------------
_GetBorder:
	jsr __GetDirHead
	bnex GetBord2
	LoadW r5, curDirHead
	jsr __ChkDkGEOS
	bne GetBord0
	ldy #$ff
	bne GetBord1
GetBord0:
	MoveW curDirHead+OFF_OP_TR_SC, r1
	ldy #0
GetBord1:
	ldx #0
GetBord2:
	rts

; ----------------------------------------------------------------------------
__ChkDkGEOS:
	ldy #OFF_GS_ID
	ldx #0
	LoadB isGEOS, 0
ChkDkG0:
	lda (r5),y
	cmp GEOSDiskID,x
	bne ChkDkG1
	iny
	inx
	cpx #11
	bne ChkDkG0
	LoadB isGEOS, $ff
ChkDkG1:
	lda isGEOS
	rts

GEOSDiskID:
	.byte "GEOS format V1.0",NULL

; ----------------------------------------------------------------------------

TCBM2SD_ReadWriteCmd:
	.byte "U0"
TCBM2SD_ReadWriteCmd_Oper:
	.byte 0
TCBM2SD_ReadWriteCmd_Track:
	.byte 0
TCBM2SD_ReadWriteCmd_Sector:
	.byte 0
	.byte 1		; number of sectors
TCBM2SD_ReadWriteCmd_End:

TCBM2SD_SendParams:
	sta TCBM2SD_ReadWriteCmd_Oper
	MoveB r1L, TCBM2SD_ReadWriteCmd_Track
	MoveB r1H, TCBM2SD_ReadWriteCmd_Sector
	LoadW z8b, TCBM2SD_ReadWriteCmd
	ldy #<(TCBM2SD_ReadWriteCmd_End-TCBM2SD_ReadWriteCmd)
	jmp TCBM_SendDOSCommand

; ----------------------------------------------------------------------------

__GetDirHead:
	jsr SetDirHead
	bne __GetBlock
_ReadBuff:
	LoadW r4, diskBlkBuf
__GetBlock:
__ReadBlock:
	jsr CheckParams_1
	bcc GetBlk0
RdBlock0:
	lda #$00		; TCBM2SD read oper
	jsr TCBM2SD_SendParams

	; XYX port offset unused, always device at $FEF0
    lda #0
    sta $FEF3           	                        ; port A DDR = input first
    sta $FEF0       	                            ; port A (to clear pullups?)
    sta $FEF2               	                    ; DAV=0 - WE ARE READY

    tay
ReadBlockLoop:
:	lda $FEF2                                   	; wait for ACK low
	bmi :-
;inc $FF19
	lda $FEF0
	sta (r4),y
	iny
	ldx $FEF1                   	                ; STATUS
	lda #$40                                    	; DAV=1 confirm
	sta $FEF2
	txa                   	  	                    ; EOI?
	and #%00000011
	bne ReadBlockLoopEnd

:	lda $FEF2										; wait for ACK high
	bpl :-
;inc $FF19
	lda $FEF0
	sta (r4),y
	iny
	ldx $FEF1                   	                ; STATUS
	lda #$00                 	                   	; DAV=0 confirm
	sta $FEF2
	txa                   	  	                    ; EOI?
	and #%00000011
	bne ReadBlockLoopEnd

	tya
	bne ReadBlockLoop
;	inc r4H                          	         	; possibly more sectors?
;	bne ReadBlockLoop

ReadBlockLoopEnd:
:	lda $FEF2                                   	; wait for ACK high
	bpl :-
	lda #$00
	sta $FEF0										; clear data port (just in case it was one of command bytes)
	lda #$ff            	                        ; port A to output (a bit delayed after ACK)
	sta $FEF3
	lda #$40										; $40 = DAV (bit 6) to 1
	sta $FEF2

	ldx #0
GetBlk0:
	rts

; ----------------------------------------------------------------------------
__PutDirHead:
	jsr SetDirHead
	bne __PutBlock
_WriteBuff:
	LoadW r4, diskBlkBuf
__PutBlock:
__VerWriteBlock:
__WriteBlock:
	jsr CheckParams_1
	bcc WriteBlockEnd

	lda #$02		; TCBM2SD write oper
	jsr TCBM2SD_SendParams

	; port A is already an output
	; DAV is high, ACK is high
	lda #$40                           	 	        ; DAV=1 byte is not ready
	sta $FEF2

	ldy #0
WriteBlockLoop:
	lda (r4),y
	sta $FEF0
	iny
	lda #$00                           	 	        ; DAV=0 byte is ready
	sta $FEF2
:	lda $FEF2                   	                ; wait for ACK low when it's received
	bmi :-
	lda $FEF1                         	    	    ; STATUS
	and #%00000011									; EOI?
	bne WriteBlockLoopEnd
;inc $FF19
	lda (r4),y
	sta $FEF0
	iny
	lda #$40                        	            ; DAV=1 byte is ready
	sta $FEF2
:	lda $FEF2                                   	; wait for ACK high when it's received
	bpl :-
	lda $FEF1                         	    	    ; STATUS
	and #%00000011									; EOI?
	bne WriteBlockLoopEnd
;inc $FF19
	tya
	bne WriteBlockLoop
	; we can send more sectors - but this example saves only one
;	inc r4H											; possibly more sectors?
;	bne WriteBlockLoop

WriteBlockLoopEnd:
	lda $FEF2                                   	; wait for ACK high
	bpl :-
	lda #$00
	sta $FEF0										; clear data port (just in case it was one of command bytes)
	lda #$ff            	                        ; port A to output (a bit delayed after ACK)
	sta $FEF3
	lda #$40										; $40 = DAV (bit 6) to 1
	sta $FEF2

	ldx #0
WriteBlockEnd:
	rts

; ----------------------------------------------------------------------------
__OpenDisk:
	jsr __NewDisk
	bnex OpenDsk1
	jsr __GetDirHead
	bnex OpenDsk1
	LoadW r5, curDirHead
	jsr __ChkDkGEOS
	LoadW r4, curDirHead+OFF_DISK_NAME
	ldx #r5
	jsr GetPtrCurDkNm
	ldx #r4
	ldy #r5
	lda #18
	jsr CopyFString
	ldx #0
OpenDsk1:
	rts

; ----------------------------------------------------------------------------
__GetFreeDirBlk:
	PushB r6L
	PushW r2
	ldx r10L
	inx
	stx r6L
	LoadB r1L, DIR_TRACK
	LoadB r1H, 1
GFDirBlk0:
	jsr _ReadBuff
GFDirBlk1:
	bnex GFDirBlk5
	dec r6L
	beq GFDirBlk3
GFDirBlk11:
	lda diskBlkBuf
	bne GFDirBlk2
	jsr _AddDirBlock
	bra GFDirBlk1
GFDirBlk2:
	sta r1L
	MoveB diskBlkBuf+1, r1H
	bra GFDirBlk0
GFDirBlk3:
	ldy #FRST_FILE_ENTRY
	ldx #0
GFDirBlk4:
	lda diskBlkBuf,y
	beq GFDirBlk5
	tya
	addv $20
	tay
	bcc GFDirBlk4
	LoadB r6L, 1
	ldx #FULL_DIRECTORY
	ldy r10L
	iny
	sty r10L
	cpy #$12
	bcc GFDirBlk11
GFDirBlk5:
	PopW r2
	PopB r6L
	rts

; ----------------------------------------------------------------------------
_AddDirBlock:
	PushW r6
	ldy #$48
	ldx #FULL_DIRECTORY
	lda curDirHead,y
	beq :+
	MoveW r1, r3
	jsr __SetNextFree
	MoveW r3, diskBlkBuf
	jsr _WriteBuff
	bnex :+
	MoveW r3, r1
	jsr ClearAndWrite
:
	PopW r6
	rts

; ----------------------------------------------------------------------------
ClearAndWrite:
	lda #0
	tay
:	sta diskBlkBuf,y
	iny
	bne :-
	dey
	sty diskBlkBuf+1
	jmp _WriteBuff

; ----------------------------------------------------------------------------
__SetNextFree:
	lda r3H
	add interleave
	sta r6H
	MoveB r3L, r6L
	cmp #25
	bcc SNxtFree0
	dec r6H
SNxtFree0:
	cmp #DIR_TRACK
	beq SNxtFree1
SNxtFree00:
	lda r6L
	cmp #DIR_TRACK
	beq SNxtFree3
SNxtFree1:
	asl
	asl
	tax
	lda curDirHead,x
	beq SNxtFree3
	lda r6L
	jsr SNxtFreeHelp
	lda SecScTab,x
	sta r7L
	tay
SNxtFree2:
	jsr SNxtFreeHelp2
	bcc SNxtFree4
	inc r6H
	dey
	bne SNxtFree2
SNxtFree3:
	inc r6L
	CmpBI r6L, N_TRACKS+1
	bcs SNxtFree5
	sub r3L
	sta r6H
	asl
	adc #4
	adc interleave
	sta r6H
	bne SNxtFree00
SNxtFree4:
	MoveW_ r6, r3
	ldx #0
	rts
SNxtFree5:
	ldx #INSUFF_SPACE
	rts
	
SNxtFreeHelp:
	ldx #0
:
	cmp SecTrTab,x
	bcc :+
	inx
	bne :-
:
	rts

SecTrTab:
	.byte 18, 25, 31, 36
SecScTab:
	.byte 21, 19, 18, 17

; ----------------------------------------------------------------------------
SNxtFreeHelp2:
	lda r6H
SNFHlp2_1:
	cmp r7L
	bcc SNFHlp2_2
	sub r7L
	bra SNFHlp2_1
SNFHlp2_2:
	sta r6H
; XXX that would be _AllocateBlock in drv1541

	jsr __FindBAMBit
	beq :+
	lda r8H
	eor #$ff
	and curDirHead,x
	sta curDirHead,x
	ldx r7H
	dec curDirHead,x
	clc
	rts

:	sec
	rts

; ----------------------------------------------------------------------------
__FindBAMBit:
	lda r6L
	asl
	asl
	sta r7H
	lda r6H
	and #%00000111
	tax
	lda FBBBitTab,x
	sta r8H
	lda r6H
	lsr
	lsr
	lsr
	sec
	adc r7H
	tax
	lda curDirHead,x
	and r8H
	rts

FBBBitTab:
	.byte $01, $02, $04, $08
	.byte $10, $20, $40, $80

; ----------------------------------------------------------------------------
__FreeBlock:
	jsr __FindBAMBit
	bne :+
	lda r8H
	eor curDirHead,x
	sta curDirHead,x
	ldx r7H
	inc curDirHead,x
	ldx #0
	rts
:
	ldx #BAD_BAM
	rts

; ----------------------------------------------------------------------------
__CalcBlksFree:
	LoadW_ r4, 0
	ldy #OFF_TO_BAM
:
	lda (r5),y
	add r4L
	sta r4L
	bcc :+
	inc r4H
:
	tya
	clc
	adc #4
	tay
	cpy #$48
	beq :-
	cpy #$90
	bne :--
	LoadW r3, $0298
SetGDisk2:
	rts

; ----------------------------------------------------------------------------
__SetGEOSDisk:
	jsr __GetDirHead
	bnex SetGDisk2
	LoadW r5, curDirHead
	jsr __CalcBlksFree
	ldx #INSUFF_SPACE
	lda r4L
	ora r4H
	beq SetGDisk2
	LoadB r0L, 0
	LoadB r3L, DIR_TRACK+1
:
	LoadB r3H, 0
	jsr __SetNextFree
	beqx SetGDisk0
	lda r0L
	bne SetGDisk2
	LoadB r3L, 1
	sta r0L
	bne :-
SetGDisk0:
	MoveW r3, r1
	jsr ClearAndWrite
	bnex SetGDisk2
	MoveW r1, curDirHead+OFF_OP_TR_SC
	ldy #OFF_GS_ID
	ldx #0
:	lda GEOSDiskID,x
	sta curDirHead,y
	iny
	inx
	cmp #0
	bne :-
	jmp __PutDirHead

; ----------------------------------------------------------------------------
CheckParams_1:
	ldx #INV_TRACK
	lda r1L
	beq :+
	cmp #N_TRACKS+1
	bcs :+
	sec
	rts
:
	clc
	rts

; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------

; part of GEOS Kernal follows

; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------

.segment "GEOSKERNALLO"

; XXX NOT AllocateBlock
.assert * = $96D2, error, "Add2 must be at $96D2"
; _Add2 = files1a2a.s
_AllocateBlock:
Add2:
		clc
        lda     #2
        adc     r6L
        sta     r6L
        bcc     @1
        inc     r6H
@1:
Add2_return:
		rts

; ----------------------------------------------------------------------------
.assert * = $96DE, error, "_ReadFile must be at $96DE"
; _ReadFile = files1a2b.s
_ReadFile:
	jsr __EnterTurbo
	bnex Add2_return
	PushW r0
	LoadW r4, diskBlkBuf
	LoadB r5L, 2
	MoveW r1, fileTrScTab+2
L9700:
	jsr     __ReadBlock                     ; 9700
	bnex ReadFileEnd
	ldy #$fe
	lda diskBlkBuf
	bne :+
	ldy diskBlkBuf+1
	dey
        beq     L9741                           ; 9711
:
	lda r2H
	bne :+
	cpy r2L
	bcc :+
	beq :+
	ldx #BFR_OVERFLOW
	bne ReadFileEnd

:	sty r1L
:	lda diskBlkBuf+1,y
	dey
	sta (r7),y
	bne :-
	AddB r1L, r7L
	bcc :+
	inc r7H
:
	SubB r1L, r2L
	bcs :+
	dec r2H
:
L9741:
	inc r5L
	inc r5L
	ldy r5L
	MoveB diskBlkBuf+1, r1H
	sta fileTrScTab+1,y
	MoveB diskBlkBuf, r1L
	sta fileTrScTab,y
        bne     L9700                           ; 9757
	ldx #0
ReadFileEnd:
	PopW r0
	rts

; ----------------------------------------------------------------------------
.assert * = $9762, error, "FlaggedPutBlock must be at $9762"
; FlaggedPutBlock = files1a2b.s

FlaggedPutBlock:
	lda verifyFlag
	beq @1
	jmp __VerWriteBlock
@1:	jmp __WriteBlock

; ----------------------------------------------------------------------------
.assert * = $976D, error, "_WriteFile must be at $976D"
;_WriteFile = files1b.s
_WriteFile:
	jsr __EnterTurbo
	bnex :+
	sta verifyFlag
	LoadW r4, diskBlkBuf
	PushW r6
	PushW r7
	jsr DoWriteFile
	PopW r7
	PopW r6
	bnex :+
	dec verifyFlag
	jmp DoWriteFile
:	rts

; ----------------------------------------------------------------------------

.assert * = $97A3, error, "DoWriteFile must be at $97A3"
;DoWriteFile = files1b.s
DoWriteFile:
	ldy #0
	lda (r6),y
	beq @2
	sta r1L
	iny
	lda (r6),y
	sta r1H
	dey
	jsr Add2
	lda (r6),y
	sta (r4),y
	iny
	lda (r6),y
	sta (r4),y
	ldy #$fe
@1:	dey
	lda (r7),y
	sta diskBlkBuf+2,y
	tya
	bne @1
	jsr FlaggedPutBlock
	bnex @3
	AddVW $fe, r7
	bra DoWriteFile
@2:	tax
@3:
__InitDoneForIO:								; 97DD - NOT InitDoneForIO
	rts

; ----------------------------------------------------------------------------

; drv code turbo restart

DosCMDExe:
		.byte   "M-E"
		.word 	$0400
		.byte $ff	; end of command marker

DrvCodeBoot:
        .byte   "&0:TDISK*,U"                   ; 97E4
		.byte $ff	; end of command marker
DrvCodeBootEnd:
; ----------------------------------------------------------------------------
		.byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 97F0 UNUSED?

; ----------------------------------------------------------------------------

.assert * = $97F8, error, "TCBMPortOffs must be at $97F8"
TCBMPortOffs:
        .byte   $30,$00
; ----------------------------------------------------------------------------
.assert * = $97FA, error, "_WriteFile / _ReadFile vectors must be at $97FA"
		.word _WriteFile
		.word _ReadFile
; ----------------------------------------------------------------------------
.assert * = $97FE, error, "Serial number must be at $97FE"
		.word $3e12
