; da65 V2.19 - Git dcdf7ade0
; Created:    2024-11-28 23:41:47
; Input file: boot2.bin
; Page:       1


        .setcpu "6502"

DriveOp         := $0042                        ; operation code, 1=read, 2=write, 3=get status byte
BufferVec       := $0044                        ; buffer vector
BufferVecHi     := $0045
L0134           := $0134
L06D0           := $06D0
L6A70           := $6A70
L8000           := $8000
L8AE6           := $8AE6
SectorBuffer    := $BF00                        ; general disk buffer
LCC07           := $CC07
IECBitTable:
        .byte   $FF
LC801:  .byte   $FF
LC802:  .byte   $FF
LC803:  .byte   $FF,$FF,$FF,$FF,$FF,$A0,$50,$0A
        .byte   $05,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$A0,$50,$0A
        .byte   $05,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$20,$10,$02
        .byte   $01,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$20,$10,$02
        .byte   $01,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$80,$40,$08
        .byte   $04,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$80,$40,$08
        .byte   $04,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00
        .byte   $00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00
        .byte   $00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF
SendByte:
        tay
        and     #$03
        ora     #$08
        pha
        tya
        lsr     a
        lsr     a
        tay
        and     #$03
        ora     #$08
        pha
        tya
        lsr     a
        lsr     a
        tay
        and     #$03
        pha
        lda     #$0C
        sta     $01
LC91A:  lda     $01
        bpl     LC91A
        sei
LC91F:  lda     $FF1D
        cmp     #$C8
        bcs     LC930
        and     #$07
        cmp     #$08
        bcs     LC930
        cmp     #$05
        bcs     LC91F
LC930:  lda     #$D6
        sta     $FF13
        lda     #$08
        sta     $01
        tya
        lsr     a
        lsr     a
        ora     #$08
        sta     a:$01
        pla
        sta     $01
        ora     #$08
        pla
        sta     $01
        pla
        sta     $01
        ldy     #$00
        lda     #$D4
        sta     $FF13
        lda     #$08
        sta     $01
        cli
        rts

GetByte:lda     #$D6
        sta     $FF13
        lda     #$0C
        sta     $01
LC962:  lda     $01
        bpl     LC962
        sei
        ldy     #$08
LC969:  lda     $FF1D
        cmp     #$C8
        bcs     LC974
        and     #$02
        bne     LC969
LC974:  sty     $01
        .byte   $1A
        .byte   $1A
        pha
        pla
        ldy     $01
        lda     LC803,y
        .byte   $1A
        ldy     $01
        ora     LC802,y
        .byte   $1A
        ldy     $01
        ora     LC801,y
        .byte   $1A
        .byte   $1A
        ldy     $01
        ora     IECBitTable,y
        ldy     #$D4
        sty     $FF13
        tay
        cli
        rts

BlockNumTmp:
        .byte   $00
BlockNumTmpHi:
        .byte   $00
; Do operation from DriveOp with block number already converted to track and sector. This must be at C99C
DoSectorOp:
        lda     DriveOp
        jsr     SendByte
        lda     BlockNumTmp
        jsr     SendByte
        lda     BlockNumTmpHi
        jsr     SendByte
        lda     BufferVec
        sta     LC9CA
        sta     LC9DA
        lda     BufferVecHi
        sta     LC9CB
        sta     LC9DB
        lda     DriveOp
        cmp     #$03
        beq     DoGetStatus
        cmp     #$02
        bne     DoGetSector
; Write buffer to disk
DoPutSector:
        ldx     #$00
LC9C9:  .byte   $BD
LC9CA:  brk
LC9CB:  tsx
        jsr     SendByte
        inx
        bne     LC9C9
        beq     DoGetStatus
; Read disk sector into buffer
DoGetSector:
        ldx     #$00
LC9D6:  jsr     GetByte
        .byte   $9D
LC9DA:  brk
LC9DB:  tsx
        inx
        bne     LC9D6
; Get operation status from drive
DoGetStatus:
        jsr     GetByte
        cmp     #$01
        rts

        clc
        jsr     LC9FA
        jsr     LCB61
        bcs     LC9F9
        sec
        jsr     LC9FA
        inc     BufferVecHi
        jsr     LCB61
        dec     BufferVecHi
LC9F9:  rts

LC9FA:  lda     $46
        rol     a
        sta     BlockNumTmpHi
        sta     LCA41
        lda     $47
        rol     a
        sta     BlockNumTmp
        sta     LCA42
        ldx     #$00
LCA0E:  sec
        lda     BlockNumTmpHi
        sbc     TrackSizeTab,x
        tay
        lda     BlockNumTmp
        sbc     #$00
        bcc     LCA26
        inx
        sta     BlockNumTmp
        sty     BlockNumTmpHi
        bcs     LCA0E
LCA26:  inx
        cpx     #$12
        bcc     LCA2C
        inx
LCA2C:  stx     BlockNumTmp
        jmp     ConvertBlockTmp

        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
