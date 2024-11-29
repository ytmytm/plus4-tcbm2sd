; da65 V2.19 - Git dcdf7ade0
; Created:    2024-11-28 23:41:47
; Input file: boot1.bin
; Page:       1


        .setcpu "6502"

L0134           := $0134
L065B           := $065B
L0663           := $0663
L06D0           := $06D0
L4000           := $4000
L668D           := $668D
L6A70           := $6A70
L8000           := $8000
L80A5           := $80A5
L9416           := $9416
L9B18           := $9B18
LC99C           := $C99C
LCB61           := $CB61
LCB77           := $CB77
LEDA9           := $EDA9
LFFBA           := $FFBA
LFFBD           := $FFBD
LFFC0           := $FFC0
LFFE7           := $FFE7
        jsr     LFFE7
        ldx     #$2D
        ldy     #$18
        lda     #$02
        jsr     LFFBD
        lda     #$02
        tay
        ldx     #$08
        jsr     LFFBA
        jsr     LFFC0
        jsr     LEDA9
        bcs     L17D7
        dec     L183B
        ldx     #$1F
; Patch loader (to C900) for TCBM comm instead of serial
L17C8:  lda     L17F6,x
        sta     L1D00,x
        lda     L180E,x
        sta     L1D5B,x
        dex
        bpl     L17C8
L17D7:  ldx     #$2F
        ldy     #$18
        lda     #$0D
        jsr     LFFBD
        lda     #$0F
        tay
        ldx     #$08
        jsr     LFFBA
        jsr     LFFC0
        lda     $FEF1
L17EE:  cmp     $FEF1
        beq     L17EE
        jmp     L1A05

L17F6:  sta     $FEF0
        lda     #$00
        sta     $FEF2
L17FE:  bit     $FEF2
        bmi     L17FE
        lda     #$40
        sta     $FEF2
L1808:  bit     $FEF2
        bpl     L1808
        rts

L180E:  lda     #$00
        sta     $FEF3
        sta     $FEF2
L1816:  bit     $FEF2
        bmi     L1816
        ldy     $FEF0
        lda     #$FF
        sta     $FEF2
L1823:  bit     $FEF2
        bpl     L1823
        sta     $FEF3
        tya
        rts

L182D:  .byte   "#1"
L182F:  .byte   "B-E:2 0 1  1"

; Drive code at (1,13 - IEC) or (1,12 - TCBM)
L183B:  .byte   "3"
L183C:  sei
        ldx     #$00
        lda     #$00
        sta     $FF15
        sta     $FF19
L1847:  sta     $B000,x
        sta     $B100,x
        sta     $B200,x
        sta     $B300,x
        inx
        bne     L1847
        stx     $FF0A
        stx     $FF11
        dex
        stx     $FF09
        stx     $FF0C
        stx     $FF0D
        inx
        lda     #$17
        sta     $FF06
        lda     #$08
        sta     $FF07
        lda     #$C4
        sta     $FF12
        lda     #$D6
        sta     $FF13
        lda     #$B0
        sta     $FF14
        cli
        rts

L1882:  jsr     LCB61
        bcs     L1888
        rts

L1888:  inc     $FF19
        jmp     L1888

L188E:  stx     $30
        sty     $31
        lda     #$01
        sta     $C99A
        lda     #$02
        sta     $C99B
        lda     #$01
        sta     $42
        lda     #$00
        sta     $44
        lda     #$BF
        sta     $45
L18A8:  jsr     L1882
        ldx     #$00
L18AD:  txa
        asl     a
        asl     a
        asl     a
        asl     a
        asl     a
        clc
        adc     #$05
        sta     $32
        lda     #$BF
        sta     $33
        ldy     #$00
L18BE:  lda     ($30),y
        cmp     ($32),y
        bne     L18CB
        iny
        cpy     #$10
        bne     L18BE
        beq     L18DD
L18CB:  inx
        cpx     #$08
        bne     L18AD
        lda     $BF01
        cmp     #$FF
        beq     L1888
        sta     $C99B
        jmp     L18A8

L18DD:  dec     $32
        dec     $32
        ldy     #$00
        lda     ($32),y
        sta     $C99A
        iny
        lda     ($32),y
        sta     $C99B
        lda     #$00
        sta     $30
L18F2:  jsr     L1882
        lda     $30
        bne     L1903
        lda     $BF02
        sta     $32
        lda     $BF03
        sta     $33
