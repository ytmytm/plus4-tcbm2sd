; da65 V2.19 - Git dcdf7ade0
; Created:    2025-07-27 18:21:12
; Input file: util1000.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
L0006           := $0006
L0810           := $0810
L7048           := $7048
L802E           := $802E
L8117           := $8117
L8A7B           := $8A7B
LD84E           := $D84E
LF2CE           := $F2CE
LF352           := $F352
LFFBA           := $FFBA
LFFBD           := $FFBD
LFFD5           := $FFD5
; ----------------------------------------------------------------------------
UtilStart:
        jmp     L115B                           ; 1000

; ----------------------------------------------------------------------------
L1003:  bit     $01                             ; 1003
        bvc     L1003                           ; 1005
        sta     $FF                             ; 1007
        lda     #$D2                            ; 1009
        sta     $FF13                           ; 100B
        ldy     #$04                            ; 100E
L1010:  nop                                     ; 1010
        nop                                     ; 1011
        nop                                     ; 1012
        lda     #$0A                            ; 1013
        asl     $FF                             ; 1015
        bcc     L101B                           ; 1017
        lda     #$0B                            ; 1019
L101B:  sta     $01                             ; 101B
        nop                                     ; 101D
        nop                                     ; 101E
        nop                                     ; 101F
        nop                                     ; 1020
        lda     #$08                            ; 1021
        asl     $FF                             ; 1023
        bcc     L1029                           ; 1025
        lda     #$09                            ; 1027
L1029:  sta     $01                             ; 1029
        nop                                     ; 102B
        nop                                     ; 102C
        nop                                     ; 102D
        nop                                     ; 102E
        nop                                     ; 102F
        dey                                     ; 1030
        bne     L1010                           ; 1031
        lda     #$08                            ; 1033
        sta     $01                             ; 1035
        lda     #$D0                            ; 1037
        sta     $FF13                           ; 1039
        rts                                     ; 103C

; ----------------------------------------------------------------------------
L103D:  bit     $01                             ; 103D
        bvc     L103D                           ; 103F
        lda     #$D2                            ; 1041
        sta     $FF13                           ; 1043
        ldy     #$04                            ; 1046
L1048:  lda     #$89                            ; 1048
        sta     $01                             ; 104A
        jsr     L107C                           ; 104C
        lda     $01                             ; 104F
        and     #$40                            ; 1051
        cmp     #$40                            ; 1053
        rol     $FF                             ; 1055
        lda     #$88                            ; 1057
        sta     $01                             ; 1059
        jsr     L107C                           ; 105B
        lda     $01                             ; 105E
        and     #$40                            ; 1060
        cmp     #$40                            ; 1062
        rol     $FF                             ; 1064
        dey                                     ; 1066
        bne     L1048                           ; 1067
        lda     #$89                            ; 1069
        sta     $01                             ; 106B
        jsr     L107C                           ; 106D
        lda     #$08                            ; 1070
        sta     $01                             ; 1072
        lda     #$D0                            ; 1074
        sta     $FF13                           ; 1076
        lda     $FF                             ; 1079
        rts                                     ; 107B

; ----------------------------------------------------------------------------
L107C:  nop                                     ; 107C
        nop                                     ; 107D
        nop                                     ; 107E
        nop                                     ; 107F
        nop                                     ; 1080
        rts                                     ; 1081

; ----------------------------------------------------------------------------
L1082:  lda     #$09                            ; 1082
L1084:  sta     $01                             ; 1084
        lda     $D5                             ; 1086
        jsr     L1003                           ; 1088
        lda     L1159                           ; 108B
        jsr     L1003                           ; 108E
        lda     L115A                           ; 1091
        jmp     L1003                           ; 1094

; ----------------------------------------------------------------------------
L1097:  lda     $D6                             ; 1097
        sta     L10CA                           ; 1099
        sta     L10B9                           ; 109C
        lda     $D7                             ; 109F
        sta     L10CB                           ; 10A1
        sta     L10BA                           ; 10A4
        jsr     L1082                           ; 10A7
        lda     $D5                             ; 10AA
        cmp     #$03                            ; 10AC
        beq     L10CF                           ; 10AE
        bcs     L10D5                           ; 10B0
        cmp     #$02                            ; 10B2
        bne     L10C4                           ; 10B4
        ldx     #$00                            ; 10B6
L10B8:  .byte   $BD                             ; 10B8
L10B9:  .byte   $FF                             ; 10B9
L10BA:  .byte   $FF                             ; 10BA
        jsr     L1003                           ; 10BB
        inx                                     ; 10BE
        bne     L10B8                           ; 10BF
        jmp     L10CF                           ; 10C1

; ----------------------------------------------------------------------------
L10C4:  ldx     #$00                            ; 10C4
L10C6:  jsr     L103D                           ; 10C6
        .byte   $9D                             ; 10C9
L10CA:  .byte   $FF                             ; 10CA
L10CB:  .byte   $FF                             ; 10CB
        inx                                     ; 10CC
        bne     L10C6                           ; 10CD
L10CF:  jsr     L103D                           ; 10CF
        sta     L1158                           ; 10D2
L10D5:  lda     #$C8                            ; 10D5
L10D7:  sta     $01                             ; 10D7
        lda     L1158                           ; 10D9
        cmp     #$01                            ; 10DC
        rts                                     ; 10DE

; ----------------------------------------------------------------------------
L10DF:  lda     $D8                             ; 10DF
        sta     L115A                           ; 10E1
        lda     $D9                             ; 10E4
        sta     L1159                           ; 10E6
        jsr     L10EF                           ; 10E9
        jmp     L1097                           ; 10EC

; ----------------------------------------------------------------------------
L10EF:  ldx     #$00                            ; 10EF
L10F1:  sec                                     ; 10F1
        lda     L115A                           ; 10F2
        sbc     L1135,x                         ; 10F5
        tay                                     ; 10F8
        lda     L1159                           ; 10F9
        sbc     #$00                            ; 10FC
        bcc     L1109                           ; 10FE
        inx                                     ; 1100
        sta     L1159                           ; 1101
        .byte   $8C                             ; 1104
        .byte   $5A                             ; 1105
L1106:  ora     ($B0),y                         ; 1106
        inx                                     ; 1108
L1109:  inx                                     ; 1109
        cpx     #$23                            ; 110A
        beq     L1117                           ; 110C
        .byte   $E0                             ; 110E
L110F:  .byte   $12                             ; 110F
        bcc     L1113                           ; 1110
        inx                                     ; 1112
L1113:  stx     L1159                           ; 1113
        rts                                     ; 1116

; ----------------------------------------------------------------------------
L1117:  lda     #$12                            ; 1117
        sta     L1159                           ; 1119
        sec                                     ; 111C
        sbc     L115A                           ; 111D
        sta     L115A                           ; 1120
        rts                                     ; 1123

; ----------------------------------------------------------------------------
L1124:  ldx     #$7E                            ; 1124
L1126:  lda     $5600,x                         ; 1126
        sta     L1003,x                         ; 1129
        dex                                     ; 112C
        bpl     L1126                           ; 112D
        lda     #$24                            ; 112F
        jmp     L12CE                           ; 1131

; ----------------------------------------------------------------------------
        brk                                     ; 1134
L1135:  ora     $15,x                           ; 1135
        ora     $15,x                           ; 1137
        ora     $15,x                           ; 1139
        ora     $15,x                           ; 113B
        ora     $15,x                           ; 113D
        ora     $15,x                           ; 113F
        ora     $15,x                           ; 1141
        ora     $15,x                           ; 1143
        ora     $13,x                           ; 1145
        .byte   $13                             ; 1147
        .byte   $13                             ; 1148
        .byte   $13                             ; 1149
        .byte   $13                             ; 114A
        .byte   $13                             ; 114B
        .byte   $12                             ; 114C
        .byte   $12                             ; 114D
        .byte   $12                             ; 114E
        .byte   $12                             ; 114F
        .byte   $12                             ; 1150
        .byte   $12                             ; 1151
        ora     ($11),y                         ; 1152
        ora     ($11),y                         ; 1154
        ora     ($FF),y                         ; 1156
L1158:  brk                                     ; 1158
L1159:  brk                                     ; 1159
L115A:  brk                                     ; 115A
L115B:  jsr     L190E                           ; 115B
        ldx     #$00                            ; 115E
        lda     #$71                            ; 1160
L1162:  sta     $0800,x                         ; 1162
        sta     $0900,x                         ; 1165
        sta     $0A00,x                         ; 1168
        sta     $0B00,x                         ; 116B
        inx                                     ; 116E
        bne     L1162                           ; 116F
        lda     #$16                            ; 1171
        sta     $FF19                           ; 1173
        sta     $FF15                           ; 1176
        lda     #$04                            ; 1179
        sta     $FF12                           ; 117B
        lda     #$08                            ; 117E
        sta     $FF14                           ; 1180
        sta     $FF07                           ; 1183
        lda     #$17                            ; 1186
        sta     $FF06                           ; 1188
        lda     $5600                           ; 118B
        cmp     #$24                            ; 118E
        beq     L1196                           ; 1190
        jsr     L1124                           ; 1192
        nop                                     ; 1195
L1196:  ldx     #$FF                            ; 1196
        txs                                     ; 1198
        jsr     L190E                           ; 1199
        jsr     L14CB                           ; 119C
        ldy     #$A0                            ; 119F
        tax                                     ; 11A1
        tax                                     ; 11A2
        tax                                     ; 11A3
        ldy     #$C4                            ; 11A4
        .byte   $F2                             ; 11A6
        sbc     ($E7,x)                         ; 11A7
        .byte   $EF                             ; 11A9
        inc     $D7A0                           ; 11AA
        sbc     ($F2,x)                         ; 11AD
        .byte   $F3                             ; 11AF
        ldy     #$D5                            ; 11B0
        .byte   $F4                             ; 11B2
        sbc     #$EC                            ; 11B3
        sbc     #$F4                            ; 11B5
        sbc     $D0A0,y                         ; 11B7
        .byte   $F2                             ; 11BA
        .byte   $EF                             ; 11BB
        .byte   $E7                             ; 11BC
        .byte   $F2                             ; 11BD
        sbc     ($ED,x)                         ; 11BE
        ldy     #$AA                            ; 11C0
        tax                                     ; 11C2
        tax                                     ; 11C3
        sta     $ADAD                           ; 11C4
        lda     $ADAD                           ; 11C7
        lda     $ADAD                           ; 11CA
        lda     $ADAD                           ; 11CD
        lda     $ADAD                           ; 11D0
        lda     $ADAD                           ; 11D3
        lda     $ADAD                           ; 11D6
        lda     $ADAD                           ; 11D9
        lda     $ADAD                           ; 11DC
        lda     $ADAD                           ; 11DF
        lda     $ADAD                           ; 11E2
        lda     $ADAD                           ; 11E5
        lda     $ADAD                           ; 11E8
        lda     $8DAD                           ; 11EB
        sta     $A9B1                           ; 11EE
        ldy     #$C2                            ; 11F1
        sbc     ($E3,x)                         ; 11F3
        .byte   $EB                             ; 11F5
        sbc     $F0,x                           ; 11F6
        ldy     #$E1                            ; 11F8
        ldy     #$E4                            ; 11FA
        sbc     #$F3                            ; 11FC
        .byte   $EB                             ; 11FE
        ldx     $B28D                           ; 11FF
        lda     #$A0                            ; 1202
        .byte   $D2                             ; 1204
        sbc     $F4                             ; 1205
        sbc     $F2,x                           ; 1207
        inc     $F4A0                           ; 1209
        .byte   $EF                             ; 120C
        ldy     #$C4                            ; 120D
        .byte   $F2                             ; 120F
        sbc     ($E7,x)                         ; 1210
        .byte   $EF                             ; 1212
        inc     $D7A0                           ; 1213
        sbc     ($F2,x)                         ; 1216
        .byte   $F3                             ; 1218
        ldx     $B38D                           ; 1219
        lda     #$A0                            ; 121C
        .byte   $D4                             ; 121E
        .byte   $F2                             ; 121F
        sbc     ($EE,x)                         ; 1220
        .byte   $F3                             ; 1222
        inc     $E5                             ; 1223
        .byte   $F2                             ; 1225
        ldy     #$E3                            ; 1226
        inx                                     ; 1228
        sbc     ($F2,x)                         ; 1229
        sbc     ($E3,x)                         ; 122B
        .byte   $F4                             ; 122D
        sbc     $F2                             ; 122E
        .byte   $F3                             ; 1230
        .byte   $AE                             ; 1231
        brk                                     ; 1232
L1233:  jsr     L137B                           ; 1233
        sec                                     ; 1236
        sbc     #$B1                            ; 1237
        cmp     #$03                            ; 1239
        bcc     L1243                           ; 123B
        jsr     L1509                           ; 123D
        jmp     L1233                           ; 1240

; ----------------------------------------------------------------------------
L1243:  asl     a                               ; 1243
        tay                                     ; 1244
        lda     L1252,y                         ; 1245
        sta     L0006                           ; 1248
        lda     L1253,y                         ; 124A
        sta     $07                             ; 124D
        jmp     (L0006)                         ; 124F

; ----------------------------------------------------------------------------
L1252:  .byte   $0B                             ; 1252
L1253:  .byte   $1A                             ; 1253
        cli                                     ; 1254
        .byte   $12                             ; 1255
        dec     L201B,x                         ; 1256
        ora     ($19),y                         ; 1259
        jsr     L12EE                           ; 125B
        lda     #$12                            ; 125E
        sta     L1159                           ; 1260
        lda     #$00                            ; 1263
        sta     L115A                           ; 1265
        lda     #$04                            ; 1268
        sta     $D5                             ; 126A
        jsr     L1097                           ; 126C
        nop                                     ; 126F
        nop                                     ; 1270
        nop                                     ; 1271
        nop                                     ; 1272
        nop                                     ; 1273
        nop                                     ; 1274
        nop                                     ; 1275
        nop                                     ; 1276
        nop                                     ; 1277
        nop                                     ; 1278
        nop                                     ; 1279
        sta     $FF3E                           ; 127A
        nop                                     ; 127D
        ldy     #$78                            ; 127E
L1280:  lda     $FF1D                           ; 1280
        beq     L1280                           ; 1283
L1285:  lda     $FF1D                           ; 1285
        bne     L1285                           ; 1288
        dey                                     ; 128A
        bne     L1280                           ; 128B
        lda     #$00                            ; 128D
        sta     $FF19                           ; 128F
        sta     $FF06                           ; 1292
        sei                                     ; 1295
        cld                                     ; 1296
        ldx     #$FF                            ; 1297
        txs                                     ; 1299
        jsr     LF352                           ; 129A
        jsr     LF2CE                           ; 129D
        jsr     LD84E                           ; 12A0
        lda     #$00                            ; 12A3
        sta     $FF19                           ; 12A5
        sta     $FF15                           ; 12A8
        cli                                     ; 12AB
        jsr     L8117                           ; 12AC
        jsr     L802E                           ; 12AF
        jsr     L8A7B                           ; 12B2
        lda     #$01                            ; 12B5
        ldx     #$08                            ; 12B7
        ldy     #$01                            ; 12B9
        jsr     LFFBA                           ; 12BB
        lda     #$02                            ; 12BE
        ldx     #$CC                            ; 12C0
        ldy     #$12                            ; 12C2
        jsr     LFFBD                           ; 12C4
        lda     #$00                            ; 12C7
        jmp     LFFD5                           ; 12C9

; ----------------------------------------------------------------------------
        .byte   ":*"                            ; 12CC
; ----------------------------------------------------------------------------
L12CE:  sta     L1084                           ; 12CE
        sta     L10D7                           ; 12D1
        rts                                     ; 12D4

; ----------------------------------------------------------------------------
        brk                                     ; 12D5
        brk                                     ; 12D6
        brk                                     ; 12D7
        brk                                     ; 12D8
        brk                                     ; 12D9
        brk                                     ; 12DA
        brk                                     ; 12DB
        brk                                     ; 12DC
        brk                                     ; 12DD
        brk                                     ; 12DE
        brk                                     ; 12DF
        brk                                     ; 12E0
        brk                                     ; 12E1
        brk                                     ; 12E2
        brk                                     ; 12E3
        brk                                     ; 12E4
        brk                                     ; 12E5
        brk                                     ; 12E6
        brk                                     ; 12E7
        brk                                     ; 12E8
        brk                                     ; 12E9
        brk                                     ; 12EA
        brk                                     ; 12EB
        brk                                     ; 12EC
        brk                                     ; 12ED
L12EE:  lda     #$FF                            ; 12EE
        sta     L137A                           ; 12F0
        lda     #$00                            ; 12F3
        sta     $D6                             ; 12F5
        lda     #$FC                            ; 12F7
        sta     $D7                             ; 12F9
        lda     #$01                            ; 12FB
        sta     $D5                             ; 12FD
        lda     #$04                            ; 12FF
        sta     $D8                             ; 1301
        lda     #$00                            ; 1303
        sta     $D9                             ; 1305
        jsr     L10DF                           ; 1307
        bcs     L1328                           ; 130A
        ldx     L131B                           ; 130C
L130F:  lda     L131B,x                         ; 130F
        cmp     $FC04,x                         ; 1312
        bne     L1328                           ; 1315
        dex                                     ; 1317
        bne     L130F                           ; 1318
        rts                                     ; 131A

; ----------------------------------------------------------------------------
L131B:  .byte   $0C                             ; 131B
        .byte   $44                             ; 131C
        .byte   $52                             ; 131D
        eor     ($47,x)                         ; 131E
        .byte   $4F                             ; 1320
        lsr     $572E                           ; 1321
        eor     ($52,x)                         ; 1324
        .byte   $53                             ; 1326
        .byte   $31                             ; 1327
