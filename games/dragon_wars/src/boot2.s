; da65 V2.19 - Git dcdf7ade0
; Created:    2025-07-27 12:19:22
; Input file: boot2.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
DriveOp         := $00D5                        ; operation code, 1=read, 2=write, 3=get status byte
BufferVec       := $00D6                        ; operation buffer vector
BlockNum        := $00D8                        ; operation block number
L0D00           := $0D00
L0E00           := $0E00
L1000           := $1000
L27D7           := $27D7
L2CDF           := $2CDF
L3706           := $3706
L3C97           := $3C97
L3F51           := $3F51
L3F85           := $3F85
L41E9           := $41E9
Copy_LoaderCode_To_FF20:= $4E39                 ; Copies code from $5600 to $ff20
DoSectorOp      := $5694                        ; Do operation from DriveOp with block number already converted to track and sector. This must be at 5694(?)
ConvertBlockTmp := $56EC                        ; Convert from block number to track and sector
BlockNumTmp     := $5745                        ; ProDOS block number / converted track and sector
L8000           := $8000
BUFCE00         := $CE00                        ; ProDOS buffer 1
BUFCF00         := $CF00                        ; ProDOS buffer 2
LFFFC           := $FFFC
; ----------------------------------------------------------------------------
        ldx     #$71                            ; C000
        ldy     #$C1                            ; C002
        jsr     LC18B                           ; C004
        bcc     LC015                           ; C007
LC009:  lda     #$00                            ; C009
        sta     $FF09                           ; C00B
        sta     $FF0A                           ; C00E
        sei                                     ; C011
        jmp     (LFFFC)                         ; C012

; ----------------------------------------------------------------------------
LC015:  jsr     L1000                           ; C015
        ldx     #$85                            ; C018
        ldy     #$C1                            ; C01A
        jsr     LC18B                           ; C01C
        bcs     LC009                           ; C01F
        ldx     #$7A                            ; C021
        ldy     #$C1                            ; C023
        jsr     LC18B                           ; C025
        bcs     LC009                           ; C028
        ldx     #$00                            ; C02A
        txa                                     ; C02C
LC02D:  sta     $02,x                           ; C02D
        sta     $0100,x                         ; C02F
        sta     $0200,x                         ; C032
        sta     $F500,x                         ; C035
        inx                                     ; C038
        bne     LC02D                           ; C039
        ldx     #$FF                            ; C03B
        txs                                     ; C03D
        jsr     L8000                           ; C03E
        php                                     ; C041
LC042:  lda     $FF1D                           ; C042
        bne     LC042                           ; C045
        lda     #$00                            ; C047
        sta     $FF06                           ; C049
        sta     $FF19                           ; C04C
        plp                                     ; C04F
        bcc     LC061                           ; C050
        ldx     #$80                            ; C052
        ldy     #$C1                            ; C054
        jsr     LC18B                           ; C056
        bcs     LC05E                           ; C059
        jmp     L1000                           ; C05B

; ----------------------------------------------------------------------------
LC05E:  jmp     LC009                           ; C05E

; ----------------------------------------------------------------------------
LC061:  ldx     #$00                            ; C061
        lda     #$FF                            ; C063
LC065:  sta     $7E00,x                         ; C065
        sta     $7F00,x                         ; C068
        inx                                     ; C06B
        bne     LC065                           ; C06C
        jsr     Copy_LoaderCode_To_FF20         ; C06E
        jsr     LC2F2                           ; C071
        jsr     LC102                           ; C074
        jsr     L2CDF                           ; C077
        ldx     #$FF                            ; C07A
        stx     $39                             ; C07C
        stx     $F557                           ; C07E
        stx     $F55B                           ; C081
        stx     $F556                           ; C084
        stx     $F55A                           ; C087
        stx     $4E                             ; C08A
        stx     $55                             ; C08C
        stx     $F508                           ; C08E
        lda     #$00                            ; C091
        sta     $F5DC                           ; C093
        jsr     L27D7                           ; C096
        jsr     L3F51                           ; C099
        lda     #$01                            ; C09C
        sta     $62                             ; C09E
        lda     #$27                            ; C0A0
        sta     $64                             ; C0A2
        lda     #$08                            ; C0A4
        sta     $63                             ; C0A6
        lda     #$B8                            ; C0A8
        sta     $65                             ; C0AA
        sta     $66                             ; C0AC
        jsr     L3C97                           ; C0AE
