; da65 V2.19 - Git dcdf7ade0
; Created:    2024-11-28 23:41:47
; Input file: boot0.bin
; Page:       1


        .setcpu "6502"

L17A7           := $17A7
L213F           := $213F
LEC8B           := $EC8B
LEF3B           := $EF3B
LF211           := $F211
LF2CE           := $F2CE
        adc     $02
L0265:  lda     #$17
        sta     $9E
        lda     #$A7
        sta     $9D
        ldy     #$FF
        sty     $FD16
        iny
        sty     $6AD8
        sty     $FF06
L0279:  jsr     LEC8B
        sta     ($9D),y
        iny
        bne     L0283
        inc     $9E
L0283:  bit     $90
        bvc     L0279
        jsr     LEF3B
        jsr     LF211
        jsr     LF2CE
        ldx     #$36
L0292:  lda     L02C3,x
        sta     $FF40,x
        dex
        bpl     L0292
        lda     #$DF
        sta     $FD16
        ldx     #$44
        stx     $FD15
        stx     $4000
        lda     #$45
        sta     $FD15
        sta     $4000
        stx     $FD15
        cpx     $4000
        nop
        nop
        jsr     L213F
        lda     #$FF
        sta     $FD16
        jmp     L17A7

L02C3:  ldy     #$0F
L02C5:  lda     $0211,y
        cmp     #$E5
        bne     L02DA
        lda     $0210,y
        cmp     #$F9
        bne     L02DA
        lda     $020F,y
        cmp     #$C5
        beq     L02E6
L02DA:  dey
        bpl     L02C5
        nop
        nop
        txa
        asl     a
        tay
        rts

        nop
        nop
        nop
L02E6:  ldy     #$00
        sty     $842A
        sty     $842B
        sty     $842C
        sty     $842D
        pla
        pla
        txa
        asl     a
        tay
        rts

        brk
        brk
        brk
        brk
        brk
        brk
        stx     $86
        .byte   $12
        .byte   $87
        lsr     $89,x
        ror     $D68B
        .byte   $8B
        .byte   $17
        sty     $6A,x
        .byte   $89
        dey
        .byte   $8B
        .byte   $8B
        sty     $CE42
        asl     $4CCE
        .byte   $F4
        .byte   $53
        .byte   $EF
        eor     $18EE,x
        sbc     $ED60
        .byte   $0C
        .byte   $EF
        inx
        .byte   $EB
        .byte   $4B
        cpx     L0265