L1328:  jsr     L14CB                           ; 1328
        sta     $D08D                           ; 132B
        cpx     $E1E5                           ; 132E
        .byte   $F3                             ; 1331
        sbc     $A0                             ; 1332
        sbc     #$EE                            ; 1334
        .byte   $F3                             ; 1336
        sbc     $F2                             ; 1337
        .byte   $F4                             ; 1339
        ldy     #$F9                            ; 133A
        .byte   $EF                             ; 133C
        sbc     $F2,x                           ; 133D
        ldy     #$C4                            ; 133F
        .byte   $F2                             ; 1341
        sbc     ($E7,x)                         ; 1342
        .byte   $EF                             ; 1344
        inc     $D7A0                           ; 1345
        sbc     ($F2,x)                         ; 1348
L134A:  .byte   $F3                             ; 134A
        sta     $E9E4                           ; 134B
        .byte   $F3                             ; 134E
        .byte   $EB                             ; 134F
        ldy     #$F3                            ; 1350
        sbc     #$E4                            ; 1352
        sbc     $A0                             ; 1354
        .byte   $A3                             ; 1356
        lda     ($AE),y                         ; 1357
        sta     $F2D0                           ; 1359
        sbc     $F3                             ; 135C
        .byte   $F3                             ; 135E
        ldy     #$D2                            ; 135F
        cmp     $D4                             ; 1361
        cmp     $D2,x                           ; 1363
        dec     $F4A0                           ; 1365
        .byte   $EF                             ; 1368
        ldy     #$E3                            ; 1369
        .byte   $EF                             ; 136B
        inc     $E9F4                           ; 136C
        inc     $E5F5                           ; 136F
        ldx     L2000                           ; 1372
        .byte   $7B                             ; 1375
        .byte   $13                             ; 1376
        jmp     L12EE                           ; 1377

; ----------------------------------------------------------------------------
L137A:  brk                                     ; 137A
L137B:  txa                                     ; 137B
        pha                                     ; 137C
        tya                                     ; 137D
        pha                                     ; 137E
        nop                                     ; 137F
        nop                                     ; 1380
        nop                                     ; 1381
        nop                                     ; 1382
L1383:  jsr     L1407                           ; 1383
        jsr     L13E8                           ; 1386
        lda     $DA                             ; 1389
        bpl     L1383                           ; 138B
        pla                                     ; 138D
        tay                                     ; 138E
        pla                                     ; 138F
        tax                                     ; 1390
        nop                                     ; 1391
        nop                                     ; 1392
        nop                                     ; 1393
        nop                                     ; 1394
        lda     $DA                             ; 1395
        pha                                     ; 1397
        lda     #$00                            ; 1398
        sta     $DA                             ; 139A
        pla                                     ; 139C
        cmp     #$E1                            ; 139D
        bcc     L13A7                           ; 139F
        cmp     #$FB                            ; 13A1
        bcs     L13A7                           ; 13A3
        and     #$DF                            ; 13A5
L13A7:  rts                                     ; 13A7

; ----------------------------------------------------------------------------
L13A8:  tya                                     ; 13A8
        sbc     ($00),y                         ; 13A9
        ldy     #$B2                            ; 13AB
        brk                                     ; 13AD
        brk                                     ; 13AE
        lda     ($BF),y                         ; 13AF
        .byte   $AB                             ; 13B1
        lda     a:$9B,x                         ; 13B2
        .byte   $BB                             ; 13B5
        tax                                     ; 13B6
        dey                                     ; 13B7
        ldy     $BAAD                           ; 13B8
        ldx     $EC8B                           ; 13BB
        beq     L134A                           ; 13BE
        inc     $EBEF                           ; 13C0
        sbc     $EAB0                           ; 13C3
        sbc     #$B9                            ; 13C6
        inc     $F5,x                           ; 13C8
        inx                                     ; 13CA
        .byte   $E2                             ; 13CB
        clv                                     ; 13CC
        .byte   $E7                             ; 13CD
        sbc     $F8B7,y                         ; 13CE
        .byte   $F4                             ; 13D1
        inc     $E3                             ; 13D2
        ldx     $E4,y                           ; 13D4
        .byte   $F2                             ; 13D6
        lda     $00,x                           ; 13D7
        sbc     $F3                             ; 13D9
        .byte   $FA                             ; 13DB
        ldy     $E1,x                           ; 13DC
        .byte   $F7                             ; 13DE
        .byte   $B3                             ; 13DF
        brk                                     ; 13E0
        lda     $B3,x                           ; 13E1
        lda     ($B7),y                         ; 13E3
        brk                                     ; 13E5
        .byte   $8D                             ; 13E6
        dey                                     ; 13E7
L13E8:  lda     $DA                             ; 13E8
        bmi     L1406                           ; 13EA
        lda     L1476                           ; 13EC
        beq     L1406                           ; 13EF
        lda     L1477                           ; 13F1
        sta     $DA                             ; 13F4
        ldx     #$00                            ; 13F6
L13F8:  lda     L1478,x                         ; 13F8
        sta     L1477,x                         ; 13FB
        inx                                     ; 13FE
        cpx     #$0E                            ; 13FF
        bne     L13F8                           ; 1401
        dec     L1476                           ; 1403
L1406:  rts                                     ; 1406

; ----------------------------------------------------------------------------
L1407:  ldx     #$FE                            ; 1407
        stx     L1475                           ; 1409
        inx                                     ; 140C
        stx     $FF00                           ; 140D
        inx                                     ; 1410
        stx     $FF01                           ; 1411
        ldx     #$07                            ; 1414
L1416:  lda     L1475                           ; 1416
        jsr     L14BF                           ; 1419
        ora     L1465,x                         ; 141C
        cmp     L146D,x                         ; 141F
        bne     L142C                           ; 1422
L1424:  sec                                     ; 1424
        rol     L1475                           ; 1425
        dex                                     ; 1428
        bpl     L1416                           ; 1429
        rts                                     ; 142B

; ----------------------------------------------------------------------------
L142C:  cmp     #$FF                            ; 142C
        bne     L1435                           ; 142E
        sta     L146D,x                         ; 1430
        beq     L1424                           ; 1433
L1435:  ldy     L146D,x                         ; 1435
        cpy     #$FF                            ; 1438
        bne     L1424                           ; 143A
        pha                                     ; 143C
        txa                                     ; 143D
        asl     a                               ; 143E
        asl     a                               ; 143F
        asl     a                               ; 1440
        tay                                     ; 1441
        pla                                     ; 1442
        sta     L146D,x                         ; 1443
        dey                                     ; 1446
L1447:  asl     a                               ; 1447
        iny                                     ; 1448
        bcs     L1447                           ; 1449
        lda     L13A8,y                         ; 144B
        bpl     L1464                           ; 144E
        inc     L1476                           ; 1450
        ldx     L1476                           ; 1453
        cpx     #$10                            ; 1456
        bcc     L145E                           ; 1458
        dex                                     ; 145A
        stx     L1476                           ; 145B
L145E:  jsr     L1486                           ; 145E
        sta     L1476,x                         ; 1461
L1464:  rts                                     ; 1464

; ----------------------------------------------------------------------------
L1465:  asl     $00                             ; 1465
        brk                                     ; 1467
        brk                                     ; 1468
        brk                                     ; 1469
        brk                                     ; 146A
        .byte   $80                             ; 146B
        brk                                     ; 146C
L146D:  .byte   $FF                             ; 146D
        .byte   $FF                             ; 146E
        .byte   $FF                             ; 146F
        .byte   $FF                             ; 1470
        .byte   $FF                             ; 1471
        .byte   $FF                             ; 1472
        .byte   $FF                             ; 1473
        .byte   $FF                             ; 1474
L1475:  .byte   $FE                             ; 1475
L1476:  brk                                     ; 1476
L1477:  brk                                     ; 1477
L1478:  brk                                     ; 1478
        brk                                     ; 1479
        brk                                     ; 147A
        brk                                     ; 147B
        brk                                     ; 147C
        brk                                     ; 147D
        brk                                     ; 147E
        brk                                     ; 147F
        brk                                     ; 1480
        brk                                     ; 1481
        brk                                     ; 1482
        brk                                     ; 1483
        brk                                     ; 1484
        brk                                     ; 1485
L1486:  pha                                     ; 1486
        lda     #$FD                            ; 1487
        jsr     L14BF                           ; 1489
        and     #$80                            ; 148C
        bne     L14B4                           ; 148E
        nop                                     ; 1490
        nop                                     ; 1491
        nop                                     ; 1492
        nop                                     ; 1493
        nop                                     ; 1494
        nop                                     ; 1495
        nop                                     ; 1496
        nop                                     ; 1497
        nop                                     ; 1498
        pla                                     ; 1499
        cmp     #$B1                            ; 149A
        bcc     L14AC                           ; 149C
        cmp     #$BA                            ; 149E
        bcc     L14AD                           ; 14A0
        cmp     #$E1                            ; 14A2
        bcc     L14AC                           ; 14A4
        cmp     #$FB                            ; 14A6
        bcs     L14AC                           ; 14A8
        and     #$DF                            ; 14AA
L14AC:  rts                                     ; 14AC

; ----------------------------------------------------------------------------
L14AD:  and     #$0F                            ; 14AD
        tay                                     ; 14AF
        lda     L14B5,y                         ; 14B0
        rts                                     ; 14B3

; ----------------------------------------------------------------------------
L14B4:  pla                                     ; 14B4
L14B5:  rts                                     ; 14B5

; ----------------------------------------------------------------------------
        lda     ($A2,x)                         ; 14B6
        .byte   $A3                             ; 14B8
        ldy     $A5                             ; 14B9
        ldx     $A7                             ; 14BB
        tay                                     ; 14BD
        .byte   $A9                             ; 14BE
L14BF:  sta     $FD30                           ; 14BF
        sta     $FF08                           ; 14C2
        lda     $FF08                           ; 14C5
        rts                                     ; 14C8

; ----------------------------------------------------------------------------
        rts                                     ; 14C9

; ----------------------------------------------------------------------------
        rts                                     ; 14CA

; ----------------------------------------------------------------------------
L14CB:  pla                                     ; 14CB
        sta     L14DC                           ; 14CC
        pla                                     ; 14CF
        sta     L14DD                           ; 14D0
L14D3:  inc     L14DC                           ; 14D3
        bne     L14DB                           ; 14D6
        inc     L14DD                           ; 14D8
L14DB:  .byte   $AD                             ; 14DB
L14DC:  .byte   $FF                             ; 14DC
L14DD:  .byte   $FF                             ; 14DD
        beq     L14E6                           ; 14DE
        jsr     L1935                           ; 14E0
        jmp     L14D3                           ; 14E3

; ----------------------------------------------------------------------------
L14E6:  lda     L14DD                           ; 14E6
        pha                                     ; 14E9
        lda     L14DC                           ; 14EA
        pha                                     ; 14ED
        rts                                     ; 14EE

; ----------------------------------------------------------------------------
L14EF:  stx     L14F6                           ; 14EF
        sty     L14F7                           ; 14F2
L14F5:  .byte   $AD                             ; 14F5
L14F6:  .byte   $FF                             ; 14F6
L14F7:  .byte   $FF                             ; 14F7
        beq     L1508                           ; 14F8
        jsr     L1935                           ; 14FA
        inc     L14F6                           ; 14FD
        bne     L14F5                           ; 1500
        inc     L14F7                           ; 1502
        jmp     L14F5                           ; 1505

; ----------------------------------------------------------------------------
L1508:  rts                                     ; 1508

; ----------------------------------------------------------------------------
L1509:  ldx     #$32                            ; 1509
        ldy     #$64                            ; 150B
        jmp     L19E8                           ; 150D

; ----------------------------------------------------------------------------
L1510:  ldy     #$10                            ; 1510
L1512:  cmp     L1564,y                         ; 1512
        beq     L1547                           ; 1515
        dey                                     ; 1517
        bpl     L1512                           ; 1518
        pha                                     ; 151A
        jsr     L14CB                           ; 151B
        sta     $F2D0                           ; 151E
        .byte   $EF                             ; 1521
        cpy     $CF                             ; 1522
        .byte   $D3                             ; 1524
        ldy     #$E5                            ; 1525
        .byte   $F2                             ; 1527
        .byte   $F2                             ; 1528
        .byte   $EF                             ; 1529
        .byte   $F2                             ; 152A
        ldy     #$A3                            ; 152B
        ldy     $00                             ; 152D
        pla                                     ; 152F
        jsr     L19D2                           ; 1530
        jsr     L14CB                           ; 1533
        ldy     #$E8                            ; 1536
        sbc     ($F3,x)                         ; 1538
        ldy     #$EF                            ; 153A
        .byte   $E3                             ; 153C
        .byte   $E3                             ; 153D
        sbc     $F2,x                           ; 153E
        sbc     $E4                             ; 1540
        lda     ($00,x)                         ; 1542
        jmp     L155E                           ; 1544

; ----------------------------------------------------------------------------
L1547:  tya                                     ; 1547
        asl     a                               ; 1548
        tay                                     ; 1549
        ldx     L1575,y                         ; 154A
        lda     L1576,y                         ; 154D
        tay                                     ; 1550
        lda     #$8D                            ; 1551
        jsr     L1935                           ; 1553
        jsr     L14EF                           ; 1556
        lda     #$AE                            ; 1559
        jsr     L1935                           ; 155B
L155E:  jsr     L16AC                           ; 155E
        jmp     L1196                           ; 1561

; ----------------------------------------------------------------------------
L1564:  .byte   $27                             ; 1564
        plp                                     ; 1565
        .byte   $2B                             ; 1566
        rol     $402F                           ; 1567
        .byte   $44                             ; 156A
        eor     $46                             ; 156B
        .byte   $47                             ; 156D
        pha                                     ; 156E
        eor     #$4A                            ; 156F
        lsr     $5752                           ; 1571
        cli                                     ; 1574
L1575:  .byte   $97                             ; 1575
L1576:  ora     $A1,x                           ; 1576
        ora     $B5,x                           ; 1578
        ora     $C5,x                           ; 157A
        ora     $D5,x                           ; 157C
        ora     $E6,x                           ; 157E
        ora     $F7,x                           ; 1580
        ora     $08,x                           ; 1582
        asl     $1B,x                           ; 1584
        asl     $2A,x                           ; 1586
        asl     $3E,x                           ; 1588
        asl     $48,x                           ; 158A
        asl     $57,x                           ; 158C
        asl     $6A,x                           ; 158E
        asl     $76,x                           ; 1590
        asl     $88,x                           ; 1592
        asl     $99,x                           ; 1594
        asl     $C9,x                           ; 1596
        .byte   $AF                             ; 1598
        .byte   $CF                             ; 1599
        ldy     #$C5                            ; 159A
        .byte   $F2                             ; 159C
        .byte   $F2                             ; 159D
        .byte   $EF                             ; 159E
        .byte   $F2                             ; 159F
        brk                                     ; 15A0
        dec     $A0EF                           ; 15A1
        cpx     $E5                             ; 15A4
        inc     $E9,x                           ; 15A6
        .byte   $E3                             ; 15A8
        sbc     $A0                             ; 15A9
        .byte   $E3                             ; 15AB
        .byte   $EF                             ; 15AC
        .byte   $EE                             ; 15AD
        .byte   $EE                             ; 15AE
L15AF:  sbc     $E3                             ; 15AF
        .byte   $F4                             ; 15B1
        sbc     $E4                             ; 15B2
        brk                                     ; 15B4
        .byte   $D7                             ; 15B5
        .byte   $F2                             ; 15B6
        sbc     #$F4                            ; 15B7
        sbc     $A0                             ; 15B9
        beq     L15AF                           ; 15BB
        .byte   $EF                             ; 15BD
        .byte   $F4                             ; 15BE
        sbc     $E3                             ; 15BF
        .byte   $F4                             ; 15C1
        sbc     $E4                             ; 15C2
        brk                                     ; 15C4
        dec     $EF,x                           ; 15C5
        cpx     $EDF5                           ; 15C7
        sbc     $A0                             ; 15CA
        .byte   $F3                             ; 15CC
        .byte   $F7                             ; 15CD
        sbc     #$F4                            ; 15CE
        .byte   $E3                             ; 15D0
        inx                                     ; 15D1
        sbc     $E4                             ; 15D2
        brk                                     ; 15D4
        dec     $A0EF                           ; 15D5
        cpx     $E9                             ; 15D8
        .byte   $F3                             ; 15DA
        .byte   $EB                             ; 15DB
        ldy     #$E9                            ; 15DC
        inc     $E4A0                           ; 15DE
        .byte   $F2                             ; 15E1
        sbc     #$F6                            ; 15E2
        sbc     $00                             ; 15E4
        cmp     #$EE                            ; 15E6
        inc     $E1,x                           ; 15E8
        cpx     $E4E9                           ; 15EA
        ldy     #$F0                            ; 15ED
        sbc     ($F4,x)                         ; 15EF
        inx                                     ; 15F1
        inc     $EDE1                           ; 15F2
        sbc     $00                             ; 15F5
        dec     $EEEF                           ; 15F7
        sbc     $F8                             ; 15FA
        sbc     #$F3                            ; 15FC
        .byte   $F4                             ; 15FE
        sbc     ($EE,x)                         ; 15FF
        .byte   $F4                             ; 1601
        ldy     #$F0                            ; 1602
        sbc     ($F4,x)                         ; 1604
        inx                                     ; 1606
        brk                                     ; 1607
        dec     $EF,x                           ; 1608
        cpx     $EDF5                           ; 160A
        sbc     $A0                             ; 160D
        inc     $F4EF                           ; 160F
        ldy     #$ED                            ; 1612
        .byte   $EF                             ; 1614
        sbc     $EE,x                           ; 1615
        .byte   $F4                             ; 1617
        sbc     $E4                             ; 1618