LC0B1:  lda     $FF1D                           ; C0B1
        bne     LC0B1                           ; C0B4
        lda     #$37                            ; C0B6
        sta     $FF06                           ; C0B8
        ldx     #$29                            ; C0BB
LC0BD:  lda     LC0D8,x                         ; C0BD
        sta     $AA,x                           ; C0C0
        dex                                     ; C0C2
        bpl     LC0BD                           ; C0C3
        jsr     L3706                           ; C0C5
        ldx     #$00                            ; C0C8
        ldy     #$00                            ; C0CA
        lda     #$01                            ; C0CC
        jsr     L3F85                           ; C0CE
        ldx     #$00                            ; C0D1
        ldy     #$00                            ; C0D3
        jmp     L41E9                           ; C0D5

; ----------------------------------------------------------------------------
LC0D8:  iny                                     ; C0D8
        tya                                     ; C0D9
        clc                                     ; C0DA
        adc     $BC                             ; C0DB
        sta     $BC                             ; C0DD
        bcc     LC0E9                           ; C0DF
LC0E1:  inc     $BD                             ; C0E1
        bne     LC0E9                           ; C0E3
        inc     $BC                             ; C0E5
        beq     LC0E1                           ; C0E7
LC0E9:  lda     $FFFF                           ; C0E9
        inc     $BC                             ; C0EC
        beq     LC0FE                           ; C0EE
LC0F0:  asl     a                               ; C0F0
        bcs     LC0F8                           ; C0F1
        sta     $C8                             ; C0F3
        jmp     (L0D00)                         ; C0F5

; ----------------------------------------------------------------------------
LC0F8:  sta     $CE                             ; C0F8
        clc                                     ; C0FA
        jmp     (L0E00)                         ; C0FB

; ----------------------------------------------------------------------------
LC0FE:  inc     $BD                             ; C0FE
        bne     LC0F0                           ; C100
LC102:  ldx     #$1F                            ; C102
        lda     #$00                            ; C104
LC106:  sta     $0200,x                         ; C106
        sta     $0220,x                         ; C109
        sta     $0240,x                         ; C10C
        sta     $0260,x                         ; C10F
        sta     $0280,x                         ; C112
        sta     $02A0,x                         ; C115
        sta     $02C0,x                         ; C118
        sta     $02E0,x                         ; C11B
        sta     $0300,x                         ; C11E
        dex                                     ; C121
        bpl     LC106                           ; C122
        ldx     #$02                            ; C124
LC126:  lda     LC15C,x                         ; C126
        sta     $0200,x                         ; C129
        lda     LC15F,x                         ; C12C
        sta     $0220,x                         ; C12F
        lda     LC162,x                         ; C132
        sta     $0240,x                         ; C135
        lda     LC165,x                         ; C138
        sta     $0260,x                         ; C13B
        lda     LC168,x                         ; C13E
        sta     $0280,x                         ; C141
        lda     LC16B,x                         ; C144
        sta     $02A0,x                         ; C147
        lda     LC16E,x                         ; C14A
        sta     $02C0,x                         ; C14D
        lda     #$FF                            ; C150
        sta     $02E0,x                         ; C152
        sta     $0300,x                         ; C155
        dex                                     ; C158
        bpl     LC126                           ; C159
        rts                                     ; C15B

; ----------------------------------------------------------------------------
LC15C:  .byte   $FF,$00,$00                     ; C15C
LC15F:  .byte   $7F,$80,$F5                     ; C15F
LC162:  .byte   $01,$00,$01                     ; C162
LC165:  .byte   $00,$0E,$00                     ; C165
LC168:  .byte   $FF,$FF,$FF                     ; C168
LC16B:  .byte   $01,$02,$FF                     ; C16B
LC16E:  .byte   $FF,$00                         ; C16E
; ----------------------------------------------------------------------------
        .byte   $01                             ; C170
; 8, TITLEPIC $C171
NAME_TITLEPIC:
        .byte   $08,$D4,$C9,$D4,$CC,$C5,$D0,$C9 ; C171
        .byte   $C3                             ; C179
; 5, MUSIC $C17A
NAME_MUSIC:
        .byte   $05,$CD,$D5,$D3,$C9,$C3         ; C17A
; 4, UTIL $C180
NAME_UTIL:
        .byte   $04,$D5,$D4,$C9,$CC             ; C180
; 5, SUBS1 $C185
NAME_SUBS:
        .byte   $05,$D3,$D5,$C2,$D3             ; C185
; ----------------------------------------------------------------------------
        .byte   $B1                             ; C18A
