; da65 V2.19 - Git dcdf7ade0
; Created:    2024-09-21 19:34:58
; Input file: drv1551.bin
; Page:       1


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
errCount:  .byte   $00                             ; 904B
errStore:  .byte   $01                             ; 904C
tryCount:  .byte   $00                             ; 904D
borderFlag:  .byte   $00                             ; borderFlag
; ----------------------------------------------------------------------------

; send standard M-E command, this seems to be standard protocol

SendExitTurbo:
		lda     #$81		; GEOS protocol ExitTurbo command?
        jsr     _SendTSBytes                    ; 9051
        ldx     #<(DrvCodeBootEnd-1-DosCMDExe)	; just point to end command marker so no more bytes are sent after OPEN

L9056:  lda #$FF		; ??? $FF as Secondary byte after OPEN ???
		.byte $2c

TCBM_OPEN:				; OPEN and send DosCMDExe+x as filename (with $ff as end of cmd marker)
		lda #$F0		; OPEN
        pha                                     ; 905B
        jsr     TCBM_LISTEN
        pla                                     ; 905F
        jsr     TCBM_SECONDARY
:		lda     DosCMDExe,x						; M-E $0400
        bmi     :+
        jsr     TCBM_SENDBYTE
        inx                                     ; 906B
        bne     :-
:		; fall into UNLISTEN

TCBM_UNLISTEN:
		lda #$3F		; UNLISTEN
		.byte $2c
TCBM_UNTALK:
		lda #$5F		; UNTALK
		.byte $2c
TCBM_LISTEN:
		lda #$20		; LISTEN
		.byte $2c
TCBM_TALK:
		lda #$40		; TALK
        pha                                     ; 9079
        lda     #$81    ; command byte
        bne     TCBM_Send
TCBM_SECONDARY:			; send secondary addr ($60 == SECOND after LISTEN and after TALK)
		pha
        lda     #$82    ; second byte
        bne     TCBM_Send
TCBM_SENDBYTE:
		pha
        lda     #$83    ; computer sends data byte
TCBM_Send:
		stx curDevice
        jsr GetTCBMPortOffs
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
        ldx curDevice
		pla
		rts