L161A:  brk                                     ; 161A
        dec     $E9                             ; 161B
        cpx     $A0E5                           ; 161D
        inc     $F4EF                           ; 1620
        ldy     #$E6                            ; 1623
        .byte   $EF                             ; 1625
        sbc     $EE,x                           ; 1626
        cpx     $00                             ; 1628
        cpy     $F5                             ; 162A
        beq     L161A                           ; 162C
        sbc     #$E3                            ; 162E
        sbc     ($F4,x)                         ; 1630
        sbc     $A0                             ; 1632
        inc     $E9                             ; 1634
        cpx     $A0E5                           ; 1636
        inc     $EDE1                           ; 1639
        sbc     $00                             ; 163C
        cpy     $E9                             ; 163E
        .byte   $F3                             ; 1640
        .byte   $EB                             ; 1641
        ldy     #$E6                            ; 1642
        sbc     $EC,x                           ; 1644
        cpx     $C400                           ; 1646
        sbc     #$F2                            ; 1649
        sbc     $E3                             ; 164B
        .byte   $F4                             ; 164D
        .byte   $EF                             ; 164E
        .byte   $F2                             ; 164F
        sbc     $E6A0,y                         ; 1650
        sbc     $EC,x                           ; 1653
        cpx     $C200                           ; 1655
        sbc     ($E4,x)                         ; 1658
        ldy     #$D0                            ; 165A
        .byte   $F2                             ; 165C
        .byte   $EF                             ; 165D
        cpy     $CF                             ; 165E
        .byte   $D3                             ; 1660
        ldy     #$F6                            ; 1661
        sbc     $F2                             ; 1663
        .byte   $F3                             ; 1665
        sbc     #$EF                            ; 1666
        inc     $C600                           ; 1668
        sbc     #$EC                            ; 166B
        sbc     $A0                             ; 166D
        cpy     $E3EF                           ; 166F
        .byte   $EB                             ; 1672
        sbc     $E4                             ; 1673
        brk                                     ; 1675
        .byte   $CE                             ; 1676
        .byte   $EF                             ; 1677
L1678:  .byte   $F4                             ; 1678
        ldy     #$E1                            ; 1679
        ldy     #$D0                            ; 167B
        .byte   $F2                             ; 167D
        .byte   $EF                             ; 167E
        cpy     $CF                             ; 167F
        .byte   $D3                             ; 1681
        ldy     #$E4                            ; 1682
        sbc     #$F3                            ; 1684
        .byte   $EB                             ; 1686
        brk                                     ; 1687
        cpy     $F5                             ; 1688
        beq     L1678                           ; 168A
        sbc     #$E3                            ; 168C
        sbc     ($F4,x)                         ; 168E
        sbc     $A0                             ; 1690
        inc     $EF,x                           ; 1692
        cpx     $EDF5                           ; 1694
        sbc     $00                             ; 1697
        .byte   $C2                             ; 1699
        sbc     ($E4,x)                         ; 169A
        ldy     #$F6                            ; 169C
        .byte   $EF                             ; 169E
        cpx     $EDF5                           ; 169F
        sbc     $A0                             ; 16A2
        .byte   $E2                             ; 16A4
        sbc     #$F4                            ; 16A5
        ldy     #$ED                            ; 16A7
        sbc     ($F0,x)                         ; 16A9
        brk                                     ; 16AB
L16AC:  jsr     L14CB                           ; 16AC
        sta     $D08D                           ; 16AF
        .byte   $F2                             ; 16B2
        sbc     $F3                             ; 16B3
        .byte   $F3                             ; 16B5
        ldy     #$E1                            ; 16B6
        inc     $A0F9                           ; 16B8
        .byte   $EB                             ; 16BB
        sbc     $F9                             ; 16BC
        ldx     a:$8D                           ; 16BE
        jmp     L137B                           ; 16C1

; ----------------------------------------------------------------------------
L16C4:  ror     L16EE                           ; 16C4
L16C7:  jsr     L137B                           ; 16C7
        cmp     #$8D                            ; 16CA
        beq     L16E7                           ; 16CC
        cmp     #$CE                            ; 16CE
        beq     L16DF                           ; 16D0
        cmp     #$D9                            ; 16D2
        bne     L16C7                           ; 16D4
L16D6:  jsr     L14CB                           ; 16D6
        cmp     $F3E5,y                         ; 16D9
        brk                                     ; 16DC
        clc                                     ; 16DD
        rts                                     ; 16DE

; ----------------------------------------------------------------------------
L16DF:  jsr     L14CB                           ; 16DF
        dec     a:$EF                           ; 16E2
        sec                                     ; 16E5
        rts                                     ; 16E6

; ----------------------------------------------------------------------------
L16E7:  rol     L16EE                           ; 16E7
        bcc     L16D6                           ; 16EA
        bcs     L16DF                           ; 16EC
L16EE:  brk                                     ; 16EE
L16EF:  sta     L1831                           ; 16EF
        stx     $F8                             ; 16F2
        sty     $F9                             ; 16F4
        lsr     a                               ; 16F6
        bcs     L1701                           ; 16F7
        lda     #$00                            ; 16F9
        sta     L289C                           ; 16FB
        sta     L289B                           ; 16FE
L1701:  jsr     L18BC                           ; 1701
        ldx     #$00                            ; 1704
L1706:  txa                                     ; 1706
        pha                                     ; 1707
        jsr     L1933                           ; 1708
        lda     #$A1                            ; 170B
        jsr     L1935                           ; 170D
        lda     #$1B                            ; 1710
        sta     L289D                           ; 1712
        lda     #$A1                            ; 1715
        .byte   $20                             ; 1717
L1718:  and     $19,x                           ; 1718
        pla                                     ; 171A
        tax                                     ; 171B
        inx                                     ; 171C
        cpx     #$10                            ; 171D
        bcc     L1706                           ; 171F
        jsr     L18BC                           ; 1721
        lda     #$04                            ; 1724
        sta     L289E                           ; 1726
        lda     #$00                            ; 1729
L172B:  pha                                     ; 172B
        clc                                     ; 172C
        adc     L289B                           ; 172D
        jsr     L180D                           ; 1730
        inc     L289E                           ; 1733
        pla                                     ; 1736
        clc                                     ; 1737
        adc     #$01                            ; 1738
        cmp     #$10                            ; 173A
        bcc     L172B                           ; 173C
L173E:  jsr     L137B                           ; 173E
        ldy     #$08                            ; 1741
L1743:  cmp     L175B,y                         ; 1743
        beq     L174B                           ; 1746
        dey                                     ; 1748
        bne     L1743                           ; 1749
L174B:  tya                                     ; 174B
        asl     a                               ; 174C
        tay                                     ; 174D
        lda     L1764,y                         ; 174E
        sta     L0006                           ; 1751
        lda     L1765,y                         ; 1753
        sta     $07                             ; 1756
        jmp     (L0006)                         ; 1758

; ----------------------------------------------------------------------------
L175B:  brk                                     ; 175B
        txa                                     ; 175C
        .byte   $8B                             ; 175D
        sta     $88,x                           ; 175E
        .byte   $9B                             ; 1760
        sta     $F4D4                           ; 1761
L1764:  .byte   $CC                             ; 1764
L1765:  .byte   $17                             ; 1765
        ror     $17,x                           ; 1766
        ldx     $17                             ; 1768
        cpy     $CC17                           ; 176A
        .byte   $17                             ; 176D
        inc     $17,x                           ; 176E
        .byte   $CF                             ; 1770
        .byte   $17                             ; 1771
        .byte   $F2                             ; 1772
        .byte   $17                             ; 1773
        .byte   $F2                             ; 1774
        .byte   $17                             ; 1775
        lda     L289C                           ; 1776
        clc                                     ; 1779
        adc     #$01                            ; 177A
        bcs     L179C                           ; 177C
        ldy     #$00                            ; 177E
        cmp     ($F8),y                         ; 1780
        bcs     L179C                           ; 1782
        sta     L289C                           ; 1784
        sec                                     ; 1787
        sbc     L289B                           ; 1788
        cmp     #$10                            ; 178B
        bcc     L1795                           ; 178D
        inc     L289B                           ; 178F
        jsr     L186E                           ; 1792
L1795:  ldx     L289C                           ; 1795
        dex                                     ; 1798
        jmp     L17C3                           ; 1799

; ----------------------------------------------------------------------------
L179C:  ldx     #$8C                            ; 179C
        ldy     #$06                            ; 179E
        jsr     L19E8                           ; 17A0
        jmp     L173E                           ; 17A3

; ----------------------------------------------------------------------------
        lda     L289C                           ; 17A6
        beq     L179C                           ; 17A9
        dec     L289C                           ; 17AB
        lda     L289C                           ; 17AE
        sec                                     ; 17B1
        sbc     L289B                           ; 17B2
        cmp     #$10                            ; 17B5
        bcc     L17BF                           ; 17B7
        dec     L289B                           ; 17B9
        jsr     L1895                           ; 17BC
L17BF:  ldx     L289C                           ; 17BF
        inx                                     ; 17C2
L17C3:  ldy     L289C                           ; 17C3
        jsr     L17FA                           ; 17C6
        jmp     L173E                           ; 17C9

; ----------------------------------------------------------------------------
        jmp     L179C                           ; 17CC

; ----------------------------------------------------------------------------
        lda     L289C                           ; 17CF
        jsr     L17DA                           ; 17D2
        lda     L289C                           ; 17D5
        clc                                     ; 17D8
        rts                                     ; 17D9

; ----------------------------------------------------------------------------
L17DA:  inc     $F8                             ; 17DA
        asl     a                               ; 17DC
        bcc     L17E1                           ; 17DD
        inc     $F9                             ; 17DF
L17E1:  tay                                     ; 17E1
        lda     ($F8),y                         ; 17E2
        sta     $FA                             ; 17E4
        iny                                     ; 17E6
        lda     ($F8),y                         ; 17E7
        sta     $FB                             ; 17E9
        bcc     L17EF                           ; 17EB
        dec     $F9                             ; 17ED
L17EF:  dec     $F8                             ; 17EF
        rts                                     ; 17F1

; ----------------------------------------------------------------------------
        lda     #$FE                            ; 17F2
        sec                                     ; 17F4
        rts                                     ; 17F5

; ----------------------------------------------------------------------------
        lda     #$FF                            ; 17F6
        sec                                     ; 17F8
        rts                                     ; 17F9

; ----------------------------------------------------------------------------
L17FA:  tya                                     ; 17FA
        pha                                     ; 17FB
        jsr     L1801                           ; 17FC
        pla                                     ; 17FF
        tax                                     ; 1800
L1801:  txa                                     ; 1801
        sec                                     ; 1802
        sbc     L289B                           ; 1803
        clc                                     ; 1806
        adc     #$04                            ; 1807
        sta     L289E                           ; 1809
        txa                                     ; 180C
L180D:  ldx     #$01                            ; 180D
        stx     L289D                           ; 180F
        ldx     #$1B                            ; 1812
        stx     L186A                           ; 1814
        ldy     #$00                            ; 1817
        cmp     ($F8),y                         ; 1819
        bcc     L1820                           ; 181B
        jmp     L1860                           ; 181D

; ----------------------------------------------------------------------------
L1820:  cmp     L289C                           ; 1820
        bne     L182A                           ; 1823
        ldy     #$80                            ; 1825
        sty     L1989                           ; 1827
L182A:  pha                                     ; 182A
        jsr     L17DA                           ; 182B
        pla                                     ; 182E
        tay                                     ; 182F
        .byte   $A9                             ; 1830
L1831:  brk                                     ; 1831
        lsr     a                               ; 1832
        lsr     a                               ; 1833
        lsr     a                               ; 1834
        lsr     a                               ; 1835
        and     #$0E                            ; 1836
        tax                                     ; 1838
        lda     L1846,x                         ; 1839
        sta     L0006                           ; 183C
        lda     L1847,x                         ; 183E
        sta     $07                             ; 1841
        jmp     (L0006)                         ; 1843

; ----------------------------------------------------------------------------
L1846:  pha                                     ; 1846
L1847:  clc                                     ; 1847
        ldy     #$00                            ; 1848
L184A:  lda     ($FA),y                         ; 184A
        beq     L1860                           ; 184C
        ora     #$80                            ; 184E
        jsr     L1935                           ; 1850
        lda     ($FA),y                         ; 1853
        bpl     L1860                           ; 1855
        iny                                     ; 1857
        lda     L289D                           ; 1858
        cmp     L186A                           ; 185B
        bcc     L184A                           ; 185E
L1860:  jsr     L1869                           ; 1860
        lda     #$00                            ; 1863
        sta     L1989                           ; 1865
        rts                                     ; 1868

; ----------------------------------------------------------------------------
L1869:  .byte   $A9                             ; 1869
L186A:  brk                                     ; 186A
        jmp     L19B8                           ; 186B

; ----------------------------------------------------------------------------
L186E:  ldx     #$04                            ; 186E
L1870:  lda     L18DF,x                         ; 1870
        sta     $09                             ; 1873
        lda     L18F7,x                         ; 1875
        sta     $0A                             ; 1878
        lda     L18DE,x                         ; 187A
        sta     L0006                           ; 187D
        lda     L18F6,x                         ; 187F
        sta     $07                             ; 1882
        ldy     #$01                            ; 1884
L1886:  lda     ($09),y                         ; 1886
        sta     (L0006),y                       ; 1888
        iny                                     ; 188A
        cpy     #$1B                            ; 188B
        bcc     L1886                           ; 188D
        inx                                     ; 188F
        cpx     #$13                            ; 1890
        bcc     L1870                           ; 1892
        rts                                     ; 1894

; ----------------------------------------------------------------------------
L1895:  ldx     #$12                            ; 1895
L1897:  lda     L18DF,x                         ; 1897
        sta     L0006                           ; 189A
        lda     L18F7,x                         ; 189C
        sta     $07                             ; 189F
        .byte   $BD                             ; 18A1
L18A2:  dec     $8518,x                         ; 18A2
        ora     #$BD                            ; 18A5
        inc     $18,x                           ; 18A7
        sta     $0A                             ; 18A9
        ldy     #$01                            ; 18AB
L18AD:  lda     ($09),y                         ; 18AD
        sta     (L0006),y                       ; 18AF
        iny                                     ; 18B1
        cpy     #$1B                            ; 18B2
        bcc     L18AD                           ; 18B4
        dex                                     ; 18B6
        cpx     #$03                            ; 18B7
        bcs     L1897                           ; 18B9
        rts                                     ; 18BB

; ----------------------------------------------------------------------------
L18BC:  jsr     L14CB                           ; 18BC
        sta     $ADAB                           ; 18BF
        lda     $ADAD                           ; 18C2
        lda     $ADAD                           ; 18C5
        lda     $ADAD                           ; 18C8
        lda     $ADAD                           ; 18CB
        lda     $ADAD                           ; 18CE
        lda     $ADAD                           ; 18D1
        lda     $ADAD                           ; 18D4
        lda     $ADAD                           ; 18D7
        lda     a:$AB                           ; 18DA
        rts                                     ; 18DD

; ----------------------------------------------------------------------------
L18DE:  brk                                     ; 18DE
L18DF:  plp                                     ; 18DF
        bvc     L195A                           ; 18E0
        ldy     #$C8                            ; 18E2
        beq     L18FE                           ; 18E4
        rti                                     ; 18E6

; ----------------------------------------------------------------------------
        pla                                     ; 18E7
        bcc     L18A2                           ; 18E8
L18EA:  cpx     #$08                            ; 18EA
        bmi     L1946                           ; 18EC
        .byte   $80                             ; 18EE
        tay                                     ; 18EF
        bne     L18EA                           ; 18F0
        jsr     L7048                           ; 18F2
        tya                                     ; 18F5
L18F6:  .byte   $0C                             ; 18F6
L18F7:  .byte   $0C                             ; 18F7
        .byte   $0C                             ; 18F8
        .byte   $0C                             ; 18F9
        .byte   $0C                             ; 18FA
        .byte   $0C                             ; 18FB
        .byte   $0C                             ; 18FC
        .byte   $0D                             ; 18FD
L18FE:  ora     $0D0D                           ; 18FE
        ora     $0E0D                           ; 1901
        asl     $0E0E                           ; 1904
        asl     $0E0E                           ; 1907
        .byte   $0F                             ; 190A
        .byte   $0F                             ; 190B
        .byte   $0F                             ; 190C
        .byte   $0F                             ; 190D
L190E:  ldx     #$00                            ; 190E
        .byte   $2C                             ; 1910
L1911:  ldx     #$02                            ; 1911
        stx     L289E                           ; 1913
L1916:  lda     L18DE,x                         ; 1916
        sta     L0006                           ; 1919
        lda     L18F6,x                         ; 191B
        sta     $07                             ; 191E
        ldy     #$27                            ; 1920
        lda     #$20                            ; 1922
L1924:  sta     (L0006),y                       ; 1924
        dey                                     ; 1926
        bpl     L1924                           ; 1927
        inx                                     ; 1929
        cpx     #$18                            ; 192A
        bcc     L1916                           ; 192C
        iny                                     ; 192E
        sty     L289D                           ; 192F
        rts                                     ; 1932

; ----------------------------------------------------------------------------
L1933:  lda     #$8D                            ; 1933
L1935:  sta     L194E                           ; 1935
        pha                                     ; 1938
        txa                                     ; 1939
        pha                                     ; 193A
        tya                                     ; 193B
        pha                                     ; 193C
        ldx     L289E                           ; 193D
        lda     L18DE,x                         ; 1940
        sta     L0006                           ; 1943
        .byte   $BD                             ; 1945
L1946:  inc     $18,x                           ; 1946
        sta     $07                             ; 1948
        ldy     L289D                           ; 194A
        .byte   $A9                             ; 194D