L1903:  ldx     #$00
        lda     $BF00
        bne     L190E
        ldx     $BF01
        inx
L190E:  stx     $31
        ldx     #$02
        lda     $30
        bne     L1918
        ldx     #$04
L1918:  ldy     #$00
L191A:  lda     $BF00,x
        sta     ($32),y
        iny
        inx
        cpx     $31
        bne     L191A
        tya
        clc
        adc     $32
        sta     $32
        bcc     L192F
        inc     $33
L192F:  lda     #$01
        sta     $30
        lda     $BF00
        beq     L1944
        sta     $C99A
        lda     $BF01
        sta     $C99B
        jmp     L18F2

L1944:  rts

L1945:  .byte   "MAINPIC"
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0
L1955:  .byte   "SPLASH"
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0
L1965:  .byte   "DMUSIC"
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0
L1975:  .byte   "UTIL"
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0,$A0
L1985:  .byte   "SUBS1"
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0
L1995:  .byte   "SUBS2"
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0
L19A5:  .byte   "SUBS3"
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0
L19B5:  .byte   "BARD3.PIC"

        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0
L19C5:  .byte   "BARD3.COL"

        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0
L19D5:  .byte   "MUSIC"
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0
L19E5:  .byte   "I/O"
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .byte   $A0,$A0,$A0,$A0,$A0
L19F5:  .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
L1A05:  sei
        sta     $FF3F
        ldx     #$00
L1A0B:  lda     L1C00,x
        sta     $C800,x
        lda     L1D00,x
        sta     $C900,x
        lda     L1E00,x
        sta     $CA00,x
        lda     L1F00,x
        sta     $CB00,x
        inx
        bne     L1A0B
        jsr     L2139
        ldx     #$65
        ldy     #$19
        jsr     L188E
        jsr     L1B62
L1A33:  ldx     #$45
        ldy     #$19
        jsr     L188E
        ldx     #$55
        ldy     #$19
        jsr     L188E
        jsr     L4000
        pha
        jsr     L1B62
        ldx     #$75
        ldy     #$19
        jsr     L188E
        pla
        jsr     L2000
        php
        jsr     L1B62
        plp
        bcs     L1A33
        ldx     #$85
        ldy     #$19
        jsr     L188E
        ldx     #$95
        ldy     #$19
        jsr     L188E
        ldx     #$A5
        ldy     #$19
        jsr     L188E
        ldx     #$B5
        ldy     #$19
        jsr     L188E
        ldx     #$C5
        ldy     #$19
        jsr     L188E
        jsr     L1BC7
        ldx     #$D5
        ldy     #$19
        jsr     L188E
        ldx     #$E5
        ldy     #$19
        jsr     L188E
        lda     #$37
        sta     $FF06
        lda     #$18
        sta     $FF07
        lda     #$02
        sta     $FF0A
        lda     #$FF
        sta     $FF09
        lda     #$08
        sta     $FF12
        lda     #$C0
        sta     $FF14
        lda     #$00
        sta     $FF15
        sta     $FF19
        lda     #$71
        sta     $FF16
        ldx     #$00
L1ABB:  txa
        lsr     a
        lda     #$FF
        bcs     L1AC3
        lda     #$FE
L1AC3:  sta     L4000,x
        sta     $4100,x
        sta     $4200,x
        cpx     #$FE
        bcs     L1ADB
        lda     #$00
        sta     $02,x
        cpx     #$E0
        bcs     L1ADB
        sta     $0300,x
L1ADB:  inx
        bne     L1ABB
        lda     #$41
L1AE0:  sta     $034E
        dex
        txs
        cld
        bit     L1AEC
        jmp     L0663

