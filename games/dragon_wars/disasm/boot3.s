; da65 V2.19 - Git dcdf7ade0
; Created:    2025-07-27 12:19:22
; Input file: boot3.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
DriveOp         := $00D5                        ; operation code, 1=read, 2=write, 3=get status byte
BufferVec       := $00D6                        ; operation buffer vector
BlockNum        := $00D8                        ; operation block number
tmpbyte         := $00FF                        ; tmp storage for Send/GetByte
DiskSideNum     := $F5DF                        ; needed disk side number (0=disk1, 1=disk2, ...) same as on C64
; ----------------------------------------------------------------------------
; Send byte from A, use $FF as tmp
SendByte:
        bit     $01                             ; 5600
        bvc     SendByte                        ; 5602
        sta     tmpbyte                         ; 5604
        lda     #$D2                            ; 5606
        sta     $FF13                           ; 5608
        ldy     #$04                            ; 560B
L560D:  nop                                     ; 560D
        nop                                     ; 560E
        nop                                     ; 560F
        lda     #$0A                            ; 5610
        asl     tmpbyte                         ; 5612
        bcc     L5618                           ; 5614
        lda     #$0B                            ; 5616
L5618:  sta     $01                             ; 5618
        nop                                     ; 561A
        nop                                     ; 561B
        nop                                     ; 561C
        nop                                     ; 561D
        lda     #$08                            ; 561E
        asl     tmpbyte                         ; 5620
        bcc     L5626                           ; 5622
        lda     #$09                            ; 5624
L5626:  sta     $01                             ; 5626
        nop                                     ; 5628
        nop                                     ; 5629
        nop                                     ; 562A
        nop                                     ; 562B
        nop                                     ; 562C
        dey                                     ; 562D
        bne     L560D                           ; 562E
        lda     #$08                            ; 5630
        sta     $01                             ; 5632
        lda     #$D0                            ; 5634
        sta     $FF13                           ; 5636
        rts                                     ; 5639

; ----------------------------------------------------------------------------
; Get byte into A, use $FF as tmp
GetByte:bit     $01                             ; 563A
        bvc     GetByte                         ; 563C
        lda     #$D2                            ; 563E
        sta     $FF13                           ; 5640
        ldy     #$04                            ; 5643
L5645:  lda     #$89                            ; 5645
        sta     $01                             ; 5647
        jsr     Delay                           ; 5649
        lda     $01                             ; 564C
        and     #$40                            ; 564E
        cmp     #$40                            ; 5650
        rol     tmpbyte                         ; 5652
        lda     #$88                            ; 5654
        sta     $01                             ; 5656
        jsr     Delay                           ; 5658
        lda     $01                             ; 565B
        and     #$40                            ; 565D
        cmp     #$40                            ; 565F
        rol     tmpbyte                         ; 5661
        dey                                     ; 5663
        bne     L5645                           ; 5664
        lda     #$89                            ; 5666
        sta     $01                             ; 5668
        jsr     Delay                           ; 566A
        lda     #$08                            ; 566D
        sta     $01                             ; 566F
        lda     #$D0                            ; 5671
        sta     $FF13                           ; 5673
        lda     tmpbyte                         ; 5676
        rts                                     ; 5678

; ----------------------------------------------------------------------------
; Delay for IEC ops
Delay:  nop                                     ; 5679
        nop                                     ; 567A
        nop                                     ; 567B
        nop                                     ; 567C
        nop                                     ; 567D
        rts                                     ; 567E

; ----------------------------------------------------------------------------
; Send parameters to the drive: op, track, sector
SendParams:
        lda     #$09                            ; 567F
        sta     $01                             ; 5681
        lda     DriveOp                         ; 5683
        jsr     SendByte                        ; 5685
        lda     BlockNumTmp                     ; 5688
        jsr     SendByte                        ; 568B
        lda     BlockNumTmp+1                   ; 568E
        jmp     SendByte                        ; 5691

; ----------------------------------------------------------------------------
; Do operation from DriveOp with block number already converted to track and sector. This must be at 5694(?)
DoSectorOp:
        lda     BufferVec                       ; 5694
        sta     ReadBufferAddr                  ; 5696
        sta     WriteBufferAddr                 ; 5699
        lda     BufferVec+1                     ; 569C
        sta     ReadBufferAddr+1                ; 569E
        sta     WriteBufferAddr+1               ; 56A1
        jsr     SendParams                      ; 56A4
        lda     DriveOp                         ; 56A7
        cmp     #$03                            ; 56A9
        beq     L56BE                           ; 56AB
        bcs     L56D2                           ; 56AD
        cmp     #$02                            ; 56AF
        bne     DoGetSector                     ; 56B1