L194E:  brk                                     ; 194E
        cmp     #$8D                            ; 194F
        beq     L196E                           ; 1951
        and     #$7F                            ; 1953
        cmp     #$60                            ; 1955
        bcc     L195B                           ; 1957
        .byte   $29                             ; 1959
L195A:  .byte   $1F                             ; 195A
L195B:  bit     L1989                           ; 195B
        bpl     L1962                           ; 195E
        ora     #$80                            ; 1960
L1962:  sta     (L0006),y                       ; 1962
        inc     L289D                           ; 1964
        lda     L289D                           ; 1967
        cmp     #$28                            ; 196A
        bcc     L1983                           ; 196C
L196E:  lda     #$00                            ; 196E
        sta     L289D                           ; 1970
        inc     L289E                           ; 1973
        lda     L289E                           ; 1976
        cmp     #$18                            ; 1979
        bcc     L1983                           ; 197B
        dec     L289E                           ; 197D
        jsr     L198A                           ; 1980
L1983:  pla                                     ; 1983
        tay                                     ; 1984
        pla                                     ; 1985
        tax                                     ; 1986
        pla                                     ; 1987
        rts                                     ; 1988

; ----------------------------------------------------------------------------
L1989:  brk                                     ; 1989
L198A:  ldx     #$02                            ; 198A
L198C:  lda     L18DF,x                         ; 198C
        sta     $09                             ; 198F
        lda     L18F7,x                         ; 1991
        sta     $0A                             ; 1994
        lda     L18DE,x                         ; 1996
        sta     L0006                           ; 1999
        lda     L18F6,x                         ; 199B
        sta     $07                             ; 199E
        ldy     #$27                            ; 19A0
L19A2:  lda     ($09),y                         ; 19A2
        sta     (L0006),y                       ; 19A4
        dey                                     ; 19A6
        bpl     L19A2                           ; 19A7
        inx                                     ; 19A9
        cpx     #$17                            ; 19AA
        bcc     L198C                           ; 19AC
        ldy     #$27                            ; 19AE
        lda     #$A0                            ; 19B0
L19B2:  sta     ($09),y                         ; 19B2
        dey                                     ; 19B4
        bpl     L19B2                           ; 19B5
        rts                                     ; 19B7

; ----------------------------------------------------------------------------
L19B8:  sta     L289F                           ; 19B8
L19BB:  lda     L289D                           ; 19BB
        cmp     L289F                           ; 19BE
        bcs     L19CB                           ; 19C1
        lda     #$A0                            ; 19C3
        jsr     L1935                           ; 19C5
        jmp     L19BB                           ; 19C8

; ----------------------------------------------------------------------------
L19CB:  lda     L289F                           ; 19CB
        sta     L289D                           ; 19CE
        rts                                     ; 19D1

; ----------------------------------------------------------------------------
L19D2:  pha                                     ; 19D2
        lsr     a                               ; 19D3
        lsr     a                               ; 19D4
        lsr     a                               ; 19D5
        lsr     a                               ; 19D6
        jsr     L19DB                           ; 19D7
        pla                                     ; 19DA
L19DB:  and     #$0F                            ; 19DB
        ora     #$B0                            ; 19DD
        cmp     #$BA                            ; 19DF
        bcc     L19E5                           ; 19E1
        adc     #$06                            ; 19E3
L19E5:  jmp     L1935                           ; 19E5

; ----------------------------------------------------------------------------
L19E8:  stx     L0006                           ; 19E8
        sty     $07                             ; 19EA
        nop                                     ; 19EC
        nop                                     ; 19ED
        ldy     #$00                            ; 19EE
        lda     #$30                            ; 19F0
L19F2:  ldx     L0006                           ; 19F2
        eor     #$0F                            ; 19F4
        sta     $FF11                           ; 19F6
L19F9:  dey                                     ; 19F9
        bne     L1A00                           ; 19FA
        dec     $07                             ; 19FC
        beq     L1A05                           ; 19FE
L1A00:  dex                                     ; 1A00
        bne     L19F9                           ; 1A01
        beq     L19F2                           ; 1A03
L1A05:  lda     #$00                            ; 1A05
        sta     $FF11                           ; 1A07
        rts                                     ; 1A0A

; ----------------------------------------------------------------------------
L1A0B:  lda     #$00                            ; 1A0B
        sta     L1BDC                           ; 1A0D
        sta     L1BDD                           ; 1A10
L1A13:  jsr     L1AE2                           ; 1A13
        jsr     L1B3B                           ; 1A16
        jsr     L1AE5                           ; 1A19
        lda     L1BDC                           ; 1A1C
        ora     L1BDD                           ; 1A1F
        bne     L1A29                           ; 1A22
        jsr     L1A5C                           ; 1A24
        bcs     L1A2E                           ; 1A27
L1A29:  jsr     L1B86                           ; 1A29
        bcc     L1A13                           ; 1A2C
L1A2E:  jsr     L1911                           ; 1A2E
        jsr     L14CB                           ; 1A31
        sta     $E1C2                           ; 1A34
        .byte   $E3                             ; 1A37
        .byte   $EB                             ; 1A38
        sbc     $F0,x                           ; 1A39
        ldy     #$E1                            ; 1A3B
        inc     $F4EF                           ; 1A3D
        inx                                     ; 1A40
        sbc     $F2                             ; 1A41
        ldy     #$E4                            ; 1A43
        sbc     #$F3                            ; 1A45
        .byte   $EB                             ; 1A47
        .byte   $BF                             ; 1A48
        ldy     #$A8                            ; 1A49
        cmp     $CEAF,y                         ; 1A4B
        lda     #$A0                            ; 1A4E
        brk                                     ; 1A50
        sec                                     ; 1A51
        jsr     L16C4                           ; 1A52
        bcc     L1A0B                           ; 1A55
        jmp     L1196                           ; 1A57

; ----------------------------------------------------------------------------
L1A5A:  .byte   $AB                             ; 1A5A
L1A5B:  .byte   $02                             ; 1A5B
L1A5C:  lda     #$12                            ; 1A5C
        sta     L1159                           ; 1A5E
        lda     #$00                            ; 1A61
        sta     L115A                           ; 1A63
        lda     #$00                            ; 1A66
        sta     $D6                             ; 1A68
        lda     #$FC                            ; 1A6A
        sta     $D7                             ; 1A6C
        lda     #$01                            ; 1A6E
        sta     $D5                             ; 1A70
        jsr     L1097                           ; 1A72
        bcs     L1AAD                           ; 1A75
        jsr     L14CB                           ; 1A77
        sta     $C68D                           ; 1A7A
        .byte   $EF                             ; 1A7D
        .byte   $F2                             ; 1A7E
        sbc     $F4E1                           ; 1A7F
        ldy     #$00                            ; 1A82
        ldy     #$00                            ; 1A84
L1A86:  lda     $FC90,y                         ; 1A86
        ora     #$80                            ; 1A89
        jsr     L1935                           ; 1A8B
        iny                                     ; 1A8E
        cpy     #$18                            ; 1A8F
        bcc     L1A86                           ; 1A91
        jsr     L14CB                           ; 1A93
        .byte   $BF                             ; 1A96
        sta     $D9A8                           ; 1A97
        .byte   $AF                             ; 1A9A
        dec     $A0A9                           ; 1A9B
        brk                                     ; 1A9E
        ldx     #$8C                            ; 1A9F
        ldy     #$06                            ; 1AA1
        jsr     L19E8                           ; 1AA3
        sec                                     ; 1AA6
        jsr     L16C4                           ; 1AA7
        bcc     L1AAD                           ; 1AAA
L1AAC:  rts                                     ; 1AAC

; ----------------------------------------------------------------------------
L1AAD:  jsr     L14CB                           ; 1AAD
        sta     $EFC6                           ; 1AB0
        .byte   $F2                             ; 1AB3
        sbc     $F4E1                           ; 1AB4
        .byte   $F4                             ; 1AB7
        sbc     #$EE                            ; 1AB8
        .byte   $E7                             ; 1ABA
        ldy     #$E4                            ; 1ABB
        sbc     #$F3                            ; 1ABD
        .byte   $EB                             ; 1ABF
        ldx     $AEAE                           ; 1AC0
        brk                                     ; 1AC3
        lda     #$01                            ; 1AC4
        sta     L1159                           ; 1AC6
        lda     #$00                            ; 1AC9
        sta     L115A                           ; 1ACB
        lda     #$00                            ; 1ACE
        sta     $D6                             ; 1AD0
        lda     #$FC                            ; 1AD2
        sta     $D7                             ; 1AD4
        lda     #$03                            ; 1AD6
        sta     $D5                             ; 1AD8
        jsr     L1097                           ; 1ADA
        bcc     L1AAC                           ; 1ADD
        jmp     L1510                           ; 1ADF

; ----------------------------------------------------------------------------
L1AE2:  lda     #$00                            ; 1AE2
        .byte   $2C                             ; 1AE4
L1AE5:  lda     #$01                            ; 1AE5
        pha                                     ; 1AE7
        jsr     L1911                           ; 1AE8
        jsr     L14CB                           ; 1AEB
        sta     $ECD0                           ; 1AEE
        sbc     $E1                             ; 1AF1
        .byte   $F3                             ; 1AF3
        sbc     $A0                             ; 1AF4
        sbc     #$EE                            ; 1AF6
        .byte   $F3                             ; 1AF8
        sbc     $F2                             ; 1AF9
        .byte   $F4                             ; 1AFB
        ldy     #$F4                            ; 1AFC
        inx                                     ; 1AFE
        sbc     $A0                             ; 1AFF
        brk                                     ; 1B01
        pla                                     ; 1B02
        bne     L1B12                           ; 1B03
        jsr     L14CB                           ; 1B05
        .byte   $D3                             ; 1B08
        .byte   $CF                             ; 1B09
        cmp     $D2,x                           ; 1B0A
        .byte   $C3                             ; 1B0C
        cmp     $00                             ; 1B0D
        jmp     L1B21                           ; 1B0F

; ----------------------------------------------------------------------------
L1B12:  jsr     L14CB                           ; 1B12
        cpy     $C5                             ; 1B15
        .byte   $D3                             ; 1B17
        .byte   $D4                             ; 1B18
        cmp     #$CE                            ; 1B19
        cmp     ($D4,x)                         ; 1B1B
        cmp     #$CF                            ; 1B1D
        .byte   $CE                             ; 1B1F
        brk                                     ; 1B20
L1B21:  jsr     L14CB                           ; 1B21
        sta     $E9E4                           ; 1B24
        .byte   $F3                             ; 1B27
        .byte   $EB                             ; 1B28
        ldy     #$E9                            ; 1B29
        inc     $F4A0                           ; 1B2B
        inx                                     ; 1B2E
        sbc     $A0                             ; 1B2F
        cpx     $F2                             ; 1B31
        sbc     #$F6                            ; 1B33
        sbc     $AE                             ; 1B35
        brk                                     ; 1B37
        jmp     L16AC                           ; 1B38

; ----------------------------------------------------------------------------
L1B3B:  jsr     L1911                           ; 1B3B
        jsr     L14CB                           ; 1B3E
        sta     $E5D2                           ; 1B41
        sbc     ($E4,x)                         ; 1B44
        sbc     #$EE                            ; 1B46
        .byte   $E7                             ; 1B48
        ldx     $AEAE                           ; 1B49
        brk                                     ; 1B4C
        lda     L1BDC                           ; 1B4D
        sta     $D8                             ; 1B50
        lda     L1BDD                           ; 1B52
        sta     $D9                             ; 1B55
        lda     #$A1                            ; 1B57
        sta     $D6                             ; 1B59
        lda     #$28                            ; 1B5B
        sta     $D7                             ; 1B5D
L1B5F:  lda     #$01                            ; 1B5F
        sta     $D5                             ; 1B61
        jsr     L10DF                           ; 1B63
        bcs     L1B83                           ; 1B66
        inc     $D7                             ; 1B68
        inc     $D8                             ; 1B6A
        bne     L1B70                           ; 1B6C
        inc     $D9                             ; 1B6E
L1B70:  lda     $D8                             ; 1B70
        cmp     L1A5A                           ; 1B72
        lda     $D9                             ; 1B75
        sbc     L1A5B                           ; 1B77
        bcs     L1B82                           ; 1B7A
        lda     $D7                             ; 1B7C
        cmp     #$FB                            ; 1B7E
        bcc     L1B5F                           ; 1B80
L1B82:  rts                                     ; 1B82

; ----------------------------------------------------------------------------
L1B83:  jmp     L1510                           ; 1B83

; ----------------------------------------------------------------------------
L1B86:  jsr     L1911                           ; 1B86
        jsr     L14CB                           ; 1B89
        sta     $F2D7                           ; 1B8C
        sbc     #$F4                            ; 1B8F
        sbc     #$EE                            ; 1B91
        .byte   $E7                             ; 1B93
        ldx     $AEAE                           ; 1B94
        brk                                     ; 1B97
        lda     L1BDC                           ; 1B98
        sta     $D8                             ; 1B9B
        lda     L1BDD                           ; 1B9D
        sta     $D9                             ; 1BA0
        lda     #$A1                            ; 1BA2
        sta     $D6                             ; 1BA4
        lda     #$28                            ; 1BA6
        sta     $D7                             ; 1BA8
L1BAA:  lda     #$02                            ; 1BAA
        sta     $D5                             ; 1BAC
        jsr     L10DF                           ; 1BAE
        bcs     L1BD9                           ; 1BB1
        inc     $D7                             ; 1BB3
        inc     $D8                             ; 1BB5
        bne     L1BBB                           ; 1BB7
        inc     $D9                             ; 1BB9
L1BBB:  lda     $D8                             ; 1BBB
        cmp     L1A5A                           ; 1BBD
        lda     $D9                             ; 1BC0
        sbc     L1A5B                           ; 1BC2
        bcs     L1BCE                           ; 1BC5
        lda     $D7                             ; 1BC7
        cmp     #$FB                            ; 1BC9
        bcc     L1BAA                           ; 1BCB
        clc                                     ; 1BCD
L1BCE:  lda     $D8                             ; 1BCE
        sta     L1BDC                           ; 1BD0
        lda     $D9                             ; 1BD3
        sta     L1BDD                           ; 1BD5
        rts                                     ; 1BD8

; ----------------------------------------------------------------------------
L1BD9:  jmp     L1510                           ; 1BD9

; ----------------------------------------------------------------------------
L1BDC:  brk                                     ; 1BDC
L1BDD:  brk                                     ; 1BDD
L1BDE:  jsr     L1911                           ; 1BDE
        jsr     L14CB                           ; 1BE1
        .byte   $D4                             ; 1BE4
        .byte   $F2                             ; 1BE5
        sbc     ($EE,x)                         ; 1BE6
        .byte   $F3                             ; 1BE8
        inc     $E5                             ; 1BE9
        .byte   $F2                             ; 1BEB
        ldy     #$E3                            ; 1BEC
        inx                                     ; 1BEE
        sbc     ($F2,x)                         ; 1BEF
        sbc     ($E3,x)                         ; 1BF1
        .byte   $F4                             ; 1BF3
        sbc     $F2                             ; 1BF4
        .byte   $F3                             ; 1BF6
        sta     $B18D                           ; 1BF7
        lda     #$A0                            ; 1BFA
        .byte   $C2                             ; 1BFC
        sbc     ($F2,x)                         ; 1BFD
        cpx     $A7                             ; 1BFF
        .byte   $F3                             ; 1C01
        ldy     #$D4                            ; 1C02
        sbc     ($EC,x)                         ; 1C04
        sbc     $A0                             ; 1C06
        cmp     #$A0                            ; 1C08
        tsx                                     ; 1C0A
        ldy     #$D4                            ; 1C0B
        sbc     ($EC,x)                         ; 1C0D
        sbc     $F3                             ; 1C0F
        ldy     #$EF                            ; 1C11
        inc     $A0                             ; 1C13
        .byte   $F4                             ; 1C15
        inx                                     ; 1C16
        sbc     $A0                             ; 1C17
        cmp     $EE,x                           ; 1C19
        .byte   $EB                             ; 1C1B
        inc     $F7EF                           ; 1C1C
        inc     $B28D                           ; 1C1F
        lda     #$A0                            ; 1C22
        .byte   $C2                             ; 1C24
        sbc     ($F2,x)                         ; 1C25
        cpx     $A7                             ; 1C27
        .byte   $F3                             ; 1C29
        ldy     #$D4                            ; 1C2A
        sbc     ($EC,x)                         ; 1C2C
        sbc     $A0                             ; 1C2E
        cmp     #$C9                            ; 1C30
        ldy     #$BA                            ; 1C32
        ldy     #$D4                            ; 1C34
        inx                                     ; 1C36
        sbc     $A0                             ; 1C37
        cpy     $E5                             ; 1C39
        .byte   $F3                             ; 1C3B
        .byte   $F4                             ; 1C3C
        sbc     #$EE                            ; 1C3D
        sbc     $CBA0,y                         ; 1C3F
        inc     $E7E9                           ; 1C42
        inx                                     ; 1C45
        .byte   $F4                             ; 1C46
        sta     $A9B3                           ; 1C47
        ldy     #$C2                            ; 1C4A
        sbc     ($F2,x)                         ; 1C4C
        cpx     $A7                             ; 1C4E
        .byte   $F3                             ; 1C50
        ldy     #$D4                            ; 1C51
        sbc     ($EC,x)                         ; 1C53
        sbc     $A0                             ; 1C55
        cmp     #$C9                            ; 1C57
        cmp     #$A0                            ; 1C59
        tsx                                     ; 1C5B
        ldy     #$D4                            ; 1C5C
        inx                                     ; 1C5E
        sbc     $A0                             ; 1C5F
        .byte   $D4                             ; 1C61
        inx                                     ; 1C62
        sbc     #$E5                            ; 1C63
        inc     $A0                             ; 1C65
        .byte   $EF                             ; 1C67
        inc     $A0                             ; 1C68
        dec     $E1                             ; 1C6A
        .byte   $F4                             ; 1C6C
        sbc     $8D                             ; 1C6D
        sta     $EFCE                           ; 1C6F
        .byte   $F4                             ; 1C72
        sbc     $BA                             ; 1C73
        ldy     #$D4                            ; 1C75
        .byte   $F2                             ; 1C77
        sbc     ($EE,x)                         ; 1C78
        .byte   $F3                             ; 1C7A
        inc     $E5                             ; 1C7B
        .byte   $F2                             ; 1C7D
        .byte   $F2                             ; 1C7E
        sbc     #$EE                            ; 1C7F
        .byte   $E7                             ; 1C81
        ldy     #$E3                            ; 1C82
        inx                                     ; 1C84
        sbc     ($F2,x)                         ; 1C85
        sbc     ($E3,x)                         ; 1C87
        .byte   $F4                             ; 1C89
        sbc     $F2                             ; 1C8A
        .byte   $F3                             ; 1C8C
        ldy     #$F7                            ; 1C8D
        sbc     #$EC                            ; 1C8F
        cpx     $F7A0                           ; 1C91
        sbc     #$F0                            ; 1C94
        sbc     $8D                             ; 1C96
        .byte   $EF                             ; 1C98
        sbc     $F4,x                           ; 1C99
        ldy     #$E1                            ; 1C9B
        inc     $A0F9                           ; 1C9D
        sbc     $F8                             ; 1CA0
        sbc     #$F3                            ; 1CA2
        .byte   $F4                             ; 1CA4
        sbc     #$EE                            ; 1CA5
        .byte   $E7                             ; 1CA7
        ldy     #$F3                            ; 1CA8
        sbc     ($F6,x)                         ; 1CAA
        sbc     $E4                             ; 1CAC
        ldy     #$E7                            ; 1CAE
        sbc     ($ED,x)                         ; 1CB0
        sbc     $A1                             ; 1CB2
        lda     ($00,x)                         ; 1CB4