L1AEC:  ldx     #$00
        stx     $CB67
        inx
        stx     $CB68
        lda     #$51
        sta     $67CC
        lda     #$01
        sta     $67CD
        rts

        .byte   $AF
        .byte   $DF
        .byte   $0F
        .byte   $37
        .byte   $5F
        .byte   $87
        .byte   $AF
        .byte   $CF
        .byte   $E7
        .byte   $07
        .byte   $23
        .byte   $3F
        .byte   $57
        .byte   $6F
        .byte   $87
        .byte   $9B
        .byte   $AF
        .byte   $C3
        .byte   $D7
        .byte   $E7
        .byte   $F3
        .byte   $03
        ora     ($1F),y
        .byte   $2B
        .byte   $37
        .byte   $43
        eor     $6157
        .byte   $6B
        .byte   $73
        adc     $8881,y
        .byte   $8F
        sta     $9B,x
        lda     ($A6,x)
        .byte   $AB
        bcs     L1AE0
        lda     $C0BD,y
        cpy     $C8
        dex
        brk
        brk
        ora     ($01,x)
        ora     ($01,x)
        ora     ($01,x)
        ora     ($02,x)
        .byte   $02
        .byte   $02
        .byte   $02
        .byte   $02
        .byte   $02
        .byte   $02
        .byte   $02
        .byte   $02
        .byte   $02
        .byte   $02
        .byte   $02
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
L1B62:  ldx     #$00
        lda     #$00
        sta     $FF15
        sta     $FF19
L1B6C:  sta     $B000,x
        sta     $B100,x
        sta     $B200,x
        sta     $B300,x
        inx
        bne     L1B6C
        dex
        stx     $FF0C
        stx     $FF0D
        inx
        lda     #$17
        sta     $FF06
        lda     #$08
        sta     $FF07
        lda     $FF12
        and     #$03
        ora     #$C4
        sta     $FF12
        lda     #$D6
        sta     $FF13
        lda     #$B0
        sta     $FF14
        ldx     #$B2
        ldy     #$1B
        stx     $FFFE
        sty     $FFFF
        lda     #$02
        sta     $FF0A
        cli
        rts

        sei
        pha
        txa
        pha
        tya
        pha
        lda     $FF09
        sta     $FF09
        jsr     LCB77
        pla
        tay
        pla
        tax
        pla
        rti

L1BC7:  sei
L1BC8:  lda     #$02
L1BCA:  bit     $FF09
        beq     L1BCA
        sta     $FF09
L1BD2:  bit     $FF09
        beq     L1BD2
        sta     $FF09
        lda     $FF11
        and     #$0F
        beq     L1BF4
        sec
        sbc     #$01
        sta     L1F6D
        lda     $FF11
        and     #$F0
        ora     #$00
        sta     $FF11
        jmp     L1BC8

L1BF4:  jmp     L183C

        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
L1C00:  .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $A0,$50,$0A,$05,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $A0,$50,$0A,$05,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $20,$10,$02,$01,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $20,$10,$02,$01,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $80,$40,$08,$04,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $80,$40,$08,$04,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $00,$00,$00,$00,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $00,$00,$00,$00,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
L1D00:  .byte   $A8,$29,$03,$09,$08,$48,$98,$4A
        .byte   $4A,$A8,$29,$03,$09,$08,$48,$98
        .byte   $4A,$4A,$A8,$29,$03,$48,$A9,$0C
        .byte   $85,$01,$A5,$01,$10,$FC,$78,$AD
        .byte   $1D,$FF,$C9,$C8,$B0,$0A,$29,$07
        .byte   $C9,$08,$B0,$04,$C9,$05,$B0,$EF
        .byte   $A9,$D6,$8D,$13,$FF,$A9,$08,$85
        .byte   $01,$98,$4A,$4A,$09,$08,$8D,$01
        .byte   $00,$68,$85,$01,$09,$08,$68,$85
        .byte   $01,$68,$85,$01,$A0,$00,$A9,$D4
        .byte   $8D,$13,$FF,$A9,$08,$85,$01,$58
        .byte   $60,$A9,$D6
L1D5B:  .byte   $8D,$13,$FF,$A9,$0C,$85,$01,$A5
        .byte   $01,$10,$FC,$78,$A0,$08,$AD,$1D
        .byte   $FF,$C9,$C8,$B0,$04,$29,$02,$D0
        .byte   $F5,$84,$01,$1A,$1A,$48,$68,$A4
        .byte   $01,$B9,$03,$C8,$1A,$A4,$01,$19
        .byte   $02,$C8,$1A,$A4,$01,$19,$01,$C8
        .byte   $1A,$1A,$A4,$01,$19,$00,$C8,$A0
        .byte   $D4,$8C,$13,$FF,$A8,$58,$60,$00
        .byte   $00,$A5,$42,$20,$00,$C9,$AD,$9A
        .byte   $C9,$20,$00,$C9,$AD,$9B,$C9,$20
        .byte   $00,$C9,$A5,$44,$8D,$CA,$C9,$8D
        .byte   $DA,$C9,$A5,$45,$8D,$CB,$C9,$8D
        .byte   $DB,$C9,$A5,$42,$C9,$03,$F0,$1C
        .byte   $C9,$02,$D0,$0D,$A2,$00,$BD,$00
        .byte   $BA,$20,$00,$C9,$E8,$D0,$F7,$F0
        .byte   $0B,$A2,$00,$20,$59,$C9,$9D,$00
        .byte   $BA,$E8,$D0,$F7,$20,$59,$C9,$C9
        .byte   $01,$60,$18,$20,$FA,$C9,$20,$61
        .byte   $CB,$B0,$0B,$38,$20,$FA,$C9,$E6
        .byte   $45,$20,$61,$CB,$C6,$45,$60,$A5
        .byte   $46,$2A,$8D,$9B,$C9
