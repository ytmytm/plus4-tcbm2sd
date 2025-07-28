; da65 V2.19 - Git dcdf7ade0
; Created:    2025-07-27 12:19:22
; Input file: boot0.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
L1800           := $1800
LEC8B           := $EC8B
LEF3B           := $EF3B
LF211           := $F211
; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0265
        sty     $9D                             ; 0267
        lda     #$18                            ; 0269
        sta     $9E                             ; 026B
L026D:  jsr     LEC8B                           ; 026D
        sta     ($9D),y                         ; 0270
        inc     $9D                             ; 0272
        bne     L0278                           ; 0274
        inc     $9E                             ; 0276
L0278:  bit     $90                             ; 0278
        bvc     L026D                           ; 027A
        jsr     LEF3B                           ; 027C
        jsr     LF211                           ; 027F
        lda     #$F2                            ; 0282
        sta     L0327                           ; 0284
        lda     #$0B                            ; 0287
        sta     $FF06                           ; 0289
        jmp     L1800                           ; 028C

; ----------------------------------------------------------------------------
        brk                                     ; 028F
        brk                                     ; 0290
        brk                                     ; 0291
        brk                                     ; 0292
        brk                                     ; 0293
        brk                                     ; 0294
        brk                                     ; 0295
        brk                                     ; 0296
        brk                                     ; 0297
        brk                                     ; 0298
        brk                                     ; 0299
        brk                                     ; 029A
        brk                                     ; 029B
        brk                                     ; 029C
        brk                                     ; 029D
        brk                                     ; 029E
        brk                                     ; 029F
        brk                                     ; 02A0
        brk                                     ; 02A1
        brk                                     ; 02A2
        brk                                     ; 02A3
        brk                                     ; 02A4
        brk                                     ; 02A5
        brk                                     ; 02A6
        brk                                     ; 02A7
        brk                                     ; 02A8
        brk                                     ; 02A9
        brk                                     ; 02AA
        brk                                     ; 02AB
        brk                                     ; 02AC
        brk                                     ; 02AD
        brk                                     ; 02AE
        brk                                     ; 02AF
        brk                                     ; 02B0
        brk                                     ; 02B1
        brk                                     ; 02B2
        brk                                     ; 02B3
        brk                                     ; 02B4
        brk                                     ; 02B5
        brk                                     ; 02B6
        brk                                     ; 02B7
        brk                                     ; 02B8
        brk                                     ; 02B9
        brk                                     ; 02BA
        brk                                     ; 02BB
        brk                                     ; 02BC
        brk                                     ; 02BD
        brk                                     ; 02BE
        brk                                     ; 02BF
        brk                                     ; 02C0
        brk                                     ; 02C1
        brk                                     ; 02C2
        brk                                     ; 02C3
        brk                                     ; 02C4
        brk                                     ; 02C5
        brk                                     ; 02C6
        brk                                     ; 02C7
        brk                                     ; 02C8
        brk                                     ; 02C9
        brk                                     ; 02CA
        brk                                     ; 02CB
        brk                                     ; 02CC
        brk                                     ; 02CD
        brk                                     ; 02CE
        brk                                     ; 02CF
        brk                                     ; 02D0
        brk                                     ; 02D1
        brk                                     ; 02D2
        brk                                     ; 02D3
        brk                                     ; 02D4
        brk                                     ; 02D5
        brk                                     ; 02D6
        brk                                     ; 02D7
        brk                                     ; 02D8
        brk                                     ; 02D9
        brk                                     ; 02DA
        brk                                     ; 02DB
        brk                                     ; 02DC
        brk                                     ; 02DD
        brk                                     ; 02DE
        brk                                     ; 02DF
        brk                                     ; 02E0
        brk                                     ; 02E1
        brk                                     ; 02E2
        brk                                     ; 02E3
        brk                                     ; 02E4
        brk                                     ; 02E5
        brk                                     ; 02E6
        brk                                     ; 02E7
        brk                                     ; 02E8
        brk                                     ; 02E9
        brk                                     ; 02EA
        brk                                     ; 02EB
        brk                                     ; 02EC
        brk                                     ; 02ED
        brk                                     ; 02EE
        brk                                     ; 02EF
        brk                                     ; 02F0
        brk                                     ; 02F1
        brk                                     ; 02F2
        brk                                     ; 02F3
        brk                                     ; 02F4
        brk                                     ; 02F5
        brk                                     ; 02F6
        brk                                     ; 02F7
        brk                                     ; 02F8
        brk                                     ; 02F9
        brk                                     ; 02FA
        brk                                     ; 02FB
        brk                                     ; 02FC
        brk                                     ; 02FD
        brk                                     ; 02FE
        brk                                     ; 02FF
        stx     $86                             ; 0300
        .byte   $12                             ; 0302
        .byte   $87                             ; 0303
        lsr     $89,x                           ; 0304
        ror     $D68B                           ; 0306
        .byte   $8B                             ; 0309
        .byte   $17                             ; 030A
        sty     $6A,x                           ; 030B
        .byte   $89                             ; 030D
        dey                                     ; 030E
        .byte   $8B                             ; 030F
        .byte   $8B                             ; 0310
        sty     $CE42                           ; 0311
        asl     $4CCE                           ; 0314
        .byte   $F4                             ; 0317
        .byte   $53                             ; 0318
        .byte   $EF                             ; 0319
        eor     $18EE,x                         ; 031A
        sbc     $ED60                           ; 031D
        .byte   $0C                             ; 0320
        .byte   $EF                             ; 0321
        inx                                     ; 0322
        .byte   $EB                             ; 0323
        .byte   $4B                             ; 0324
        .byte   $EC                             ; 0325
        .byte   $65                             ; 0326
L0327:  .byte   $02                             ; 0327