L1CB6:  jsr     L137B                           ; 1CB6
        cmp     #$9B                            ; 1CB9
        bne     L1CC0                           ; 1CBB
        jmp     L1196                           ; 1CBD

; ----------------------------------------------------------------------------
L1CC0:  cmp     #$B1                            ; 1CC0
        bcc     L1CB6                           ; 1CC2
        cmp     #$B4                            ; 1CC4
        bcs     L1CB6                           ; 1CC6
        sec                                     ; 1CC8
        sbc     #$B1                            ; 1CC9
        sta     L2893                           ; 1CCB
        jsr     L1911                           ; 1CCE
        jsr     L1AE2                           ; 1CD1
        jsr     L1CEB                           ; 1CD4
        jsr     L1E83                           ; 1CD7
        jsr     L23A5                           ; 1CDA
        jsr     L240A                           ; 1CDD
        bcs     L1CE8                           ; 1CE0
        jsr     L237D                           ; 1CE2
        jsr     L2755                           ; 1CE5
L1CE8:  jmp     L1BDE                           ; 1CE8

; ----------------------------------------------------------------------------
L1CEB:  jsr     L14CB                           ; 1CEB
        sta     $E5D2                           ; 1CEE
        sbc     ($E4,x)                         ; 1CF1
        sbc     #$EE                            ; 1CF3
        .byte   $E7                             ; 1CF5
        ldy     #$E3                            ; 1CF6
        inx                                     ; 1CF8
        sbc     ($F2,x)                         ; 1CF9
        sbc     ($E3,x)                         ; 1CFB
        .byte   $F4                             ; 1CFD
        sbc     $F2                             ; 1CFE
        ldy     #$E4                            ; 1D00
        sbc     ($F4,x)                         ; 1D02
        sbc     ($AE,x)                         ; 1D04
        ldx     a:$AE                           ; 1D06
        lda     #$A1                            ; 1D09
        sta     $D6                             ; 1D0B
        lda     #$48                            ; 1D0D
        sta     $D7                             ; 1D0F
        lda     L2893                           ; 1D11
        asl     a                               ; 1D14
        tay                                     ; 1D15
        lda     L1D23,y                         ; 1D16
        sta     L0006                           ; 1D19
        lda     L1D24,y                         ; 1D1B
        sta     $07                             ; 1D1E
        jmp     (L0006)                         ; 1D20

; ----------------------------------------------------------------------------
L1D23:  .byte   $84                             ; 1D23
L1D24:  ora     L1D61,x                         ; 1D24
        and     #$1D                            ; 1D27
        ldx     #$00                            ; 1D29
        lda     #$1D                            ; 1D2B
        sta     L1159                           ; 1D2D
L1D30:  stx     L1D50                           ; 1D30
        lda     L1D51,x                         ; 1D33
        sta     L115A                           ; 1D36
        lda     #$01                            ; 1D39
        sta     $D5                             ; 1D3B
        jsr     L1097                           ; 1D3D
        bcc     L1D45                           ; 1D40
        jmp     L1510                           ; 1D42

; ----------------------------------------------------------------------------
L1D45:  inc     $D7                             ; 1D45
        ldx     L1D50                           ; 1D47
        inx                                     ; 1D4A
        cpx     #$10                            ; 1D4B
        bcc     L1D30                           ; 1D4D
        rts                                     ; 1D4F

; ----------------------------------------------------------------------------
L1D50:  brk                                     ; 1D50
L1D51:  .byte   $0B                             ; 1D51
        .byte   $04                             ; 1D52
        .byte   $0F                             ; 1D53
        php                                     ; 1D54
        ora     ($0C,x)                         ; 1D55
        ora     $10                             ; 1D57
        ora     #$02                            ; 1D59
        ora     L1106                           ; 1D5B
        asl     a                               ; 1D5E
        .byte   $03                             ; 1D5F
        .byte   $0E                             ; 1D60
L1D61:  lda     #$02                            ; 1D61
        sta     L1159                           ; 1D63
        lda     #$00                            ; 1D66
        sta     L115A                           ; 1D68
L1D6B:  lda     #$01                            ; 1D6B
        sta     $D5                             ; 1D6D
        jsr     L1097                           ; 1D6F
        bcc     L1D77                           ; 1D72
        jmp     L1510                           ; 1D74

; ----------------------------------------------------------------------------
L1D77:  inc     $D7                             ; 1D77
        inc     L115A                           ; 1D79
        lda     L115A                           ; 1D7C
        cmp     #$10                            ; 1D7F
        bcc     L1D6B                           ; 1D81
        rts                                     ; 1D83

; ----------------------------------------------------------------------------
        ldx     #$10                            ; 1D84
        ldy     #$00                            ; 1D86
        lda     #$A1                            ; 1D88
        sta     L0006                           ; 1D8A
        lda     #$48                            ; 1D8C
        sta     $07                             ; 1D8E
        tya                                     ; 1D90
L1D91:  sta     (L0006),y                       ; 1D91
        iny                                     ; 1D93
        bne     L1D91                           ; 1D94
        inc     $07                             ; 1D96
        dex                                     ; 1D98
        bne     L1D91                           ; 1D99
        ldx     #$A2                            ; 1D9B
        ldy     #$1D                            ; 1D9D
        jmp     L1DA7                           ; 1D9F

; ----------------------------------------------------------------------------
        dec     $B0CD                           ; 1DA2
        bcs     L1DA7                           ; 1DA5
L1DA7:  stx     L1E5E                           ; 1DA7
        sty     L1E5F                           ; 1DAA
        lda     #$12                            ; 1DAD
        sta     L1159                           ; 1DAF
        lda     #$00                            ; 1DB2
        sta     L115A                           ; 1DB4
        jsr     L1E6E                           ; 1DB7
L1DBA:  lda     $FC00                           ; 1DBA
        sta     L1159                           ; 1DBD
        lda     $FC01                           ; 1DC0
        sta     L115A                           ; 1DC3
        lda     L1159                           ; 1DC6
        bne     L1DCD                           ; 1DC9
        sec                                     ; 1DCB
        rts                                     ; 1DCC

; ----------------------------------------------------------------------------
L1DCD:  jsr     L1E6E                           ; 1DCD
        lda     #$00                            ; 1DD0
        pha                                     ; 1DD2
        pla                                     ; 1DD3
L1DD4:  pha                                     ; 1DD4
        jsr     L1E4E                           ; 1DD5
        bcc     L1DE5                           ; 1DD8
        pla                                     ; 1DDA
        clc                                     ; 1DDB
        adc     #$01                            ; 1DDC
        cmp     #$08                            ; 1DDE
        bcc     L1DD4                           ; 1DE0
        jmp     L1DBA                           ; 1DE2

; ----------------------------------------------------------------------------
L1DE5:  pla                                     ; 1DE5
        asl     a                               ; 1DE6
        asl     a                               ; 1DE7
        asl     a                               ; 1DE8
        asl     a                               ; 1DE9
        asl     a                               ; 1DEA
        tax                                     ; 1DEB
        lda     $FC03,x                         ; 1DEC
        sta     L1159                           ; 1DEF
        lda     $FC04,x                         ; 1DF2
        sta     L115A                           ; 1DF5
        lda     #$9F                            ; 1DF8
        sta     L1E43                           ; 1DFA
        lda     #$49                            ; 1DFD
        sta     L1E44                           ; 1DFF
        lda     L1159                           ; 1E02
        beq     L1E1E                           ; 1E05
L1E07:  jsr     L1E6E                           ; 1E07
        jsr     L1E20                           ; 1E0A
        lda     $FC00                           ; 1E0D
        sta     L1159                           ; 1E10
        lda     $FC01                           ; 1E13
        sta     L115A                           ; 1E16
        lda     L1159                           ; 1E19
        bne     L1E07                           ; 1E1C
L1E1E:  clc                                     ; 1E1E
        rts                                     ; 1E1F

; ----------------------------------------------------------------------------
L1E20:  lda     $FC00                           ; 1E20
        beq     L1E31                           ; 1E23
        ldy     #$02                            ; 1E25
L1E27:  lda     $FC00,y                         ; 1E27
        jsr     L1E42                           ; 1E2A
        iny                                     ; 1E2D
        bne     L1E27                           ; 1E2E
L1E30:  rts                                     ; 1E30

; ----------------------------------------------------------------------------
L1E31:  ldy     #$02                            ; 1E31
L1E33:  lda     $FC00,y                         ; 1E33
        jsr     L1E42                           ; 1E36
        cpy     $FC01                           ; 1E39
        beq     L1E30                           ; 1E3C
        iny                                     ; 1E3E
        bne     L1E33                           ; 1E3F
        rts                                     ; 1E41

; ----------------------------------------------------------------------------
L1E42:  .byte   $8D                             ; 1E42
L1E43:  .byte   $FF                             ; 1E43
L1E44:  .byte   $FF                             ; 1E44
        inc     L1E43                           ; 1E45
        bne     L1E4D                           ; 1E48
        inc     L1E44                           ; 1E4A
L1E4D:  rts                                     ; 1E4D

; ----------------------------------------------------------------------------
L1E4E:  asl     a                               ; 1E4E
        asl     a                               ; 1E4F
        asl     a                               ; 1E50
        asl     a                               ; 1E51
        asl     a                               ; 1E52
        tay                                     ; 1E53
        lda     $FC02,y                         ; 1E54
        bne     L1E5B                           ; 1E57
L1E59:  sec                                     ; 1E59
        rts                                     ; 1E5A

; ----------------------------------------------------------------------------
L1E5B:  ldx     #$00                            ; 1E5B
L1E5D:  .byte   $BD                             ; 1E5D
L1E5E:  .byte   $FF                             ; 1E5E
L1E5F:  .byte   $FF                             ; 1E5F
        beq     L1E6C                           ; 1E60
        eor     $FC05,y                         ; 1E62
        asl     a                               ; 1E65
        bne     L1E59                           ; 1E66
        iny                                     ; 1E68
        inx                                     ; 1E69
        bne     L1E5D                           ; 1E6A
L1E6C:  clc                                     ; 1E6C
        rts                                     ; 1E6D

; ----------------------------------------------------------------------------
L1E6E:  lda     #$01                            ; 1E6E
        sta     $D5                             ; 1E70
        lda     #$00                            ; 1E72
        sta     $D6                             ; 1E74
        lda     #$FC                            ; 1E76
        sta     $D7                             ; 1E78
        jsr     L1097                           ; 1E7A
        bcc     L1E82                           ; 1E7D
        jmp     L1510                           ; 1E7F

; ----------------------------------------------------------------------------
L1E82:  rts                                     ; 1E82

; ----------------------------------------------------------------------------
L1E83:  lda     L2893                           ; 1E83
        asl     a                               ; 1E86
        clc                                     ; 1E87
        adc     L2893                           ; 1E88
        tax                                     ; 1E8B
        lda     L1EC7,x                         ; 1E8C
        sta     L1EBC                           ; 1E8F
        lda     L1EC8,x                         ; 1E92
        sta     L1EBD                           ; 1E95
        lda     L1EC9,x                         ; 1E98
        sta     L1EB8                           ; 1E9B
        ldy     #$00                            ; 1E9E
L1EA0:  lda     L1ED0,y                         ; 1EA0
        sta     $4F                             ; 1EA3
        lda     L1ED1,y                         ; 1EA5
        sta     $50                             ; 1EA8
        tya                                     ; 1EAA
        pha                                     ; 1EAB
        ldy     #$00                            ; 1EAC
        tya                                     ; 1EAE
L1EAF:  sta     ($4F),y                         ; 1EAF
        iny                                     ; 1EB1
        bne     L1EAF                           ; 1EB2
        pla                                     ; 1EB4
        pha                                     ; 1EB5
        tay                                     ; 1EB6
        .byte   $C0                             ; 1EB7
L1EB8:  rti                                     ; 1EB8

; ----------------------------------------------------------------------------
        bcs     L1EBE                           ; 1EB9
        .byte   $20                             ; 1EBB
L1EBC:  .byte   $FF                             ; 1EBC
L1EBD:  .byte   $FF                             ; 1EBD
L1EBE:  pla                                     ; 1EBE
        tay                                     ; 1EBF
        iny                                     ; 1EC0
        iny                                     ; 1EC1
        cpy     #$40                            ; 1EC2
        bcc     L1EA0                           ; 1EC4
        rts                                     ; 1EC6

; ----------------------------------------------------------------------------
L1EC7:  .byte   $10                             ; 1EC7
L1EC8:  .byte   $1F                             ; 1EC8
L1EC9:  .byte   $3C                             ; 1EC9
        .byte   $34                             ; 1ECA
        .byte   $1F                             ; 1ECB
        .byte   $3C                             ; 1ECC
        ora     $21,x                           ; 1ECD
        rti                                     ; 1ECF

; ----------------------------------------------------------------------------
L1ED0:  .byte   $A1                             ; 1ED0
L1ED1:  plp                                     ; 1ED1
        lda     ($29,x)                         ; 1ED2
        lda     ($2A,x)                         ; 1ED4
        lda     ($2B,x)                         ; 1ED6
        lda     ($2C,x)                         ; 1ED8
        lda     ($2D,x)                         ; 1EDA
        lda     ($2E,x)                         ; 1EDC
        lda     ($2F,x)                         ; 1EDE
        lda     ($30,x)                         ; 1EE0
        lda     ($31,x)                         ; 1EE2
        lda     ($32,x)                         ; 1EE4
        lda     ($33,x)                         ; 1EE6
        lda     ($34,x)                         ; 1EE8
        lda     ($35,x)                         ; 1EEA
        lda     ($36,x)                         ; 1EEC
        lda     ($37,x)                         ; 1EEE
        lda     ($38,x)                         ; 1EF0
        lda     ($39,x)                         ; 1EF2
        lda     ($3A,x)                         ; 1EF4
        lda     ($3B,x)                         ; 1EF6
        lda     ($3C,x)                         ; 1EF8
        lda     ($3D,x)                         ; 1EFA
        lda     ($3E,x)                         ; 1EFC
        lda     ($3F,x)                         ; 1EFE
        lda     ($40,x)                         ; 1F00
        lda     ($41,x)                         ; 1F02
        lda     ($42,x)                         ; 1F04
        lda     ($43,x)                         ; 1F06
        lda     ($44,x)                         ; 1F08
        lda     ($45,x)                         ; 1F0A
        lda     ($46,x)                         ; 1F0C
        lda     ($47,x)                         ; 1F0E
        tya                                     ; 1F10
        tax                                     ; 1F11
        clc                                     ; 1F12
        adc     #$04                            ; 1F13
        tay                                     ; 1F15
        lda     L1FDC,y                         ; 1F16
        sta     L0006                           ; 1F19
        lda     L1FDD,y                         ; 1F1B
        sta     $07                             ; 1F1E
        ldy     #$64                            ; 1F20
        lda     #$00                            ; 1F22
        sta     (L0006),y                       ; 1F24
        txa                                     ; 1F26
        tay                                     ; 1F27
        jsr     L201C                           ; 1F28
        bcs     L1F2E                           ; 1F2B
        rts                                     ; 1F2D

; ----------------------------------------------------------------------------
L1F2E:  ldy     #$00                            ; 1F2E
        tya                                     ; 1F30
        sta     ($4F),y                         ; 1F31
        rts                                     ; 1F33

; ----------------------------------------------------------------------------
        tya                                     ; 1F34
        tax                                     ; 1F35
        clc                                     ; 1F36
        adc     #$04                            ; 1F37
        tay                                     ; 1F39
        lda     L1FDC,y                         ; 1F3A
        sta     L0006                           ; 1F3D
        lda     L1FDD,y                         ; 1F3F
        sta     $07                             ; 1F42
        ldy     #$00                            ; 1F44
        lda     (L0006),y                       ; 1F46
        beq     L1F2E                           ; 1F48