L1E00:  .byte   $8D,$41,$CA,$A5,$47,$2A,$8D,$9A
        .byte   $C9,$8D,$42,$CA,$A2,$00,$38,$AD
        .byte   $9B,$C9,$FD,$43,$CA,$A8,$AD,$9A
        .byte   $C9,$E9,$00,$90,$09,$E8,$8D,$9A
        .byte   $C9,$8C,$9B,$C9,$B0,$E8,$E8,$E0
        .byte   $12,$90,$01,$E8,$8E,$9A,$C9,$4C
        .byte   $65,$CA,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$15,$15,$15,$15,$15
        .byte   $15,$15,$15,$15,$15,$15,$15,$15
        .byte   $15,$15,$15,$15,$13,$13,$13,$13
        .byte   $13,$13,$12,$12,$12,$12,$12,$12
        .byte   $11,$11,$11,$11,$11,$AD,$9A,$C9
        .byte   $A2,$04,$DD,$88,$CA,$CA,$B0,$FA
        .byte   $8A,$0A,$AA,$BD,$8D,$CA,$8D,$83
        .byte   $CA,$BD,$8E,$CA,$8D,$84,$CA,$AC
        .byte   $9B,$C9,$B9,$95,$CA,$8D,$9B,$C9
        .byte   $60,$24,$1F,$19,$12,$CF,$CA,$BD
        .byte   $CA,$AA,$CA,$95,$CA,$00,$0B,$01
        .byte   $0C,$02,$0D,$03,$0E,$04,$0F,$05
        .byte   $10,$06,$11,$07,$12,$08,$13,$09
        .byte   $14,$0A,$00,$0B,$03,$0E,$06,$11
        .byte   $09,$01,$0C,$04,$0F,$07,$12,$0A
        .byte   $02,$0D,$05,$10,$08,$00,$0B,$04
        .byte   $0F,$08,$01,$0C,$05,$10,$09,$02
        .byte   $0D,$06,$11,$0A,$03,$0E,$07,$00
        .byte   $0B,$05,$10,$0A,$04,$0F,$09,$03
        .byte   $0E,$08,$02,$0D,$07,$01,$0C,$06
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$02,$01,$01,$05,$0E,$01
        .byte   $00,$07,$03,$04,$03,$04,$01,$06
        .byte   $03,$00,$04,$03,$05,$06,$04,$01
L1F00:  .byte   $48,$29,$0F,$AA,$BD,$E0,$CA,$8D
        .byte   $9A,$C9,$68,$48,$4A,$4A,$4A,$4A
        .byte   $AA,$BD,$E0,$CA,$0A,$0A,$0A,$0A
        .byte   $0D,$9A,$C9,$A2,$03,$9D,$28,$C4
        .byte   $9D,$50,$C4,$9D,$78,$C4,$9D,$A0
        .byte   $C4,$9D,$C8,$C4,$9D,$F0,$C4,$9D
        .byte   $18,$C5,$9D,$40,$C5,$9D,$68,$C5
        .byte   $9D,$90,$C5,$9D,$B8,$C5,$E8,$E0
        .byte   $0E,$90,$DA,$68,$48,$29,$0F,$AA
        .byte   $BD,$F0,$CA,$0A,$0A,$0A,$0A,$8D
        .byte   $9A,$C9,$68,$4A,$4A,$4A,$4A,$AA
        .byte   $BD,$F0,$CA,$0D,$9A,$C9,$4C,$E6
        .byte   $8A,$A9,$D4,$8D,$13,$FF,$20,$9C
        .byte   $C9,$08,$48,$A9,$D6