LC18B:  stx     $F9                             ; C18B
        sty     $FA                             ; C18D
        lda     #$01                            ; C18F
        sta     DriveOp                         ; C191
        lda     #$00                            ; C193
        sta     BufferVec                       ; C195
        lda     #$CE                            ; C197
        sta     BufferVec+1                     ; C199
        lda     #$02                            ; C19B
        sta     BlockNum                        ; C19D
        lda     #$00                            ; C19F
        sta     BlockNum+1                      ; C1A1
LC1A3:  jsr     LC2AC                           ; C1A3
        ldx     #$00                            ; C1A6
LC1A8:  clc                                     ; C1A8
        lda     #$00                            ; C1A9
        adc     LC292,x                         ; C1AB
        sta     $F7                             ; C1AE
        lda     #$CE                            ; C1B0
        adc     LC29F,x                         ; C1B2
        sta     $F8                             ; C1B5
        ldy     #$00                            ; C1B7
        lda     ($F7),y                         ; C1B9
        and     #$F0                            ; C1BB
        beq     LC1D4                           ; C1BD
        lda     ($F7),y                         ; C1BF
        and     #$0F                            ; C1C1
        cmp     ($F9),y                         ; C1C3
        bne     LC1D4                           ; C1C5
        tay                                     ; C1C7
LC1C8:  lda     ($F9),y                         ; C1C8
        eor     ($F7),y                         ; C1CA
        asl     a                               ; C1CC
        bne     LC1D4                           ; C1CD
        dey                                     ; C1CF
        bne     LC1C8                           ; C1D0
        beq     LC1EA                           ; C1D2
LC1D4:  inx                                     ; C1D4
        cpx     #$0D                            ; C1D5
        bcc     LC1A8                           ; C1D7
        lda     BUFCE00+2                       ; C1D9
        sta     BlockNum                        ; C1DC
        lda     BUFCE00+3                       ; C1DE
        sta     BlockNum+1                      ; C1E1
        ora     BlockNum                        ; C1E3
        bne     LC1A3                           ; C1E5
        lda     #$46                            ; C1E7
        rts                                     ; C1E9

; ----------------------------------------------------------------------------
LC1EA:  ldy     #$15                            ; C1EA
        lda     ($F7),y                         ; C1EC
        sta     $FD                             ; C1EE
        iny                                     ; C1F0
        lda     ($F7),y                         ; C1F1
        sta     $FE                             ; C1F3
        ldy     #$1F                            ; C1F5
        lda     ($F7),y                         ; C1F7
        sta     $FB                             ; C1F9
        iny                                     ; C1FB
        lda     ($F7),y                         ; C1FC
        sta     $FC                             ; C1FE
        ldy     #$11                            ; C200
        lda     ($F7),y                         ; C202
        sta     BlockNum                        ; C204
        iny                                     ; C206
        lda     ($F7),y                         ; C207
        sta     BlockNum+1                      ; C209
        ldy     #$00                            ; C20B
        lda     ($F7),y                         ; C20D
        and     #$F0                            ; C20F
        cmp     #$10                            ; C211
        beq     LC24D                           ; C213
        lda     #$00                            ; C215
        sta     BufferVec                       ; C217
        lda     #$CE                            ; C219
        sta     BufferVec+1                     ; C21B
        jsr     LC2AC                           ; C21D
        ldx     #$00                            ; C220
LC222:  stx     $F6                             ; C222
        lda     BUFCE00,x                       ; C224
        sta     BlockNum                        ; C227
        lda     BUFCF00,x                       ; C229
        sta     BlockNum+1                      ; C22C
        lda     $FE                             ; C22E
        cmp     #$02                            ; C230
        bcc     LC24D                           ; C232
        lda     $FB                             ; C234
        sta     BufferVec                       ; C236
        lda     $FC                             ; C238
        sta     BufferVec+1                     ; C23A
        jsr     LC2AC                           ; C23C
        inc     $FC                             ; C23F
        inc     $FC                             ; C241
        dec     $FE                             ; C243
        dec     $FE                             ; C245
        ldx     $F6                             ; C247
        inx                                     ; C249
        jmp     LC222                           ; C24A

; ----------------------------------------------------------------------------
LC24D:  lda     #$00                            ; C24D
        sta     BufferVec                       ; C24F
        lda     #$CE                            ; C251
        sta     BufferVec+1                     ; C253
        jsr     LC2AC                           ; C255
        lda     $FB                             ; C258
        sta     $F7                             ; C25A
        lda     $FC                             ; C25C
        sta     $F8                             ; C25E
        ldy     #$00                            ; C260
        lda     $FE                             ; C262
        beq     LC281                           ; C264