L1F4A:  lda     (L0006),y                       ; 1F4A
        eor     L1F5C,y                         ; 1F4C
        sta     (L0006),y                       ; 1F4F
        iny                                     ; 1F51
        bpl     L1F4A                           ; 1F52
        txa                                     ; 1F54
        tay                                     ; 1F55
        jsr     L201C                           ; 1F56
        bcs     L1F2E                           ; 1F59
        rts                                     ; 1F5B

; ----------------------------------------------------------------------------
L1F5C:  .byte   $7F                             ; 1F5C
        ror     $7C7D,x                         ; 1F5D
        .byte   $7B                             ; 1F60
        .byte   $7A                             ; 1F61
        .byte   $79                             ; 1F62
L1F63:  sei                                     ; 1F63
        .byte   $77                             ; 1F64
        ror     $75,x                           ; 1F65
        .byte   $74                             ; 1F67
        .byte   $73                             ; 1F68
        .byte   $72                             ; 1F69
        adc     ($70),y                         ; 1F6A
        .byte   $F2                             ; 1F6C
        dec     $48,x                           ; 1F6D
        and     ($9A),y                         ; 1F6F
        ldy     $4EC3                           ; 1F71
        .byte   $77                             ; 1F74
        plp                                     ; 1F75
        and     ($10),y                         ; 1F76
        .byte   $DC                             ; 1F78
        cpy     $46                             ; 1F79
        .byte   $7A                             ; 1F7B
        sed                                     ; 1F7C
        ror     $23                             ; 1F7D
        .byte   $89                             ; 1F7F
        .byte   $93                             ; 1F80
        .byte   $92                             ; 1F81
        sta     ($90),y                         ; 1F82
        .byte   $87                             ; 1F84
        sty     $33                             ; 1F85
        lda     $C4                             ; 1F87
        cmp     $6C                             ; 1F89
        .byte   $72                             ; 1F8B
        and     #$63                            ; 1F8C
        .byte   $44                             ; 1F8E
        bpl     L1F92                           ; 1F8F
        .byte   $01                             ; 1F91
L1F92:  and     $72,x                           ; 1F92
        .byte   $47                             ; 1F94
        .byte   $23                             ; 1F95
        .byte   $03                             ; 1F96
        .byte   $8F                             ; 1F97
        .byte   $F3                             ; 1F98
        .byte   $77                             ; 1F99
        .byte   $42                             ; 1F9A
        rti                                     ; 1F9B

; ----------------------------------------------------------------------------
        .byte   $3F                             ; 1F9C
        rol     $423D,x                         ; 1F9D
        .byte   $74                             ; 1FA0
        .byte   $73                             ; 1FA1
        tya                                     ; 1FA2
        adc     ($F4),y                         ; 1FA3
        sbc     $35,x                           ; 1FA5
        .byte   $34                             ; 1FA7
        .byte   $02                             ; 1FA8
        dec     $D3,x                           ; 1FA9
        .byte   $44                             ; 1FAB
        .byte   $97                             ; 1FAC
        sta     $63                             ; 1FAD
        .byte   $33                             ; 1FAF
        .byte   $73                             ; 1FB0
        eor     $46                             ; 1FB1
        eor     #$48                            ; 1FB3
        .byte   $47                             ; 1FB5
        .byte   $93                             ; 1FB6
        lda     $42B7,x                         ; 1FB7
        ora     ($30,x)                         ; 1FBA
        .byte   $63                             ; 1FBC
        .byte   $1F                             ; 1FBD
        and     #$88                            ; 1FBE
        lsr     $63,x                           ; 1FC0
        ora     L1718,y                         ; 1FC2
        asl     $54,x                           ; 1FC5
        .byte   $77                             ; 1FC7
        .byte   $F2                             ; 1FC8
        beq     L1FDC                           ; 1FC9
        bvs     L1F63                           ; 1FCB
        .byte   $82                             ; 1FCD
        and     $44,x                           ; 1FCE
        lda     $48C5                           ; 1FD0
        .byte   $53                             ; 1FD3
        .byte   $5A                             ; 1FD4
        .byte   $42                             ; 1FD5
        bvs     L1FE1                           ; 1FD6
        .byte   $FF                             ; 1FD8
        .byte   $33                             ; 1FD9
        brk                                     ; 1FDA
        brk                                     ; 1FDB
L1FDC:  .byte   $A1                             ; 1FDC
L1FDD:  pha                                     ; 1FDD
        and     ($49,x)                         ; 1FDE
        .byte   $A1                             ; 1FE0
L1FE1:  eor     #$21                            ; 1FE1
        lsr     a                               ; 1FE3
        lda     ($4A,x)                         ; 1FE4
        and     ($4B,x)                         ; 1FE6
        lda     ($4B,x)                         ; 1FE8
        and     ($4C,x)                         ; 1FEA
        lda     ($4C,x)                         ; 1FEC
        and     ($4D,x)                         ; 1FEE
        lda     ($4D,x)                         ; 1FF0
        and     ($4E,x)                         ; 1FF2
        lda     ($4E,x)                         ; 1FF4
        and     ($4F,x)                         ; 1FF6
        lda     ($4F,x)                         ; 1FF8
        and     ($50,x)                         ; 1FFA
        lda     ($50,x)                         ; 1FFC
        and     ($51,x)                         ; 1FFE
L2000:  lda     ($51,x)                         ; 2000
        and     ($52,x)                         ; 2002
        lda     ($52,x)                         ; 2004
        and     ($53,x)                         ; 2006
        lda     ($53,x)                         ; 2008
        and     ($54,x)                         ; 200A
        lda     ($54,x)                         ; 200C
        and     ($55,x)                         ; 200E
        lda     ($55,x)                         ; 2010
        and     ($56,x)                         ; 2012
        lda     ($56,x)                         ; 2014
        and     ($57,x)                         ; 2016
        lda     ($57,x)                         ; 2018
        .byte   $21                             ; 201A
L201B:  cli                                     ; 201B
L201C:  tya                                     ; 201C
        clc                                     ; 201D
        adc     #$04                            ; 201E
        tay                                     ; 2020
        lda     L1FDC,y                         ; 2021
        sta     L0006                           ; 2024
        lda     L1FDD,y                         ; 2026
        sta     $07                             ; 2029
        ldy     #$00                            ; 202B
        lda     (L0006),y                       ; 202D
        beq     L203B                           ; 202F
        ora     #$80                            ; 2031
        cmp     #$FF                            ; 2033
        beq     L203B                           ; 2035
        cmp     #$AA                            ; 2037
        bne     L203D                           ; 2039
L203B:  sec                                     ; 203B
        rts                                     ; 203C

; ----------------------------------------------------------------------------
L203D:  ldy     #$00                            ; 203D
L203F:  lda     (L0006),y                       ; 203F
        cmp     #$FF                            ; 2041
        beq     L204E                           ; 2043
        ora     #$80                            ; 2045
        sta     ($4F),y                         ; 2047
        iny                                     ; 2049
        cpy     #$0C                            ; 204A
        bcc     L203F                           ; 204C
L204E:  dey                                     ; 204E
        lda     ($4F),y                         ; 204F
        and     #$7F                            ; 2051
        sta     ($4F),y                         ; 2053
        ldy     #$10                            ; 2055
        lda     (L0006),y                       ; 2057
        lsr     a                               ; 2059
        lsr     a                               ; 205A
        lsr     a                               ; 205B
        ldy     #$0D                            ; 205C
        sta     ($4F),y                         ; 205E
        ldy     #$10                            ; 2060
        lda     (L0006),y                       ; 2062
        asl     a                               ; 2064
        asl     a                               ; 2065
        and     #$1C                            ; 2066
        sta     $09                             ; 2068
        iny                                     ; 206A
        lda     (L0006),y                       ; 206B
        rol     a                               ; 206D
        rol     a                               ; 206E
        rol     a                               ; 206F
        and     #$03                            ; 2070
        ora     $09                             ; 2072
        ldy     #$11                            ; 2074
        sta     ($4F),y                         ; 2076
        ldy     #$11                            ; 2078
        lda     (L0006),y                       ; 207A
        and     #$1F                            ; 207C
        ldy     #$0F                            ; 207E
        sta     ($4F),y                         ; 2080
        ldy     #$12                            ; 2082
        lda     (L0006),y                       ; 2084
        lsr     a                               ; 2086
        lsr     a                               ; 2087
        lsr     a                               ; 2088
        ldy     #$13                            ; 2089
        sta     ($4F),y                         ; 208B
        ldy     #$21                            ; 208D
        lda     (L0006),y                       ; 208F
        ldy     #$4F                            ; 2091
        sta     ($4F),y                         ; 2093
        ldy     #$20                            ; 2095
        lda     (L0006),y                       ; 2097
        ldy     #$50                            ; 2099
        sta     ($4F),y                         ; 209B
        ldy     #$38                            ; 209D
        lda     (L0006),y                       ; 209F
        cmp     #$0B                            ; 20A1
        bcc     L20A6                           ; 20A3
        rts                                     ; 20A5

; ----------------------------------------------------------------------------
L20A6:  cmp     #$05                            ; 20A6
        beq     L20D6                           ; 20A8
        cmp     #$06                            ; 20AA
        beq     L20D6                           ; 20AC
        cmp     #$07                            ; 20AE
        beq     L20F8                           ; 20B0
        cmp     #$00                            ; 20B2
        beq     L20F8                           ; 20B4
        cmp     #$08                            ; 20B6
        beq     L20EB                           ; 20B8
        cmp     #$09                            ; 20BA
        beq     L20CD                           ; 20BC
        ldy     #$20                            ; 20BE
        lda     #$01                            ; 20C0
        sta     ($4F),y                         ; 20C2
        lda     #$FC                            ; 20C4
        ldy     #$3C                            ; 20C6
        sta     ($4F),y                         ; 20C8
        jmp     L2102                           ; 20CA

; ----------------------------------------------------------------------------
L20CD:  ldy     #$27                            ; 20CD
        lda     #$01                            ; 20CF
        sta     ($4F),y                         ; 20D1
        jmp     L2102                           ; 20D3

; ----------------------------------------------------------------------------
L20D6:  ldy     #$29                            ; 20D6
        lda     #$01                            ; 20D8
        sta     ($4F),y                         ; 20DA
        ldy     #$2A                            ; 20DC
        sta     ($4F),y                         ; 20DE
        ldy     #$28                            ; 20E0
        sta     ($4F),y                         ; 20E2
        ldy     #$24                            ; 20E4
        sta     ($4F),y                         ; 20E6
        jmp     L2102                           ; 20E8

; ----------------------------------------------------------------------------
L20EB:  ldy     #$2C                            ; 20EB
        lda     #$01                            ; 20ED
        sta     ($4F),y                         ; 20EF
        ldy     #$22                            ; 20F1
        sta     ($4F),y                         ; 20F3
        jmp     L2102                           ; 20F5

; ----------------------------------------------------------------------------
L20F8:  ldy     #$37                            ; 20F8
        lda     #$01                            ; 20FA
        sta     ($4F),y                         ; 20FC
        ldy     #$36                            ; 20FE
        sta     ($4F),y                         ; 2100
L2102:  ldy     #$31                            ; 2102
        lda     (L0006),y                       ; 2104
        ldy     #$16                            ; 2106
        sta     ($4F),y                         ; 2108
        ldy     #$30                            ; 210A
        lda     (L0006),y                       ; 210C
        ldy     #$17                            ; 210E
        sta     ($4F),y                         ; 2110
        jmp     L21F5                           ; 2112

; ----------------------------------------------------------------------------
        lda     L1FDC,y                         ; 2115
        sta     L0006                           ; 2118
        lda     L1FDD,y                         ; 211A
        sta     $07                             ; 211D
        ldy     #$00                            ; 211F
        lda     (L0006),y                       ; 2121
        beq     L212F                           ; 2123
        ora     #$80                            ; 2125
        cmp     #$FF                            ; 2127
        beq     L212F                           ; 2129
        cmp     #$AA                            ; 212B
        bne     L2135                           ; 212D
L212F:  ldy     #$00                            ; 212F
        tya                                     ; 2131
        sta     ($4F),y                         ; 2132
        rts                                     ; 2134

; ----------------------------------------------------------------------------
L2135:  ldy     #$00                            ; 2135
L2137:  lda     (L0006),y                       ; 2137
        cmp     #$FF                            ; 2139
        beq     L2146                           ; 213B
        ora     #$80                            ; 213D
        sta     ($4F),y                         ; 213F
        iny                                     ; 2141
        cpy     #$0C                            ; 2142
        bcc     L2137                           ; 2144
L2146:  dey                                     ; 2146
        lda     ($4F),y                         ; 2147
        and     #$7F                            ; 2149
        sta     ($4F),y                         ; 214B
        ldy     #$10                            ; 214D
        lda     (L0006),y                       ; 214F
        ldy     #$0D                            ; 2151
        sta     ($4F),y                         ; 2153
        ldy     #$11                            ; 2155
        lda     (L0006),y                       ; 2157
        ldy     #$11                            ; 2159
        sta     ($4F),y                         ; 215B
        ldy     #$12                            ; 215D
        lda     (L0006),y                       ; 215F
        ldy     #$0F                            ; 2161
        sta     ($4F),y                         ; 2163
        ldy     #$13                            ; 2165
        lda     (L0006),y                       ; 2167
        ldy     #$13                            ; 2169
        sta     ($4F),y                         ; 216B
        ldy     #$1F                            ; 216D
        lda     (L0006),y                       ; 216F
        ldy     #$4F                            ; 2171
        sta     ($4F),y                         ; 2173
        ldy     #$20                            ; 2175
        lda     (L0006),y                       ; 2177
        ldy     #$50                            ; 2179
        sta     ($4F),y                         ; 217B
        ldy     #$29                            ; 217D
        lda     (L0006),y                       ; 217F
        cmp     #$0D                            ; 2181
        bcc     L2186                           ; 2183
        rts                                     ; 2185

; ----------------------------------------------------------------------------
L2186:  cmp     #$05                            ; 2186
        beq     L21B6                           ; 2188
        cmp     #$06                            ; 218A
        beq     L21B6                           ; 218C
        cmp     #$07                            ; 218E
        beq     L21D8                           ; 2190
        cmp     #$00                            ; 2192
        beq     L21D8                           ; 2194
        cmp     #$08                            ; 2196
        beq     L21CB                           ; 2198
        cmp     #$09                            ; 219A
        beq     L21AD                           ; 219C
        ldy     #$20                            ; 219E
        lda     #$01                            ; 21A0
        sta     ($4F),y                         ; 21A2
        lda     #$FC                            ; 21A4
        ldy     #$3C                            ; 21A6
        sta     ($4F),y                         ; 21A8
        jmp     L21E2                           ; 21AA

; ----------------------------------------------------------------------------
L21AD:  ldy     #$27                            ; 21AD
        lda     #$01                            ; 21AF
        sta     ($4F),y                         ; 21B1
        jmp     L21E2                           ; 21B3

; ----------------------------------------------------------------------------
L21B6:  ldy     #$29                            ; 21B6
        lda     #$01                            ; 21B8
        sta     ($4F),y                         ; 21BA
        ldy     #$2A                            ; 21BC
        sta     ($4F),y                         ; 21BE
        ldy     #$28                            ; 21C0
        sta     ($4F),y                         ; 21C2
        ldy     #$24                            ; 21C4
        sta     ($4F),y                         ; 21C6
        jmp     L21E2                           ; 21C8

; ----------------------------------------------------------------------------
L21CB:  ldy     #$2C                            ; 21CB
        lda     #$01                            ; 21CD
        sta     ($4F),y                         ; 21CF
        ldy     #$22                            ; 21D1
        sta     ($4F),y                         ; 21D3
        jmp     L21E2                           ; 21D5

; ----------------------------------------------------------------------------
L21D8:  ldy     #$37                            ; 21D8
        lda     #$01                            ; 21DA
        sta     ($4F),y                         ; 21DC
        ldy     #$36                            ; 21DE
        sta     ($4F),y                         ; 21E0
L21E2:  ldy     #$23                            ; 21E2
        lda     (L0006),y                       ; 21E4
        ldy     #$16                            ; 21E6
        sta     ($4F),y                         ; 21E8
        ldy     #$24                            ; 21EA
        lda     (L0006),y                       ; 21EC
        ldy     #$17                            ; 21EE
        sta     ($4F),y                         ; 21F0
        jmp     L21F5                           ; 21F2

; ----------------------------------------------------------------------------
L21F5:  ldy     #$0D                            ; 21F5
L21F7:  lda     ($4F),y                         ; 21F7
        cmp     #$10                            ; 21F9
        bcc     L2201                           ; 21FB
        lda     #$10                            ; 21FD
        sta     ($4F),y                         ; 21FF
L2201:  dey                                     ; 2201
        sta     ($4F),y                         ; 2202
        iny                                     ; 2204
        iny                                     ; 2205
        iny                                     ; 2206
        cpy     #$15                            ; 2207
        bcc     L21F7                           ; 2209
        ldy     #$16                            ; 220B
        lda     ($4F),y                         ; 220D
        cmp     #$1E                            ; 220F
        iny                                     ; 2211
        lda     ($4F),y                         ; 2212
        sbc     #$00                            ; 2214
        bcc     L2221                           ; 2216
        lda     #$00                            ; 2218
        sta     ($4F),y                         ; 221A
        dey                                     ; 221C
        lda     #$1E                            ; 221D
        sta     ($4F),y                         ; 221F