; Write buffer to disk
DoPutSector:
        ldx     #$00                            ; 56B3
; LDA xxxx,X
LoadByte:
        .byte   $BD                             ; 56B5
WriteBufferAddr:
        .byte   $FF                             ; 56B6
        .byte   $FF                             ; 56B7
        jsr     SendByte                        ; 56B8
        inx                                     ; 56BB
        bne     LoadByte                        ; 56BC
L56BE:  jmp     DoGetStatus                     ; 56BE

; ----------------------------------------------------------------------------
; Read disk sector into buffer
DoGetSector:
        ldx     #$00                            ; 56C1
L56C3:  jsr     GetByte                         ; 56C3
; STA xxxx,X
StoreByte:
        .byte   $9D                             ; 56C6
ReadBufferAddr:
        .byte   $FF                             ; 56C7
        .byte   $FF                             ; 56C8
        inx                                     ; 56C9
        bne     L56C3                           ; 56CA
; Get operation status from drive
DoGetStatus:
        jsr     GetByte                         ; 56CC
        sta     IOStatus                        ; 56CF
L56D2:  lda     #$C8                            ; 56D2
        sta     $01                             ; 56D4
        lda     IOStatus                        ; 56D6
        cmp     #$01                            ; 56D9
        rts                                     ; 56DB

; ----------------------------------------------------------------------------
; Do block operation, called externally. This must be at $56DC
DoBlockOp:
        lda     BlockNum                        ; 56DC
        sta     BlockNumTmp+1                   ; 56DE
        lda     BlockNum+1                      ; 56E1
        sta     BlockNumTmp                     ; 56E3
        jsr     ConvertBlockTmp                 ; 56E6
        jmp     DoSectorOp                      ; 56E9

; ----------------------------------------------------------------------------
; Convert from block number to track and sector
ConvertBlockTmp:
        ldx     #$00                            ; 56EC
L56EE:  sec                                     ; 56EE
        lda     BlockNumTmp+1                   ; 56EF
        sbc     TrackSizeTab,x                  ; 56F2
        tay                                     ; 56F5
        lda     BlockNumTmp                     ; 56F6
        sbc     #$00                            ; 56F9
        bcc     L5706                           ; 56FB
        inx                                     ; 56FD
        sta     BlockNumTmp                     ; 56FE
        sty     BlockNumTmp+1                   ; 5701
        bcs     L56EE                           ; 5704
L5706:  inx                                     ; 5706
        cpx     #$23                            ; 5707
        beq     L5714                           ; 5709
        cpx     #$12                            ; 570B
        bcc     L5710                           ; 570D
        inx                                     ; 570F
L5710:  stx     BlockNumTmp                     ; 5710
        rts                                     ; 5713

; ----------------------------------------------------------------------------
L5714:  lda     #$12                            ; 5714
        sta     BlockNumTmp                     ; 5716
        sec                                     ; 5719
        sbc     BlockNumTmp+1                   ; 571A
        sta     BlockNumTmp+1                   ; 571D
        rts                                     ; 5720

; ----------------------------------------------------------------------------
; Track lengths (32 entries)
TrackSizeTab:
        .byte   $15,$15,$15,$15,$15,$15,$15,$15 ; 5721
        .byte   $15,$15,$15,$15,$15,$15,$15,$15 ; 5729
        .byte   $15,$13,$13,$13,$13,$13,$13,$12 ; 5731
        .byte   $12,$12,$12,$12,$12,$11,$11,$11 ; 5739
        .byte   $11,$11                         ; 5741
; ----------------------------------------------------------------------------
        .byte   $FF                             ; 5743
; Status of the last I/O operation
IOStatus:
        brk                                     ; 5744
; ProDOS block number / converted track and sector
BlockNumTmp:
        .word   $0000                           ; 5745
; ----------------------------------------------------------------------------
; boot1.bin sets $FFFE/F to that
IRQHandler:
        pha                                     ; 5747
        lda     #$FF                            ; 5748
        sta     $FF09                           ; 574A
        pla                                     ; 574D
; end of code: $574F, $57FF?
ProDOS_END:
        rti                                     ; 574E

; ----------------------------------------------------------------------------
