; da65 V2.19 - Git dcdf7ade0
; Created:    2025-07-26 22:10:20
; Input file: boot1.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
LC000           := $C000
LEDA9           := $EDA9
LFFBA           := $FFBA
LFFBD           := $FFBD
LFFC0           := $FFC0
LFFE7           := $FFE7
; ----------------------------------------------------------------------------
        sei                                     ; 1800
        cld                                     ; 1801
        ldx     #$FF                            ; 1802
        txs                                     ; 1804
        lda     #$08                            ; 1805
        sta     $AE                             ; 1807
        sta     $FF06                           ; 1809
; Detect IEC (C=1) or TCBM (C=0)
L180C:  jsr     LEDA9                           ; 180C
        bcs     L1834                           ; 180F
        lda     #$4C                            ; 1811
        sta     L1865                           ; 1813
        ldx     #$1B                            ; 1816
; Patch loader (to C000) for TCBM comm instead of serial (C300 and 5600)
L1818:  lda     L18BB,x                         ; 1818
        sta     $1C17,x                         ; 181B
        lda     L18D1,x                         ; 181E
        sta     $1C51,x                         ; 1821
        dex                                     ; 1824
        bpl     L1818                           ; 1825
; Drive code at (18,2 - IEC) or (18,8 - TCBM)
L1827:  lda     #$38                            ; 1827
        sta     L18F8                           ; 1829
        lda     #$24                            ; 182C
        sta     $1C98                           ; 182E
        sta     $1CEB                           ; 1831
L1834:  jsr     L185B                           ; 1834
        sei                                     ; 1837
        ldx     #$00                            ; 1838
L183A:  lda     $18FB,x                         ; 183A
        sta     LC000,x                         ; 183D
        lda     $19FB,x                         ; 1840
        sta     $C100,x                         ; 1843
        lda     $1AFB,x                         ; 1846
        sta     $C200,x                         ; 1849
        lda     $1BFB,x                         ; 184C
        sta     $C300,x                         ; 184F
        dex                                     ; 1852
        bne     L183A                           ; 1853
        sta     $FF3F                           ; 1855
        jmp     LC000                           ; 1858

; ----------------------------------------------------------------------------
L185B:  jsr     LFFE7                           ; 185B
        jsr     L18A7                           ; 185E
        jsr     L189A                           ; 1861
        sei                                     ; 1864
L1865:  bit     L1874                           ; 1865
        lda     #$49                            ; 1868
        sta     $01                             ; 186A
L186C:  bit     $01                             ; 186C
        bvs     L186C                           ; 186E
        lda     #$C8                            ; 1870
        sta     $01                             ; 1872
L1874:  ldx     #$14                            ; 1874
L1876:  cpx     $FF1D                           ; 1876
        bne     L1876                           ; 1879
        dex                                     ; 187B
        bne     L1876                           ; 187C
        ldx     #$00                            ; 187E
L1880:  lda     $1C17,x                         ; 1880
        sta     $5600,x                         ; 1883
        lda     $1D17,x                         ; 1886
        sta     $5700,x                         ; 1889
        inx                                     ; 188C
        bne     L1880                           ; 188D
        lda     #$47                            ; 188F
        sta     $FFFE                           ; 1891
        lda     #$57                            ; 1894
        sta     $FFFF                           ; 1896
        rts                                     ; 1899

; ----------------------------------------------------------------------------
L189A:  ldx     #$ED                            ; 189A
        ldy     #$18                            ; 189C
        lda     #$0C                            ; 189E
        jsr     LFFBD                           ; 18A0
        lda     #$0F                            ; 18A3
        bne     L18B2                           ; 18A5
L18A7:  lda     #$02                            ; 18A7
        ldx     #$F9                            ; 18A9
        ldy     #$18                            ; 18AB
        jsr     LFFBD                           ; 18AD
        lda     #$02                            ; 18B0
L18B2:  tay                                     ; 18B2
        ldx     #$08                            ; 18B3
        jsr     LFFBA                           ; 18B5
        jmp     LFFC0                           ; 18B8

; ----------------------------------------------------------------------------
L18BB:  sta     $FEE0                           ; 18BB
L18BE:  bit     $FEE2                           ; 18BE
        bmi     L18BE                           ; 18C1
        asl     $FEE2                           ; 18C3
L18C6:  bit     $FEE2                           ; 18C6
        bpl     L18C6                           ; 18C9
        lda     #$40                            ; 18CB
        sta     $FEE2                           ; 18CD
        rts                                     ; 18D0

; ----------------------------------------------------------------------------
L18D1:  inc     $FEE3                           ; 18D1
L18D4:  bit     $FEE2                           ; 18D4
        bmi     L18D4                           ; 18D7
        asl     $FEE2                           ; 18D9
        lda     $FEE0                           ; 18DC
L18DF:  bit     $FEE2                           ; 18DF
        bpl     L18DF                           ; 18E2
        ldy     #$40                            ; 18E4
        sty     $FEE2                           ; 18E6
        dec     $FEE3                           ; 18E9
        rts                                     ; 18EC

; ----------------------------------------------------------------------------
; Block-Execute command
L18ED:  .byte   "B-E 2 0 18 "                   ; 18ED
                                                ; 18F5
L18F8:  .byte   "2"                             ; 18F8
L18F9:  .byte   "#0"                            ; 18F9