L1F6D:  .byte   $8D,$13,$FF,$68,$28,$60
L1F73:  .byte   $A2,$A6,$8E,$20,$FF,$BD,$89,$1F
        .byte   $9D,$FF,$00,$CA,$D0,$F7,$A9,$20
        .byte   $8D,$39,$21,$8D,$E6,$1A
L1F89:  .byte   $60
        ldx     $42
        dex
        bne     L1FA8
        lda     $45
        cmp     #$CC
        bne     L1FAB
        sec
        lda     $C99B
        sbc     #$02
        ora     #$F0
        sta     $CA41
        lda     #$02
        sta     $CA42
        bne     L1FAB
        nop
L1FA8:  jmp     LC99C

L1FAB:  lda     $6AD8
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
L1FCA:  lda     $7800,x
        ldy     L8000,x
        sta     L8000,x
        tya
        sta     $7800,x
        dex
        bne     L1FCA
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
        bne     L2007
        lda     #$DF
L2000:  jsr     L06D0
        and     #$04
        beq     L2008
L2007:  rts

L2008:  lda     #$0C
        sta     $06
        sta     $35
        jsr     L668D
        lda     #$3E
        sta     $930B
        lda     #$00
        sta     $943C
        jsr     L9416
        bcs     L202D
        lda     #$00
        sta     $06AB
        lda     #$93
        sta     $06AC
        jmp     L065B

L202D:  jmp     L9B18

L2030:  tax
        lda     $02
        pha
        lda     $03
        pha
        cpx     $FF20
        beq     L204E
        stx     $FF20
        ldx     #$00
        txa
L2042:  sta     $7D00,x
        sta     $7E00,x
        sta     $7EF0,x
        dex
        bne     L2042
L204E:  lda     $CA41
        sta     $02
        lda     $CA42
        tax
        clc
        adc     #$7D
        sta     $03
        ldy     #$00
        lda     ($02),y
        php
        lda     #$01
        sta     ($02),y
        inx
        txa
        ldy     $02
        asl     $02
        rol     a
        asl     $02
        rol     a
        ora     #$40
        sta     $02
        tya
        and     #$3F
        ora     #$40
        sta     $8073
        sta     $8085
        plp
        bne     L20A9
        lda     #$FF
        sta     $FD16
        cli
        jsr     LC99C
        sei
        lda     #$DF
        sta     $FD16
        bcs     L20C3
        jsr     L80A5
        ldx     $02
L2097:  lda     #$42
        sta     $FD15
        lda     ($44),y
        stx     $FD15
        sta     $6F00,y
        dey
        bne     L2097
        beq     L20BE
L20A9:  jsr     L80A5
        ldx     #$42
L20AE:  lda     $02
        sta     $FD15
        lda     $6F00,y
        stx     $FD15
        sta     ($44),y
        dey
        bne     L20AE
L20BE:  clc
        lda     $03
        sta     $45
L20C3:  lda     #$FF
        sta     $FD16
        pla
        sta     $03
        pla
        sta     $02
        cli
        bcs     L20D2
        rts

L20D2:  jmp     LC99C

        lda     $45
        sta     $03
        tax
        and     #$3F
        ora     #$40
        sta     $45
        txa
        asl     a
        rol     a
        rol     a
        and     #$03
        ora     #$40
        sta     $8068
        sta     $807D
        ldy     #$00
        rts

L20F1:  lda     #$DF
        sta     $FD16
        lda     #$4F
        sta     $FD15
        lda     #$00
        sta     $44
        lda     #$0A
        sta     $C99B
        lda     #$12
        sta     $C99A
        lda     #$01
        sta     $42
        lda     #$70
        sta     $45
L2111:  jsr     L1882
        inc     $C99B
        inc     $45
        lda     $45
        cmp     #$78
        bne     L2111
        lda     #$01
        ldx     #$07
L2123:  sta     $7FF0,x
        dex
        bpl     L2123
        ldx     #$00
L212B:  lda     L2030,x
        sta     $7800,x
        dex
        bne     L212B
        dex
        stx     $FD16
        rts

L2139:  bit     L20F1
        jmp     L183C

L213F:  bne     L2144
        jmp     L1F73

L2144:  ldx     #$A6
L2146:  lda     L1F89,x
        sta     a:$FF,x
        dex
        bne     L2146
        rts