LCA41:  brk
LCA42:  brk
; TrackLengths
TrackSizeTab:
        .byte   $15,$15,$15,$15,$15,$15,$15,$15
        .byte   $15,$15,$15,$15,$15,$15,$15,$15
        .byte   $15,$13,$13,$13,$13,$13,$13,$12
        .byte   $12,$12,$12,$12,$12,$11,$11,$11
        .byte   $11,$11
; Convert from block number to track and sector
ConvertBlockTmp:
        lda     BlockNumTmp
        ldx     #$04
LCA6A:  cmp     LCA88,x
        dex
        bcs     LCA6A
        txa
        asl     a
        tax
        lda     TrackInterleaveSectorNumber,x
        sta     LCA83
        lda     TrackInterleaveSectorNumber+1,x
        sta     LCA84
        ldy     BlockNumTmpHi
        .byte   $B9
LCA83:  .byte   $95
LCA84:  dex
        sta     BlockNumTmpHi
LCA88:  rts

TrackSpeedZones:
        .byte   $24,$1F,$19,$12
TrackInterleaveSectorNumber:
        .word   $CACF,$CABD,$CAAA,$CA95
LCA95:  .byte   $00,$0B,$01,$0C,$02,$0D,$03,$0E
        .byte   $04,$0F,$05,$10,$06,$11,$07,$12
        .byte   $08,$13,$09,$14,$0A
LCAAA:  .byte   $00,$0B,$03,$0E,$06,$11,$09,$01
        .byte   $0C,$04,$0F,$07,$12,$0A,$02,$0D
        .byte   $05,$10,$08
LCABD:  .byte   $00,$0B,$04,$0F,$08,$01,$0C,$05
        .byte   $10,$09,$02,$0D,$06,$11,$0A,$03
        .byte   $0E,$07
LCACF:  .byte   $00,$0B,$05,$10,$0A,$04,$0F,$09
        .byte   $03,$0E,$08,$02,$0D,$07,$01,$0C
        .byte   $06
LCAE0:  .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$02,$01,$01,$05,$0E,$01
LCAF0:  .byte   $00
        .byte   $07
        .byte   $03
        .byte   $04
        .byte   $03
        .byte   $04
        ora     ($06,x)
        .byte   $03
        brk
        .byte   $04
        .byte   $03
        ora     $06
        .byte   $04
        ora     ($48,x)
        and     #$0F
        tax
        lda     LCAE0,x
        sta     BlockNumTmp
        pla
        pha
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        tax
        lda     LCAE0,x
        asl     a
        asl     a
        asl     a
        asl     a
        ora     BlockNumTmp
        ldx     #$03
LCB1D:  sta     $C428,x
        sta     $C450,x
        sta     $C478,x
        sta     $C4A0,x
        sta     $C4C8,x
        sta     $C4F0,x
        sta     $C518,x
        sta     $C540,x
        sta     $C568,x
        sta     $C590,x
        sta     $C5B8,x
        inx
        cpx     #$0E
        bcc     LCB1D
        pla
        pha
        and     #$0F
        tax
        lda     LCAF0,x
        asl     a
        asl     a
        asl     a
        asl     a
        sta     BlockNumTmp
        pla
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        tax
        lda     LCAF0,x
        ora     BlockNumTmp
        jmp     L8AE6

LCB61:  lda     #$D4
        sta     $FF13
        jsr     DoSectorOp
        php
        pha
        lda     #$D6
        sta     $FF13
        pla
        plp
        rts

        ldx     #$A6
        .byte   $8E
        .byte   $20
LCB77:  .byte   $FF
LCB78:  lda     $1F89,x
        sta     a:$FF,x
        dex
        bne     LCB78
        lda     #$20
        sta     $2139
        sta     $1AE6
        rts

        ldx     DriveOp
        dex
        bne     LCBA8
        lda     BufferVecHi
        cmp     #$CC
        bne     LCBAB
        sec
        lda     BlockNumTmpHi
        sbc     #$02
        ora     #$F0
        sta     LCA41
        lda     #$02
        sta     LCA42
        bne     LCBAB
        nop
LCBA8:  jmp     DoSectorOp

LCBAB:  lda     $6AD8
        pha
        jsr     L0134
        pla
        jsr     L8000
        jsr     L0134
        dex
        stx     $FD16
        rts

        lda     #$DF
        sta     $FD16
        lda     #$4F
        sta     $FD15
        ldx     #$00
LCBCA:  lda     $7800,x
        ldy     L8000,x
        sta     L8000,x
        tya
        sta     $7800,x
        dex
        bne     LCBCA
        rts

        lda     #$DF
        sta     $FD16
        lda     #$4F
        sta     $FD15
        lda     #$00
        sta     $7D00
        sta     $7D01
        lda     #$FF
        sta     $FD16
        jmp     L6A70

        lda     #$7F
        jsr     L06D0
        and     #$04
        bne     LCC07
        lda     #$DF