; ----------------------------------------------------------------------------
; 97F8/F9 - filled in by booter with offset to TCBM drive port $30 (#8) or $00 (#9)
GetTCBMPortOffs:
	pha                                     ; 90AC
	ldx curDrive
	lda TCBMPortOffs-8,x
	tax
	pla
	rts

; ----------------------------------------------------------------------------
__ChangeDiskDevice:
        and     #$09                            ; 90B6
        pha                                     ; 90B8
        jsr     __EnterTurbo                    ; 90B9
	bnex :+
        pla                                     ; 90BF
        pha                                     ; 90C0
        sta     r1                              ; 90C1
        lda     #$80                            ; 90C3 ; GEOS protocol ChangeDiskDevice command?
        jsr     _SendTSBytes                    ; 90C5
	jsr PurTur0
	pla
	tax
	lda #%11000000
	sta _turboFlags,x
	stx curDrive
	stx curDeviceP4
	ldx #0
	rts
:	pla
	rts

; ----------------------------------------------------------------------------
__ExitTurbo:
	txa
	pha
	ldx curDrive
	lda _turboFlags,x
	and #%01000000
	beq :+
	jsr SendExitTurbo
	ldx curDrive
	lda _turboFlags,x
	and #%10111111
	sta _turboFlags,x
:	pla
	tax
	rts

; ----------------------------------------------------------------------------
__PurgeTurbo:
	jsr	__ExitTurbo
PurTur0:
	ldy curDrive
	lda #0
	sta _turboFlags,y
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
__EnterTurbo:
	lda curDrive
	jsr SetDevice
	ldx curDrive
	lda _turboFlags,x
	bmi EntTur0
        jsr     DoRAMOp                         ; 927C	; ROM farjmp?
	.word $eda9 	; $EDA9 = ROM check for TCBM device at X (8 or 9)
        bcs     L92A0                           ; 9281
        ldx     #<(DrvCodeBoot+1-DosCMDExe)		; DrvCodeBoot command but without initial '&'?
        jsr     TCBM_OPEN                           ; 9285
	LoadB STATUS, 0
        jsr     TCBM_TALK
        lda     #$60                            ; SECOND
        jsr     TCBM_SECONDARY                           ; 9291
        jsr     DoRAMOp                         ; 9294	; ROM farjmp?
	.word $ec96		; $EC96 = ROM ???
        jsr     TCBM_UNTALK
        ldx     STATUS                          ; 929C
        beq     L92A3                           ; 929E
L92A0:  ldx     #DEV_NOT_FOUND
        rts                                     ; 92A2

L92A3:  ldx     #<(DrvCodeBoot-DosCMDExe)		; this calls DrvCodeBoot command
        jsr     L9056                           ; 92A5
	ldx curDrive
	lda #%11000000
	sta _turboFlags,x
EntTur0:
	and #%01000000
	bne EntTur3
        tax                                     ; A=X=0, this calls M-E from DosCMDExe
        jsr     L9056                           ; 92B5	; DoneWithIO
	ldx curDrive
	lda _turboFlags,x
	ora #%01000000
	sta _turboFlags,x
EntTur3:
	ldx #0
	rts

; ----------------------------------------------------------------------------
__NewDisk:
	jsr __EnterTurbo
	bnex NewDsk2
	sta errCount
NewDsk0:
	lda #$82						; ; GEOS protocol NewDisk command?
        jsr     _SendTSBytes
        jsr     _CheckErrors
	beq NewDsk2
	inc errCount
	cpy errCount
	beq	NewDsk2
	bcs	NewDsk0
NewDsk2:
	rts

; ----------------------------------------------------------------------------
__GetDirHead:
	jsr SetDirHead
	bne __GetBlock
_ReadBuff:
	LoadW r4, diskBlkBuf
__GetBlock:
	jsr __EnterTurbo
	bnex GetBlk0
__ReadBlock:
	jsr CheckParams_1
	bcc GetBlk0
RdBlock0:
	lda #$83					; ; GEOS protocol ReadBlock command?
        jsr     _SendTSBytes                    ; 92FE
        lda     #$84            ; ; GEOS protocol ReadBlock command?
        jsr     _SendTSBytes                    ; 9303
	MoveW r4, z8b
        jsr     Hst_RecvByte                           ; 930E	; XXX Hst_RecvByte?
        ldx     #$00                            ; 9311
        cpy     #$01                            ; 9313
	bne RdBlock1
        dey                                     ; 9317
        lda     (r4),y                          ; 9318
        jsr     L93D4                           ; 931A	; XXX GetDError?
	inc errCount
	cpy errCount
	beq RdBlock1
	bcs RdBlock0
RdBlock1:
	txa
GetBlk0:
	rts

; ----------------------------------------------------------------------------
_SendTSBytes:
		; send t&s from r1
        ldy     r1H                             ; 9329
        sty     L96D0+1                         ; 932B
        ldy     r1                              ; 932E
        sty     L96D0                           ; 9330
	ldy #>L96D0
	sty z8b+1
	ldy #<L96D0
	sty z8b	
        ldy     #$02                            ; 933B
        jsr     GetTCBMPortOffs                           ; 933D
        sta     TriportA,x                      ; 9340
:		lda     TriportC,x
		bmi		:-
        lda     #$00                            ; 9348
        sta     TriportA,x                      ; 934A

Hst_SendBytes:									; send Y bytes from (z8b) in reversed order
		tya
        pha                                     ; 934E
        ldy     #$00                            ; 934F
        jsr     Hst_SendByte
        pla                                     ; 9354
        tay                                     ; 9355
Hst_SendByteLoop:
		dey
		lda     (z8b),y
Hst_SendByte:
		pha
:		lda     TriportC,x
		bmi		:-
        pla                                     ; 935F
        sta     TriportA,x                      ; 9360
        lsr     TriportC,x                      ; copy DAV bit to ACK
:		lda     TriportC,x
		bpl		:-
        lda     #$00                            ; 936B
        sta     TriportA,x                      ; 936D
        lsr     TriportC,x                      ; copy DAV bit to ACK
        tya                                     ; 9373
        bne     Hst_SendByteLoop
        rts                                     ; 9376

; ----------------------------------------------------------------------------
Hst_RecvByte:
:		lda     TriportC,x
		bmi		:-
        lda     #$00                            ; 937C
        sta     TriportDDRA,x                   ; 937E
        ldy     #$01                            ; 9381
        jsr     Hst_RecvBytes                   ; 9383
        tya                                     ; 9386
        pha                                     ; 9387
        jsr     Hst_RecvBytes                   ; 9388
        lda     #$FF                            ; 938B
        sta     TriportDDRA,x                   ; 938D
        lsr     TriportC,x                      ; copy DAV bit to ACK
:		lda     TriportC,x
		bpl		:-
        lda     #$00                            ; 9398
        sta     TriportA,x                      ; 939A
        lsr     TriportC,x                      ; copy DAV bit to ACK
        pla                                     ; 93A0
        tay                                     ; 93A1
        rts                                     ; 93A2

; ----------------------------------------------------------------------------
Hst_RecvBytes:
		dey                                     ; 93A3
        lsr     TriportC,x                      ; 93A4
:		lda     TriportC,x
		bpl		:-
        lda     TriportA,x                      ; 93AC
        pha                                     ; 93AF
        lsr     TriportC,x                      ; copy DAV bit to ACK
:		lda     TriportC,x
		bmi		:-
        pla                                     ; 93B8
        sta     (z8b),y                         ; 93B9
        cpy     #$00                            ; 93BB
        bne     Hst_RecvBytes                   ; 93BD
        tay                                     ; 93BF
        rts                                     ; 93C0

; ----------------------------------------------------------------------------
_CheckErrors:
        lda     #$85                            ; ; GEOS protocol ReadStatus command?
        jsr     _SendTSBytes                    ; 93C3
	LoadW z8b, errStore
        jsr     Hst_RecvByte                           ; 93CE	; Hst_RecvByte?
	lda errStore
L93D4:
	pha
	tay
	lda DOSErrTab-1,y
	tay
	pla
	cmp #1
	beq GetDErr1
	addv $1e
	bne GetDErr2
GetDErr1:
	lda #0
GetDErr2:
	tax
	rts

DOSErrTab:
	.byte $01, $05, $02, $08
	.byte $08, $01, $05, $01
	.byte $05, $05, $05

; ----------------------------------------------------------------------------
__OpenDisk:
	ldy curDrive
	lda _driveType,y
	sta tmpDriveType
	and #%10111111
	sta _driveType,y
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
	ldy curDrive
	lda tmpDriveType
	sta _driveType,y
	rts

tmpDriveType:
	.byte $01	; 1541 or 1551, who cares

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
	jsr __PutDirHead
SetGDisk2:
	rts

; ----------------------------------------------------------------------------
__PutDirHead:
	jsr SetDirHead
	bne __PutBlock
_WriteBuff:
	LoadW r4, diskBlkBuf
__PutBlock:
	jsr __EnterTurbo
	bnex SetGDisk2
	jsr __WriteBlock
	bnex SetGDisk2
	jmp __VerWriteBlock

; ----------------------------------------------------------------------------
CheckParams_1:
	LoadB errCount, 0
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
__WriteBlock:
	jsr CheckParams_1
	bcc :++
:
	lda #$86							; ; GEOS protocol WriteBlock command
	jsr _SendTSBytes
	MoveW r4, z8b
	ldy #0
	jsr Hst_SendBytes                           ; 968A ; XXX Hst_SendByte
	jsr _CheckErrors
	beq :+
	inc errCount
	cpy errCount
	beq :+
	bcs :-
:	rts

; ----------------------------------------------------------------------------
__VerWriteBlock:
	jsr CheckParams_1
	bcc @end
:
	LoadB tryCount, 3
:
	lda #$83							; ; GEOS protocol command
	jsr _SendTSBytes
	jsr  _CheckErrors
	beqx :+
	dec tryCount
	bne :-
	ldx #$25
	inc errCount
	CmpBI errCount, 5
	beq :+
	pha
	jsr __WriteBlock
	PopB errCount
	beqx :--
:	txa
@end:
	rts

; ----------------------------------------------------------------------------

	; temporary buffer for r1 (t&s) for GEOS protocol
L96D0:
	.byte $12	; track
	.byte 0		; sector

; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------

; part of GEOS Kernal follows

; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------

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
;.assert * = $9762, error, "FlaggedPutBlock must be at $9762"
; FlaggedPutBlock = files1a2b.s

FlaggedPutBlock:
	lda verifyFlag
	beq @1
	jmp __VerWriteBlock
@1:	jmp __WriteBlock

; ----------------------------------------------------------------------------
;.assert * = $976D, error, "_WriteFile must be at $976D"
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

;.assert * = $97A3, error, "DoWriteFile must be at $97A3"
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
TCBMPortOffs:
        .byte   $30,$00
; ----------------------------------------------------------------------------
.assert * = $97FA, error, "_WriteFile / _ReadFile vectors must be at $97FA"
		.word _WriteFile
		.word _ReadFile
; ----------------------------------------------------------------------------
.assert * = $97FE, error, "Serial number must be at $97FE"
		.word $3e12
; ----------------------------------------------------------------------------
        .byte   $F0                             ; 9800

; can't use anything above $9800-$9d80