L2221:  ldy     #$16                            ; 2221
        lda     ($4F),y                         ; 2223
        ldy     #$14                            ; 2225
        sta     ($4F),y                         ; 2227
        ldy     #$18                            ; 2229
        sta     ($4F),y                         ; 222B
        ldy     #$1A                            ; 222D
        sta     ($4F),y                         ; 222F
        ldy     #$17                            ; 2231
        lda     ($4F),y                         ; 2233
        ldy     #$15                            ; 2235
        sta     ($4F),y                         ; 2237
        ldy     #$19                            ; 2239
        sta     ($4F),y                         ; 223B
        ldy     #$1B                            ; 223D
        sta     ($4F),y                         ; 223F
        ldy     #$4F                            ; 2241
        lda     ($4F),y                         ; 2243
        cmp     #$02                            ; 2245
        iny                                     ; 2247
        lda     ($4F),y                         ; 2248
        sbc     #$00                            ; 224A
        bcc     L2257                           ; 224C
        lda     #$00                            ; 224E
        sta     ($4F),y                         ; 2250
        dey                                     ; 2252
        lda     #$02                            ; 2253
        sta     ($4F),y                         ; 2255
L2257:  ldx     #$00                            ; 2257
L2259:  ldy     L22EC,x                         ; 2259
L225C:  jsr     L2354                           ; 225C
        bcc     L226A                           ; 225F
        iny                                     ; 2261
        tya                                     ; 2262
        cmp     L22ED,x                         ; 2263
        bcc     L225C                           ; 2266
        bcs     L227F                           ; 2268
L226A:  ldy     L22F2,x                         ; 226A
        lda     ($4F),y                         ; 226D
        bne     L2275                           ; 226F
        lda     #$01                            ; 2271
        sta     ($4F),y                         ; 2273
L2275:  ldy     #$30                            ; 2275
        lda     ($4F),y                         ; 2277
        bne     L227F                           ; 2279
        lda     #$01                            ; 227B
        sta     ($4F),y                         ; 227D
L227F:  inx                                     ; 227F
        cpx     #$05                            ; 2280
        bcc     L2259                           ; 2282
        ldy     #$4F                            ; 2284
        lda     ($4F),y                         ; 2286
        sec                                     ; 2288
        sbc     #$01                            ; 2289
        asl     a                               ; 228B
        clc                                     ; 228C
        adc     #$82                            ; 228D
        sta     $09                             ; 228F
        ldx     #$1E                            ; 2291
L2293:  ldy     L22F7,x                         ; 2293
        lda     ($4F),y                         ; 2296
        beq     L22B0                           ; 2298
        tay                                     ; 229A
        sec                                     ; 229B
        lda     $09                             ; 229C
        sbc     L2335,x                         ; 229E
        bcc     L22AC                           ; 22A1
L22A3:  dey                                     ; 22A3
        beq     L22AE                           ; 22A4
        sec                                     ; 22A6
        sbc     L2316,x                         ; 22A7
        bcs     L22A3                           ; 22AA
L22AC:  lda     #$00                            ; 22AC
L22AE:  sta     $09                             ; 22AE
L22B0:  dex                                     ; 22B0
        bpl     L2293                           ; 22B1
        lda     $09                             ; 22B3
        cmp     #$0C                            ; 22B5
        bcs     L22BB                           ; 22B7
        lda     #$0C                            ; 22B9
L22BB:  ldy     #$3B                            ; 22BB
        sta     ($4F),y                         ; 22BD
        ldy     #$30                            ; 22BF
        lda     ($4F),y                         ; 22C1
        ldy     #$2F                            ; 22C3
        ora     ($4F),y                         ; 22C5
        ldy     #$32                            ; 22C7
        ora     ($4F),y                         ; 22C9
        ldy     #$2E                            ; 22CB
        ora     ($4F),y                         ; 22CD
        beq     L22EA                           ; 22CF
        ldy     #$12                            ; 22D1
        lda     ($4F),y                         ; 22D3
        asl     a                               ; 22D5
        ldy     #$1E                            ; 22D6
        sta     ($4F),y                         ; 22D8
        ldy     #$1C                            ; 22DA
        sta     ($4F),y                         ; 22DC
        lda     #$00                            ; 22DE
        adc     #$00                            ; 22E0
        ldy     #$1F                            ; 22E2
        sta     ($4F),y                         ; 22E4
        ldy     #$1D                            ; 22E6
        sta     ($4F),y                         ; 22E8
L22EA:  clc                                     ; 22EA
        rts                                     ; 22EB

; ----------------------------------------------------------------------------
L22EC:  brk                                     ; 22EC
L22ED:  asl     $19                             ; 22ED
        rol     $3A                             ; 22EF
        .byte   $3D                             ; 22F1
L22F2:  bmi     L2323                           ; 22F2
        rol     $3032                           ; 22F4
L22F7:  ora     L110F                           ; 22F7
        .byte   $13                             ; 22FA
        asl     $20,x                           ; 22FB
        and     ($22,x)                         ; 22FD
        .byte   $23                             ; 22FF
        bit     $25                             ; 2300
        rol     $27                             ; 2302
        plp                                     ; 2304
        and     #$2A                            ; 2305
        .byte   $2B                             ; 2307
        bit     $2E2D                           ; 2308
        .byte   $2F                             ; 230B
        bmi     L2340                           ; 230C
        .byte   $33                             ; 230E
        .byte   $34                             ; 230F
        and     $36,x                           ; 2310
        .byte   $37                             ; 2312
        sec                                     ; 2313
        .byte   $39                             ; 2314
        .byte   $3A                             ; 2315
L2316:  ora     ($02,x)                         ; 2316
        ora     ($02,x)                         ; 2318
        .byte   $02                             ; 231A
        ora     ($01,x)                         ; 231B
        ora     ($01,x)                         ; 231D
        ora     ($02,x)                         ; 231F
        ora     ($01,x)                         ; 2321
L2323:  .byte   $02                             ; 2323
        .byte   $02                             ; 2324
        ora     ($01,x)                         ; 2325
        ora     ($01,x)                         ; 2327
        .byte   $02                             ; 2329
        .byte   $02                             ; 232A
        .byte   $02                             ; 232B
        .byte   $02                             ; 232C
        .byte   $02                             ; 232D
        .byte   $02                             ; 232E
        .byte   $02                             ; 232F
        .byte   $02                             ; 2330
        .byte   $02                             ; 2331
        .byte   $02                             ; 2332
        .byte   $02                             ; 2333
        .byte   $02                             ; 2334
L2335:  ora     ($02,x)                         ; 2335
        ora     ($02,x)                         ; 2337
        .byte   $02                             ; 2339
        ora     ($01,x)                         ; 233A
        ora     ($01,x)                         ; 233C
        ora     ($02,x)                         ; 233E
L2340:  ora     ($01,x)                         ; 2340
        .byte   $02                             ; 2342
        .byte   $02                             ; 2343
        ora     ($01,x)                         ; 2344
        ora     ($01,x)                         ; 2346
        asl     a                               ; 2348
        asl     a                               ; 2349
        ora     $0A                             ; 234A
        .byte   $02                             ; 234C
        .byte   $02                             ; 234D
        .byte   $02                             ; 234E
        .byte   $02                             ; 234F
        .byte   $02                             ; 2350
        .byte   $02                             ; 2351
        .byte   $02                             ; 2352
        .byte   $02                             ; 2353
L2354:  pha                                     ; 2354
        txa                                     ; 2355
        pha                                     ; 2356
        tya                                     ; 2357
        pha                                     ; 2358
        tya                                     ; 2359
        pha                                     ; 235A
        and     #$07                            ; 235B
        tax                                     ; 235D
        pla                                     ; 235E
        lsr     a                               ; 235F
        lsr     a                               ; 2360
        lsr     a                               ; 2361
        clc                                     ; 2362
        adc     #$3C                            ; 2363
        tay                                     ; 2365
        clc                                     ; 2366
        lda     ($4F),y                         ; 2367
        and     L2375,x                         ; 2369
        bne     L236F                           ; 236C
        sec                                     ; 236E
L236F:  pla                                     ; 236F
        tay                                     ; 2370
        pla                                     ; 2371
        tax                                     ; 2372
        pla                                     ; 2373
        rts                                     ; 2374

; ----------------------------------------------------------------------------
L2375:  .byte   $80                             ; 2375
        rti                                     ; 2376

; ----------------------------------------------------------------------------
        jsr     L0810                           ; 2377
        .byte   $04                             ; 237A
        .byte   $02                             ; 237B
        .byte   $01                             ; 237C
L237D:  ldy     #$00                            ; 237D
        tya                                     ; 237F
L2380:  sta     $56A1,y                         ; 2380
        iny                                     ; 2383
        bne     L2380                           ; 2384
        lda     #$FF                            ; 2386
        sta     $56A3                           ; 2388
        ldy     #$06                            ; 238B
L238D:  lda     L239D,y                         ; 238D
        sta     $56AB,y                         ; 2390
        dey                                     ; 2393
        bpl     L238D                           ; 2394
        lda     L23A4                           ; 2396
        sta     $56C0                           ; 2399
        rts                                     ; 239C

; ----------------------------------------------------------------------------
L239D:  .byte   $80                             ; 239D
        .byte   $82                             ; 239E
        sty     $86                             ; 239F
        dey                                     ; 23A1
        txa                                     ; 23A2
        .byte   $8C                             ; 23A3
L23A4:  brk                                     ; 23A4
L23A5:  jsr     L23AE                           ; 23A5
        lda     #$01                            ; 23A8
        jsr     L278D                           ; 23AA
        rts                                     ; 23AD

; ----------------------------------------------------------------------------
L23AE:  jsr     L12EE                           ; 23AE
        lda     #$00                            ; 23B1
        sta     L2898                           ; 23B3
        sta     L2899                           ; 23B6
        sta     L289A                           ; 23B9
        sta     L2894                           ; 23BC
        lda     #$02                            ; 23BF
        sta     L2895                           ; 23C1
        lda     #$01                            ; 23C4
        jsr     L278D                           ; 23C6
        lda     #$00                            ; 23C9
        sta     L2898                           ; 23CB
        sta     L289A                           ; 23CE
        lda     #$03                            ; 23D1
        sta     L2899                           ; 23D3
        ldy     #$07                            ; 23D6
        ldx     #$00                            ; 23D8
L23DA:  lda     $48A2,x                         ; 23DA
        cmp     #$FF                            ; 23DD
        beq     L23F4                           ; 23DF
        clc                                     ; 23E1
        lda     $48A1,x                         ; 23E2
        adc     L2898                           ; 23E5
        sta     L2898                           ; 23E8
        lda     $48A2,x                         ; 23EB
        adc     L2899                           ; 23EE
        sta     L2899                           ; 23F1
L23F4:  inx                                     ; 23F4
        inx                                     ; 23F5
        dey                                     ; 23F6
        bne     L23DA                           ; 23F7
        lda     #$00                            ; 23F9
        sta     L2894                           ; 23FB
        lda     #$10                            ; 23FE
        sta     L2895                           ; 2400
        rts                                     ; 2403

; ----------------------------------------------------------------------------
        ora     $44                             ; 2404
        eor     ($54,x)                         ; 2406
        eor     ($31,x)                         ; 2408
L240A:  lda     #$00                            ; 240A
        sta     L261F                           ; 240C
L240F:  jsr     L25F3                           ; 240F
        jsr     L1911                           ; 2412
        lda     $FC00                           ; 2415
        bne     L244F                           ; 2418
        lda     L261F                           ; 241A
        beq     L2422                           ; 241D
        jmp     L2620                           ; 241F

; ----------------------------------------------------------------------------
L2422:  jsr     L14CB                           ; 2422
        .byte   $D4                             ; 2425
        inx                                     ; 2426
        sbc     $F2                             ; 2427
        sbc     $A0                             ; 2429
        sbc     ($F2,x)                         ; 242B
        sbc     $A0                             ; 242D
        inc     $A0EF                           ; 242F
        .byte   $E3                             ; 2432
        inx                                     ; 2433
        sbc     ($F2,x)                         ; 2434
        sbc     ($E3,x)                         ; 2436
        .byte   $F4                             ; 2438
        sbc     $F2                             ; 2439
        .byte   $F3                             ; 243B
        ldy     #$F4                            ; 243C
        .byte   $EF                             ; 243E
        ldy     #$F4                            ; 243F
        .byte   $F2                             ; 2441
        sbc     ($EE,x)                         ; 2442
        .byte   $F3                             ; 2444
        inc     $E5                             ; 2445
        .byte   $F2                             ; 2447
        ldx     L2000                           ; 2448
        ldy     $3816                           ; 244B
        rts                                     ; 244E

; ----------------------------------------------------------------------------
L244F:  jsr     L14CB                           ; 244F
        .byte   $D4                             ; 2452
        .byte   $F2                             ; 2453
        sbc     ($EE,x)                         ; 2454
        .byte   $F3                             ; 2456
        inc     $E5                             ; 2457
        .byte   $F2                             ; 2459
        ldy     #$F7                            ; 245A
        inx                                     ; 245C
        sbc     #$E3                            ; 245D
        inx                                     ; 245F
        ldy     #$E3                            ; 2460
        inx                                     ; 2462
        sbc     ($F2,x)                         ; 2463
        sbc     ($E3,x)                         ; 2465
        .byte   $F4                             ; 2467
        sbc     $F2                             ; 2468
        .byte   $BF                             ; 246A
        brk                                     ; 246B
        .byte   $A9                             ; 246C
L246D:  ora     $8D,x                           ; 246D
        .byte   $9E                             ; 246F
        plp                                     ; 2470
        lda     #$00                            ; 2471
        sta     L289D                           ; 2473
        jsr     L14CB                           ; 2476
        bne     L246D                           ; 2479
        sbc     $F3                             ; 247B
        .byte   $F3                             ; 247D
        ldy     #$D2                            ; 247E
        cmp     $D4                             ; 2480
        cmp     $D2,x                           ; 2482
        dec     $F4A0                           ; 2484
        .byte   $EF                             ; 2487
        ldy     #$F3                            ; 2488
        sbc     $EC                             ; 248A
        sbc     $E3                             ; 248C
        .byte   $F4                             ; 248E
        ldy     #$E3                            ; 248F
        inx                                     ; 2491
        sbc     ($F2,x)                         ; 2492
        sbc     ($E3,x)                         ; 2494
        .byte   $F4                             ; 2496
        sbc     $F2                             ; 2497
        ldy     $D4A0                           ; 2499
        ldy     #$F4                            ; 249C
        .byte   $EF                             ; 249E
        sta     $EFE4                           ; 249F
        ldy     #$F4                            ; 24A2
        inx                                     ; 24A4
        sbc     $A0                             ; 24A5
        .byte   $F4                             ; 24A7
        .byte   $F2                             ; 24A8
        sbc     ($EE,x)                         ; 24A9
        .byte   $F3                             ; 24AB
        inc     $E5                             ; 24AC
        .byte   $F2                             ; 24AE
        ldy     #$EF                            ; 24AF
        .byte   $F2                             ; 24B1
        ldy     #$BC                            ; 24B2
        lda     $A0AD                           ; 24B4
        .byte   $F4                             ; 24B7
        .byte   $EF                             ; 24B8
        ldy     #$E3                            ; 24B9
        sbc     ($EE,x)                         ; 24BB
        .byte   $E3                             ; 24BD
        sbc     $EC                             ; 24BE
        ldx     $A900                           ; 24C0
        .byte   $02                             ; 24C3
        sta     L289E                           ; 24C4
        lda     #$00                            ; 24C7
        ldx     #$00                            ; 24C9
        ldy     #$FC                            ; 24CB
        jsr     L16EF                           ; 24CD
        bcc     L24DB                           ; 24D0
        cmp     #$FE                            ; 24D2
        bne     L24D9                           ; 24D4
        jmp     L2620                           ; 24D6

; ----------------------------------------------------------------------------
L24D9:  sec                                     ; 24D9
        rts                                     ; 24DA

; ----------------------------------------------------------------------------
L24DB:  pha                                     ; 24DB
        jsr     L1911                           ; 24DC
        jsr     L14CB                           ; 24DF
        .byte   $D7                             ; 24E2
        inx                                     ; 24E3
        sbc     #$E3                            ; 24E4
        inx                                     ; 24E6
        ldy     #$F3                            ; 24E7
        cpx     $F4EF                           ; 24E9
        ldy     #$F7                            ; 24EC
        sbc     #$EC                            ; 24EE
        cpx     $E2A0                           ; 24F0
        sbc     $A0                             ; 24F3
        .byte   $F2                             ; 24F5
        sbc     $F0                             ; 24F6
        cpx     $E3E1                           ; 24F8
        sbc     $E4                             ; 24FB
        ldy     #$F7                            ; 24FD
        sbc     #$F4                            ; 24FF
        inx                                     ; 2501
        sta     $6800                           ; 2502
        pha                                     ; 2505
        asl     a                               ; 2506
        tay                                     ; 2507
        lda     $FC01,y                         ; 2508
        sta     $4F                             ; 250B
        lda     $FC02,y                         ; 250D
        sta     $50                             ; 2510
        ldy     #$FF                            ; 2512
L2514:  iny                                     ; 2514
        lda     ($4F),y                         ; 2515
        ora     #$80                            ; 2517
        jsr     L1935                           ; 2519
        lda     ($4F),y                         ; 251C
        bmi     L2514                           ; 251E
        jsr     L14CB                           ; 2520
        .byte   $BF                             ; 2523
        sta     a:$8D                           ; 2524
        jsr     L2586                           ; 2527
        jsr     L14CB                           ; 252A
        sta     $BC8D                           ; 252D
        lda     $A0AD                           ; 2530
        .byte   $F4                             ; 2533
        .byte   $EF                             ; 2534
        ldy     #$E7                            ; 2535
        .byte   $EF                             ; 2537
        ldy     #$E2                            ; 2538
        sbc     ($E3,x)                         ; 253A
        .byte   $EB                             ; 253C
        .byte   $AE                             ; 253D
        brk                                     ; 253E
L253F:  jsr     L137B                           ; 253F
        cmp     #$9B                            ; 2542
        bne     L254A                           ; 2544
        pla                                     ; 2546
        jmp     L240F                           ; 2547