LC266:  lda     BUFCE00,y                       ; C266
        sta     ($F7),y                         ; C269
        iny                                     ; C26B
        bne     LC266                           ; C26C
        inc     $F8                             ; C26E
        ldy     $FD                             ; C270
        beq     LC27F                           ; C272
        dey                                     ; C274
LC275:  lda     BUFCF00,y                       ; C275
        sta     ($F7),y                         ; C278
        dey                                     ; C27A
        cpy     #$FF                            ; C27B
        bne     LC275                           ; C27D
LC27F:  clc                                     ; C27F
        rts                                     ; C280

; ----------------------------------------------------------------------------
LC281:  ldy     $FD                             ; C281
        beq     LC27F                           ; C283
        dey                                     ; C285
LC286:  lda     BUFCE00,y                       ; C286
        sta     ($F7),y                         ; C289
        dey                                     ; C28B
        cpy     #$FF                            ; C28C
        bne     LC286                           ; C28E
        clc                                     ; C290
        rts                                     ; C291

; ----------------------------------------------------------------------------
LC292:  .byte   $04                             ; C292
        .byte   $2B                             ; C293
        .byte   $52                             ; C294
        adc     $C7A0,y                         ; C295
        inc     $3C15                           ; C298
        .byte   $63                             ; C29B
        txa                                     ; C29C
        lda     (BlockNum),y                    ; C29D
LC29F:  brk                                     ; C29F
        brk                                     ; C2A0
        brk                                     ; C2A1
        brk                                     ; C2A2
        brk                                     ; C2A3
        brk                                     ; C2A4
        brk                                     ; C2A5
        ora     ($01,x)                         ; C2A6
        ora     ($01,x)                         ; C2A8
        ora     ($01,x)                         ; C2AA
LC2AC:  lda     BlockNum                        ; C2AC
        ora     BlockNum+1                      ; C2AE
        bne     LC2C5                           ; C2B0
        ldy     #$00                            ; C2B2
        tya                                     ; C2B4
LC2B5:  sta     (BufferVec),y                   ; C2B5
        iny                                     ; C2B7
        bne     LC2B5                           ; C2B8
        inc     BufferVec+1                     ; C2BA
LC2BC:  sta     (BufferVec),y                   ; C2BC
        iny                                     ; C2BE
        bne     LC2BC                           ; C2BF
        dec     BufferVec+1                     ; C2C1
        clc                                     ; C2C3
        rts                                     ; C2C4

; ----------------------------------------------------------------------------
LC2C5:  jsr     LC2CE                           ; C2C5
        bcc     LC2CD                           ; C2C8
        jmp     (LFFFC)                         ; C2CA

; ----------------------------------------------------------------------------
LC2CD:  rts                                     ; C2CD

; ----------------------------------------------------------------------------
LC2CE:  clc                                     ; C2CE
        jsr     LC2E3                           ; C2CF
        jsr     DoSectorOp                      ; C2D2
        bcs     LC2E2                           ; C2D5
        sec                                     ; C2D7
        jsr     LC2E3                           ; C2D8
        inc     BufferVec+1                     ; C2DB
        jsr     DoSectorOp                      ; C2DD
        dec     BufferVec+1                     ; C2E0
LC2E2:  rts                                     ; C2E2

; ----------------------------------------------------------------------------
LC2E3:  lda     BlockNum                        ; C2E3
        rol     a                               ; C2E5
        sta     BlockNumTmp+1                   ; C2E6
        lda     BlockNum+1                      ; C2E9
        rol     a                               ; C2EB
        sta     BlockNumTmp                     ; C2EC
        jmp     ConvertBlockTmp                 ; C2EF

; ----------------------------------------------------------------------------
LC2F2:  ldx     #$00                            ; C2F2
LC2F4:  lda     #$42                            ; C2F4
        sta     $5800,x                         ; C2F6
        sta     $5900,x                         ; C2F9
        sta     $5A00,x                         ; C2FC
        sta     $5B00,x                         ; C2FF
        lda     #$11                            ; C302
        sta     $5C00,x                         ; C304
        sta     $5D00,x                         ; C307
        sta     $5E00,x                         ; C30A
        sta     $5F00,x                         ; C30D
        inx                                     ; C310
        bne     LC2F4                           ; C311
        lda     #$41                            ; C313
        sta     $FF16                           ; C315
        stx     $FF11                           ; C318
        rts                                     ; C31B

; ----------------------------------------------------------------------------