; ----------------------------------------------------------------------------
L254A:  sec                                     ; 254A
        sbc     #$B1                            ; 254B
        cmp     #$08                            ; 254D
        bcs     L253F                           ; 254F
        asl     a                               ; 2551
        tay                                     ; 2552
        lda     L2747,y                         ; 2553
        sta     L0006                           ; 2556
        lda     L2748,y                         ; 2558
        sta     $07                             ; 255B
        pla                                     ; 255D
        asl     a                               ; 255E
        tay                                     ; 255F
        lda     $FC01,y                         ; 2560
        sta     $4F                             ; 2563
        lda     $FC02,y                         ; 2565
        sta     $50                             ; 2568
        ldy     #$00                            ; 256A
L256C:  lda     ($4F),y                         ; 256C
        sta     (L0006),y                       ; 256E
        iny                                     ; 2570
        bne     L256C                           ; 2571
        inc     $07                             ; 2573
        lda     #$00                            ; 2575
L2577:  sta     (L0006),y                       ; 2577
        iny                                     ; 2579
        bne     L2577                           ; 257A
        sta     ($4F),y                         ; 257C
        lda     #$FF                            ; 257E
        sta     L261F                           ; 2580
        jmp     L240F                           ; 2583

; ----------------------------------------------------------------------------
L2586:  lda     #$00                            ; 2586
L2588:  pha                                     ; 2588
        asl     a                               ; 2589
        tay                                     ; 258A
        lda     L2747,y                         ; 258B
        sta     $4F                             ; 258E
        lda     L2748,y                         ; 2590
        sta     $50                             ; 2593
        pla                                     ; 2595
        pha                                     ; 2596
        clc                                     ; 2597
        adc     #$B1                            ; 2598
        jsr     L1935                           ; 259A
        lda     #$A9                            ; 259D
        jsr     L1935                           ; 259F
        .byte   $A0                             ; 25A2
L25A3:  brk                                     ; 25A3
        lda     ($4F),y                         ; 25A4
        bne     L25BC                           ; 25A6
        jsr     L14CB                           ; 25A8
        cmp     $ED                             ; 25AB
        beq     L25A3                           ; 25AD
        sbc     $F3A0,y                         ; 25AF
        cpx     $F4EF                           ; 25B2
        brk                                     ; 25B5
        jmp     L25E5                           ; 25B6

; ----------------------------------------------------------------------------
L25B9:  iny                                     ; 25B9
        lda     ($4F),y                         ; 25BA
L25BC:  ora     #$80                            ; 25BC
        jsr     L1935                           ; 25BE
        lda     ($4F),y                         ; 25C1
        bmi     L25B9                           ; 25C3
        ldy     #$4D                            ; 25C5
        lda     ($4F),y                         ; 25C7
        beq     L25E5                           ; 25C9
        lda     #$14                            ; 25CB
        sta     L289D                           ; 25CD
        jsr     L14CB                           ; 25D0
        tay                                     ; 25D3
        iny                                     ; 25D4
        sbc     #$F2                            ; 25D5
        sbc     $E4                             ; 25D7
        ldy     #$E3                            ; 25D9
        inx                                     ; 25DB
        sbc     ($F2,x)                         ; 25DC
        sbc     ($E3,x)                         ; 25DE
        .byte   $F4                             ; 25E0
        sbc     $F2                             ; 25E1
        lda     #$00                            ; 25E3
L25E5:  lda     #$8D                            ; 25E5
        jsr     L1935                           ; 25E7
        pla                                     ; 25EA
        clc                                     ; 25EB
        adc     #$01                            ; 25EC
        cmp     #$07                            ; 25EE
        bcc     L2588                           ; 25F0
        rts                                     ; 25F2

; ----------------------------------------------------------------------------
L25F3:  lda     #$A1                            ; 25F3
        sta     L0006                           ; 25F5
        lda     #$28                            ; 25F7
        sta     $07                             ; 25F9
        ldy     #$20                            ; 25FB
        sty     $09                             ; 25FD
        ldy     #$00                            ; 25FF
        ldx     #$00                            ; 2601
L2603:  lda     (L0006),y                       ; 2603
        beq     L2613                           ; 2605
        lda     L0006                           ; 2607
        sta     $FC01,x                         ; 2609
        lda     $07                             ; 260C
        sta     $FC02,x                         ; 260E
        inx                                     ; 2611
        inx                                     ; 2612
L2613:  inc     $07                             ; 2613
        dec     $09                             ; 2615
        bne     L2603                           ; 2617
        txa                                     ; 2619
        lsr     a                               ; 261A
        sta     $FC00                           ; 261B
        rts                                     ; 261E

; ----------------------------------------------------------------------------
L261F:  brk                                     ; 261F
L2620:  ldx     #$00                            ; 2620
        stx     L2746                           ; 2622
L2625:  lda     L2747,x                         ; 2625
        sta     L0006                           ; 2628
        lda     L2748,x                         ; 262A
        sta     $07                             ; 262D
        ldy     #$00                            ; 262F
        lda     (L0006),y                       ; 2631
        bne     L265D                           ; 2633
        lda     L2749,x                         ; 2635
        sta     $09                             ; 2638
        lda     L274A,x                         ; 263A
        sta     $0A                             ; 263D
        lda     ($09),y                         ; 263F
        beq     L265D                           ; 2641
L2643:  lda     ($09),y                         ; 2643
        sta     (L0006),y                       ; 2645
        iny                                     ; 2647
        bne     L2643                           ; 2648
        tya                                     ; 264A
        sta     ($09),y                         ; 264B
        inc     $0A                             ; 264D
        inc     $07                             ; 264F
L2651:  lda     ($09),y                         ; 2651
        sta     (L0006),y                       ; 2653
        iny                                     ; 2655
        bne     L2651                           ; 2656
        lda     #$FF                            ; 2658
        sta     L2746                           ; 265A
L265D:  inx                                     ; 265D
        inx                                     ; 265E
        cpx     #$0C                            ; 265F
        bcc     L2625                           ; 2661
        lda     L2746                           ; 2663
        bne     L2620                           ; 2666
        ldx     #$00                            ; 2668
        stx     L23A4                           ; 266A
        stx     L2746                           ; 266D
L2670:  lda     L2747,x                         ; 2670
        sta     L0006                           ; 2673
        lda     L2748,x                         ; 2675
        sta     $07                             ; 2678
        ldy     #$00                            ; 267A
        lda     (L0006),y                       ; 267C
        beq     L268C                           ; 267E
        inc     L23A4                           ; 2680
        ldy     #$4D                            ; 2683
        lda     (L0006),y                       ; 2685
        bne     L268C                           ; 2687
        inc     L2746                           ; 2689
L268C:  inx                                     ; 268C
        inx                                     ; 268D
        cpx     #$0E                            ; 268E
        bcc     L2670                           ; 2690
        lda     L2746                           ; 2692
        cmp     #$05                            ; 2695
        bcs     L269B                           ; 2697
        clc                                     ; 2699
        rts                                     ; 269A

; ----------------------------------------------------------------------------
L269B:  jsr     L1911                           ; 269B
        jsr     L14CB                           ; 269E
        cmp     $F5EF,y                         ; 26A1
        ldy     #$E3                            ; 26A4
        sbc     ($EE,x)                         ; 26A6
        ldy     #$EF                            ; 26A8
        inc     $F9EC                           ; 26AA
        ldy     #$E8                            ; 26AD
        sbc     ($F6,x)                         ; 26AF
        sbc     $A0                             ; 26B1
        ldy     $A0,x                           ; 26B3
        .byte   $EF                             ; 26B5
        .byte   $F2                             ; 26B6
        ldy     #$EC                            ; 26B7
        sbc     $F3                             ; 26B9
        .byte   $F3                             ; 26BB
        ldy     #$F4                            ; 26BC
        .byte   $F2                             ; 26BE
        sbc     $E5,x                           ; 26BF
        sta     $E1F0                           ; 26C1
        .byte   $F2                             ; 26C4
        .byte   $F4                             ; 26C5
        sbc     $EDA0,y                         ; 26C6
        sbc     $ED                             ; 26C9
        .byte   $E2                             ; 26CB
        sbc     $F2                             ; 26CC
        .byte   $F3                             ; 26CE
        ldx     $D9A0                           ; 26CF
        .byte   $EF                             ; 26D2
        sbc     $A0,x                           ; 26D3
        .byte   $F7                             ; 26D5
        sbc     #$EC                            ; 26D6
        cpx     $E8A0                           ; 26D8
        sbc     ($F6,x)                         ; 26DB
        sbc     $A0                             ; 26DD
        .byte   $F4                             ; 26DF
        .byte   $EF                             ; 26E0
        sta     $E5E4                           ; 26E1
        cpx     $F4E5                           ; 26E4
        sbc     $A0                             ; 26E7
        .byte   $F3                             ; 26E9
        .byte   $EF                             ; 26EA
        sbc     $A0E5                           ; 26EB
        sbc     $EDE5                           ; 26EE
        .byte   $E2                             ; 26F1
        sbc     $F2                             ; 26F2
        .byte   $F3                             ; 26F4
        ldx     $8D8D                           ; 26F5
        .byte   $D7                             ; 26F8
        inx                                     ; 26F9
        sbc     #$E3                            ; 26FA
        inx                                     ; 26FC
        ldy     #$F0                            ; 26FD
        sbc     ($F2,x)                         ; 26FF
        .byte   $F4                             ; 2701
        sbc     $EDA0,y                         ; 2702
        sbc     $ED                             ; 2705
        .byte   $E2                             ; 2707
        sbc     $F2                             ; 2708
        ldy     #$F7                            ; 270A
        sbc     #$EC                            ; 270C
        cpx     $F9A0                           ; 270E
        .byte   $EF                             ; 2711
        sbc     $A0,x                           ; 2712
        .byte   $F2                             ; 2714
        sbc     $ED                             ; 2715
        .byte   $EF                             ; 2717
        inc     $E5,x                           ; 2718
        .byte   $BF                             ; 271A
        sta     a:$8D                           ; 271B
        jsr     L2586                           ; 271E
L2721:  jsr     L137B                           ; 2721
        cmp     #$9B                            ; 2724
        bne     L272B                           ; 2726
        jmp     L1196                           ; 2728

; ----------------------------------------------------------------------------
L272B:  sec                                     ; 272B
        sbc     #$B1                            ; 272C
        cmp     #$07                            ; 272E
        bcs     L2721                           ; 2730
        asl     a                               ; 2732
        tax                                     ; 2733
        lda     L2747,x                         ; 2734
        sta     L0006                           ; 2737
        lda     L2748,x                         ; 2739
        sta     $07                             ; 273C
        ldy     #$00                            ; 273E
        tya                                     ; 2740
        sta     (L0006),y                       ; 2741
        jmp     L2620                           ; 2743

; ----------------------------------------------------------------------------
L2746:  brk                                     ; 2746
L2747:  .byte   $A1                             ; 2747
L2748:  pha                                     ; 2748
L2749:  .byte   $A1                             ; 2749
L274A:  lsr     a                               ; 274A
        lda     ($4C,x)                         ; 274B
        lda     ($4E,x)                         ; 274D
        lda     ($50,x)                         ; 274F
        lda     ($52,x)                         ; 2751
        lda     ($54,x)                         ; 2753
L2755:  jsr     L1911                           ; 2755
        jsr     L14CB                           ; 2758
        .byte   $D7                             ; 275B
        .byte   $F2                             ; 275C
        sbc     #$F4                            ; 275D
        sbc     #$EE                            ; 275F
        .byte   $E7                             ; 2761
        ldy     #$C4                            ; 2762
        .byte   $F2                             ; 2764
        sbc     ($E7,x)                         ; 2765
        .byte   $EF                             ; 2767
        inc     $D7A0                           ; 2768
        sbc     ($F2,x)                         ; 276B
        .byte   $F3                             ; 276D
        ldy     #$E3                            ; 276E
        inx                                     ; 2770
        sbc     ($F2,x)                         ; 2771
        sbc     ($E3,x)                         ; 2773
        .byte   $F4                             ; 2775
        sbc     $F2                             ; 2776
        .byte   $F3                             ; 2778
        ldx     $AEAE                           ; 2779
        brk                                     ; 277C
        lda     #$00                            ; 277D
        sta     L2894                           ; 277F
        lda     #$10                            ; 2782
        sta     L2895                           ; 2784
        lda     #$02                            ; 2787
        jsr     L278D                           ; 2789
        rts                                     ; 278C

; ----------------------------------------------------------------------------
L278D:  sta     L2885                           ; 278D
        lda     #$A1                            ; 2790
        sta     L2896                           ; 2792
        lda     #$48                            ; 2795
        sta     L2897                           ; 2797
        clc                                     ; 279A
        lda     L2899                           ; 279B
        adc     #$B0                            ; 279E
        sta     $D8                             ; 27A0
        lda     L289A                           ; 27A2
        adc     #$00                            ; 27A5
        sta     $D9                             ; 27A7
        lda     L2898                           ; 27A9
        beq     L2820                           ; 27AC
        lda     #$01                            ; 27AE
        jsr     L2886                           ; 27B0
        bcs     L27F5                           ; 27B3
        lda     L2896                           ; 27B5
        sta     $D6                             ; 27B8
        lda     L2897                           ; 27BA
        sta     $D7                             ; 27BD
        sec                                     ; 27BF
        lda     #$00                            ; 27C0
        sta     $E7                             ; 27C2
        sbc     L2898                           ; 27C4
        sta     $E6                             ; 27C7
        lda     L2895                           ; 27C9
        bne     L27D7                           ; 27CC
        lda     L2894                           ; 27CE
        cmp     $E6                             ; 27D1
        bcs     L27D7                           ; 27D3
        sta     $E6                             ; 27D5
L27D7:  ldx     L2898                           ; 27D7
        ldy     #$00                            ; 27DA
        lda     L2885                           ; 27DC
        cmp     #$02                            ; 27DF
        bne     L27F6                           ; 27E1
L27E3:  lda     ($D6),y                         ; 27E3
        sta     $FC00,x                         ; 27E5
        inx                                     ; 27E8
        iny                                     ; 27E9
        cpy     $E6                             ; 27EA
        bne     L27E3                           ; 27EC
        lda     #$02                            ; 27EE
        jsr     L2886                           ; 27F0
        bcc     L2801                           ; 27F3
L27F5:  rts                                     ; 27F5

; ----------------------------------------------------------------------------
L27F6:  lda     $FC00,x                         ; 27F6
        sta     ($D6),y                         ; 27F9
        inx                                     ; 27FB
        iny                                     ; 27FC
        cpy     $E6                             ; 27FD
        bne     L27F6                           ; 27FF
L2801:  sec                                     ; 2801
        lda     L2894                           ; 2802
        sbc     $E6                             ; 2805
        sta     L2894                           ; 2807
        bcs     L280F                           ; 280A
        dec     L2895                           ; 280C
L280F:  clc                                     ; 280F
        lda     L2896                           ; 2810
        adc     $E6                             ; 2813
        sta     L2896                           ; 2815
        bcc     L281D                           ; 2818
        inc     L2897                           ; 281A
L281D:  jsr     L287E                           ; 281D
L2820:  lda     L2896                           ; 2820
        sta     $D6                             ; 2823
        lda     L2897                           ; 2825
        sta     $D7                             ; 2828
        lda     L2895                           ; 282A
        beq     L2844                           ; 282D
        lda     L2885                           ; 282F
        sta     $D5                             ; 2832
        jsr     L10DF                           ; 2834
        bcs     L287D                           ; 2837
        jsr     L287E                           ; 2839
        inc     L2897                           ; 283C
        dec     L2895                           ; 283F
        bne     L2820                           ; 2842
L2844:  lda     L2894                           ; 2844
        beq     L287C                           ; 2847
        lda     #$01                            ; 2849
        jsr     L2886                           ; 284B
        lda     L2896                           ; 284E
        sta     $D6                             ; 2851
        lda     L2897                           ; 2853
        sta     $D7                             ; 2856
        ldy     L2894                           ; 2858
        dey                                     ; 285B
        lda     L2885                           ; 285C
        cmp     #$02                            ; 285F
        bne     L2872                           ; 2861
L2863:  lda     ($D6),y                         ; 2863
        sta     $FC00,y                         ; 2865
        dey                                     ; 2868
        cpy     #$FF                            ; 2869
        bne     L2863                           ; 286B
        lda     #$02                            ; 286D
        jmp     L2886                           ; 286F

; ----------------------------------------------------------------------------
L2872:  lda     $FC00,y                         ; 2872
        sta     ($D6),y                         ; 2875
        dey                                     ; 2877
        cpy     #$FF                            ; 2878
        bne     L2872                           ; 287A
L287C:  clc                                     ; 287C
L287D:  rts                                     ; 287D

; ----------------------------------------------------------------------------
L287E:  inc     $D8                             ; 287E
        bne     L2884                           ; 2880
        inc     $D9                             ; 2882
L2884:  rts                                     ; 2884

; ----------------------------------------------------------------------------
L2885:  brk                                     ; 2885
L2886:  sta     $D5                             ; 2886
        ldx     #$00                            ; 2888
        stx     $D6                             ; 288A
        ldx     #$FC                            ; 288C
        stx     $D7                             ; 288E
        jmp     L10DF                           ; 2890

; ----------------------------------------------------------------------------
L2893:  brk                                     ; 2893
L2894:  brk                                     ; 2894
L2895:  brk                                     ; 2895
L2896:  brk                                     ; 2896
L2897:  brk                                     ; 2897
L2898:  brk                                     ; 2898
L2899:  brk                                     ; 2899
L289A:  brk                                     ; 289A
L289B:  brk                                     ; 289B
L289C:  brk                                     ; 289C
L289D:  brk                                     ; 289D
L289E:  brk                                     ; 289E
L289F:  brk                                     ; 289F
