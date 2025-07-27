; da65 V2.19 - Git dcdf7ade0
; Created:    2025-07-27 19:58:46
; Input file: subs0500.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
L0006           := $0006
L0010           := $0010
L00AA           := $00AA
L00AC           := $00AC
L00B7           := $00B7
L00BB           := $00BB
L0101           := $0101
L0160           := $0160
L0181           := $0181
L018A           := $018A
L018C           := $018C
L0192           := $0192
L0199           := $0199
L02A8           := $02A8
L046D           := $046D
L53C8           := $53C8
L5540           := $5540
L6F6D           := $6F6D
L7000           := $7000
L7048           := $7048
L7552           := $7552
L7C74           := $7C74
L8000           := $8000
L8020           := $8020
L8040           := $8040
L910F           := $910F
L9826           := $9826
LA020           := $A020
LC0C5           := $C0C5
LC431           := $C431
LCC8C           := $CC8C
LDF0C           := $DF0C
LFF20           := $FF20
LFF5A           := $FF5A
LFF99           := $FF99
LFF9F           := $FF9F
LFFAF           := $FFAF
LFFE4           := $FFE4
LFFF6           := $FFF6
LFFFC           := $FFFC
; ----------------------------------------------------------------------------
L0500:  sty     L053B                           ; 0500
        sta     L053C                           ; 0503
        lda     #$09                            ; 0506
        bcs     L050C                           ; 0508
        lda     #$0C                            ; 050A
L050C:  sta     L0520                           ; 050C
        lda     $E8                             ; 050F
        and     #$7E                            ; 0511
        ldx     #$00                            ; 0513
        asl     a                               ; 0515
        asl     a                               ; 0516
        bcc     L051A                           ; 0517
        inx                                     ; 0519
L051A:  clc                                     ; 051A
        sta     L052A                           ; 051B
        txa                                     ; 051E
        .byte   $69                             ; 051F
L0520:  brk                                     ; 0520
        sta     L052B                           ; 0521
        ldx     #$07                            ; 0524
L0526:  lda     $E8                             ; 0526
        lsr     a                               ; 0528
        .byte   $BD                             ; 0529
L052A:  .byte   $FF                             ; 052A
L052B:  .byte   $FF                             ; 052B
        bcc     L0532                           ; 052C
L052E:  lsr     a                               ; 052E
        lsr     a                               ; 052F
        lsr     a                               ; 0530
        lsr     a                               ; 0531
L0532:  and     #$0F                            ; 0532
        tay                                     ; 0534
        lda     L0C20,y                         ; 0535
        .byte   $49                             ; 0538
L0539:  brk                                     ; 0539
        .byte   $9D                             ; 053A
L053B:  .byte   $FF                             ; 053B
L053C:  .byte   $FF                             ; 053C
        dex                                     ; 053D
        bpl     L0526                           ; 053E
L0540:  jmp     L26EB                           ; 0540

; ----------------------------------------------------------------------------
L0543:  lda     L3BF8                           ; 0543
        sta     L0010                           ; 0546
        lda     #$02                            ; 0548
        sta     $D5                             ; 054A
L054C:  ldy     $D5                             ; 054C
        .byte   $B3                             ; 054E
        rol     L0F29                           ; 054F
        sta     $83                             ; 0552
        txa                                     ; 0554
        lsr     a                               ; 0555
        lsr     a                               ; 0556
        lsr     a                               ; 0557
        lsr     a                               ; 0558
        sta     $82                             ; 0559
        lda     ($30),y                         ; 055B
        and     #$0F                            ; 055D
        sta     $84                             ; 055F
        bne     L0566                           ; 0561
L0563:  jmp     L05F8                           ; 0563

; ----------------------------------------------------------------------------
L0566:  cmp     #$0C                            ; 0566
        beq     L0563                           ; 0568
        ldx     #$01                            ; 056A
        lda     #$0C                            ; 056C
        cmp     $82                             ; 056E
        beq     L057A                           ; 0570
        inx                                     ; 0572
        cmp     $83                             ; 0573
        beq     L057A                           ; 0575
        jmp     L0603                           ; 0577

; ----------------------------------------------------------------------------
L057A:  ldy     #$03                            ; 057A
        lda     $81,x                           ; 057C
        pha                                     ; 057E
        lda     $81,y                           ; 057F
        sta     $81,x                           ; 0582
        pla                                     ; 0584
        sta     $81,y                           ; 0585
        lda     L06B5,x                         ; 0588
        sta     $0B                             ; 058B
        ldy     #$07                            ; 058D
L058F:  lda     ($E4),y                         ; 058F
        and     #$0F                            ; 0591
        ora     $0B                             ; 0593
        tax                                     ; 0595
        lda     L06B8,x                         ; 0596
        sta     $FF                             ; 0599
        lda     ($E4),y                         ; 059B
        lsr     a                               ; 059D
        lsr     a                               ; 059E
        lsr     a                               ; 059F
        lsr     a                               ; 05A0
        ora     $0B                             ; 05A1
        tax                                     ; 05A3
        lda     L06B8,x                         ; 05A4
        asl     a                               ; 05A7
        asl     a                               ; 05A8
        asl     a                               ; 05A9
        asl     a                               ; 05AA
        ora     $FF                             ; 05AB
        sta     (L0006),y                       ; 05AD
        dey                                     ; 05AF
        bpl     L058F                           ; 05B0
L05B2:  ldy     $82                             ; 05B2
        .byte   $BF                             ; 05B4
        bmi     L05C3                           ; 05B5
        asl     a                               ; 05B7
        asl     a                               ; 05B8
        asl     a                               ; 05B9
        asl     a                               ; 05BA
        sta     $82                             ; 05BB
        txa                                     ; 05BD
        lsr     a                               ; 05BE
        lsr     a                               ; 05BF
        lsr     a                               ; 05C0
        lsr     a                               ; 05C1
        .byte   $85                             ; 05C2
L05C3:  sty     $A4                             ; 05C3
        .byte   $83                             ; 05C5
        .byte   $BF                             ; 05C6
        bmi     L05D5                           ; 05C7
        ldy     $D5                             ; 05C9
        and     #$0F                            ; 05CB
        ora     $82                             ; 05CD
        sta     ($DB),y                         ; 05CF
        txa                                     ; 05D1
        and     #$F0                            ; 05D2
        .byte   $05                             ; 05D4
L05D5:  sty     $91                             ; 05D5
        cmp     $A918,x                         ; 05D7
        php                                     ; 05DA
        adc     L0006                           ; 05DB
        sta     L0006                           ; 05DD
        bcc     L05E3                           ; 05DF
        inc     $07                             ; 05E1
L05E3:  clc                                     ; 05E3
        lda     #$08                            ; 05E4
        adc     $E4                             ; 05E6
        sta     $E4                             ; 05E8
        bcc     L05EE                           ; 05EA
        inc     $E5                             ; 05EC
L05EE:  inc     $D5                             ; 05EE
        dec     L0010                           ; 05F0
        beq     L05F7                           ; 05F2
        jmp     L054C                           ; 05F4

; ----------------------------------------------------------------------------
L05F7:  rts                                     ; 05F7

; ----------------------------------------------------------------------------
L05F8:  ldy     #$07                            ; 05F8
L05FA:  lda     ($E4),y                         ; 05FA
        sta     (L0006),y                       ; 05FC
        dey                                     ; 05FE
        bpl     L05FA                           ; 05FF
        bmi     L05B2                           ; 0601
L0603:  ldx     #$01                            ; 0603
        .byte   $A5                             ; 0605
L0606:  .byte   $82                             ; 0606
        .byte   $D0                             ; 0607
L0608:  .byte   $03                             ; 0608
L0609:  jmp     L057A                           ; 0609

; ----------------------------------------------------------------------------
L060C:  inx                                     ; 060C
        lda     $83                             ; 060D
        beq     L0609                           ; 060F
        lda     #$0F                            ; 0611
        cmp     $83                             ; 0613
        beq     L0609                           ; 0615
        dex                                     ; 0617
        cmp     $82                             ; 0618
        beq     L0609                           ; 061A
        lda     #$0B                            ; 061C
        cmp     $82                             ; 061E
        beq     L0609                           ; 0620
        inx                                     ; 0622
        cmp     $83                             ; 0623
        beq     L0609                           ; 0625
        bne     L05F8                           ; 0627
L0629:  tay                                     ; 0629
        lda     #$7F                            ; 062A
        sta     $FD30                           ; 062C
        sta     $FF08                           ; 062F
        lda     $FF08                           ; 0632
        and     #$04                            ; 0635
        bne     L0646                           ; 0637
        bit     L2E9E                           ; 0639
        bpl     L0646                           ; 063C
        iny                                     ; 063E
        lda     ($9B),y                         ; 063F
        and     #$F7                            ; 0641
        sta     ($9B),y                         ; 0643
        dey                                     ; 0645
L0646:  lda     ($9B),y                         ; 0646
        rts                                     ; 0648

; ----------------------------------------------------------------------------
        brk                                     ; 0649
        brk                                     ; 064A
        brk                                     ; 064B
        brk                                     ; 064C
        brk                                     ; 064D
        brk                                     ; 064E
        brk                                     ; 064F
        sei                                     ; 0650
        sta     L7000                           ; 0651
        stx     $7001                           ; 0654
        sty     $7002                           ; 0657
        tsx                                     ; 065A
        stx     $7003                           ; 065B
        ldy     #$10                            ; 065E
        ldx     #$00                            ; 0660
L0662:  .byte   $BD                             ; 0662
        brk                                     ; 0663
L0664:  brk                                     ; 0664
        .byte   $9D                             ; 0665
        brk                                     ; 0666
L0667:  rts                                     ; 0667

; ----------------------------------------------------------------------------
        dex                                     ; 0668
        bne     L0662                           ; 0669
        inc     L0664                           ; 066B
        inc     L0667                           ; 066E
        dey                                     ; 0671
        bne     L0662                           ; 0672
        sta     $FF3E                           ; 0674
        jmp     LFFF6                           ; 0677

; ----------------------------------------------------------------------------
        brk                                     ; 067A
        brk                                     ; 067B
        brk                                     ; 067C
        brk                                     ; 067D
        brk                                     ; 067E
        brk                                     ; 067F
        brk                                     ; 0680
        brk                                     ; 0681
        brk                                     ; 0682
        brk                                     ; 0683
        brk                                     ; 0684
        brk                                     ; 0685
        brk                                     ; 0686
        brk                                     ; 0687
        brk                                     ; 0688
        brk                                     ; 0689
        brk                                     ; 068A
        brk                                     ; 068B
        brk                                     ; 068C
        brk                                     ; 068D
        brk                                     ; 068E
        brk                                     ; 068F
        brk                                     ; 0690
        brk                                     ; 0691
        brk                                     ; 0692
        brk                                     ; 0693
        brk                                     ; 0694
        brk                                     ; 0695
        brk                                     ; 0696
        brk                                     ; 0697
        brk                                     ; 0698
        brk                                     ; 0699
        brk                                     ; 069A
        brk                                     ; 069B
        brk                                     ; 069C
        brk                                     ; 069D
        brk                                     ; 069E
        brk                                     ; 069F
        brk                                     ; 06A0
        brk                                     ; 06A1
        brk                                     ; 06A2
        brk                                     ; 06A3
        brk                                     ; 06A4
        brk                                     ; 06A5
        brk                                     ; 06A6
        brk                                     ; 06A7
        brk                                     ; 06A8
        brk                                     ; 06A9
        brk                                     ; 06AA
        brk                                     ; 06AB
        brk                                     ; 06AC
        brk                                     ; 06AD
        brk                                     ; 06AE
        brk                                     ; 06AF
        brk                                     ; 06B0
        brk                                     ; 06B1
        brk                                     ; 06B2
        brk                                     ; 06B3
        brk                                     ; 06B4
L06B5:  brk                                     ; 06B5
        brk                                     ; 06B6
        .byte   $10                             ; 06B7
L06B8:  brk                                     ; 06B8
        .byte   $03                             ; 06B9
        .byte   $02                             ; 06BA
        ora     ($0C,x)                         ; 06BB
        .byte   $0F                             ; 06BD
        asl     L080D                           ; 06BE
        .byte   $0B                             ; 06C1
        asl     a                               ; 06C2
        ora     #$04                            ; 06C3
        .byte   $07                             ; 06C5
        asl     $05                             ; 06C6
        brk                                     ; 06C8
        ora     ($03,x)                         ; 06C9
        .byte   $02                             ; 06CB
        .byte   $04                             ; 06CC
        ora     $07                             ; 06CD
        asl     $0C                             ; 06CF
        ora     L0E0F                           ; 06D1
        php                                     ; 06D4
        ora     #$0B                            ; 06D5
        asl     a                               ; 06D7
L06D8:  brk                                     ; 06D8
        brk                                     ; 06D9
        brk                                     ; 06DA
        brk                                     ; 06DB
        brk                                     ; 06DC
        brk                                     ; 06DD
        brk                                     ; 06DE
        brk                                     ; 06DF
        brk                                     ; 06E0
        brk                                     ; 06E1
        brk                                     ; 06E2
        brk                                     ; 06E3
        brk                                     ; 06E4
        brk                                     ; 06E5
        brk                                     ; 06E6
        brk                                     ; 06E7
        brk                                     ; 06E8
        brk                                     ; 06E9
        brk                                     ; 06EA
        brk                                     ; 06EB
        brk                                     ; 06EC
        brk                                     ; 06ED
        brk                                     ; 06EE
        brk                                     ; 06EF
        brk                                     ; 06F0
        brk                                     ; 06F1
        brk                                     ; 06F2
        brk                                     ; 06F3
        brk                                     ; 06F4
        brk                                     ; 06F5
        brk                                     ; 06F6
        brk                                     ; 06F7
        brk                                     ; 06F8
        brk                                     ; 06F9
        brk                                     ; 06FA
        brk                                     ; 06FB
        brk                                     ; 06FC
        brk                                     ; 06FD
        brk                                     ; 06FE
        brk                                     ; 06FF
        brk                                     ; 0700
        brk                                     ; 0701
        brk                                     ; 0702
        brk                                     ; 0703
        brk                                     ; 0704
        brk                                     ; 0705
        brk                                     ; 0706
        brk                                     ; 0707
        brk                                     ; 0708
        brk                                     ; 0709
        brk                                     ; 070A
        brk                                     ; 070B
        brk                                     ; 070C
        brk                                     ; 070D
        brk                                     ; 070E
        brk                                     ; 070F
        brk                                     ; 0710
        brk                                     ; 0711
        brk                                     ; 0712
        brk                                     ; 0713
        brk                                     ; 0714
        brk                                     ; 0715
        brk                                     ; 0716
        brk                                     ; 0717
        brk                                     ; 0718
        brk                                     ; 0719
        brk                                     ; 071A
        brk                                     ; 071B
        brk                                     ; 071C
        brk                                     ; 071D
        brk                                     ; 071E
        brk                                     ; 071F
        brk                                     ; 0720
        brk                                     ; 0721
        brk                                     ; 0722
        brk                                     ; 0723
        brk                                     ; 0724
        brk                                     ; 0725
        brk                                     ; 0726
        brk                                     ; 0727
        brk                                     ; 0728
        brk                                     ; 0729
        brk                                     ; 072A
        brk                                     ; 072B
L072C:  brk                                     ; 072C
        brk                                     ; 072D
        brk                                     ; 072E
        brk                                     ; 072F
        brk                                     ; 0730
        brk                                     ; 0731
        brk                                     ; 0732
        brk                                     ; 0733
        brk                                     ; 0734
        brk                                     ; 0735
        brk                                     ; 0736
        brk                                     ; 0737
        brk                                     ; 0738
        brk                                     ; 0739
        brk                                     ; 073A
        brk                                     ; 073B
        brk                                     ; 073C
        brk                                     ; 073D
        brk                                     ; 073E
        brk                                     ; 073F
        brk                                     ; 0740
        brk                                     ; 0741
        brk                                     ; 0742
        brk                                     ; 0743
        brk                                     ; 0744
        brk                                     ; 0745
        brk                                     ; 0746
        brk                                     ; 0747
        brk                                     ; 0748
        brk                                     ; 0749
        brk                                     ; 074A
        brk                                     ; 074B
        brk                                     ; 074C
        brk                                     ; 074D
        brk                                     ; 074E
        brk                                     ; 074F
        brk                                     ; 0750
        brk                                     ; 0751
        brk                                     ; 0752
        brk                                     ; 0753
        brk                                     ; 0754
        brk                                     ; 0755
        brk                                     ; 0756
        brk                                     ; 0757
        brk                                     ; 0758
        brk                                     ; 0759
        brk                                     ; 075A
        brk                                     ; 075B
        brk                                     ; 075C
        brk                                     ; 075D
        brk                                     ; 075E
        brk                                     ; 075F
        brk                                     ; 0760
        brk                                     ; 0761
        brk                                     ; 0762
        brk                                     ; 0763
        brk                                     ; 0764
        brk                                     ; 0765
        brk                                     ; 0766
        brk                                     ; 0767
        brk                                     ; 0768
        brk                                     ; 0769
        brk                                     ; 076A
        brk                                     ; 076B
        brk                                     ; 076C
        brk                                     ; 076D
        brk                                     ; 076E
        brk                                     ; 076F
        brk                                     ; 0770
        brk                                     ; 0771
        brk                                     ; 0772
        brk                                     ; 0773
        brk                                     ; 0774
        brk                                     ; 0775
        brk                                     ; 0776
        brk                                     ; 0777
        brk                                     ; 0778
        brk                                     ; 0779
        brk                                     ; 077A
        brk                                     ; 077B
        brk                                     ; 077C
        brk                                     ; 077D
        brk                                     ; 077E
        brk                                     ; 077F
        brk                                     ; 0780
        brk                                     ; 0781
        brk                                     ; 0782
        brk                                     ; 0783
        brk                                     ; 0784
        brk                                     ; 0785
        brk                                     ; 0786
        brk                                     ; 0787
        brk                                     ; 0788
        brk                                     ; 0789
        brk                                     ; 078A
        brk                                     ; 078B
        brk                                     ; 078C
        brk                                     ; 078D
        brk                                     ; 078E
        brk                                     ; 078F
        brk                                     ; 0790
        brk                                     ; 0791
        brk                                     ; 0792
        brk                                     ; 0793
        brk                                     ; 0794
        brk                                     ; 0795
        brk                                     ; 0796
        brk                                     ; 0797
        brk                                     ; 0798
        brk                                     ; 0799
        brk                                     ; 079A
        brk                                     ; 079B
        brk                                     ; 079C
        brk                                     ; 079D
        brk                                     ; 079E
        brk                                     ; 079F
        brk                                     ; 07A0
        brk                                     ; 07A1
        brk                                     ; 07A2
        brk                                     ; 07A3
        brk                                     ; 07A4
        brk                                     ; 07A5
        brk                                     ; 07A6
        brk                                     ; 07A7
        brk                                     ; 07A8
        brk                                     ; 07A9
        brk                                     ; 07AA
        brk                                     ; 07AB
        brk                                     ; 07AC
        brk                                     ; 07AD
        brk                                     ; 07AE
        brk                                     ; 07AF
        brk                                     ; 07B0
        brk                                     ; 07B1
        brk                                     ; 07B2
        brk                                     ; 07B3
        brk                                     ; 07B4
        brk                                     ; 07B5
        brk                                     ; 07B6
        brk                                     ; 07B7
        brk                                     ; 07B8
        brk                                     ; 07B9
        brk                                     ; 07BA
        brk                                     ; 07BB
        brk                                     ; 07BC
        brk                                     ; 07BD
        brk                                     ; 07BE
        brk                                     ; 07BF
        brk                                     ; 07C0
        brk                                     ; 07C1
        brk                                     ; 07C2
        brk                                     ; 07C3
        brk                                     ; 07C4
        brk                                     ; 07C5
        brk                                     ; 07C6
        brk                                     ; 07C7
        brk                                     ; 07C8
        brk                                     ; 07C9
        brk                                     ; 07CA
        brk                                     ; 07CB
        brk                                     ; 07CC
        brk                                     ; 07CD
        brk                                     ; 07CE
        brk                                     ; 07CF
        brk                                     ; 07D0
        brk                                     ; 07D1
        brk                                     ; 07D2
        brk                                     ; 07D3
        brk                                     ; 07D4
        brk                                     ; 07D5
        brk                                     ; 07D6
        brk                                     ; 07D7
        brk                                     ; 07D8
        brk                                     ; 07D9
        brk                                     ; 07DA
        brk                                     ; 07DB
        brk                                     ; 07DC
        brk                                     ; 07DD
        brk                                     ; 07DE
        brk                                     ; 07DF
        brk                                     ; 07E0
        brk                                     ; 07E1
        brk                                     ; 07E2
        brk                                     ; 07E3
        brk                                     ; 07E4
        brk                                     ; 07E5
        brk                                     ; 07E6
        brk                                     ; 07E7
        brk                                     ; 07E8
        brk                                     ; 07E9
        brk                                     ; 07EA
        brk                                     ; 07EB
        brk                                     ; 07EC
        brk                                     ; 07ED
        brk                                     ; 07EE
        brk                                     ; 07EF
        brk                                     ; 07F0
        brk                                     ; 07F1
        brk                                     ; 07F2
        brk                                     ; 07F3
        brk                                     ; 07F4
        brk                                     ; 07F5
        brk                                     ; 07F6
        brk                                     ; 07F7
        brk                                     ; 07F8
        brk                                     ; 07F9
        brk                                     ; 07FA
        brk                                     ; 07FB
        brk                                     ; 07FC
        brk                                     ; 07FD
        brk                                     ; 07FE
        brk                                     ; 07FF
L0800:  brk                                     ; 0800
        brk                                     ; 0801
        brk                                     ; 0802
        brk                                     ; 0803
        brk                                     ; 0804
        brk                                     ; 0805
        brk                                     ; 0806
        brk                                     ; 0807
        brk                                     ; 0808
        brk                                     ; 0809
        brk                                     ; 080A
        brk                                     ; 080B
        brk                                     ; 080C
L080D:  brk                                     ; 080D
        brk                                     ; 080E
        brk                                     ; 080F
L0810:  brk                                     ; 0810
        brk                                     ; 0811
        brk                                     ; 0812
        brk                                     ; 0813
        brk                                     ; 0814
        brk                                     ; 0815
        brk                                     ; 0816
        brk                                     ; 0817
L0818:  brk                                     ; 0818
        brk                                     ; 0819
        brk                                     ; 081A
        brk                                     ; 081B
L081C:  brk                                     ; 081C
        brk                                     ; 081D
        brk                                     ; 081E
        brk                                     ; 081F
        brk                                     ; 0820
        brk                                     ; 0821
        brk                                     ; 0822
        brk                                     ; 0823
        brk                                     ; 0824
        brk                                     ; 0825
        brk                                     ; 0826
        brk                                     ; 0827
        brk                                     ; 0828
        brk                                     ; 0829
        brk                                     ; 082A
L082B:  brk                                     ; 082B
L082C:  brk                                     ; 082C
        brk                                     ; 082D
        brk                                     ; 082E
        brk                                     ; 082F
        brk                                     ; 0830
        brk                                     ; 0831
        brk                                     ; 0832
        brk                                     ; 0833
        brk                                     ; 0834
        brk                                     ; 0835
        brk                                     ; 0836
        brk                                     ; 0837
        brk                                     ; 0838
        brk                                     ; 0839
        brk                                     ; 083A
        brk                                     ; 083B
        brk                                     ; 083C
        brk                                     ; 083D
        brk                                     ; 083E
        brk                                     ; 083F
        brk                                     ; 0840
        brk                                     ; 0841
        brk                                     ; 0842
        brk                                     ; 0843
        brk                                     ; 0844
        brk                                     ; 0845
        brk                                     ; 0846
        brk                                     ; 0847
        brk                                     ; 0848
        brk                                     ; 0849
        brk                                     ; 084A
        brk                                     ; 084B
        brk                                     ; 084C
        brk                                     ; 084D
        brk                                     ; 084E
        brk                                     ; 084F
        brk                                     ; 0850
        brk                                     ; 0851
        brk                                     ; 0852
        brk                                     ; 0853
        brk                                     ; 0854
        brk                                     ; 0855
        brk                                     ; 0856
        brk                                     ; 0857
        brk                                     ; 0858
        brk                                     ; 0859
        brk                                     ; 085A
        brk                                     ; 085B
        brk                                     ; 085C
        brk                                     ; 085D
        brk                                     ; 085E
        brk                                     ; 085F
        brk                                     ; 0860
        brk                                     ; 0861
        brk                                     ; 0862
        brk                                     ; 0863
        brk                                     ; 0864
        brk                                     ; 0865
        brk                                     ; 0866
        brk                                     ; 0867
        brk                                     ; 0868
        brk                                     ; 0869
        brk                                     ; 086A
        brk                                     ; 086B
        brk                                     ; 086C
        brk                                     ; 086D
        brk                                     ; 086E
        brk                                     ; 086F
        brk                                     ; 0870
        brk                                     ; 0871
        brk                                     ; 0872
        brk                                     ; 0873
        brk                                     ; 0874
        brk                                     ; 0875
        brk                                     ; 0876
        brk                                     ; 0877
        brk                                     ; 0878
        brk                                     ; 0879
        brk                                     ; 087A
        brk                                     ; 087B
        brk                                     ; 087C
        brk                                     ; 087D
        brk                                     ; 087E
        brk                                     ; 087F
L0880:  brk                                     ; 0880
        brk                                     ; 0881
L0882:  brk                                     ; 0882
        brk                                     ; 0883
        brk                                     ; 0884
        brk                                     ; 0885
        brk                                     ; 0886
        brk                                     ; 0887
        brk                                     ; 0888
        brk                                     ; 0889
        brk                                     ; 088A
        brk                                     ; 088B
        brk                                     ; 088C
        brk                                     ; 088D
        brk                                     ; 088E
        brk                                     ; 088F
        brk                                     ; 0890
        brk                                     ; 0891
        brk                                     ; 0892
        brk                                     ; 0893
        brk                                     ; 0894
        brk                                     ; 0895
        brk                                     ; 0896
        brk                                     ; 0897
        brk                                     ; 0898
        brk                                     ; 0899
        brk                                     ; 089A
        brk                                     ; 089B
        brk                                     ; 089C
        brk                                     ; 089D
        brk                                     ; 089E
        brk                                     ; 089F
        brk                                     ; 08A0
        brk                                     ; 08A1
        brk                                     ; 08A2
        brk                                     ; 08A3
        brk                                     ; 08A4
        brk                                     ; 08A5
        brk                                     ; 08A6
        brk                                     ; 08A7
        brk                                     ; 08A8
        brk                                     ; 08A9
        brk                                     ; 08AA
        brk                                     ; 08AB
        brk                                     ; 08AC
        brk                                     ; 08AD
        brk                                     ; 08AE
        brk                                     ; 08AF
        brk                                     ; 08B0
        brk                                     ; 08B1
        brk                                     ; 08B2
        brk                                     ; 08B3
        brk                                     ; 08B4
        brk                                     ; 08B5
        brk                                     ; 08B6
        brk                                     ; 08B7
        brk                                     ; 08B8
        brk                                     ; 08B9
        brk                                     ; 08BA
        brk                                     ; 08BB
        brk                                     ; 08BC
        brk                                     ; 08BD
        brk                                     ; 08BE
        brk                                     ; 08BF
        brk                                     ; 08C0
        brk                                     ; 08C1
        brk                                     ; 08C2
        brk                                     ; 08C3
        brk                                     ; 08C4
        brk                                     ; 08C5
        brk                                     ; 08C6
        brk                                     ; 08C7
        brk                                     ; 08C8
        brk                                     ; 08C9
        brk                                     ; 08CA
        brk                                     ; 08CB
        brk                                     ; 08CC
        brk                                     ; 08CD
        brk                                     ; 08CE
        brk                                     ; 08CF
        brk                                     ; 08D0
        brk                                     ; 08D1
        brk                                     ; 08D2
        brk                                     ; 08D3
        brk                                     ; 08D4
        brk                                     ; 08D5
        brk                                     ; 08D6
        brk                                     ; 08D7
        brk                                     ; 08D8
        brk                                     ; 08D9
        brk                                     ; 08DA
        brk                                     ; 08DB
        brk                                     ; 08DC
        brk                                     ; 08DD
        brk                                     ; 08DE
        brk                                     ; 08DF
        brk                                     ; 08E0
        brk                                     ; 08E1
        brk                                     ; 08E2
        brk                                     ; 08E3
        brk                                     ; 08E4
        brk                                     ; 08E5
        brk                                     ; 08E6
        brk                                     ; 08E7
        brk                                     ; 08E8
        brk                                     ; 08E9
        brk                                     ; 08EA
        brk                                     ; 08EB
        brk                                     ; 08EC
        brk                                     ; 08ED
        brk                                     ; 08EE
        brk                                     ; 08EF
        brk                                     ; 08F0
        brk                                     ; 08F1
        brk                                     ; 08F2
        brk                                     ; 08F3
        brk                                     ; 08F4
        brk                                     ; 08F5
        brk                                     ; 08F6
        brk                                     ; 08F7
        brk                                     ; 08F8
        brk                                     ; 08F9
        brk                                     ; 08FA
        brk                                     ; 08FB
        brk                                     ; 08FC
        brk                                     ; 08FD
        brk                                     ; 08FE
        brk                                     ; 08FF
        brk                                     ; 0900
        brk                                     ; 0901
        brk                                     ; 0902
        brk                                     ; 0903
        brk                                     ; 0904
        brk                                     ; 0905
        brk                                     ; 0906
        brk                                     ; 0907
        brk                                     ; 0908
        brk                                     ; 0909
        brk                                     ; 090A
        brk                                     ; 090B
        brk                                     ; 090C
        brk                                     ; 090D
        brk                                     ; 090E
        brk                                     ; 090F
        brk                                     ; 0910
        brk                                     ; 0911
        brk                                     ; 0912
        brk                                     ; 0913
        brk                                     ; 0914
        brk                                     ; 0915
        brk                                     ; 0916
        brk                                     ; 0917
        brk                                     ; 0918
        brk                                     ; 0919
        brk                                     ; 091A
        brk                                     ; 091B
        brk                                     ; 091C
        brk                                     ; 091D
        brk                                     ; 091E
        brk                                     ; 091F
        brk                                     ; 0920
        brk                                     ; 0921
        brk                                     ; 0922
        brk                                     ; 0923
        brk                                     ; 0924
        brk                                     ; 0925
        brk                                     ; 0926
        brk                                     ; 0927
        brk                                     ; 0928
        brk                                     ; 0929
        brk                                     ; 092A
        brk                                     ; 092B
        brk                                     ; 092C
        brk                                     ; 092D
        brk                                     ; 092E
        brk                                     ; 092F
        brk                                     ; 0930
        brk                                     ; 0931
        brk                                     ; 0932
        brk                                     ; 0933
        brk                                     ; 0934
        brk                                     ; 0935
        brk                                     ; 0936
        brk                                     ; 0937
        brk                                     ; 0938
        brk                                     ; 0939
        brk                                     ; 093A
        brk                                     ; 093B
        brk                                     ; 093C
        brk                                     ; 093D
        brk                                     ; 093E
        brk                                     ; 093F
        brk                                     ; 0940
        brk                                     ; 0941
        brk                                     ; 0942
        brk                                     ; 0943
        brk                                     ; 0944
        brk                                     ; 0945
        brk                                     ; 0946
        brk                                     ; 0947
        brk                                     ; 0948
        brk                                     ; 0949
        brk                                     ; 094A
        brk                                     ; 094B
        brk                                     ; 094C
        brk                                     ; 094D
        brk                                     ; 094E
        brk                                     ; 094F
        brk                                     ; 0950
        brk                                     ; 0951
        brk                                     ; 0952
        brk                                     ; 0953
        brk                                     ; 0954
        brk                                     ; 0955
        brk                                     ; 0956
        brk                                     ; 0957
        brk                                     ; 0958
        brk                                     ; 0959
        brk                                     ; 095A
        brk                                     ; 095B
        brk                                     ; 095C
        brk                                     ; 095D
        brk                                     ; 095E
        brk                                     ; 095F
        brk                                     ; 0960
        brk                                     ; 0961
        brk                                     ; 0962
        brk                                     ; 0963
        brk                                     ; 0964
        brk                                     ; 0965
        brk                                     ; 0966
        brk                                     ; 0967
        brk                                     ; 0968
        brk                                     ; 0969
        brk                                     ; 096A
        brk                                     ; 096B
L096C:  brk                                     ; 096C
        brk                                     ; 096D
        brk                                     ; 096E
        brk                                     ; 096F
        brk                                     ; 0970
        brk                                     ; 0971
        brk                                     ; 0972
        brk                                     ; 0973
        brk                                     ; 0974
        brk                                     ; 0975
        brk                                     ; 0976
        brk                                     ; 0977
        brk                                     ; 0978
        brk                                     ; 0979
        brk                                     ; 097A
        brk                                     ; 097B
        brk                                     ; 097C
        brk                                     ; 097D
        brk                                     ; 097E
L097F:  brk                                     ; 097F
        rti                                     ; 0980

; ----------------------------------------------------------------------------
        rti                                     ; 0981

; ----------------------------------------------------------------------------
        rti                                     ; 0982

; ----------------------------------------------------------------------------
        rti                                     ; 0983

; ----------------------------------------------------------------------------
        brk                                     ; 0984
        rti                                     ; 0985

; ----------------------------------------------------------------------------
        rti                                     ; 0986

; ----------------------------------------------------------------------------
        brk                                     ; 0987
        tax                                     ; 0988
        tax                                     ; 0989
        cpx     #$A0                            ; 098A
        cpx     #$A0                            ; 098C
        ldy     #$00                            ; 098E
        sty     $86                             ; 0990
        bit     $8644                           ; 0992
        bit     a:$24                           ; 0995
        rti                                     ; 0998

; ----------------------------------------------------------------------------
        rti                                     ; 0999

; ----------------------------------------------------------------------------
        .byte   $04                             ; 099A
        asl     a:$04                           ; 099B
        brk                                     ; 099E
        brk                                     ; 099F
        .byte   $82                             ; 09A0
        .byte   $44                             ; 09A1
        plp                                     ; 09A2
        plp                                     ; 09A3
        plp                                     ; 09A4
        .byte   $44                             ; 09A5
        .byte   $82                             ; 09A6
        brk                                     ; 09A7
        brk                                     ; 09A8
        rti                                     ; 09A9

; ----------------------------------------------------------------------------
        lsr     a                               ; 09AA
        cpx     $4A                             ; 09AB
        rti                                     ; 09AD

; ----------------------------------------------------------------------------
        brk                                     ; 09AE
        brk                                     ; 09AF
        brk                                     ; 09B0
        brk                                     ; 09B1
        brk                                     ; 09B2
        cpx     #$04                            ; 09B3
        .byte   $04                             ; 09B5
        php                                     ; 09B6
        brk                                     ; 09B7
        brk                                     ; 09B8
        brk                                     ; 09B9
        jsr     L8040                           ; 09BA
        .byte   $04                             ; 09BD
        .byte   $04                             ; 09BE
        brk                                     ; 09BF
        lsr     L4ACA                           ; 09C0
        lsr     a                               ; 09C3
        lsr     a                               ; 09C4
        lsr     a                               ; 09C5
        lsr     $EE00                           ; 09C6
        tax                                     ; 09C9
        .byte   $22                             ; 09CA
        .byte   $62                             ; 09CB
        bit     $A8                             ; 09CC
        inc     $EA00                           ; 09CE
        txa                                     ; 09D1
        txa                                     ; 09D2
        inc     L2222                           ; 09D3
        .byte   $E2                             ; 09D6
        brk                                     ; 09D7
        inc     L282A                           ; 09D8
        rol     L2A2A                           ; 09DB
        rol     $EE00                           ; 09DE
        tax                                     ; 09E1
        tax                                     ; 09E2
        inc     L2A2A                           ; 09E3
        inc     a:$00                           ; 09E6
        brk                                     ; 09E9
        .byte   $44                             ; 09EA
        brk                                     ; 09EB
        .byte   $44                             ; 09EC
        rti                                     ; 09ED

; ----------------------------------------------------------------------------
        .byte   $80                             ; 09EE
        brk                                     ; 09EF
        brk                                     ; 09F0
        .byte   $02                             ; 09F1
        cpx     $08                             ; 09F2
        cpx     $02                             ; 09F4
        brk                                     ; 09F6
        brk                                     ; 09F7
        cpx     #$A8                            ; 09F8
        bit     $42                             ; 09FA
        .byte   $04                             ; 09FC
        pha                                     ; 09FD
        rti                                     ; 09FE

; ----------------------------------------------------------------------------
        brk                                     ; 09FF
        .byte   $EF                             ; 0A00
        .byte   $AF                             ; 0A01
        .byte   $AF                             ; 0A02
        .byte   $EF                             ; 0A03
        .byte   $AF                             ; 0A04
        .byte   $AF                             ; 0A05
        .byte   $AF                             ; 0A06
        .byte   $0F                             ; 0A07
        cpx     $8AAA                           ; 0A08
        sty     $AA8A                           ; 0A0B
        cpx     $EC00                           ; 0A0E
        txa                                     ; 0A11
        txa                                     ; 0A12
        dex                                     ; 0A13
        txa                                     ; 0A14
        txa                                     ; 0A15
        cpx     $EE00                           ; 0A16
        tay                                     ; 0A19
        dey                                     ; 0A1A
        sty     $A8A8                           ; 0A1B
        inx                                     ; 0A1E
        brk                                     ; 0A1F
        nop                                     ; 0A20
        lsr     a                               ; 0A21
        lsr     a                               ; 0A22
        lsr     L4A4A                           ; 0A23
        nop                                     ; 0A26
        brk                                     ; 0A27
        ldx     #$A2                            ; 0A28
        ldx     #$C2                            ; 0A2A
        tax                                     ; 0A2C
        tax                                     ; 0A2D
        ldx     $A800                           ; 0A2E
        inx                                     ; 0A31
        tay                                     ; 0A32
        tay                                     ; 0A33
        tay                                     ; 0A34
L0A35:  tay                                     ; 0A35
        ldx     $EC00                           ; 0A36
        tax                                     ; 0A39
        tax                                     ; 0A3A
        tax                                     ; 0A3B
        tax                                     ; 0A3C
        tax                                     ; 0A3D
        nop                                     ; 0A3E
        brk                                     ; 0A3F
        inc     $AAAA                           ; 0A40
        ldx     $A8A8                           ; 0A43
        inx                                     ; 0A46
        bmi     L0A35                           ; 0A47
        txa                                     ; 0A49
        txa                                     ; 0A4A
        cpx     L2A2A                           ; 0A4B
        nop                                     ; 0A4E
        brk                                     ; 0A4F
        ldx     $A4A4                           ; 0A50
        ldy     $A4                             ; 0A53
        ldy     $E4                             ; 0A55
        brk                                     ; 0A57
        tax                                     ; 0A58
        tax                                     ; 0A59
        tax                                     ; 0A5A
        tax                                     ; 0A5B
        tax                                     ; 0A5C
        cpx     $A4                             ; 0A5D
        brk                                     ; 0A5F
        tax                                     ; 0A60
        tax                                     ; 0A61
        tax                                     ; 0A62
        .byte   $44                             ; 0A63
        lsr     a                               ; 0A64
        lsr     a                               ; 0A65
        lsr     a                               ; 0A66
        brk                                     ; 0A67
        dec     $8282                           ; 0A68
        sty     $88                             ; 0A6B
        dey                                     ; 0A6D
        dec     $C400                           ; 0A6E
        lsr     a                               ; 0A71
        pha                                     ; 0A72
        jmp     L4848                           ; 0A73

; ----------------------------------------------------------------------------
        dec     $0400                           ; 0A76
        asl     $F424                           ; 0A79
        bit     $04                             ; 0A7C
        .byte   $04                             ; 0A7E
        brk                                     ; 0A7F
        asl     a                               ; 0A80
        asl     a                               ; 0A81
        cpx     #$20                            ; 0A82
        cpx     #$A0                            ; 0A84
        cpx     #$00                            ; 0A86
        brk                                     ; 0A88
        php                                     ; 0A89
        inx                                     ; 0A8A
        ldx     $AA8A                           ; 0A8B
        inc     a:$00                           ; 0A8E
        .byte   $02                             ; 0A91
        .byte   $E2                             ; 0A92
        ldx     $8AEA                           ; 0A93
        .byte   $EE                             ; 0A96
L0A97:  brk                                     ; 0A97
        brk                                     ; 0A98
        asl     $A8EA                           ; 0A99
        ldy     L28E8                           ; 0A9C
        cpx     #$00                            ; 0A9F
        pha                                     ; 0AA1
        php                                     ; 0AA2
        lsr     L4A4A                           ; 0AA3
        lsr     a                               ; 0AA6
        brk                                     ; 0AA7
        brk                                     ; 0AA8
        .byte   $82                             ; 0AA9
        .byte   $80                             ; 0AAA
        ldx     #$C2                            ; 0AAB
        ldx     #$AA                            ; 0AAD
        asl     $0400                           ; 0AAF
        ldy     $E4                             ; 0AB2
        ldy     $A4                             ; 0AB4
        ldy     $00                             ; 0AB6
        brk                                     ; 0AB8
        brk                                     ; 0AB9
        inc     $AAAA                           ; 0ABA
        tax                                     ; 0ABD
        nop                                     ; 0ABE
        brk                                     ; 0ABF
        brk                                     ; 0AC0
        brk                                     ; 0AC1
        inc     $AAAA                           ; 0AC2
        inc     L2828                           ; 0AC5
        brk                                     ; 0AC8
        brk                                     ; 0AC9
        inc     $E88A                           ; 0ACA
        plp                                     ; 0ACD
        inx                                     ; 0ACE
        brk                                     ; 0ACF
        brk                                     ; 0AD0
        .byte   $04                             ; 0AD1
        ldx     $A4A4                           ; 0AD2
        ldy     $E4                             ; 0AD5
        brk                                     ; 0AD7
        brk                                     ; 0AD8
        brk                                     ; 0AD9
        tax                                     ; 0ADA
        tax                                     ; 0ADB
        tax                                     ; 0ADC
        cpx     $A4                             ; 0ADD
        brk                                     ; 0ADF
        brk                                     ; 0AE0
        brk                                     ; 0AE1
        tax                                     ; 0AE2
        tax                                     ; 0AE3
        ldy     $EA                             ; 0AE4
        rol     a                               ; 0AE6
        cpx     #$70                            ; 0AE7
        .byte   $80                             ; 0AE9
        ldx     $B4A2,y                         ; 0AEA
        dey                                     ; 0AED
        ror     $6C00,x                         ; 0AEE
        .byte   $62                             ; 0AF1
        ror     a                               ; 0AF2
        .byte   $62                             ; 0AF3
        ror     a                               ; 0AF4
        .byte   $62                             ; 0AF5
        jmp     (L0F60)                         ; 0AF6

; ----------------------------------------------------------------------------
        .byte   $8F                             ; 0AF9
        .byte   $8F                             ; 0AFA
        .byte   $CF                             ; 0AFB
        .byte   $CF                             ; 0AFC
        .byte   $EF                             ; 0AFD
        .byte   $EF                             ; 0AFE
        .byte   $FF                             ; 0AFF
L0B00:  brk                                     ; 0B00
        rti                                     ; 0B01

; ----------------------------------------------------------------------------
        .byte   $80                             ; 0B02
        cpy     #$10                            ; 0B03
        bvc     L0A97                           ; 0B05
        bne     L0B29                           ; 0B07
        rts                                     ; 0B09

; ----------------------------------------------------------------------------
        ldy     #$E0                            ; 0B0A
        bmi     L0B7E                           ; 0B0C
        bcs     L0B00                           ; 0B0E
        .byte   $04                             ; 0B10
        .byte   $44                             ; 0B11
        sty     $C4                             ; 0B12
        .byte   $14                             ; 0B14
        .byte   $54                             ; 0B15
        sty     $D4,x                           ; 0B16
        bit     $64                             ; 0B18
        ldy     $E4                             ; 0B1A
        .byte   $34                             ; 0B1C
        .byte   $74                             ; 0B1D
        ldy     $F4,x                           ; 0B1E
        php                                     ; 0B20
        pha                                     ; 0B21
        dey                                     ; 0B22
        iny                                     ; 0B23
        clc                                     ; 0B24
        cli                                     ; 0B25
        tya                                     ; 0B26
        cld                                     ; 0B27
        plp                                     ; 0B28
L0B29:  pla                                     ; 0B29
        tay                                     ; 0B2A
        inx                                     ; 0B2B
        sec                                     ; 0B2C
        sei                                     ; 0B2D
        clv                                     ; 0B2E
        sed                                     ; 0B2F
        .byte   $0C                             ; 0B30
        jmp     LCC8C                           ; 0B31

; ----------------------------------------------------------------------------
        .byte   $1C                             ; 0B34
        .byte   $5C                             ; 0B35
        .byte   $9C                             ; 0B36
        .byte   $DC                             ; 0B37
        bit     $AC6C                           ; 0B38
        cpx     $7C3C                           ; 0B3B
        ldy     $01FC,x                         ; 0B3E
        eor     ($81,x)                         ; 0B41
        cmp     ($11,x)                         ; 0B43
        eor     ($91),y                         ; 0B45
        cmp     ($21),y                         ; 0B47
        adc     ($A1,x)                         ; 0B49
        sbc     ($31,x)                         ; 0B4B
        adc     ($B1),y                         ; 0B4D
        sbc     ($05),y                         ; 0B4F
        eor     $85                             ; 0B51
        cmp     $15                             ; 0B53
        eor     $95,x                           ; 0B55
        cmp     $25,x                           ; 0B57
        adc     $A5                             ; 0B59
        sbc     $35                             ; 0B5B
        adc     $B5,x                           ; 0B5D
        sbc     $09,x                           ; 0B5F
        eor     #$89                            ; 0B61
        cmp     #$19                            ; 0B63
        eor     $D999,y                         ; 0B65
        and     #$69                            ; 0B68
        lda     #$E9                            ; 0B6A
        and     $B979,y                         ; 0B6C
        sbc     L4D0D,y                         ; 0B6F
        sta     L1DCD                           ; 0B72
        eor     $DD9D,x                         ; 0B75
        and     $AD6D                           ; 0B78
        sbc     $7D3D                           ; 0B7B
L0B7E:  lda     $02FD,x                         ; 0B7E
        .byte   $42                             ; 0B81
        .byte   $82                             ; 0B82
        .byte   $C2                             ; 0B83
        .byte   $12                             ; 0B84
        .byte   $52                             ; 0B85
        .byte   $92                             ; 0B86
        .byte   $D2                             ; 0B87
        .byte   $22                             ; 0B88
        .byte   $62                             ; 0B89
        ldx     #$E2                            ; 0B8A
        .byte   $32                             ; 0B8C
        .byte   $72                             ; 0B8D
        .byte   $B2                             ; 0B8E
        .byte   $F2                             ; 0B8F
        asl     $46                             ; 0B90
        stx     $C6                             ; 0B92
        asl     $56,x                           ; 0B94
        stx     $D6,y                           ; 0B96
        rol     $66                             ; 0B98
        ldx     $E6                             ; 0B9A
        rol     $76,x                           ; 0B9C
        ldx     $F6,y                           ; 0B9E
        asl     a                               ; 0BA0
        lsr     a                               ; 0BA1
        txa                                     ; 0BA2
        dex                                     ; 0BA3
        .byte   $1A                             ; 0BA4
        .byte   $5A                             ; 0BA5
        txs                                     ; 0BA6
        .byte   $DA                             ; 0BA7
        rol     a                               ; 0BA8
        ror     a                               ; 0BA9
        tax                                     ; 0BAA
        nop                                     ; 0BAB
        .byte   $3A                             ; 0BAC
        .byte   $7A                             ; 0BAD
        tsx                                     ; 0BAE
        .byte   $FA                             ; 0BAF
        asl     $8E4E                           ; 0BB0
        dec     $5E1E                           ; 0BB3
        .byte   $9E                             ; 0BB6
        dec     $6E2E,x                         ; 0BB7
        ldx     L3EEE                           ; 0BBA
        ror     $FEBE,x                         ; 0BBD
        .byte   $03                             ; 0BC0
        .byte   $43                             ; 0BC1
        .byte   $83                             ; 0BC2
        .byte   $C3                             ; 0BC3
        .byte   $13                             ; 0BC4
        .byte   $53                             ; 0BC5
        .byte   $93                             ; 0BC6
        .byte   $D3                             ; 0BC7
        .byte   $23                             ; 0BC8
        .byte   $63                             ; 0BC9
        .byte   $A3                             ; 0BCA
        .byte   $E3                             ; 0BCB
        .byte   $33                             ; 0BCC
        .byte   $73                             ; 0BCD
        .byte   $B3                             ; 0BCE
        .byte   $F3                             ; 0BCF
        .byte   $07                             ; 0BD0
        .byte   $47                             ; 0BD1
        .byte   $87                             ; 0BD2
        .byte   $C7                             ; 0BD3
        .byte   $17                             ; 0BD4
        .byte   $57                             ; 0BD5
        .byte   $97                             ; 0BD6
        .byte   $D7                             ; 0BD7
        .byte   $27                             ; 0BD8
        .byte   $67                             ; 0BD9
        .byte   $A7                             ; 0BDA
        .byte   $E7                             ; 0BDB
        .byte   $37                             ; 0BDC
        .byte   $77                             ; 0BDD
        .byte   $B7                             ; 0BDE
        .byte   $F7                             ; 0BDF
        .byte   $0B                             ; 0BE0
        .byte   $4B                             ; 0BE1
        .byte   $8B                             ; 0BE2
        .byte   $CB                             ; 0BE3
        .byte   $1B                             ; 0BE4
        .byte   $5B                             ; 0BE5
        .byte   $9B                             ; 0BE6
        .byte   $DB                             ; 0BE7
        .byte   $2B                             ; 0BE8
        .byte   $6B                             ; 0BE9
        .byte   $AB                             ; 0BEA
        .byte   $EB                             ; 0BEB
        .byte   $3B                             ; 0BEC
        .byte   $7B                             ; 0BED
        .byte   $BB                             ; 0BEE
        .byte   $FB                             ; 0BEF
        .byte   $0F                             ; 0BF0
        .byte   $4F                             ; 0BF1
        .byte   $8F                             ; 0BF2
        .byte   $CF                             ; 0BF3
        .byte   $1F                             ; 0BF4
        .byte   $5F                             ; 0BF5
        .byte   $9F                             ; 0BF6
        .byte   $DF                             ; 0BF7
        .byte   $2F                             ; 0BF8
        .byte   $6F                             ; 0BF9
L0BFA:  .byte   $AF                             ; 0BFA
        .byte   $EF                             ; 0BFB
        .byte   $3F                             ; 0BFC
        .byte   $7F                             ; 0BFD
        .byte   $BF                             ; 0BFE
        .byte   $FF                             ; 0BFF
        .byte   $FF                             ; 0C00
        .byte   $FF                             ; 0C01
        php                                     ; 0C02
        php                                     ; 0C03
        .byte   $FB                             ; 0C04
        .byte   $FB                             ; 0C05
        asl     a                               ; 0C06
        asl     a                               ; 0C07
        .byte   $AF                             ; 0C08
        .byte   $AF                             ; 0C09
        lda     ($A1,x)                         ; 0C0A
        lda     $A5AD                           ; 0C0C
        lda     $A5                             ; 0C0F
        lda     $B5                             ; 0C11
        lda     $85,x                           ; 0C13
        sta     $F5                             ; 0C15
        sbc     $50,x                           ; 0C17
        bvc     L0BFA                           ; 0C19
        .byte   $DF                             ; 0C1B
        bpl     L0C2E                           ; 0C1C
        .byte   $FF                             ; 0C1E
        .byte   $FF                             ; 0C1F
L0C20:  eor     $56,x                           ; 0C20
        eor     $655A,y                         ; 0C22
        ror     $69                             ; 0C25
        ror     a                               ; 0C27
        sta     $96,x                           ; 0C28
        sta     $A59A,y                         ; 0C2A
        .byte   $A6                             ; 0C2D
L0C2E:  lda     #$AA                            ; 0C2E
        brk                                     ; 0C30
        adc     ($32),y                         ; 0C31
        .byte   $43                             ; 0C33
        .byte   $34                             ; 0C34
        eor     $16                             ; 0C35
        .byte   $67                             ; 0C37
        sec                                     ; 0C38
        ora     #$42                            ; 0C39
        and     ($41,x)                         ; 0C3B
        adc     $36                             ; 0C3D
        eor     ($55),y                         ; 0C3F
        .byte   $FF                             ; 0C41
        .byte   $FF                             ; 0C42
        .byte   $FF                             ; 0C43
        .byte   $FF                             ; 0C44
        .byte   $FF                             ; 0C45
        .byte   $FF                             ; 0C46
        tax                                     ; 0C47
        eor     $DB,x                           ; 0C48
        .byte   $DB                             ; 0C4A
        .byte   $DB                             ; 0C4B
        .byte   $DB                             ; 0C4C
        .byte   $DB                             ; 0C4D
        .byte   $DB                             ; 0C4E
        tax                                     ; 0C4F
        brk                                     ; 0C50
        brk                                     ; 0C51
        brk                                     ; 0C52
        brk                                     ; 0C53
        brk                                     ; 0C54
        brk                                     ; 0C55
        brk                                     ; 0C56
        brk                                     ; 0C57
        brk                                     ; 0C58
        brk                                     ; 0C59
        brk                                     ; 0C5A
        brk                                     ; 0C5B
        brk                                     ; 0C5C
        brk                                     ; 0C5D
        brk                                     ; 0C5E
        brk                                     ; 0C5F
        brk                                     ; 0C60
        brk                                     ; 0C61
        brk                                     ; 0C62
        brk                                     ; 0C63
        brk                                     ; 0C64
        brk                                     ; 0C65
        brk                                     ; 0C66
        brk                                     ; 0C67
        brk                                     ; 0C68
        brk                                     ; 0C69
        brk                                     ; 0C6A
        brk                                     ; 0C6B
        brk                                     ; 0C6C
        brk                                     ; 0C6D
        brk                                     ; 0C6E
        brk                                     ; 0C6F
        brk                                     ; 0C70
        brk                                     ; 0C71
        brk                                     ; 0C72
        brk                                     ; 0C73
        brk                                     ; 0C74
        brk                                     ; 0C75
        brk                                     ; 0C76
        brk                                     ; 0C77
        brk                                     ; 0C78
        brk                                     ; 0C79
        brk                                     ; 0C7A
        brk                                     ; 0C7B
        brk                                     ; 0C7C
        brk                                     ; 0C7D
        brk                                     ; 0C7E
        brk                                     ; 0C7F
        brk                                     ; 0C80
        brk                                     ; 0C81
        brk                                     ; 0C82
        brk                                     ; 0C83
        brk                                     ; 0C84
        brk                                     ; 0C85
        brk                                     ; 0C86
        brk                                     ; 0C87
        tax                                     ; 0C88
        .byte   $80                             ; 0C89
        .byte   $80                             ; 0C8A
        .byte   $80                             ; 0C8B
        .byte   $80                             ; 0C8C
        .byte   $80                             ; 0C8D
        .byte   $80                             ; 0C8E
        .byte   $80                             ; 0C8F
        tax                                     ; 0C90
        .byte   $02                             ; 0C91
        .byte   $02                             ; 0C92
        .byte   $02                             ; 0C93
        .byte   $02                             ; 0C94
        .byte   $02                             ; 0C95
        .byte   $02                             ; 0C96
        .byte   $02                             ; 0C97
        .byte   $80                             ; 0C98
        .byte   $80                             ; 0C99
        .byte   $80                             ; 0C9A
        .byte   $80                             ; 0C9B
        .byte   $80                             ; 0C9C
        .byte   $80                             ; 0C9D
        .byte   $80                             ; 0C9E
        tax                                     ; 0C9F
        .byte   $02                             ; 0CA0
        .byte   $02                             ; 0CA1
        .byte   $02                             ; 0CA2
        .byte   $02                             ; 0CA3
        .byte   $02                             ; 0CA4
        .byte   $02                             ; 0CA5
        .byte   $02                             ; 0CA6
        tax                                     ; 0CA7
        .byte   $80                             ; 0CA8
        .byte   $80                             ; 0CA9
        .byte   $80                             ; 0CAA
        .byte   $80                             ; 0CAB
        .byte   $80                             ; 0CAC
        .byte   $80                             ; 0CAD
        .byte   $80                             ; 0CAE
        .byte   $80                             ; 0CAF
        brk                                     ; 0CB0
        brk                                     ; 0CB1
        brk                                     ; 0CB2
        brk                                     ; 0CB3
        brk                                     ; 0CB4
        brk                                     ; 0CB5
        brk                                     ; 0CB6
        rol     a                               ; 0CB7
        rol     a                               ; 0CB8
        brk                                     ; 0CB9
        brk                                     ; 0CBA
        brk                                     ; 0CBB
        brk                                     ; 0CBC
        brk                                     ; 0CBD
        brk                                     ; 0CBE
        brk                                     ; 0CBF
        jsr     L2020                           ; 0CC0
        jsr     L2020                           ; 0CC3
        jsr     L8020                           ; 0CC6
        sta     ($82,x)                         ; 0CC9
        stx     $86                             ; 0CCB
        sta     ($81,x)                         ; 0CCD
        .byte   $80                             ; 0CCF
        .byte   $02                             ; 0CD0
        .byte   $82                             ; 0CD1
L0CD2:  .byte   $B2                             ; 0CD2
        ldx     #$A2                            ; 0CD3
        .byte   $82                             ; 0CD5
        .byte   $82                             ; 0CD6
        .byte   $02                             ; 0CD7
        .byte   $80                             ; 0CD8
        sta     ($81,x)                         ; 0CD9
        stx     $86                             ; 0CDB
        .byte   $82                             ; 0CDD
        sta     ($80,x)                         ; 0CDE
        .byte   $02                             ; 0CE0
        .byte   $82                             ; 0CE1
        .byte   $82                             ; 0CE2
        ldx     #$A2                            ; 0CE3
        .byte   $B2                             ; 0CE5
        .byte   $82                             ; 0CE6
        .byte   $02                             ; 0CE7
        .byte   $02                             ; 0CE8
        .byte   $02                             ; 0CE9
        .byte   $02                             ; 0CEA
        .byte   $02                             ; 0CEB
        .byte   $02                             ; 0CEC
        .byte   $02                             ; 0CED
        .byte   $02                             ; 0CEE
        .byte   $02                             ; 0CEF
        brk                                     ; 0CF0
        brk                                     ; 0CF1
        brk                                     ; 0CF2
        brk                                     ; 0CF3
        brk                                     ; 0CF4
        brk                                     ; 0CF5
        brk                                     ; 0CF6
        tax                                     ; 0CF7
        tax                                     ; 0CF8
        brk                                     ; 0CF9
        brk                                     ; 0CFA
        brk                                     ; 0CFB
        brk                                     ; 0CFC
        brk                                     ; 0CFD
L0CFE:  brk                                     ; 0CFE
        brk                                     ; 0CFF
        lda     ($0E,x)                         ; 0D00
        .byte   $9C                             ; 0D02
        asl     L0EA8                           ; 0D03
        ldy     $0E,x                           ; 0D06
        ldx     $BD0E                           ; 0D08
        .byte   $0E                             ; 0D0B
        dex                                     ; 0D0C
L0D0D:  .byte   $0E                             ; 0D0D
        .byte   $D3                             ; 0D0E
L0D0F:  asl     L0EDA                           ; 0D0F
        .byte   $E7                             ; 0D12
        asl     L0EF9                           ; 0D13
        .byte   $0F                             ; 0D16
        .byte   $0F                             ; 0D17
        .byte   $27                             ; 0D18
        .byte   $0F                             ; 0D19
        eor     #$0F                            ; 0D1A
        jmp     (L910F)                         ; 0D1C

; ----------------------------------------------------------------------------
        .byte   $0F                             ; 0D1F
        .byte   $BB                             ; 0D20
        .byte   $0F                             ; 0D21
        cpx     $0F                             ; 0D22
        .byte   $0B                             ; 0D24
        bpl     L0D48                           ; 0D25
        bpl     L0D62                           ; 0D27
L0D29:  bpl     L0D86                           ; 0D29
        bpl     L0DAB                           ; 0D2B
        bpl     L0CD2                           ; 0D2D
        bpl     L0CFE                           ; 0D2F
        bpl     L0D29                           ; 0D31
        bpl     L0D49                           ; 0D33
        ora     ($2C),y                         ; 0D35
        ora     ($5E),y                         ; 0D37
        ora     ($BF),y                         ; 0D39
        ora     L41EC,x                         ; 0D3B
        bpl     L0D5E                           ; 0D3E
        brk                                     ; 0D40
        brk                                     ; 0D41
        dey                                     ; 0D42
        ora     ($8F),y                         ; 0D43
        ora     ($9A),y                         ; 0D45
L0D47:  .byte   $11                             ; 0D47
L0D48:  .byte   $AE                             ; 0D48
L0D49:  ora     (L00BB),y                       ; 0D49
        ora     ($C0),y                         ; 0D4B
        ora     ($D7),y                         ; 0D4D
        ora     ($E6),y                         ; 0D4F
        ora     ($EB),y                         ; 0D51
        ora     ($FD),y                         ; 0D53
        ora     ($08),y                         ; 0D55
        .byte   $12                             ; 0D57
        ora     L1F12                           ; 0D58
        .byte   $12                             ; 0D5B
        rol     $12                             ; 0D5C
L0D5E:  .byte   $2B                             ; 0D5E
        .byte   $12                             ; 0D5F
        lsr     a                               ; 0D60
        .byte   $12                             ; 0D61
L0D62:  adc     $12                             ; 0D62
        sty     $12                             ; 0D64
        .byte   $9F                             ; 0D66
        .byte   $12                             ; 0D67
        .byte   $E2                             ; 0D68
        .byte   $12                             ; 0D69
        inc     L2F12,x                         ; 0D6A
        .byte   $13                             ; 0D6D
        .byte   $53                             ; 0D6E
        .byte   $13                             ; 0D6F
        adc     $8313                           ; 0D70
        .byte   $13                             ; 0D73
        sta     $B313,x                         ; 0D74
        .byte   $13                             ; 0D77
        cmp     $E313                           ; 0D78
        .byte   $13                             ; 0D7B
        .byte   $17                             ; 0D7C
        .byte   $14                             ; 0D7D
        pha                                     ; 0D7E
        .byte   $14                             ; 0D7F
        eor     $6614,y                         ; 0D80
        .byte   $14                             ; 0D83
        .byte   $6D                             ; 0D84
        .byte   $14                             ; 0D85
L0D86:  .byte   $74                             ; 0D86
        .byte   $14                             ; 0D87
        ror     $8714,x                         ; 0D88
        .byte   $14                             ; 0D8B
        .byte   $92                             ; 0D8C
        .byte   $14                             ; 0D8D
        tya                                     ; 0D8E
        .byte   $14                             ; 0D8F
        sbc     ($14,x)                         ; 0D90
        sbc     $0414,y                         ; 0D92
        ora     $17,x                           ; 0D95
        ora     $1F,x                           ; 0D97
        ora     $26,x                           ; 0D99
        ora     $4A,x                           ; 0D9B
        ora     $56,x                           ; 0D9D
        ora     $64,x                           ; 0D9F
        ora     $9C,x                           ; 0DA1
        ora     $C8,x                           ; 0DA3
        ora     $DC,x                           ; 0DA5
        ora     $04,x                           ; 0DA7
        asl     $0D,x                           ; 0DA9
L0DAB:  asl     $1A,x                           ; 0DAB
        asl     $27,x                           ; 0DAD
        asl     $4E,x                           ; 0DAF
        asl     $F4,x                           ; 0DB1
        ora     $74,x                           ; 0DB3
        asl     L169F                           ; 0DB5
        .byte   $AF                             ; 0DB8
        asl     $ED,x                           ; 0DB9
        asl     $2B,x                           ; 0DBB
        .byte   $17                             ; 0DBD
        adc     ($17),y                         ; 0DBE
        .byte   $89                             ; 0DC0
        .byte   $17                             ; 0DC1
        .byte   $A3                             ; 0DC2
        .byte   $17                             ; 0DC3
        .byte   $BF                             ; 0DC4
        .byte   $17                             ; 0DC5
        sbc     $5A17                           ; 0DC6
        clc                                     ; 0DC9
        sta     $9E18,x                         ; 0DCA
        .byte   $14                             ; 0DCD
        lda     $EA18                           ; 0DCE
        clc                                     ; 0DD1
        .byte   $14                             ; 0DD2
        ora     L193E,y                         ; 0DD3
        ror     a                               ; 0DD6
        ora     L1972,y                         ; 0DD7
        lda     $B319                           ; 0DDA
        ora     L19BE,y                         ; 0DDD
        .byte   $DB                             ; 0DE0
        ora     L19F8,y                         ; 0DE1
        .byte   $42                             ; 0DE4
        .byte   $1A                             ; 0DE5
        .byte   $3A                             ; 0DE6
        .byte   $1B                             ; 0DE7
        .byte   $43                             ; 0DE8
        .byte   $1B                             ; 0DE9
        .byte   $4F                             ; 0DEA
        .byte   $1B                             ; 0DEB
        eor     $1B,x                           ; 0DEC
        .byte   $5B                             ; 0DEE
        .byte   $1B                             ; 0DEF
        lsr     $6C1B,x                         ; 0DF0
        .byte   $1B                             ; 0DF3
        .byte   $6F                             ; 0DF4
        .byte   $1B                             ; 0DF5
        .byte   $97                             ; 0DF6
        .byte   $1B                             ; 0DF7
        .byte   $83                             ; 0DF8
        .byte   $1B                             ; 0DF9
        lda     $B31B                           ; 0DFA
        .byte   $1B                             ; 0DFD
        dec     $E11B                           ; 0DFE
        .byte   $1B                             ; 0E01
        .byte   $13                             ; 0E02
        .byte   $1C                             ; 0E03
        ora     L341C,x                         ; 0E04
        .byte   $1C                             ; 0E07
        eor     $1C                             ; 0E08
        eor     $711C,x                         ; 0E0A
        .byte   $1C                             ; 0E0D
        .byte   $8D                             ; 0E0E
L0E0F:  .byte   $1C                             ; 0E0F
        .byte   $A3                             ; 0E10
        .byte   $1C                             ; 0E11
        lda     #$1C                            ; 0E12
        lda     $C51C,x                         ; 0E14
        .byte   $1C                             ; 0E17
        .byte   $CB                             ; 0E18
        .byte   $1C                             ; 0E19
        .byte   $F2                             ; 0E1A
        .byte   $1C                             ; 0E1B
        brk                                     ; 0E1C
        brk                                     ; 0E1D
        sed                                     ; 0E1E
        .byte   $1C                             ; 0E1F
        inc     L081C,x                         ; 0E20
        ora     L1D0E,x                         ; 0E23
        .byte   $64                             ; 0E26
        ora     L1D6A,x                         ; 0E27
        sbc     ($1B),y                         ; 0E2A
        php                                     ; 0E2C
        .byte   $1C                             ; 0E2D
        .byte   $0B                             ; 0E2E
        .byte   $17                             ; 0E2F
        eor     $C417                           ; 0E30
        .byte   $14                             ; 0E33
        .byte   $F7                             ; 0E34
        .byte   $0F                             ; 0E35
        .byte   $73                             ; 0E36
        ora     $7F,x                           ; 0E37
        ora     $8D,x                           ; 0E39
        ora     $65,x                           ; 0E3B
        .byte   $1C                             ; 0E3D
        .byte   $FE                             ; 0E3E
        .byte   $1D                             ; 0E3F
L0E40:  sta     $8B                             ; 0E40
        stx     $90                             ; 0E42
        sty     $91                             ; 0E44
        lda     $8A                             ; 0E46
        pha                                     ; 0E48
        sec                                     ; 0E49
        lda     $BC                             ; 0E4A
        sbc     $97                             ; 0E4C
        tax                                     ; 0E4E
        lda     $BD                             ; 0E4F
        sbc     $98                             ; 0E51
        pha                                     ; 0E53
        txa                                     ; 0E54
        pha                                     ; 0E55
        lda     $95                             ; 0E56
        pha                                     ; 0E58
        tsx                                     ; 0E59
        stx     $95                             ; 0E5A
        lda     $8B                             ; 0E5C
        sta     $8A                             ; 0E5E
        jsr     L1D98                           ; 0E60
L0E63:  lda     $90                             ; 0E63
        ldx     $91                             ; 0E65
        clc                                     ; 0E67
        adc     $97                             ; 0E68
        sta     $BC                             ; 0E6A
        txa                                     ; 0E6C
        adc     $98                             ; 0E6D
        sta     $BD                             ; 0E6F
        jmp     L00BB                           ; 0E71

; ----------------------------------------------------------------------------
        ldx     $95                             ; 0E74
        txs                                     ; 0E76
        pla                                     ; 0E77
        sta     $95                             ; 0E78
        pla                                     ; 0E7A
        sta     $90                             ; 0E7B
        pla                                     ; 0E7D
        sta     $91                             ; 0E7E
        pla                                     ; 0E80
        sta     $8A                             ; 0E81
        sta     $8B                             ; 0E83
        jsr     L1D98                           ; 0E85
        clc                                     ; 0E88
        lda     $90                             ; 0E89
        adc     $97                             ; 0E8B
        sta     $BC                             ; 0E8D
        lda     $91                             ; 0E8F
        adc     $98                             ; 0E91
        sta     $BD                             ; 0E93
        lda     #$00                            ; 0E95
        sta     $94                             ; 0E97
        sta     $8F                             ; 0E99
        rts                                     ; 0E9B

; ----------------------------------------------------------------------------
        lda     #$00                            ; 0E9C
        sta     $8F                             ; 0E9E
        bit     $FFA9                           ; 0EA0
        sta     $94                             ; 0EA3
        jmp     L00BB                           ; 0EA5

; ----------------------------------------------------------------------------
L0EA8:  lda     $8B                             ; 0EA8
        pha                                     ; 0EAA
        jmp     L00BB                           ; 0EAB

; ----------------------------------------------------------------------------
        lda     $8A                             ; 0EAE
        pha                                     ; 0EB0
        jmp     L00BB                           ; 0EB1

; ----------------------------------------------------------------------------
        pla                                     ; 0EB4
        sta     $8B                             ; 0EB5
        jsr     L1D98                           ; 0EB7
        jmp     L00BB                           ; 0EBA

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0EBD
        lda     ($BC),y                         ; 0EBF
        tax                                     ; 0EC1
        lda     $F500,x                         ; 0EC2
        sta     $8D                             ; 0EC5
        jmp     L00B7                           ; 0EC7

; ----------------------------------------------------------------------------
L0ECA:  ldy     #$00                            ; 0ECA
        lda     ($BC),y                         ; 0ECC
        sta     $8D                             ; 0ECE
        jmp     L00B7                           ; 0ED0

; ----------------------------------------------------------------------------
        lda     #$00                            ; 0ED3
        sta     $8D                             ; 0ED5
        jmp     L00BB                           ; 0ED7

; ----------------------------------------------------------------------------
L0EDA:  ldy     #$00                            ; 0EDA
        lda     ($BC),y                         ; 0EDC
        tax                                     ; 0EDE
        lda     $8D                             ; 0EDF
        sta     $F500,x                         ; 0EE1
        jmp     L00B7                           ; 0EE4

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0EE7
        lda     ($BC),y                         ; 0EE9
        sta     $8E                             ; 0EEB
        bit     $94                             ; 0EED
        bpl     L0EF6                           ; 0EEF
        iny                                     ; 0EF1
        lda     ($BC),y                         ; 0EF2
        sta     $8F                             ; 0EF4
L0EF6:  jmp     L00AA                           ; 0EF6

; ----------------------------------------------------------------------------
L0EF9:  ldy     #$00                            ; 0EF9
        lda     ($BC),y                         ; 0EFB
        tax                                     ; 0EFD
L0EFE:  lda     $F500,x                         ; 0EFE
        sta     $8E                             ; 0F01
        bit     $94                             ; 0F03
        bpl     L0F0C                           ; 0F05
        lda     $F501,x                         ; 0F07
        sta     $8F                             ; 0F0A
L0F0C:  jmp     L00B7                           ; 0F0C

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0F0F
        lda     ($BC),y                         ; 0F11
        adc     $8D                             ; 0F13
        tax                                     ; 0F15
        lda     $F500,x                         ; 0F16
        sta     $8E                             ; 0F19
        bit     $94                             ; 0F1B
        bpl     L0F24                           ; 0F1D
        lda     $F501,x                         ; 0F1F
        sta     $8F                             ; 0F22
L0F24:  jmp     L00B7                           ; 0F24

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0F27
L0F29:  lda     ($BC),y                         ; 0F29
        adc     $99                             ; 0F2B
        sta     $90                             ; 0F2D
        iny                                     ; 0F2F
        lda     ($BC),y                         ; 0F30
        adc     $9A                             ; 0F32
        sta     $91                             ; 0F34
        dey                                     ; 0F36
        lda     ($90),y                         ; 0F37
        sta     $8E                             ; 0F39
        bit     $94                             ; 0F3B
        bpl     L0F44                           ; 0F3D
        iny                                     ; 0F3F
        lda     ($90),y                         ; 0F40
        sta     $8F                             ; 0F42
L0F44:  lda     #$02                            ; 0F44
        jmp     L00AC                           ; 0F46

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0F49
        lda     ($BC),y                         ; 0F4B
        adc     $99                             ; 0F4D
        sta     $90                             ; 0F4F
        iny                                     ; 0F51
        lda     ($BC),y                         ; 0F52
        adc     $9A                             ; 0F54
        sta     $91                             ; 0F56
        ldy     $8D                             ; 0F58
        lda     ($90),y                         ; 0F5A
        sta     $8E                             ; 0F5C
        bit     $94                             ; 0F5E
L0F60:  bpl     L0F67                           ; 0F60
        iny                                     ; 0F62
        lda     ($90),y                         ; 0F63
        sta     $8F                             ; 0F65
L0F67:  lda     #$02                            ; 0F67
        jmp     L00AC                           ; 0F69

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0F6C
        lda     ($BC),y                         ; 0F6E
        tax                                     ; 0F70
        lda     $F500,x                         ; 0F71
        adc     $99                             ; 0F74
        sta     $90                             ; 0F76
        lda     $F501,x                         ; 0F78
        adc     $9A                             ; 0F7B
        sta     $91                             ; 0F7D
        ldy     $8D                             ; 0F7F
        lda     ($90),y                         ; 0F81
        sta     $8E                             ; 0F83
        bit     $94                             ; 0F85
        bpl     L0F8E                           ; 0F87
        iny                                     ; 0F89
        lda     ($90),y                         ; 0F8A
        sta     $8F                             ; 0F8C
L0F8E:  jmp     L00B7                           ; 0F8E

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0F91
        lda     ($BC),y                         ; 0F93
        tay                                     ; 0F95
        ldx     $F502,y                         ; 0F96
        lda     $F500,y                         ; 0F99
        adc     $0200,x                         ; 0F9C
        sta     $90                             ; 0F9F
        lda     $F501,y                         ; 0FA1
        adc     $0220,x                         ; 0FA4
        sta     $91                             ; 0FA7
        ldy     $8D                             ; 0FA9
        lda     ($90),y                         ; 0FAB
        sta     $8E                             ; 0FAD
        bit     $94                             ; 0FAF
        bpl     L0FB8                           ; 0FB1
        iny                                     ; 0FB3
        lda     ($90),y                         ; 0FB4
        sta     $8F                             ; 0FB6
L0FB8:  jmp     L00B7                           ; 0FB8

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0FBB
        lda     ($BC),y                         ; 0FBD
        tax                                     ; 0FBF
        lda     $F500,x                         ; 0FC0
        adc     $99                             ; 0FC3
        sta     $90                             ; 0FC5
        lda     $F501,x                         ; 0FC7
        adc     $9A                             ; 0FCA
        sta     $91                             ; 0FCC
        iny                                     ; 0FCE
        lda     ($BC),y                         ; 0FCF
        tay                                     ; 0FD1
        lda     ($90),y                         ; 0FD2
        sta     $8E                             ; 0FD4
        bit     $94                             ; 0FD6
        bpl     L0FDF                           ; 0FD8
        iny                                     ; 0FDA
        lda     ($90),y                         ; 0FDB
        sta     $8F                             ; 0FDD
L0FDF:  lda     #$02                            ; 0FDF
        jmp     L00AC                           ; 0FE1

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0FE4
        lda     ($BC),y                         ; 0FE6
        tax                                     ; 0FE8
        tya                                     ; 0FE9
        sta     $F500,x                         ; 0FEA
        bit     $94                             ; 0FED
        bpl     L0FF4                           ; 0FEF
        sta     $F501,x                         ; 0FF1
L0FF4:  jmp     L00B7                           ; 0FF4

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 0FF7
        lda     ($BC),y                         ; 0FF9
        tax                                     ; 0FFB
        lda     #$FF                            ; 0FFC
        sta     $F500,x                         ; 0FFE
        bit     $94                             ; 1001
        bpl     L1008                           ; 1003
        sta     $F501,x                         ; 1005
L1008:  jmp     L00B7                           ; 1008

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 100B
        lda     ($BC),y                         ; 100D
L100F:  tax                                     ; 100F
        lda     $8E                             ; 1010
        sta     $F500,x                         ; 1012
        bit     $94                             ; 1015
        bpl     L101E                           ; 1017
        lda     $8F                             ; 1019
        sta     $F501,x                         ; 101B
L101E:  jmp     L00B7                           ; 101E

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1021
        lda     ($BC),y                         ; 1023
        adc     $8D                             ; 1025
        tax                                     ; 1027
        lda     $8E                             ; 1028
        sta     $F500,x                         ; 102A
        bit     $94                             ; 102D
        bpl     L1036                           ; 102F
        lda     $8F                             ; 1031
        sta     $F501,x                         ; 1033
L1036:  jmp     L00B7                           ; 1036

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1039
        lda     ($BC),y                         ; 103B
        adc     $99                             ; 103D
        sta     $90                             ; 103F
        iny                                     ; 1041
        lda     ($BC),y                         ; 1042
        adc     $9A                             ; 1044
        sta     $91                             ; 1046
        dey                                     ; 1048
        lda     $8E                             ; 1049
        sta     ($90),y                         ; 104B
        bit     $94                             ; 104D
        bpl     L1056                           ; 104F
        iny                                     ; 1051
        lda     $8F                             ; 1052
        sta     ($90),y                         ; 1054
L1056:  lda     #$02                            ; 1056
        jmp     L00AC                           ; 1058

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 105B
        lda     ($BC),y                         ; 105D
        adc     $99                             ; 105F
        sta     $90                             ; 1061
        iny                                     ; 1063
        lda     ($BC),y                         ; 1064
        adc     $9A                             ; 1066
        sta     $91                             ; 1068
        ldy     $8D                             ; 106A
        lda     $8E                             ; 106C
        sta     ($90),y                         ; 106E
        bit     $94                             ; 1070
        bpl     L1079                           ; 1072
        iny                                     ; 1074
        lda     $8F                             ; 1075
        sta     ($90),y                         ; 1077
L1079:  lda     #$02                            ; 1079
        jmp     L00AC                           ; 107B

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 107E
        lda     ($BC),y                         ; 1080
        tax                                     ; 1082
        lda     $F500,x                         ; 1083
        adc     $99                             ; 1086
L1088:  sta     $90                             ; 1088
        lda     $F501,x                         ; 108A
        adc     $9A                             ; 108D
        sta     $91                             ; 108F
        ldy     $8D                             ; 1091
        lda     $8E                             ; 1093
        sta     ($90),y                         ; 1095
        bit     $94                             ; 1097
        bpl     L10A0                           ; 1099
        iny                                     ; 109B
        lda     $8F                             ; 109C
        sta     ($90),y                         ; 109E
L10A0:  jmp     L00B7                           ; 10A0

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 10A3
        lda     ($BC),y                         ; 10A5
        tay                                     ; 10A7
        ldx     $F502,y                         ; 10A8
        lda     $F500,y                         ; 10AB
        adc     $0200,x                         ; 10AE
        sta     $90                             ; 10B1
        lda     $F501,y                         ; 10B3
        adc     $0220,x                         ; 10B6
        sta     $91                             ; 10B9
        ldy     $8D                             ; 10BB
        lda     $8E                             ; 10BD
        sta     ($90),y                         ; 10BF
        bit     $94                             ; 10C1
        bpl     L10CA                           ; 10C3
        iny                                     ; 10C5
        lda     $8F                             ; 10C6
        sta     ($90),y                         ; 10C8
L10CA:  jmp     L00B7                           ; 10CA

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 10CD
        lda     ($BC),y                         ; 10CF
        tax                                     ; 10D1
        lda     $F500,x                         ; 10D2
        adc     $99                             ; 10D5
        sta     $90                             ; 10D7
        lda     $F501,x                         ; 10D9
        adc     $9A                             ; 10DC
        sta     $91                             ; 10DE
        iny                                     ; 10E0
        lda     ($BC),y                         ; 10E1
        tay                                     ; 10E3
        lda     $8E                             ; 10E4
        sta     ($90),y                         ; 10E6
        bit     $94                             ; 10E8
        bpl     L10F1                           ; 10EA
        iny                                     ; 10EC
        lda     $8F                             ; 10ED
        sta     ($90),y                         ; 10EF
L10F1:  lda     #$02                            ; 10F1
        jmp     L00AC                           ; 10F3

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 10F6
        lda     ($BC),y                         ; 10F8
        tax                                     ; 10FA
        iny                                     ; 10FB
        lda     ($BC),y                         ; 10FC
        tay                                     ; 10FE
        lda     $F500,x                         ; 10FF
        sta     $F500,y                         ; 1102
        bit     $94                             ; 1105
        bpl     L110F                           ; 1107
        lda     $F501,x                         ; 1109
        sta     $F501,y                         ; 110C
L110F:  lda     #$02                            ; 110F
        jmp     L00AC                           ; 1111

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1114
        lda     ($BC),y                         ; 1116
        tax                                     ; 1118
        iny                                     ; 1119
        lda     ($BC),y                         ; 111A
        sta     $F500,x                         ; 111C
        bit     $94                             ; 111F
        bpl     L1129                           ; 1121
        iny                                     ; 1123
        lda     ($BC),y                         ; 1124
        sta     $F501,x                         ; 1126
L1129:  jmp     L00AA                           ; 1129

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 112C
        lda     ($BC),y                         ; 112E
        adc     $99                             ; 1130
        sta     $90                             ; 1132
        iny                                     ; 1134
        lda     ($BC),y                         ; 1135
        adc     $9A                             ; 1137
        sta     $91                             ; 1139
        iny                                     ; 113B
        clc                                     ; 113C
        lda     ($BC),y                         ; 113D
        adc     $99                             ; 113F
        sta     $92                             ; 1141
        iny                                     ; 1143
        lda     ($BC),y                         ; 1144
        adc     $9A                             ; 1146
        sta     $93                             ; 1148
        ldy     #$00                            ; 114A
        lda     ($90),y                         ; 114C
        sta     ($92),y                         ; 114E
        bit     $94                             ; 1150
        bpl     L1159                           ; 1152
        iny                                     ; 1154
        lda     ($90),y                         ; 1155
        sta     ($92),y                         ; 1157
L1159:  lda     #$04                            ; 1159
        jmp     L00AC                           ; 115B

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 115E
        lda     ($BC),y                         ; 1160
        adc     $99                             ; 1162
        sta     $90                             ; 1164
        iny                                     ; 1166
        lda     ($BC),y                         ; 1167
        adc     $9A                             ; 1169
        sta     $91                             ; 116B
        iny                                     ; 116D
        lda     ($BC),y                         ; 116E
        ldy     #$00                            ; 1170
        sta     ($90),y                         ; 1172
        bit     $94                             ; 1174
        bpl     L1183                           ; 1176
        ldy     #$03                            ; 1178
        lda     ($BC),y                         ; 117A
        ldy     #$01                            ; 117C
        sta     ($90),y                         ; 117E
        lda     #$04                            ; 1180
        .byte   $2C                             ; 1182
L1183:  lda     #$03                            ; 1183
        jmp     L00AC                           ; 1185

; ----------------------------------------------------------------------------
        lda     $8E                             ; 1188
        sta     $8D                             ; 118A
        jmp     L00BB                           ; 118C

; ----------------------------------------------------------------------------
        lda     $8D                             ; 118F
        sta     $8E                             ; 1191
        lda     #$00                            ; 1193
        sta     $8F                             ; 1195
        jmp     L00BB                           ; 1197

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 119A
        lda     ($BC),y                         ; 119C
        tax                                     ; 119E
        inc     $F500,x                         ; 119F
        bne     L11AB                           ; 11A2
        bit     $94                             ; 11A4
        bpl     L11AB                           ; 11A6
        inc     $F501,x                         ; 11A8
L11AB:  jmp     L00B7                           ; 11AB

; ----------------------------------------------------------------------------
        inc     $8E                             ; 11AE
        bne     L11B8                           ; 11B0
        bit     $94                             ; 11B2
        bpl     L11B8                           ; 11B4
        inc     $8F                             ; 11B6
L11B8:  jmp     L00BB                           ; 11B8

; ----------------------------------------------------------------------------
        inc     $8D                             ; 11BB
        jmp     L00BB                           ; 11BD

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 11C0
        lda     ($BC),y                         ; 11C2
        tax                                     ; 11C4
        lda     $F500,x                         ; 11C5
        bne     L11D1                           ; 11C8
        bit     $94                             ; 11CA
        bpl     L11D1                           ; 11CC
        dec     $F501,x                         ; 11CE
L11D1:  dec     $F500,x                         ; 11D1
        jmp     L00B7                           ; 11D4

; ----------------------------------------------------------------------------
        lda     $8E                             ; 11D7
        bne     L11E1                           ; 11D9
        bit     $94                             ; 11DB
        bpl     L11E1                           ; 11DD
        dec     $8F                             ; 11DF
L11E1:  dec     $8E                             ; 11E1
        jmp     L00BB                           ; 11E3

; ----------------------------------------------------------------------------
        dec     $8D                             ; 11E6
        jmp     L00BB                           ; 11E8

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 11EB
        lda     ($BC),y                         ; 11ED
        tax                                     ; 11EF
        asl     $F500,x                         ; 11F0
        bit     $94                             ; 11F3
        bpl     L11FA                           ; 11F5
        rol     $F501,x                         ; 11F7
L11FA:  jmp     L00B7                           ; 11FA

; ----------------------------------------------------------------------------
        asl     $8E                             ; 11FD
        bit     $94                             ; 11FF
        bpl     L1205                           ; 1201
        rol     $8F                             ; 1203
L1205:  jmp     L00BB                           ; 1205

; ----------------------------------------------------------------------------
        asl     $8D                             ; 1208
        jmp     L00BB                           ; 120A

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 120D
        lda     ($BC),y                         ; 120F
        tax                                     ; 1211
        bit     $94                             ; 1212
        bpl     L1219                           ; 1214
        lsr     $F501,x                         ; 1216
L1219:  ror     $F500,x                         ; 1219
        jmp     L00B7                           ; 121C

; ----------------------------------------------------------------------------
        lsr     $8F                             ; 121F
        ror     $8E                             ; 1221
        jmp     L00BB                           ; 1223

; ----------------------------------------------------------------------------
        lsr     $8D                             ; 1226
        jmp     L00BB                           ; 1228

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 122B
        lda     ($BC),y                         ; 122D
        tax                                     ; 122F
        lsr     $96                             ; 1230
        clc                                     ; 1232
        lda     $8E                             ; 1233
        adc     $F500,x                         ; 1235
        sta     $8E                             ; 1238
        bit     $94                             ; 123A
        bpl     L1245                           ; 123C
        lda     $8F                             ; 123E
        adc     $F501,x                         ; 1240
        sta     $8F                             ; 1243
L1245:  rol     $96                             ; 1245
        jmp     L00B7                           ; 1247

; ----------------------------------------------------------------------------
        lsr     $96                             ; 124A
        ldy     #$00                            ; 124C
        clc                                     ; 124E
        lda     $8E                             ; 124F
        adc     ($BC),y                         ; 1251
        sta     $8E                             ; 1253
        bit     $94                             ; 1255
        bpl     L1260                           ; 1257
        iny                                     ; 1259
        lda     $8F                             ; 125A
        adc     ($BC),y                         ; 125C
        sta     $8F                             ; 125E
L1260:  rol     $96                             ; 1260
        jmp     L00AA                           ; 1262

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1265
        lda     ($BC),y                         ; 1267
        tax                                     ; 1269
        lsr     $96                             ; 126A
        sec                                     ; 126C
        lda     $8E                             ; 126D
        sbc     $F500,x                         ; 126F
        sta     $8E                             ; 1272
        bit     $94                             ; 1274
        bpl     L127F                           ; 1276
        lda     $8F                             ; 1278
        sbc     $F501,x                         ; 127A
        sta     $8F                             ; 127D
L127F:  rol     $96                             ; 127F
        jmp     L00B7                           ; 1281

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1284
        lsr     $96                             ; 1286
        sec                                     ; 1288
        lda     $8E                             ; 1289
        sbc     ($BC),y                         ; 128B
        sta     $8E                             ; 128D
        bit     $94                             ; 128F
        bpl     L129A                           ; 1291
        iny                                     ; 1293
        lda     $8F                             ; 1294
        sbc     ($BC),y                         ; 1296
        sta     $8F                             ; 1298
L129A:  rol     $96                             ; 129A
        jmp     L00AA                           ; 129C

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 129F
        lda     ($BC),y                         ; 12A1
        tax                                     ; 12A3
        lda     $F500,x                         ; 12A4
        sta     $82                             ; 12A7
        lda     $F501,x                         ; 12A9
        sta     $83                             ; 12AC
        lda     $F502,x                         ; 12AE
        sta     $84                             ; 12B1
        lda     $F503,x                         ; 12B3
        sta     $85                             ; 12B6
L12B8:  lda     $8E                             ; 12B8
        sta     $86                             ; 12BA
        lda     $8F                             ; 12BC
        sta     $87                             ; 12BE
        jsr     L4308                           ; 12C0
L12C3:  ldx     $7A                             ; 12C3
        ldy     $7B                             ; 12C5
        stx     $F537                           ; 12C7
        sty     $F538                           ; 12CA
        lda     $7C                             ; 12CD
        sta     $F539                           ; 12CF
        lda     $7D                             ; 12D2
        sta     $F53A                           ; 12D4
        stx     $8E                             ; 12D7
        bit     $94                             ; 12D9
        bpl     L12DF                           ; 12DB
        sty     $8F                             ; 12DD
L12DF:  jmp     L00B7                           ; 12DF

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 12E2
        lda     ($BC),y                         ; 12E4
        sta     $82                             ; 12E6
        sty     $84                             ; 12E8
        sty     $85                             ; 12EA
        bit     $94                             ; 12EC
        bpl     L12F9                           ; 12EE
        inc     $BC                             ; 12F0
        bne     L12F6                           ; 12F2
        inc     $BD                             ; 12F4
L12F6:  lda     ($BC),y                         ; 12F6
        tay                                     ; 12F8
L12F9:  sty     $83                             ; 12F9
        jmp     L12B8                           ; 12FB

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 12FE
        lda     ($BC),y                         ; 1300
        tax                                     ; 1302
        lda     $F500,x                         ; 1303
        sta     $7A                             ; 1306
        lda     $F501,x                         ; 1308
        sta     $7B                             ; 130B
        lda     $F502,x                         ; 130D
        sta     $7C                             ; 1310
        lda     $F503,x                         ; 1312
        sta     $7D                             ; 1315
        lda     $8E                             ; 1317
        sta     $86                             ; 1319
        lda     $8F                             ; 131B
        sta     $87                             ; 131D
L131F:  jsr     L4347                           ; 131F
        lda     $7E                             ; 1322
        sta     $F53B                           ; 1324
        lda     $7F                             ; 1327
        sta     $F53C                           ; 1329
        jmp     L12C3                           ; 132C

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 132F
        lda     $8E                             ; 1331
        sta     $7A                             ; 1333
        lda     $8F                             ; 1335
        sta     $7B                             ; 1337
        sty     $7C                             ; 1339
        sty     $7D                             ; 133B
        lda     ($BC),y                         ; 133D
        sta     $86                             ; 133F
        bit     $94                             ; 1341
        bpl     L134E                           ; 1343
        inc     $BC                             ; 1345
        bne     L134B                           ; 1347
        inc     $BD                             ; 1349
L134B:  lda     ($BC),y                         ; 134B
        tay                                     ; 134D
L134E:  sty     $87                             ; 134E
        jmp     L131F                           ; 1350

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1353
        lda     ($BC),y                         ; 1355
        tax                                     ; 1357
        lda     $8E                             ; 1358
        and     $F500,x                         ; 135A
        sta     $8E                             ; 135D
        bit     $94                             ; 135F
        bpl     L136A                           ; 1361
        lda     $8F                             ; 1363
        and     $F501,x                         ; 1365
        sta     $8F                             ; 1368
L136A:  jmp     L00B7                           ; 136A

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 136D
        lda     $8E                             ; 136F
        and     ($BC),y                         ; 1371
        sta     $8E                             ; 1373
        bit     $94                             ; 1375
        bpl     L1380                           ; 1377
        iny                                     ; 1379
        lda     $8F                             ; 137A
        and     ($BC),y                         ; 137C
        sta     $8F                             ; 137E
L1380:  jmp     L00AA                           ; 1380

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1383
        lda     ($BC),y                         ; 1385
        tax                                     ; 1387
        lda     $8E                             ; 1388
        ora     $F500,x                         ; 138A
        sta     $8E                             ; 138D
        bit     $94                             ; 138F
        bpl     L139A                           ; 1391
        lda     $8F                             ; 1393
        ora     $F501,x                         ; 1395
        sta     $8F                             ; 1398
L139A:  jmp     L00B7                           ; 139A

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 139D
        lda     $8E                             ; 139F
        ora     ($BC),y                         ; 13A1
        sta     $8E                             ; 13A3
        bit     $94                             ; 13A5
        bpl     L13B0                           ; 13A7
        iny                                     ; 13A9
        lda     $8F                             ; 13AA
        ora     ($BC),y                         ; 13AC
        sta     $8F                             ; 13AE
L13B0:  jmp     L00AA                           ; 13B0

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 13B3
        lda     ($BC),y                         ; 13B5
        tax                                     ; 13B7
        lda     $8E                             ; 13B8
        eor     $F500,x                         ; 13BA
        sta     $8E                             ; 13BD
        bit     $94                             ; 13BF
        bpl     L13CA                           ; 13C1
        lda     $8F                             ; 13C3
        eor     $F501,x                         ; 13C5
        sta     $8F                             ; 13C8
L13CA:  jmp     L00B7                           ; 13CA

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 13CD
        lda     $8E                             ; 13CF
        eor     ($BC),y                         ; 13D1
        sta     $8E                             ; 13D3
        bit     $94                             ; 13D5
        bpl     L13E0                           ; 13D7
        iny                                     ; 13D9
        lda     $8F                             ; 13DA
        eor     ($BC),y                         ; 13DC
        sta     $8F                             ; 13DE
L13E0:  jmp     L00AA                           ; 13E0

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 13E3
        lda     ($BC),y                         ; 13E5
        tax                                     ; 13E7
        lda     $8E                             ; 13E8
        bit     $94                             ; 13EA
        bmi     L13F8                           ; 13EC
        cmp     $F500,x                         ; 13EE
        php                                     ; 13F1
        pla                                     ; 13F2
        sta     $96                             ; 13F3
        jmp     L00B7                           ; 13F5

; ----------------------------------------------------------------------------
L13F8:  cmp     $F500,x                         ; 13F8
        php                                     ; 13FB
        lda     $8F                             ; 13FC
        sbc     $F501,x                         ; 13FE
        php                                     ; 1401
        pla                                     ; 1402
        sta     $96                             ; 1403
        and     #$02                            ; 1405
        beq     L1413                           ; 1407
        plp                                     ; 1409
        beq     L1414                           ; 140A
        lda     #$FD                            ; 140C
        and     $96                             ; 140E
        sta     $96                             ; 1410
        php                                     ; 1412
L1413:  plp                                     ; 1413
L1414:  jmp     L00B7                           ; 1414

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1417
        lda     $8E                             ; 1419
        bit     $94                             ; 141B
        bmi     L1428                           ; 141D
        cmp     ($BC),y                         ; 141F
        php                                     ; 1421
        pla                                     ; 1422
        sta     $96                             ; 1423
        jmp     L00B7                           ; 1425

; ----------------------------------------------------------------------------
L1428:  cmp     ($BC),y                         ; 1428
        php                                     ; 142A
        iny                                     ; 142B
        lda     $8F                             ; 142C
        sbc     ($BC),y                         ; 142E
        php                                     ; 1430
        pla                                     ; 1431
        sta     $96                             ; 1432
        and     #$02                            ; 1434
        beq     L1442                           ; 1436
        plp                                     ; 1438
        beq     L1443                           ; 1439
        lda     #$FD                            ; 143B
        and     $96                             ; 143D
        sta     $96                             ; 143F
        php                                     ; 1441
L1442:  plp                                     ; 1442
L1443:  lda     #$02                            ; 1443
        jmp     L00AC                           ; 1445

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1448
        lda     ($BC),y                         ; 144A
        tax                                     ; 144C
        lda     $8D                             ; 144D
        cmp     $F500,x                         ; 144F
        php                                     ; 1452
        pla                                     ; 1453
        sta     $96                             ; 1454
        jmp     L00B7                           ; 1456

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1459
        lda     $8D                             ; 145B
        cmp     ($BC),y                         ; 145D
        php                                     ; 145F
        pla                                     ; 1460
        sta     $96                             ; 1461
        jmp     L00B7                           ; 1463

; ----------------------------------------------------------------------------
        lda     $96                             ; 1466
        lsr     a                               ; 1468
        bcc     L1484                           ; 1469
        bcs     L148D                           ; 146B
        lda     $96                             ; 146D
        lsr     a                               ; 146F
        bcs     L1484                           ; 1470
        bcc     L148D                           ; 1472
        lda     $96                             ; 1474
        and     #$03                            ; 1476
        cmp     #$01                            ; 1478
        beq     L1484                           ; 147A
        bne     L148D                           ; 147C
        lda     $96                             ; 147E
        and     #$02                            ; 1480
        beq     L148D                           ; 1482
L1484:  jmp     L15C8                           ; 1484

; ----------------------------------------------------------------------------
        lda     $96                             ; 1487
        and     #$02                            ; 1489
        beq     L1484                           ; 148B
L148D:  lda     #$02                            ; 148D
        jmp     L00AC                           ; 148F

; ----------------------------------------------------------------------------
        bit     $96                             ; 1492
        bmi     L1484                           ; 1494
        bpl     L148D                           ; 1496
        bit     $96                             ; 1498
        bpl     L1484                           ; 149A
        bmi     L148D                           ; 149C
        ldy     #$00                            ; 149E
        lda     ($BC),y                         ; 14A0
        tax                                     ; 14A2
        bit     $94                             ; 14A3
        bpl     L14B8                           ; 14A5
        lda     $F500,x                         ; 14A7
        lsr     a                               ; 14AA
        ora     $F500,x                         ; 14AB
        and     #$7F                            ; 14AE
        lsr     $96                             ; 14B0
        ora     $F501,x                         ; 14B2
        jmp     L14BD                           ; 14B5

; ----------------------------------------------------------------------------
L14B8:  lsr     $96                             ; 14B8
        lda     $F500,x                         ; 14BA
L14BD:  php                                     ; 14BD
        pla                                     ; 14BE
        sta     $96                             ; 14BF
        jmp     L00B7                           ; 14C1

; ----------------------------------------------------------------------------
        bit     $94                             ; 14C4
        bpl     L14D6                           ; 14C6
        lda     $8E                             ; 14C8
        lsr     a                               ; 14CA
        ora     $8E                             ; 14CB
        and     #$7F                            ; 14CD
        lsr     $96                             ; 14CF
        ora     $8F                             ; 14D1
        jmp     L14DA                           ; 14D3

; ----------------------------------------------------------------------------
L14D6:  lsr     $96                             ; 14D6
        lda     $8E                             ; 14D8
L14DA:  php                                     ; 14DA
        pla                                     ; 14DB
        sta     $96                             ; 14DC
        jmp     L00BB                           ; 14DE

; ----------------------------------------------------------------------------
        jsr     L1DB8                           ; 14E1
        ldy     #$00                            ; 14E4
        lda     ($BC),y                         ; 14E6
        tax                                     ; 14E8
        lda     $F500,x                         ; 14E9
        bmi     L14F6                           ; 14EC
        ora     #$80                            ; 14EE
        sta     $F500,x                         ; 14F0
        jsr     L1DB1                           ; 14F3
L14F6:  jmp     L00B7                           ; 14F6

; ----------------------------------------------------------------------------
        dec     $8D                             ; 14F9
        lda     $8D                             ; 14FB
        cmp     #$FF                            ; 14FD
        bne     L1514                           ; 14FF
L1501:  jmp     L148D                           ; 1501

; ----------------------------------------------------------------------------
        inc     $8D                             ; 1504
        ldy     #$00                            ; 1506
        lda     ($BC),y                         ; 1508
        inc     $BC                             ; 150A
        bne     L1510                           ; 150C
        inc     $BD                             ; 150E
L1510:  cmp     $8D                             ; 1510
        beq     L1501                           ; 1512
L1514:  jmp     L15C8                           ; 1514

; ----------------------------------------------------------------------------
        lsr     $96                             ; 1517
        sec                                     ; 1519
        rol     $96                             ; 151A
        jmp     L00BB                           ; 151C

; ----------------------------------------------------------------------------
        lsr     $96                             ; 151F
        asl     $96                             ; 1521
        jmp     L00BB                           ; 1523

; ----------------------------------------------------------------------------
        lda     $8E                             ; 1526
        sta     $86                             ; 1528
        lda     $8F                             ; 152A
        sta     $87                             ; 152C
        jsr     L4D4C                           ; 152E
        sta     $82                             ; 1531
        jsr     L4D4C                           ; 1533
        sta     $83                             ; 1536
        jsr     L4302                           ; 1538
        lda     $7C                             ; 153B
        sta     $8E                             ; 153D
        bit     $94                             ; 153F
        bpl     L1547                           ; 1541
        lda     $7D                             ; 1543
        sta     $8F                             ; 1545
L1547:  jmp     L00BB                           ; 1547

; ----------------------------------------------------------------------------
        jsr     L1D7C                           ; 154A
        ora     $F500,y                         ; 154D
        sta     $F500,y                         ; 1550
        jmp     L00B7                           ; 1553

; ----------------------------------------------------------------------------
        jsr     L1D7C                           ; 1556
        eor     #$FF                            ; 1559
        and     $F500,y                         ; 155B
        sta     $F500,y                         ; 155E
        jmp     L00B7                           ; 1561

; ----------------------------------------------------------------------------
        jsr     L1D7C                           ; 1564
        lsr     $96                             ; 1567
        and     $F500,y                         ; 1569
        php                                     ; 156C
        pla                                     ; 156D
        sta     $96                             ; 156E
        jmp     L00B7                           ; 1570

; ----------------------------------------------------------------------------
        jsr     L1D70                           ; 1573
        ora     $F500,y                         ; 1576
        sta     $F500,y                         ; 1579
        jmp     L00B7                           ; 157C

; ----------------------------------------------------------------------------
        jsr     L1D70                           ; 157F
        eor     #$FF                            ; 1582
        and     $F500,y                         ; 1584
        sta     $F500,y                         ; 1587
        jmp     L00B7                           ; 158A

; ----------------------------------------------------------------------------
        jsr     L1D70                           ; 158D
        lsr     $96                             ; 1590
        and     $F500,y                         ; 1592
        php                                     ; 1595
        pla                                     ; 1596
        sta     $96                             ; 1597
        jmp     L00B7                           ; 1599

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 159C
        lda     ($BC),y                         ; 159E
        adc     $99                             ; 15A0
        sta     L15BD                           ; 15A2
        iny                                     ; 15A5
        lda     ($BC),y                         ; 15A6
        adc     $9A                             ; 15A8
        sta     L15BE                           ; 15AA
        lda     #$00                            ; 15AD
        sta     $8F                             ; 15AF
        ldx     $8D                             ; 15B1
L15B3:  sta     $8E                             ; 15B3
        stx     $8D                             ; 15B5
L15B7:  dex                                     ; 15B7
        cpx     #$FF                            ; 15B8
        beq     L15C5                           ; 15BA
        .byte   $BD                             ; 15BC
L15BD:  .byte   $FF                             ; 15BD
L15BE:  .byte   $FF                             ; 15BE
        cmp     $8E                             ; 15BF
        bcc     L15B7                           ; 15C1
        bcs     L15B3                           ; 15C3
L15C5:  jmp     L00AA                           ; 15C5

; ----------------------------------------------------------------------------
L15C8:  clc                                     ; 15C8
        ldy     #$00                            ; 15C9
        lda     ($BC),y                         ; 15CB
        adc     $97                             ; 15CD
        tax                                     ; 15CF
        iny                                     ; 15D0
        lda     ($BC),y                         ; 15D1
        adc     $98                             ; 15D3
        stx     $BC                             ; 15D5
        sta     $BD                             ; 15D7
        jmp     L00BB                           ; 15D9

; ----------------------------------------------------------------------------
        sec                                     ; 15DC
        lda     $BC                             ; 15DD
        sbc     $97                             ; 15DF
        tax                                     ; 15E1
        lda     $BD                             ; 15E2
        sbc     $98                             ; 15E4
        inx                                     ; 15E6
        inx                                     ; 15E7
        cpx     #$02                            ; 15E8
        bcs     L15EE                           ; 15EA
        adc     #$01                            ; 15EC
L15EE:  pha                                     ; 15EE
        txa                                     ; 15EF
        pha                                     ; 15F0
        jmp     L15C8                           ; 15F1

; ----------------------------------------------------------------------------
        pla                                     ; 15F4
        beq     L15FC                           ; 15F5
        lda     $8A                             ; 15F7
        jsr     L4407                           ; 15F9
L15FC:  pla                                     ; 15FC
        sta     $8A                             ; 15FD
        sta     $8B                             ; 15FF
        jsr     L1D98                           ; 1601
        pla                                     ; 1604
        sta     $90                             ; 1605
        pla                                     ; 1607
        sta     $91                             ; 1608
        jmp     L0E63                           ; 160A

; ----------------------------------------------------------------------------
        pla                                     ; 160D
        sta     $8E                             ; 160E
        bit     $94                             ; 1610
        bpl     L1617                           ; 1612
        pla                                     ; 1614
        sta     $8F                             ; 1615
L1617:  jmp     L00BB                           ; 1617

; ----------------------------------------------------------------------------
        bit     $94                             ; 161A
        bpl     L1621                           ; 161C
        lda     $8F                             ; 161E
        pha                                     ; 1620
L1621:  lda     $8E                             ; 1621
        pha                                     ; 1623
        jmp     L00BB                           ; 1624

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1627
        lda     ($BC),y                         ; 1629
        pha                                     ; 162B
        iny                                     ; 162C
        lda     ($BC),y                         ; 162D
        sta     $90                             ; 162F
        iny                                     ; 1631
        lda     ($BC),y                         ; 1632
        sta     $91                             ; 1634
        lda     $8A                             ; 1636
        jsr     L43E8                           ; 1638
        pla                                     ; 163B
        tax                                     ; 163C
        ldy     #$00                            ; 163D
        lda     #$01                            ; 163F
        jsr     L3F85                           ; 1641
        sta     $8A                             ; 1644
        sta     $8B                             ; 1646
        jsr     L1D98                           ; 1648
        jmp     L0E63                           ; 164B

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 164E
        lda     ($BC),y                         ; 1650
        sta     $56                             ; 1652
        sty     $57                             ; 1654
        iny                                     ; 1656
        lda     ($BC),y                         ; 1657
        sta     $90                             ; 1659
        iny                                     ; 165B
        lda     ($BC),y                         ; 165C
        sta     $91                             ; 165E
        sec                                     ; 1660
        lda     $BC                             ; 1661
        sbc     $97                             ; 1663
        tax                                     ; 1665
        lda     $BD                             ; 1666
        sbc     $98                             ; 1668
        inx                                     ; 166A
        inx                                     ; 166B
        inx                                     ; 166C
        cpx     #$03                            ; 166D
        bcs     L1673                           ; 166F
        adc     #$01                            ; 1671
L1673:  pha                                     ; 1673
        txa                                     ; 1674
        pha                                     ; 1675
        lda     $8A                             ; 1676
        pha                                     ; 1678
        jsr     L442D                           ; 1679
        bcs     L1687                           ; 167C
        cpy     #$02                            ; 167E
        beq     L1687                           ; 1680
        tax                                     ; 1682
        lda     #$00                            ; 1683
        beq     L1693                           ; 1685
L1687:  ldx     $56                             ; 1687
        ldy     $57                             ; 1689
        lda     #$01                            ; 168B
        jsr     L3F85                           ; 168D
        tax                                     ; 1690
        lda     #$FF                            ; 1691
L1693:  pha                                     ; 1693
        txa                                     ; 1694
        sta     $8A                             ; 1695
        sta     $8B                             ; 1697
        jsr     L1D98                           ; 1699
        jmp     L0E63                           ; 169C

; ----------------------------------------------------------------------------
L169F:  ldx     $F501                           ; 169F
        ldy     $F500                           ; 16A2
        jsr     L318A                           ; 16A5
        lda     #$00                            ; 16A8
        sta     ($9B),y                         ; 16AA
        jmp     L00BB                           ; 16AC

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 16AF
        lda     ($BC),y                         ; 16B1
        sta     L16D1                           ; 16B3
        iny                                     ; 16B6
        lda     ($BC),y                         ; 16B7
        sta     L16D3                           ; 16B9
        lda     $F51F                           ; 16BC
        beq     L16E8                           ; 16BF
        lda     $F506                           ; 16C1
        pha                                     ; 16C4
        lda     #$00                            ; 16C5
        sta     $F506                           ; 16C7
L16CA:  lda     #$00                            ; 16CA
        sta     $94                             ; 16CC
        sta     $8F                             ; 16CE
        .byte   $A2                             ; 16D0
L16D1:  brk                                     ; 16D1
        .byte   $A0                             ; 16D2
L16D3:  brk                                     ; 16D3
        lda     $8A                             ; 16D4
        jsr     L0E40                           ; 16D6
        inc     $F506                           ; 16D9
        lda     $F506                           ; 16DC
        cmp     $F51F                           ; 16DF
        bcc     L16CA                           ; 16E2
        pla                                     ; 16E4
        sta     $F506                           ; 16E5
L16E8:  lda     #$02                            ; 16E8
        jmp     L00AC                           ; 16EA

; ----------------------------------------------------------------------------
        ldx     $F506                           ; 16ED
        lda     $F50A,x                         ; 16F0
        sta     $91                             ; 16F3
        ldy     #$00                            ; 16F5
        lda     ($BC),y                         ; 16F7
        sta     $90                             ; 16F9
        lda     ($90),y                         ; 16FB
        sta     $8E                             ; 16FD
        bit     $94                             ; 16FF
        bpl     L1708                           ; 1701
        iny                                     ; 1703
        lda     ($90),y                         ; 1704
        sta     $8F                             ; 1706
L1708:  jmp     L00B7                           ; 1708

; ----------------------------------------------------------------------------
        ldx     $F506                           ; 170B
        lda     $F50A,x                         ; 170E
        sta     $91                             ; 1711
        ldy     #$00                            ; 1713
        lda     ($BC),y                         ; 1715
        sta     $90                             ; 1717
        ldy     $8D                             ; 1719
        lda     ($90),y                         ; 171B
        sta     $8E                             ; 171D
        bit     $94                             ; 171F
        bpl     L1728                           ; 1721
        iny                                     ; 1723
        lda     ($90),y                         ; 1724
        sta     $8F                             ; 1726
L1728:  jmp     L00B7                           ; 1728

; ----------------------------------------------------------------------------
        ldx     $F506                           ; 172B
        lda     $F50A,x                         ; 172E
        sta     $91                             ; 1731
        ldy     #$00                            ; 1733
        tya                                     ; 1735
        sta     $F518,x                         ; 1736
        lda     ($BC),y                         ; 1739
        sta     $90                             ; 173B
        lda     $8E                             ; 173D
        sta     ($90),y                         ; 173F
        bit     $94                             ; 1741
        bpl     L174A                           ; 1743
        iny                                     ; 1745
        lda     $8F                             ; 1746
        sta     ($90),y                         ; 1748
L174A:  jmp     L00B7                           ; 174A

; ----------------------------------------------------------------------------
        ldx     $F506                           ; 174D
        lda     $F50A,x                         ; 1750
        sta     $91                             ; 1753
        ldy     #$00                            ; 1755
        tya                                     ; 1757
        sta     $F518,x                         ; 1758
        lda     ($BC),y                         ; 175B
        sta     $90                             ; 175D
        ldy     $8D                             ; 175F
        lda     $8E                             ; 1761
        sta     ($90),y                         ; 1763
        bit     $94                             ; 1765
        bpl     L176E                           ; 1767
        iny                                     ; 1769
        lda     $8F                             ; 176A
        sta     ($90),y                         ; 176C
L176E:  jmp     L00B7                           ; 176E

; ----------------------------------------------------------------------------
        jsr     L1D7C                           ; 1771
        pha                                     ; 1774
        ldx     $F506                           ; 1775
        lda     $F50A,x                         ; 1778
        sta     $91                             ; 177B
        lda     #$00                            ; 177D
        sta     $90                             ; 177F
        pla                                     ; 1781
        ora     ($90),y                         ; 1782
        sta     ($90),y                         ; 1784
        jmp     L00B7                           ; 1786

; ----------------------------------------------------------------------------
        jsr     L1D7C                           ; 1789
        pha                                     ; 178C
        ldx     $F506                           ; 178D
        lda     $F50A,x                         ; 1790
        sta     $91                             ; 1793
        lda     #$00                            ; 1795
        sta     $90                             ; 1797
        pla                                     ; 1799
        eor     #$FF                            ; 179A
        and     ($90),y                         ; 179C
        sta     ($90),y                         ; 179E
        jmp     L00B7                           ; 17A0

; ----------------------------------------------------------------------------
        jsr     L1D7C                           ; 17A3
        pha                                     ; 17A6
        ldx     $F506                           ; 17A7
        lda     $F50A,x                         ; 17AA
        sta     $91                             ; 17AD
        lda     #$00                            ; 17AF
        sta     $90                             ; 17B1
        pla                                     ; 17B3
        lsr     $96                             ; 17B4
        and     ($90),y                         ; 17B6
        php                                     ; 17B8
        pla                                     ; 17B9
        sta     $96                             ; 17BA
        jmp     L00B7                           ; 17BC

; ----------------------------------------------------------------------------
        lsr     $96                             ; 17BF
        ldy     #$00                            ; 17C1
        lda     ($BC),y                         ; 17C3
        sta     $90                             ; 17C5
        inc     $BC                             ; 17C7
        bne     L17CD                           ; 17C9
        inc     $BD                             ; 17CB
L17CD:  ldx     #$00                            ; 17CD
L17CF:  lda     $F50A,x                         ; 17CF
        sta     $91                             ; 17D2
        stx     $F506                           ; 17D4
        lda     ($90),y                         ; 17D7
        cmp     ($BC),y                         ; 17D9
        bcs     L17E8                           ; 17DB
        inx                                     ; 17DD
        cpx     $F51F                           ; 17DE
        bcc     L17CF                           ; 17E1
        rol     $96                             ; 17E3
        jmp     L00B7                           ; 17E5

; ----------------------------------------------------------------------------
L17E8:  asl     $96                             ; 17E8
        jmp     L00B7                           ; 17EA

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 17ED
        lda     ($BC),y                         ; 17EF
        sta     L1822                           ; 17F1
        iny                                     ; 17F4
        lda     ($BC),y                         ; 17F5
        sta     L1824                           ; 17F7
        lda     #$00                            ; 17FA
        sta     $F507                           ; 17FC
L17FF:  lda     #$00                            ; 17FF
        sta     $94                             ; 1801
        sta     $8F                             ; 1803
        ldy     $F506                           ; 1805
        ldx     $F507                           ; 1808
        clc                                     ; 180B
        lda     #$EC                            ; 180C
        adc     L1842,x                         ; 180E
        sta     $90                             ; 1811
        lda     $F50A,y                         ; 1813
        adc     L184E,x                         ; 1816
        sta     $91                             ; 1819
        ldy     #$0B                            ; 181B
        lda     ($90),y                         ; 181D
        beq     L1839                           ; 181F
        .byte   $A2                             ; 1821
L1822:  brk                                     ; 1822
        .byte   $A0                             ; 1823
L1824:  brk                                     ; 1824
        lda     $8A                             ; 1825
        jsr     L0E40                           ; 1827
        lda     $96                             ; 182A
        lsr     a                               ; 182C
        bcs     L183D                           ; 182D
        inc     $F507                           ; 182F
        lda     $F507                           ; 1832
        cmp     #$0C                            ; 1835
        bcc     L17FF                           ; 1837
L1839:  lsr     $96                             ; 1839
        asl     $96                             ; 183B
L183D:  lda     #$02                            ; 183D
        jmp     L00AC                           ; 183F

; ----------------------------------------------------------------------------
L1842:  brk                                     ; 1842
        .byte   $17                             ; 1843
        rol     $5C45                           ; 1844
        .byte   $73                             ; 1847
        txa                                     ; 1848
        lda     ($B8,x)                         ; 1849
        .byte   $CF                             ; 184B
        inc     $FD                             ; 184C
L184E:  brk                                     ; 184E
        brk                                     ; 184F
        brk                                     ; 1850
        brk                                     ; 1851
        brk                                     ; 1852
        brk                                     ; 1853
        brk                                     ; 1854
        brk                                     ; 1855
        brk                                     ; 1856
        brk                                     ; 1857
        brk                                     ; 1858
        brk                                     ; 1859
        lda     $8E                             ; 185A
        adc     $99                             ; 185C
        sta     $90                             ; 185E
        lda     $8F                             ; 1860
        adc     $9A                             ; 1862
        sta     $91                             ; 1864
        jsr     L1DB8                           ; 1866
        ldx     #$00                            ; 1869
L186B:  ldy     $F506                           ; 186B
        clc                                     ; 186E
        lda     #$EC                            ; 186F
        adc     L1842,x                         ; 1871
        sta     $92                             ; 1874
        lda     $F50A,y                         ; 1876
        adc     L184E,x                         ; 1879
        sta     $93                             ; 187C
        ldy     #$0B                            ; 187E
        lda     ($92),y                         ; 1880
        beq     L188B                           ; 1882
        inx                                     ; 1884
        cpx     #$0C                            ; 1885
        bcc     L186B                           ; 1887
        bcs     L189A                           ; 1889
L188B:  ldy     #$16                            ; 188B
L188D:  lda     ($90),y                         ; 188D
        sta     ($92),y                         ; 188F
        dey                                     ; 1891
        bpl     L188D                           ; 1892
        stx     $F507                           ; 1894
        jsr     L1DB1                           ; 1897
L189A:  jmp     L00BB                           ; 189A

; ----------------------------------------------------------------------------
        jsr     L1DB8                           ; 189D
        lda     $8E                             ; 18A0
        jsr     L1AD1                           ; 18A2
        bcs     L18AA                           ; 18A5
        jsr     L1DB1                           ; 18A7
L18AA:  jmp     L00BB                           ; 18AA

; ----------------------------------------------------------------------------
        ldx     $F507                           ; 18AD
L18B0:  ldy     $F506                           ; 18B0
        clc                                     ; 18B3
        lda     #$EC                            ; 18B4
        adc     L1842,x                         ; 18B6
        sta     $90                             ; 18B9
        lda     $F50A,y                         ; 18BB
        adc     L184E,x                         ; 18BE
        sta     $91                             ; 18C1
        tay                                     ; 18C3
        clc                                     ; 18C4
        lda     #$17                            ; 18C5
        adc     $90                             ; 18C7
        sta     $92                             ; 18C9
        bcc     L18CE                           ; 18CB
        iny                                     ; 18CD
L18CE:  sty     $93                             ; 18CE
        ldy     #$16                            ; 18D0
        cpx     #$0B                            ; 18D2
        bcs     L18E0                           ; 18D4
L18D6:  lda     ($92),y                         ; 18D6
        sta     ($90),y                         ; 18D8
        dey                                     ; 18DA
        bpl     L18D6                           ; 18DB
        inx                                     ; 18DD
        bne     L18B0                           ; 18DE
L18E0:  lda     #$00                            ; 18E0
L18E2:  sta     ($90),y                         ; 18E2
        dey                                     ; 18E4
        bpl     L18E2                           ; 18E5
        jmp     L00BB                           ; 18E7

; ----------------------------------------------------------------------------
        ldx     $F506                           ; 18EA
        ldy     $F507                           ; 18ED
        lda     #$EC                            ; 18F0
L18F2:  adc     L1842,y                         ; 18F2
        sta     $90                             ; 18F5
        lda     $F50A,x                         ; 18F7
        adc     L184E,y                         ; 18FA
        sta     $91                             ; 18FD
        ldy     #$00                            ; 18FF
        lda     ($BC),y                         ; 1901
        tay                                     ; 1903
        lda     ($90),y                         ; 1904
        sta     $8E                             ; 1906
        bit     $94                             ; 1908
        bpl     L1911                           ; 190A
        iny                                     ; 190C
        lda     ($90),y                         ; 190D
        sta     $8F                             ; 190F
L1911:  jmp     L00B7                           ; 1911

; ----------------------------------------------------------------------------
        ldx     $F506                           ; 1914
        ldy     $F507                           ; 1917
        lda     #$EC                            ; 191A
        adc     L1842,y                         ; 191C
        sta     $90                             ; 191F
        lda     $F50A,x                         ; 1921
        adc     L184E,y                         ; 1924
        sta     $91                             ; 1927
        ldy     #$00                            ; 1929
        lda     ($BC),y                         ; 192B
        tay                                     ; 192D
        lda     $8E                             ; 192E
        sta     ($90),y                         ; 1930
        bit     $94                             ; 1932
        bpl     L193B                           ; 1934
        iny                                     ; 1936
        lda     $8F                             ; 1937
        sta     ($90),y                         ; 1939
L193B:  jmp     L00B7                           ; 193B

; ----------------------------------------------------------------------------
L193E:  jsr     L1DB8                           ; 193E
        ldy     #$00                            ; 1941
        lda     $F500                           ; 1943
        cmp     ($BC),y                         ; 1946
        bcc     L1965                           ; 1948
        iny                                     ; 194A
        lda     $F501                           ; 194B
        cmp     ($BC),y                         ; 194E
        bcc     L1965                           ; 1950
        iny                                     ; 1952
        lda     ($BC),y                         ; 1953
        cmp     $F500                           ; 1955
        bcc     L1965                           ; 1958
        iny                                     ; 195A
        lda     ($BC),y                         ; 195B
        cmp     $F501                           ; 195D
        bcc     L1965                           ; 1960
        jsr     L1DB1                           ; 1962
L1965:  lda     #$04                            ; 1965
        jmp     L00AC                           ; 1967

; ----------------------------------------------------------------------------
        lda     $F503                           ; 196A
        eor     #$02                            ; 196D
        jmp     L1975                           ; 196F

; ----------------------------------------------------------------------------
L1972:  lda     $F503                           ; 1972
L1975:  jsr     L1994                           ; 1975
        lda     $F523                           ; 1978
        and     #$02                            ; 197B
        beq     L1991                           ; 197D
        ldx     $F501                           ; 197F
        ldy     $F500                           ; 1982
        jsr     L31F9                           ; 1985
        jsr     L31C5                           ; 1988
        stx     $F501                           ; 198B
        sty     $F500                           ; 198E
L1991:  jmp     L00BB                           ; 1991

; ----------------------------------------------------------------------------
L1994:  tax                                     ; 1994
        beq     L19A1                           ; 1995
        dex                                     ; 1997
        beq     L19A5                           ; 1998
        dex                                     ; 199A
        beq     L19A9                           ; 199B
        dec     $F501                           ; 199D
        rts                                     ; 19A0

; ----------------------------------------------------------------------------
L19A1:  inc     $F500                           ; 19A1
        rts                                     ; 19A4

; ----------------------------------------------------------------------------
L19A5:  inc     $F501                           ; 19A5
        rts                                     ; 19A8

; ----------------------------------------------------------------------------
L19A9:  dec     $F500                           ; 19A9
        rts                                     ; 19AC

; ----------------------------------------------------------------------------
        jsr     L2C53                           ; 19AD
        jmp     L00BB                           ; 19B0

; ----------------------------------------------------------------------------
        lda     $F503                           ; 19B3
        adc     #$0A                            ; 19B6
        jsr     L3E58                           ; 19B8
        jmp     L00BB                           ; 19BB

; ----------------------------------------------------------------------------
L19BE:  ldx     $F501                           ; 19BE
        ldy     $F500                           ; 19C1
        jsr     L3097                           ; 19C4
        ldy     #$00                            ; 19C7
        lda     ($BC),y                         ; 19C9
        tax                                     ; 19CB
L19CC:  lda     $7E,y                           ; 19CC
        sta     $F500,x                         ; 19CF
        iny                                     ; 19D2
        inx                                     ; 19D3
        cpy     #$03                            ; 19D4
        bcc     L19CC                           ; 19D6
        jmp     L00B7                           ; 19D8

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 19DB
        lda     ($BC),y                         ; 19DD
        tax                                     ; 19DF
L19E0:  lda     $F500,x                         ; 19E0
        sta     $7E,y                           ; 19E3
        iny                                     ; 19E6
        inx                                     ; 19E7
        cpy     #$03                            ; 19E8
        bcc     L19E0                           ; 19EA
        ldx     $F501                           ; 19EC
        ldy     $F500                           ; 19EF
        jsr     L30EC                           ; 19F2
        jmp     L00B7                           ; 19F5

; ----------------------------------------------------------------------------
L19F8:  ldx     $F501                           ; 19F8
        ldy     $F500                           ; 19FB
        jsr     L318A                           ; 19FE
        lda     $7C                             ; 1A01
        cmp     $F53E                           ; 1A03
        beq     L1A23                           ; 1A06
        ldy     #$00                            ; 1A08
        sty     $F53E                           ; 1A0A
        tay                                     ; 1A0D
        beq     L1A23                           ; 1A0E
        sta     $F53F                           ; 1A10
        clc                                     ; 1A13
        adc     #$01                            ; 1A14
L1A16:  asl     a                               ; 1A16
        tay                                     ; 1A17
        jsr     L1A2B                           ; 1A18
        lda     $F502                           ; 1A1B
        cmp     $F557                           ; 1A1E
        bne     L1A28                           ; 1A21
L1A23:  ldy     #$00                            ; 1A23
        jsr     L1A2B                           ; 1A25
L1A28:  jmp     L00BB                           ; 1A28

; ----------------------------------------------------------------------------
L1A2B:  lda     $0358                           ; 1A2B
        sta     L0006                           ; 1A2E
        lda     $0359                           ; 1A30
        sta     $07                             ; 1A33
        lda     (L0006),y                       ; 1A35
        tax                                     ; 1A37
        iny                                     ; 1A38
        lda     (L0006),y                       ; 1A39
        tay                                     ; 1A3B
        lda     $F556                           ; 1A3C
        jmp     L0E40                           ; 1A3F

; ----------------------------------------------------------------------------
        asl     $96                             ; 1A42
        ldx     $F501                           ; 1A44
        ldy     $F500                           ; 1A47
        jsr     L318A                           ; 1A4A
        lda     $7C                             ; 1A4D
        sta     L1AAE                           ; 1A4F
        lda     $0358                           ; 1A52
        sta     L0006                           ; 1A55
        lda     $0359                           ; 1A57
        sta     $07                             ; 1A5A
        ldx     $F556                           ; 1A5C
        ldy     #$02                            ; 1A5F
        clc                                     ; 1A61
        lda     (L0006),y                       ; 1A62
        adc     $0200,x                         ; 1A64
        sta     $9D                             ; 1A67
        iny                                     ; 1A69
        lda     (L0006),y                       ; 1A6A
        adc     $0220,x                         ; 1A6C
        sta     $9E                             ; 1A6F
L1A71:  lda     #$03                            ; 1A71
        sta     L1AC2                           ; 1A73
        ldy     #$00                            ; 1A76
        lda     ($9D),y                         ; 1A78
        iny                                     ; 1A7A
        cmp     #$FE                            ; 1A7B
        beq     L1AB1                           ; 1A7D
        bcs     L1ACE                           ; 1A7F
        cmp     #$FD                            ; 1A81
        beq     L1AA9                           ; 1A83
        cmp     #$80                            ; 1A85
        bne     L1AA4                           ; 1A87
        lda     #$04                            ; 1A89
        sta     L1AC2                           ; 1A8B
        lda     $F588                           ; 1A8E
        beq     L1AC1                           ; 1A91
        ldy     #$01                            ; 1A93
        lda     ($9D),y                         ; 1A95
        cmp     #$FF                            ; 1A97
        beq     L1AA0                           ; 1A99
        jsr     L1AD1                           ; 1A9B
        bcs     L1AC1                           ; 1A9E
L1AA0:  ldy     #$02                            ; 1AA0
        bne     L1AA9                           ; 1AA2
L1AA4:  cmp     $F585                           ; 1AA4
        bne     L1AC1                           ; 1AA7
L1AA9:  lda     ($9D),y                         ; 1AA9
        beq     L1AB1                           ; 1AAB
        .byte   $C9                             ; 1AAD
L1AAE:  brk                                     ; 1AAE
        bne     L1AC1                           ; 1AAF
L1AB1:  iny                                     ; 1AB1
        lda     ($9D),y                         ; 1AB2
        clc                                     ; 1AB4
        adc     #$01                            ; 1AB5
        asl     a                               ; 1AB7
        tay                                     ; 1AB8
        jsr     L1A2B                           ; 1AB9
        lda     $96                             ; 1ABC
        lsr     a                               ; 1ABE
        bcs     L1ACE                           ; 1ABF
L1AC1:  .byte   $A9                             ; 1AC1
L1AC2:  .byte   $03                             ; 1AC2
        clc                                     ; 1AC3
        adc     $9D                             ; 1AC4
        sta     $9D                             ; 1AC6
        bcc     L1A71                           ; 1AC8
        inc     $9E                             ; 1ACA
        bne     L1A71                           ; 1ACC
L1ACE:  jmp     L00BB                           ; 1ACE

; ----------------------------------------------------------------------------
L1AD1:  pha                                     ; 1AD1
        ldy     #$00                            ; 1AD2
        lda     #$06                            ; 1AD4
        jsr     L1B20                           ; 1AD6
        sta     L0006                           ; 1AD9
        sty     $07                             ; 1ADB
        pla                                     ; 1ADD
        ldy     $07                             ; 1ADE
        asl     a                               ; 1AE0
        clc                                     ; 1AE1
        adc     L0006                           ; 1AE2
        bcc     L1AE7                           ; 1AE4
        iny                                     ; 1AE6
L1AE7:  jsr     L1B20                           ; 1AE7
        jsr     L1B20                           ; 1AEA
        ldy     $F506                           ; 1AED
        ldx     $F507                           ; 1AF0
        clc                                     ; 1AF3
        lda     #$EC                            ; 1AF4
        adc     L1842,x                         ; 1AF6
        sta     $90                             ; 1AF9
        lda     $F50A,y                         ; 1AFB
        adc     L184E,x                         ; 1AFE
        sta     $91                             ; 1B01
        ldy     #$00                            ; 1B03
L1B05:  iny                                     ; 1B05
        cpy     #$07                            ; 1B06
        beq     L1B05                           ; 1B08
        lda     (L0006),y                       ; 1B0A
        cmp     ($90),y                         ; 1B0C
        bne     L1B1E                           ; 1B0E
        cpy     #$16                            ; 1B10
        bcs     L1B1C                           ; 1B12
        cpy     #$0B                            ; 1B14
        bcc     L1B05                           ; 1B16
        lda     (L0006),y                       ; 1B18
L1B1A:  bmi     L1B05                           ; 1B1A
L1B1C:  clc                                     ; 1B1C
        rts                                     ; 1B1D

; ----------------------------------------------------------------------------
L1B1E:  sec                                     ; 1B1E
        rts                                     ; 1B1F

; ----------------------------------------------------------------------------
L1B20:  ldx     $F55A                           ; 1B20
        clc                                     ; 1B23
        adc     $0200,x                         ; 1B24
        sta     L0006                           ; 1B27
        tya                                     ; 1B29
        adc     $0220,x                         ; 1B2A
        sta     $07                             ; 1B2D
        ldy     #$00                            ; 1B2F
        lda     (L0006),y                       ; 1B31
        pha                                     ; 1B33
        iny                                     ; 1B34
        lda     (L0006),y                       ; 1B35
        tay                                     ; 1B37
        pla                                     ; 1B38
        rts                                     ; 1B39

; ----------------------------------------------------------------------------
        lda     $F53F                           ; 1B3A
        sta     $F53E                           ; 1B3D
        jmp     L00BB                           ; 1B40

; ----------------------------------------------------------------------------
        ldx     $BC                             ; 1B43
        ldy     $BD                             ; 1B45
        jsr     L3BFA                           ; 1B47
        lda     #$04                            ; 1B4A
        jmp     L00AC                           ; 1B4C

; ----------------------------------------------------------------------------
        jsr     L3C97                           ; 1B4F
        jmp     L00BB                           ; 1B52

; ----------------------------------------------------------------------------
        jsr     L2704                           ; 1B55
        jmp     L00BB                           ; 1B58

; ----------------------------------------------------------------------------
        jsr     L2704                           ; 1B5B
        ldx     $BC                             ; 1B5E
        ldy     $BD                             ; 1B60
        jsr     L476C                           ; 1B62
L1B65:  stx     $BC                             ; 1B65
        sty     $BD                             ; 1B67
        jmp     L00BB                           ; 1B69

; ----------------------------------------------------------------------------
        jsr     L2704                           ; 1B6C
        clc                                     ; 1B6F
        lda     $8E                             ; 1B70
        adc     $99                             ; 1B72
        tax                                     ; 1B74
        lda     $8F                             ; 1B75
        adc     $9A                             ; 1B77
        tay                                     ; 1B79
        jsr     L476C                           ; 1B7A
        jsr     L1BA1                           ; 1B7D
        jmp     L00BB                           ; 1B80

; ----------------------------------------------------------------------------
        clc                                     ; 1B83
        lda     $8E                             ; 1B84
        adc     $99                             ; 1B86
        tax                                     ; 1B88
        lda     $8F                             ; 1B89
        adc     $9A                             ; 1B8B
        tay                                     ; 1B8D
        jsr     L3D8E                           ; 1B8E
        jsr     L1BA1                           ; 1B91
        jmp     L00BB                           ; 1B94

; ----------------------------------------------------------------------------
        ldx     $BC                             ; 1B97
        ldy     $BD                             ; 1B99
        jsr     L3D8E                           ; 1B9B
        jmp     L1B65                           ; 1B9E

; ----------------------------------------------------------------------------
L1BA1:  sec                                     ; 1BA1
        txa                                     ; 1BA2
        sbc     $99                             ; 1BA3
        sta     $8E                             ; 1BA5
        tya                                     ; 1BA7
        sbc     $9A                             ; 1BA8
        sta     $8F                             ; 1BAA
        rts                                     ; 1BAC

; ----------------------------------------------------------------------------
        jsr     L49B6                           ; 1BAD
        jmp     L00BB                           ; 1BB0

; ----------------------------------------------------------------------------
        ldy     $F506                           ; 1BB3
        ldx     $F507                           ; 1BB6
        lda     #$F7                            ; 1BB9
        adc     L1842,x                         ; 1BBB
        sta     $4F                             ; 1BBE
        lda     $F50A,y                         ; 1BC0
        adc     L184E,x                         ; 1BC3
        sta     $50                             ; 1BC6
        jsr     L49C2                           ; 1BC8
        jmp     L00BB                           ; 1BCB

; ----------------------------------------------------------------------------
        clc                                     ; 1BCE
        lda     $8E                             ; 1BCF
        adc     $99                             ; 1BD1
        sta     $4F                             ; 1BD3
        lda     $8F                             ; 1BD5
        adc     $9A                             ; 1BD7
        sta     $50                             ; 1BD9
        jsr     L49C2                           ; 1BDB
        jmp     L00BB                           ; 1BDE

; ----------------------------------------------------------------------------
        jsr     L25D9                           ; 1BE1
        ldy     #$00                            ; 1BE4
        lda     ($BC),y                         ; 1BE6
        clc                                     ; 1BE8
        adc     $62                             ; 1BE9
        jsr     L4B0F                           ; 1BEB
        jmp     L00B7                           ; 1BEE

; ----------------------------------------------------------------------------
        jsr     L25D9                           ; 1BF1
        clc                                     ; 1BF4
        lda     $8D                             ; 1BF5
        adc     $63                             ; 1BF7
        sta     $1D                             ; 1BF9
        clc                                     ; 1BFB
        lda     $8E                             ; 1BFC
        adc     $62                             ; 1BFE
        sta     $1B                             ; 1C00
        sta     L2685                           ; 1C02
        jmp     L00BB                           ; 1C05

; ----------------------------------------------------------------------------
        jsr     L25D9                           ; 1C08
        lda     $64                             ; 1C0B
        jsr     L4B0F                           ; 1C0D
        jmp     L00BB                           ; 1C10

; ----------------------------------------------------------------------------
        ldx     $8E                             ; 1C13
        ldy     $8F                             ; 1C15
        jsr     L487C                           ; 1C17
        jmp     L00BB                           ; 1C1A

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1C1D
        lda     ($BC),y                         ; 1C1F
        tax                                     ; 1C21
L1C22:  lda     $F500,x                         ; 1C22
        sta     $7A,y                           ; 1C25
        inx                                     ; 1C28
        iny                                     ; 1C29
        cpy     #$04                            ; 1C2A
        bcc     L1C22                           ; 1C2C
        jsr     L4889                           ; 1C2E
        jmp     L00B7                           ; 1C31

; ----------------------------------------------------------------------------
        bit     $94                             ; 1C34
        bpl     L1C3D                           ; 1C36
        lda     $8F                             ; 1C38
        jsr     L25B8                           ; 1C3A
L1C3D:  lda     $8E                             ; 1C3D
        jsr     L25B8                           ; 1C3F
        jmp     L00BB                           ; 1C42

; ----------------------------------------------------------------------------
        lda     #$FF                            ; 1C45
        sta     $56                             ; 1C47
        sta     $57                             ; 1C49
        lda     #$01                            ; 1C4B
        ldx     $8E                             ; 1C4D
        ldy     $8F                             ; 1C4F
        jsr     L444B                           ; 1C51
        sta     $8E                             ; 1C54
        lda     #$00                            ; 1C56
        sta     $8F                             ; 1C58
        jmp     L00BB                           ; 1C5A

; ----------------------------------------------------------------------------
        lda     $8E                             ; 1C5D
        jsr     L43E8                           ; 1C5F
        jmp     L00BB                           ; 1C62

; ----------------------------------------------------------------------------
        lda     $8E                             ; 1C65
        jsr     L4424                           ; 1C67
        stx     $8E                             ; 1C6A
        sty     $8F                             ; 1C6C
        jmp     L00BB                           ; 1C6E

; ----------------------------------------------------------------------------
        ldx     $8E                             ; 1C71
        ldy     $8F                             ; 1C73
        stx     $56                             ; 1C75
        sty     $57                             ; 1C77
        jsr     L3FA4                           ; 1C79
        lda     #$01                            ; 1C7C
        jsr     L444B                           ; 1C7E
        sta     $8E                             ; 1C81
        lda     #$00                            ; 1C83
        sta     $8F                             ; 1C85
        jsr     L3FBC                           ; 1C87
        jmp     L00BB                           ; 1C8A

; ----------------------------------------------------------------------------
        ldx     $8E                             ; 1C8D
        ldy     $8F                             ; 1C8F
        stx     $56                             ; 1C91
        sty     $57                             ; 1C93
        jsr     L442D                           ; 1C95
        bcs     L1CA0                           ; 1C98
        jsr     L441B                           ; 1C9A
        jsr     L3FB9                           ; 1C9D
L1CA0:  jmp     L00BB                           ; 1CA0

; ----------------------------------------------------------------------------
        jsr     L474A                           ; 1CA3
        jmp     L00BB                           ; 1CA6

; ----------------------------------------------------------------------------
        ldx     $BC                             ; 1CA9
        ldy     $BD                             ; 1CAB
        jsr     L45C7                           ; 1CAD
        sta     $8E                             ; 1CB0
        lda     #$00                            ; 1CB2
        sta     $8F                             ; 1CB4
        stx     $90                             ; 1CB6
        sty     $91                             ; 1CB8
        jmp     L0E63                           ; 1CBA

; ----------------------------------------------------------------------------
        lda     $8E                             ; 1CBD
        jsr     L3552                           ; 1CBF
        jmp     L00BB                           ; 1CC2

; ----------------------------------------------------------------------------
        jsr     L2F2B                           ; 1CC5
        jmp     L00BB                           ; 1CC8

; ----------------------------------------------------------------------------
        jsr     L475D                           ; 1CCB
        inc     $9706,x                         ; 1CCE
        .byte   $7F                             ; 1CD1
        .byte   $2B                             ; 1CD2
        cpy     #$A2                            ; 1CD3
        sbc     #$A0                            ; 1CD5
        .byte   $1C                             ; 1CD7
        jsr     L45C7                           ; 1CD8
        pha                                     ; 1CDB
        jsr     L2704                           ; 1CDC
        pla                                     ; 1CDF
        cmp     #$D9                            ; 1CE0
        php                                     ; 1CE2
        pla                                     ; 1CE3
        sta     $96                             ; 1CE4
        jmp     L00BB                           ; 1CE6

; ----------------------------------------------------------------------------
        brk                                     ; 1CE9
        brk                                     ; 1CEA
        dec     a:$00                           ; 1CEB
        cmp     $00,y                           ; 1CEE
        .byte   $FF                             ; 1CF1
        jsr     L4908                           ; 1CF2
        jmp     L00BB                           ; 1CF5

; ----------------------------------------------------------------------------
        jsr     L438D                           ; 1CF8
        jmp     L00BB                           ; 1CFB

; ----------------------------------------------------------------------------
        ldy     #$00                            ; 1CFE
        lda     ($BC),y                         ; 1D00
        jsr     L420A                           ; 1D02
        jmp     L00B7                           ; 1D05

; ----------------------------------------------------------------------------
        jsr     L49DB                           ; 1D08
        jmp     L00BB                           ; 1D0B

; ----------------------------------------------------------------------------
L1D0E:  jsr     L49DB                           ; 1D0E
        jsr     L25D9                           ; 1D11
        ldx     $F5DC                           ; 1D14
        lda     L1D58,x                         ; 1D17
        sta     L1D3B                           ; 1D1A
        .byte   $BD                             ; 1D1D
L1D1E:  lsr     $8D1D,x                         ; 1D1E
        .byte   $3C                             ; 1D21
        .byte   $1D                             ; 1D22
L1D23:  jsr     L4D41                           ; 1D23
        bmi     L1D3D                           ; 1D26
        jsr     L3843                           ; 1D28
        jsr     L4BA7                           ; 1D2B
        inc     L1D3B                           ; 1D2E
        bne     L1D23                           ; 1D31
        inc     L1D3C                           ; 1D33
        bne     L1D23                           ; 1D36
        jmp     L00BB                           ; 1D38

; ----------------------------------------------------------------------------
L1D3B:  brk                                     ; 1D3B
L1D3C:  brk                                     ; 1D3C
L1D3D:  ldx     $F5DC                           ; 1D3D
        cmp     #$88                            ; 1D40
        bne     L1D48                           ; 1D42
        dex                                     ; 1D44
        bpl     L1D48                           ; 1D45
        inx                                     ; 1D47
L1D48:  cmp     #$95                            ; 1D48
        bne     L1D52                           ; 1D4A
        inx                                     ; 1D4C
        cpx     #$06                            ; 1D4D
        bcc     L1D52                           ; 1D4F
        dex                                     ; 1D51
L1D52:  stx     $F5DC                           ; 1D52
        jmp     L00BB                           ; 1D55

; ----------------------------------------------------------------------------
L1D58:  brk                                     ; 1D58
        brk                                     ; 1D59
        brk                                     ; 1D5A
        brk                                     ; 1D5B
        brk                                     ; 1D5C
        .byte   $FF                             ; 1D5D
L1D5E:  beq     L1D58                           ; 1D5E
        .byte   $FC                             ; 1D60
        inc     $FFFF,x                         ; 1D61
        lda     $8D                             ; 1D64
        pha                                     ; 1D66
        jmp     L00BB                           ; 1D67

; ----------------------------------------------------------------------------
L1D6A:  pla                                     ; 1D6A
        sta     $8D                             ; 1D6B
        jmp     L00BB                           ; 1D6D

; ----------------------------------------------------------------------------
L1D70:  ldy     #$00                            ; 1D70
        lda     ($BC),y                         ; 1D72
        inc     $BC                             ; 1D74
        bne     L1D7E                           ; 1D76
        inc     $BD                             ; 1D78
        bne     L1D7E                           ; 1D7A
L1D7C:  lda     $8E                             ; 1D7C
L1D7E:  tay                                     ; 1D7E
        and     #$07                            ; 1D7F
        tax                                     ; 1D81
        tya                                     ; 1D82
        lsr     a                               ; 1D83
        lsr     a                               ; 1D84
        lsr     a                               ; 1D85
        ldy     #$00                            ; 1D86
        clc                                     ; 1D88
        adc     ($BC),y                         ; 1D89
        tay                                     ; 1D8B
        lda     L1D90,x                         ; 1D8C
        rts                                     ; 1D8F

; ----------------------------------------------------------------------------
L1D90:  .byte   $80                             ; 1D90
        rti                                     ; 1D91

; ----------------------------------------------------------------------------
        jsr     L0810                           ; 1D92
        .byte   $04                             ; 1D95
        .byte   $02                             ; 1D96
        .byte   $01                             ; 1D97
L1D98:  ldx     $8A                             ; 1D98
        lda     $0200,x                         ; 1D9A
        sta     $97                             ; 1D9D
        lda     $0220,x                         ; 1D9F
        sta     $98                             ; 1DA2
        ldx     $8B                             ; 1DA4
        lda     $0200,x                         ; 1DA6
        sta     $99                             ; 1DA9
        lda     $0220,x                         ; 1DAB
        sta     $9A                             ; 1DAE
        rts                                     ; 1DB0

; ----------------------------------------------------------------------------
L1DB1:  lda     #$02                            ; 1DB1
        ora     $96                             ; 1DB3
        sta     $96                             ; 1DB5
        rts                                     ; 1DB7

; ----------------------------------------------------------------------------
L1DB8:  lda     $96                             ; 1DB8
        and     #$FD                            ; 1DBA
        sta     $96                             ; 1DBC
        rts                                     ; 1DBE

; ----------------------------------------------------------------------------
        lda     $8E                             ; 1DBF
        adc     $99                             ; 1DC1
        tax                                     ; 1DC3
        lda     $8F                             ; 1DC4
        adc     $9A                             ; 1DC6
        ldy     #$00                            ; 1DC8
        bit     $8D                             ; 1DCA
        .byte   $30                             ; 1DCC
L1DCD:  .byte   $02                             ; 1DCD
        ldy     #$03                            ; 1DCE
        sta     L1DEB,y                         ; 1DD0
        txa                                     ; 1DD3
        sta     L1DEA,y                         ; 1DD4
        tya                                     ; 1DD7
        eor     #$03                            ; 1DD8
        tay                                     ; 1DDA
        lda     #$00                            ; 1DDB
        sta     L1DEA,y                         ; 1DDD
        lda     #$F6                            ; 1DE0
        sta     L1DEB,y                         ; 1DE2
        ldx     #$07                            ; 1DE5
        ldy     #$00                            ; 1DE7
L1DE9:  .byte   $B9                             ; 1DE9
L1DEA:  .byte   $FF                             ; 1DEA
L1DEB:  .byte   $FF                             ; 1DEB
        .byte   $99                             ; 1DEC
        .byte   $FF                             ; 1DED
L1DEE:  .byte   $FF                             ; 1DEE
        iny                                     ; 1DEF
        bne     L1DE9                           ; 1DF0
        inc     L1DEB                           ; 1DF2
        inc     L1DEE                           ; 1DF5
        dex                                     ; 1DF8
        bne     L1DE9                           ; 1DF9
        jmp     L00BB                           ; 1DFB

; ----------------------------------------------------------------------------
        lda     #$1D                            ; 1DFE
        sta     $56                             ; 1E00
        lda     #$00                            ; 1E02
        sta     $57                             ; 1E04
        ldx     #$00                            ; 1E06
        ldy     #$80                            ; 1E08
        jsr     L3FBC                           ; 1E0A
        jmp     L8000                           ; 1E0D

; ----------------------------------------------------------------------------
        lda     $8E                             ; 1E10
        jsr     L404C                           ; 1E12
        jmp     L00BB                           ; 1E15

; ----------------------------------------------------------------------------
L1E18:  rti                                     ; 1E18

; ----------------------------------------------------------------------------
        jmp     (L7C74)                         ; 1E19

; ----------------------------------------------------------------------------
        tay                                     ; 1E1C
        .byte   $BE                             ; 1E1D
L1E1E:  .byte   $F2                             ; 1E1E
        clc                                     ; 1E1F
        jsr     L9826                           ; 1E20
        ldy     $B0                             ; 1E23
        ldy     $D4C8,x                         ; 1E25
        cpx     #$EC                            ; 1E28
        sed                                     ; 1E2A
        .byte   $04                             ; 1E2B
L1E2C:  asl     L1E1E,x                         ; 1E2C
        asl     L1E1E,x                         ; 1E2F
        asl     L1F1F,x                         ; 1E32
        .byte   $1F                             ; 1E35
        bit     $24                             ; 1E36
        bit     $24                             ; 1E38
        bit     $24                             ; 1E3A
        bit     $24                             ; 1E3C
        bit     $25                             ; 1E3E
        plp                                     ; 1E40
        ora     ($00,x)                         ; 1E41
        clv                                     ; 1E43
        brk                                     ; 1E44
        ora     ($02,x)                         ; 1E45
        ora     ($02,x)                         ; 1E47
        ora     ($02,x)                         ; 1E49
        ora     ($02,x)                         ; 1E4B
        ora     ($02,x)                         ; 1E4D
        ora     ($02,x)                         ; 1E4F
        ora     ($02,x)                         ; 1E51
        ora     ($02,x)                         ; 1E53
        ora     ($02,x)                         ; 1E55
        ora     ($02,x)                         ; 1E57
        ora     ($02,x)                         ; 1E59
        ora     ($02,x)                         ; 1E5B
        ora     ($02,x)                         ; 1E5D
        ora     ($02,x)                         ; 1E5F
        ora     ($02,x)                         ; 1E61
        ora     ($02,x)                         ; 1E63
        ora     ($02,x)                         ; 1E65
        ora     ($02,x)                         ; 1E67
        ora     ($02,x)                         ; 1E69
        .byte   $03                             ; 1E6B
        ora     ($04,x)                         ; 1E6C
        brk                                     ; 1E6E
        tya                                     ; 1E6F
        .byte   $04                             ; 1E70
        ora     $05                             ; 1E71
        ora     $01                             ; 1E73
        .byte   $04                             ; 1E75
        .byte   $27                             ; 1E76
        tya                                     ; 1E77
        .byte   $04                             ; 1E78
        ora     $05                             ; 1E79
        ora     $28                             ; 1E7B
        ora     ($00,x)                         ; 1E7D
        bcc     L1E87                           ; 1E7F
        .byte   $07                             ; 1E81
        asl     $02                             ; 1E82
        ora     ($02,x)                         ; 1E84
        .byte   $01                             ; 1E86
L1E87:  .byte   $02                             ; 1E87
        ora     ($02,x)                         ; 1E88
        ora     ($02,x)                         ; 1E8A
        ora     ($02,x)                         ; 1E8C
        ora     ($02,x)                         ; 1E8E
        ora     ($02,x)                         ; 1E90
        ora     ($02,x)                         ; 1E92
        ora     ($07,x)                         ; 1E94
        asl     $07                             ; 1E96
        asl     $08                             ; 1E98
        ora     #$02                            ; 1E9A
        ora     ($02,x)                         ; 1E9C
        ora     ($02,x)                         ; 1E9E
        ora     ($02,x)                         ; 1EA0
        ora     ($02,x)                         ; 1EA2
        ora     ($02,x)                         ; 1EA4
        ora     ($03,x)                         ; 1EA6
        ora     ($12,x)                         ; 1EA8
        .byte   $27                             ; 1EAA
        brk                                     ; 1EAB
        asl     a                               ; 1EAC
        .byte   $0B                             ; 1EAD
        .byte   $0B                             ; 1EAE
        .byte   $0C                             ; 1EAF
        .byte   $04                             ; 1EB0
        ora     $05                             ; 1EB1
        ora     $05                             ; 1EB3
        ora     $05                             ; 1EB5
        ora     $05                             ; 1EB7
        ora     $05                             ; 1EB9
        ora     $05                             ; 1EBB
        ora     $0C                             ; 1EBD
        .byte   $04                             ; 1EBF
        .byte   $1B                             ; 1EC0
        brk                                     ; 1EC1
        .byte   $02                             ; 1EC2
        ora     ($02,x)                         ; 1EC3
        ora     ($02,x)                         ; 1EC5
        ora     ($02,x)                         ; 1EC7
        ora     ($02,x)                         ; 1EC9
        ora     ($02,x)                         ; 1ECB
        ora     ($0D,x)                         ; 1ECD
        asl     L100F                           ; 1ECF
        ora     ($12),y                         ; 1ED2
        .byte   $13                             ; 1ED4
        .byte   $14                             ; 1ED5
        ora     $16,x                           ; 1ED6
        .byte   $17                             ; 1ED8
        clc                                     ; 1ED9
        ora     L1B1A,y                         ; 1EDA
        .byte   $1C                             ; 1EDD
        ora     L1F1E,x                         ; 1EDE
        jsr     L2221                           ; 1EE1
        .byte   $23                             ; 1EE4
        bit     $02                             ; 1EE5
        ora     ($02,x)                         ; 1EE7
        ora     ($02,x)                         ; 1EE9
        ora     ($02,x)                         ; 1EEB
        ora     ($02,x)                         ; 1EED
        ora     ($02,x)                         ; 1EEF
        ora     ($02,x)                         ; 1EF1
        ora     ($00),y                         ; 1EF3
        php                                     ; 1EF5
        and     $33                             ; 1EF6
        .byte   $27                             ; 1EF8
        plp                                     ; 1EF9
        and     #$2A                            ; 1EFA
        .byte   $2B                             ; 1EFC
        bit     L2E2D                           ; 1EFD
        .byte   $27                             ; 1F00
        plp                                     ; 1F01
        and     #$2A                            ; 1F02
        .byte   $2B                             ; 1F04
        bit     L2E2D                           ; 1F05
        .byte   $27                             ; 1F08
        plp                                     ; 1F09
        and     #$3C                            ; 1F0A
        rol     L2D3F,x                         ; 1F0C
        rti                                     ; 1F0F

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; 1F10
L1F12:  .byte   $43                             ; 1F12
        .byte   $3C                             ; 1F13
        .byte   $44                             ; 1F14
        eor     $2F                             ; 1F15
        lsr     $04                             ; 1F17
        ora     ($00,x)                         ; 1F19
        brk                                     ; 1F1B
        and     ($02),y                         ; 1F1C
L1F1E:  .byte   $01                             ; 1F1E
L1F1F:  .byte   $02                             ; 1F1F
        .byte   $02                             ; 1F20
        ora     ($14,x)                         ; 1F21
        brk                                     ; 1F23
        ora     ($02,x)                         ; 1F24
        ora     $12                             ; 1F26
        asl     $00,x                           ; 1F28
        ora     ($02,x)                         ; 1F2A
        ora     ($30,x)                         ; 1F2C
        and     ($36),y                         ; 1F2E
        .byte   $32                             ; 1F30
        and     $33                             ; 1F31
        ora     $34                             ; 1F33
        and     $27,x                           ; 1F35
L1F37:  plp                                     ; 1F37
        ora     $36                             ; 1F38
        .byte   $37                             ; 1F3A
        and     #$2A                            ; 1F3B
        brk                                     ; 1F3D
        sec                                     ; 1F3E
        and     L2C2B,y                         ; 1F3F
        .byte   $04                             ; 1F42
        rol     $37,x                           ; 1F43
        and     L052E                           ; 1F45
        .byte   $34                             ; 1F48
        and     $27,x                           ; 1F49
        plp                                     ; 1F4B
        ora     $36                             ; 1F4C
        .byte   $37                             ; 1F4E
        and     #$2A                            ; 1F4F
        ora     $38                             ; 1F51
        and     L2C2B,y                         ; 1F53
        ora     $3A                             ; 1F56
        .byte   $3B                             ; 1F58
        and     L052E                           ; 1F59
        .byte   $34                             ; 1F5C
        and     $27,x                           ; 1F5D
        plp                                     ; 1F5F
        ora     $36                             ; 1F60
        .byte   $37                             ; 1F62
        and     #$3C                            ; 1F63
        ora     $38                             ; 1F65
        and     L3F3E,y                         ; 1F67
        ora     $3A                             ; 1F6A
        .byte   $3B                             ; 1F6C
        and     L0540                           ; 1F6D
        .byte   $34                             ; 1F70
        and     $41,x                           ; 1F71
        .byte   $42                             ; 1F73
        ora     $36                             ; 1F74
        .byte   $37                             ; 1F76
        .byte   $43                             ; 1F77
        .byte   $3C                             ; 1F78
        ora     $38                             ; 1F79
        and     L4544,y                         ; 1F7B
        ora     $2F                             ; 1F7E
        and     L462F,x                         ; 1F80
        ora     $7E                             ; 1F83
        adc     $777B,x                         ; 1F85
        .byte   $6F                             ; 1F88
        .byte   $5F                             ; 1F89
        .byte   $7F                             ; 1F8A
        eor     L00AA,x                         ; 1F8B
        .byte   $FF                             ; 1F8D
        .byte   $FF                             ; 1F8E
        .byte   $FF                             ; 1F8F
        .byte   $FF                             ; 1F90
        .byte   $FF                             ; 1F91
        .byte   $FF                             ; 1F92
        eor     L00AA,x                         ; 1F93
        .byte   $E7                             ; 1F95
        .byte   $E7                             ; 1F96
        .byte   $E7                             ; 1F97
        .byte   $E7                             ; 1F98
        .byte   $E7                             ; 1F99
        .byte   $E7                             ; 1F9A
        eor     $7E,x                           ; 1F9B
        ldx     $EEDE,y                         ; 1F9D
        inc     $FA,x                           ; 1FA0
        inc     $0155,x                         ; 1FA2
        .byte   $17                             ; 1FA5
        .byte   $17                             ; 1FA6
        .byte   $03                             ; 1FA7
        .byte   $3F                             ; 1FA8
        .byte   $17                             ; 1FA9
        ror     $7E7E,x                         ; 1FAA
        ror     $567E,x                         ; 1FAD
        ror     a                               ; 1FB0
        ror     $7E7E,x                         ; 1FB1
        .byte   $FF                             ; 1FB4
        eor     $55,x                           ; 1FB5
        eor     $FF,x                           ; 1FB7
        .byte   $FF                             ; 1FB9
        .byte   $FF                             ; 1FBA
        eor     $FF,x                           ; 1FBB
        adc     ($71),y                         ; 1FBD
        adc     ($E7),y                         ; 1FBF
        .byte   $E7                             ; 1FC1
        .byte   $E7                             ; 1FC2
        eor     $FD,x                           ; 1FC3
        .byte   $74                             ; 1FC5
        .byte   $74                             ; 1FC6
        .byte   $74                             ; 1FC7
        .byte   $74                             ; 1FC8
        .byte   $74                             ; 1FC9
        .byte   $74                             ; 1FCA
        brk                                     ; 1FCB
        ror     $7B7D,x                         ; 1FCC
        .byte   $77                             ; 1FCF
        .byte   $6F                             ; 1FD0
        .byte   $5F                             ; 1FD1
        .byte   $7F                             ; 1FD2
        eor     L00AA,x                         ; 1FD3
        inc     $F6FA,x                         ; 1FD5
        inc     $BEDE                           ; 1FD8
        ror     L1E1E,x                         ; 1FDB
        asl     L1A16,x                         ; 1FDE
        asl     L1E1E,x                         ; 1FE1
        ror     $DEBE,x                         ; 1FE4
        inc     $FAF6                           ; 1FE7
        inc     a:$55,x                         ; 1FEA
        .byte   $14                             ; 1FED
        ora     ($A9,x)                         ; 1FEE
        .byte   $22                             ; 1FF0
        bit     $2C                             ; 1FF1
        bit     $00                             ; 1FF3
        bvs     L200E                           ; 1FF5
        .byte   $FF                             ; 1FF7
        adc     $89,x                           ; 1FF8
        txa                                     ; 1FFA
        dey                                     ; 1FFB
        brk                                     ; 1FFC
        .byte   $14                             ; 1FFD
        eor     $5DDF                           ; 1FFE
        stx     $08,y                           ; 2001
        cpy     #$00                            ; 2003
        bvs     L201E                           ; 2005
        .byte   $F7                             ; 2007
        adc     L2497,x                         ; 2008
        .byte   $22                             ; 200B
        brk                                     ; 200C
        .byte   $14                             ; 200D
L200E:  .byte   $53                             ; 200E
        .byte   $DF                             ; 200F
        .byte   $DF                             ; 2010
        .byte   $67                             ; 2011
        dey                                     ; 2012
        php                                     ; 2013
        brk                                     ; 2014
        bmi     L2028                           ; 2015
        .byte   $F7                             ; 2017
        cmp     $A864,x                         ; 2018
        dey                                     ; 201B
        brk                                     ; 201C
        .byte   $14                             ; 201D
L201E:  .byte   $5F                             ; 201E
        .byte   $DF                             ; 201F
L2020:  adc     $9A,x                           ; 2020
        ldx     #$82                            ; 2022
        brk                                     ; 2024
        bvs     L203E                           ; 2025
        .byte   $CB                             ; 2027
L2028:  cmp     #$C9                            ; 2028
        .byte   $CB                             ; 202A
        eor     #$00                            ; 202B
        .byte   $14                             ; 202D
        .byte   $57                             ; 202E
        .byte   $CB                             ; 202F
        .byte   $CB                             ; 2030
        .byte   $CB                             ; 2031
        iny                                     ; 2032
        pha                                     ; 2033
        brk                                     ; 2034
        bvs     L204E                           ; 2035
        .byte   $F7                             ; 2037
        sbc     $69,x                           ; 2038
        .byte   $82                             ; 203A
        .byte   $32                             ; 203B
        brk                                     ; 203C
        .byte   $14                             ; 203D
L203E:  .byte   $5F                             ; 203E
        .byte   $DF                             ; 203F
        .byte   $DF                             ; 2040
        .byte   $27                             ; 2041
        rol     a                               ; 2042
        jsr     L7000                           ; 2043
        .byte   $17                             ; 2046
        .byte   $F7                             ; 2047
        sbc     $49,x                           ; 2048
        .byte   $22                             ; 204A
        jsr     L2424                           ; 204B
L204E:  bit     $24                             ; 204E
        tax                                     ; 2050
        brk                                     ; 2051
        .byte   $D0                             ; 2052
L2053:  .byte   $FF                             ; 2053
        .byte   $8B                             ; 2054
L2055:  .byte   $8B                             ; 2055
        .byte   $8B                             ; 2056
        .byte   $89                             ; 2057
        .byte   $0B                             ; 2058
        .byte   $C3                             ; 2059
        .byte   $DF                             ; 205A
        .byte   $5F                             ; 205B
        .byte   $F2                             ; 205C
        cmp     #$C9                            ; 205D
        cmp     #$42                            ; 205F
        beq     L20D8                           ; 2061
        .byte   $DF                             ; 2063
        .byte   $22                             ; 2064
        .byte   $22                             ; 2065
        .byte   $22                             ; 2066
        jsr     L02A8                           ; 2067
L206A:  bne     L20CB                           ; 206A
        iny                                     ; 206C
        iny                                     ; 206D
        pha                                     ; 206E
        tay                                     ; 206F
        php                                     ; 2070
        pha                                     ; 2071
        lda     ($0F,x)                         ; 2072
        dey                                     ; 2074
        dey                                     ; 2075
        dey                                     ; 2076
        tay                                     ; 2077
        jsr     LDF0C                           ; 2078
        .byte   $5F                             ; 207B
        .byte   $B2                             ; 207C
        .byte   $B2                             ; 207D
        .byte   $B2                             ; 207E
        .byte   $B2                             ; 207F
        .byte   $92                             ; 2080
        bmi     L20F8                           ; 2081
        .byte   $DF                             ; 2083
        .byte   $CB                             ; 2084
        iny                                     ; 2085
        iny                                     ; 2086
        lsr     a                               ; 2087
        .byte   $C2                             ; 2088
        bvs     L206A                           ; 2089
        .byte   $5F                             ; 208B
        cmp     #$88                            ; 208C
        dey                                     ; 208E
        tay                                     ; 208F
        and     ($07,x)                         ; 2090
        adc     $DF,x                           ; 2092
        .byte   $22                             ; 2094
        .byte   $82                             ; 2095
        .byte   $B2                             ; 2096
        .byte   $B2                             ; 2097
        rol     a                               ; 2098
        cpy     #$DF                            ; 2099
        .byte   $5F                             ; 209B
        and     L2D2D                           ; 209C
        .byte   $2F                             ; 209F
        and     $7507                           ; 20A0
        .byte   $DF                             ; 20A3
        cmp     #$C2                            ; 20A4
        .byte   $E2                             ; 20A6
        .byte   $22                             ; 20A7
        php                                     ; 20A8
        eor     ($DF,x)                         ; 20A9
        .byte   $5F                             ; 20AB
        brk                                     ; 20AC
        .byte   $54                             ; 20AD
        .byte   $5B                             ; 20AE
        .byte   $DA                             ; 20AF
        .byte   $F7                             ; 20B0
        .byte   $DA                             ; 20B1
        .byte   $7A                             ; 20B2
        inc     a:$00,x                         ; 20B3
        rti                                     ; 20B6

; ----------------------------------------------------------------------------
        bvc     L2055                           ; 20B7
        sty     $A4,x                           ; 20B9
        ldy     $7A                             ; 20BB
L20BD:  .byte   $DA                             ; 20BD
        ror     a                               ; 20BE
        .byte   $FF                             ; 20BF
        .byte   $5A                             ; 20C0
        nop                                     ; 20C1
        nop                                     ; 20C2
        .byte   $FB                             ; 20C3
        ldy     $A4                             ; 20C4
        ldy     L00AC                           ; 20C6
        .byte   $F4                             ; 20C8
        .byte   $BC                             ; 20C9
        .byte   $E4                             ; 20CA
L20CB:  ldy     $DE                             ; 20CB
        ror     a                               ; 20CD
        .byte   $FA                             ; 20CE
        inc     $6E5A,x                         ; 20CF
        .byte   $EB                             ; 20D2
        .byte   $FA                             ; 20D3
        ldy     $A4                             ; 20D4
        ldy     $A4                             ; 20D6
L20D8:  ldy     $BC                             ; 20D8
        cpx     $A4                             ; 20DA
        lsr     $FEF7,x                         ; 20DC
        .byte   $5A                             ; 20DF
        inc     $FAFA,x                         ; 20E0
        inc     $ECA4,x                         ; 20E3
        ldy     $A4,x                           ; 20E6
        ldy     L00AC                           ; 20E8
        ldy     $E4,x                           ; 20EA
        .byte   $EB                             ; 20EC
        inc     $DA5A,x                         ; 20ED
        .byte   $EF                             ; 20F0
        .byte   $FA                             ; 20F1
        ror     a                               ; 20F2
        .byte   $FA                             ; 20F3
        ldy     $A4                             ; 20F4
        .byte   $BC                             ; 20F6
        .byte   $E4                             ; 20F7
L20F8:  ldy     $BC,x                           ; 20F8
        ldy     $A4                             ; 20FA
        tax                                     ; 20FC
        .byte   $FF                             ; 20FD
        .byte   $F7                             ; 20FE
L20FF:  .byte   $DF                             ; 20FF
        cmp     $55F7,x                         ; 2100
        brk                                     ; 2103
        sbc     $7474,x                         ; 2104
        .byte   $74                             ; 2107
        .byte   $74                             ; 2108
        .byte   $74                             ; 2109
        .byte   $74                             ; 210A
        brk                                     ; 210B
        tax                                     ; 210C
        .byte   $7F                             ; 210D
        .byte   $6F                             ; 210E
        .byte   $5F                             ; 210F
        .byte   $7B                             ; 2110
        .byte   $77                             ; 2111
        ror     a:$7D,x                         ; 2112
        .byte   $1F                             ; 2115
        .byte   $7F                             ; 2116
        .byte   $5F                             ; 2117
        .byte   $7F                             ; 2118
        .byte   $7F                             ; 2119
        .byte   $5F                             ; 211A
        eor     a:$00,x                         ; 211B
        rti                                     ; 211E

; ----------------------------------------------------------------------------
        bvc     L20BD                           ; 211F
        sty     $A4,x                           ; 2121
        ldy     $14                             ; 2123
        eor     ($15,x)                         ; 2125
        ora     $45,x                           ; 2127
        ora     $45,x                           ; 2129
        ora     $75,x                           ; 212B
        .byte   $7F                             ; 212D
        eor     L0D47,x                         ; 212E
        .byte   $5F                             ; 2131
        .byte   $7F                             ; 2132
        .byte   $5F                             ; 2133
        bpl     L213B                           ; 2134
        .byte   $14                             ; 2136
        eor     $15                             ; 2137
        eor     ($04,x)                         ; 2139
L213B:  ora     $3F                             ; 213B
        .byte   $5F                             ; 213D
        .byte   $3F                             ; 213E
        eor     $5F,x                           ; 213F
        adc     $0F,x                           ; 2141
        .byte   $5F                             ; 2143
        ora     $44,x                           ; 2144
        ora     ($05,x)                         ; 2146
        ora     $45,x                           ; 2148
        ora     $45,x                           ; 214A
        .byte   $5F                             ; 214C
        and     L1F37,x                         ; 214D
        adc     $7777,x                         ; 2150
        .byte   $5F                             ; 2153
        ora     $40,x                           ; 2154
        ora     ($05),y                         ; 2156
        ora     $45,x                           ; 2158
        ora     L0010                           ; 215A
        .byte   $1F                             ; 215C
        .byte   $7F                             ; 215D
        .byte   $5F                             ; 215E
        .byte   $7F                             ; 215F
        .byte   $5F                             ; 2160
        .byte   $5F                             ; 2161
        .byte   $7F                             ; 2162
        ora     $A4A4                           ; 2163
        ldy     $A4                             ; 2166
        ldy     $BC                             ; 2168
        cpx     $A4                             ; 216A
        tax                                     ; 216C
        .byte   $FF                             ; 216D
        .byte   $77                             ; 216E
        .byte   $DF                             ; 216F
        .byte   $DF                             ; 2170
        .byte   $F7                             ; 2171
        eor     $00,x                           ; 2172
        .byte   $5E                             ; 2174
        .byte   $F7                             ; 2175
L2176:  inc     $FE5A,x                         ; 2176
        .byte   $FA                             ; 2179
        .byte   $FA                             ; 217A
        inc     $ECA4,x                         ; 217B
        ldy     $A4,x                           ; 217E
        ldy     L00AC                           ; 2180
        ldy     $E4,x                           ; 2182
        ldy     $A4                             ; 2184
        ldy     $B4E4,x                         ; 2186
        ldy     $A4A4,x                         ; 2189
        .byte   $7A                             ; 218C
        .byte   $DA                             ; 218D
        ror     a                               ; 218E
        .byte   $FF                             ; 218F
        .byte   $5A                             ; 2190
        nop                                     ; 2191
        nop                                     ; 2192
        .byte   $FB                             ; 2193
        ldy     $A4                             ; 2194
        ldy     L00AC                           ; 2196
        .byte   $F4                             ; 2198
        ldy     $A4E4,x                         ; 2199
        .byte   $DE                             ; 219C
        ror     a                               ; 219D
L219E:  .byte   $FA                             ; 219E
        inc     $6E5A,x                         ; 219F
        .byte   $EB                             ; 21A2
        .byte   $FA                             ; 21A3
        lsr     $FEF7,x                         ; 21A4
        .byte   $5A                             ; 21A7
        inc     $FAFA,x                         ; 21A8
        inc     $ECA4,x                         ; 21AB
        ldy     $A4,x                           ; 21AE
        ldy     L00AC                           ; 21B0
        ldy     $E4,x                           ; 21B2
        tax                                     ; 21B4
        inc     $DEFE,x                         ; 21B5
        dec     $567E,x                         ; 21B8
        ora     ($14,x)                         ; 21BB
        eor     ($15,x)                         ; 21BD
        .byte   $15                             ; 21BF
L21C0:  eor     $14                             ; 21C0
        .byte   $43                             ; 21C2
        .byte   $03                             ; 21C3
        txa                                     ; 21C4
        ldy     #$80                            ; 21C5
        .byte   $87                             ; 21C7
        ora     $FF,x                           ; 21C8
        cpy     #$00                            ; 21CA
        asl     a                               ; 21CC
        rol     a                               ; 21CD
        asl     a                               ; 21CE
        .byte   $F2                             ; 21CF
        .byte   $FC                             ; 21D0
        .byte   $FF                             ; 21D1
        .byte   $03                             ; 21D2
        brk                                     ; 21D3
        cli                                     ; 21D4
        cli                                     ; 21D5
        cli                                     ; 21D6
        bvc     L2241                           ; 21D7
        plp                                     ; 21D9
        iny                                     ; 21DA
        iny                                     ; 21DB
        sty     L0D0D                           ; 21DC
        .byte   $83                             ; 21DF
        jsr     L0880                           ; 21E0
        asl     a                               ; 21E3
        bcc     L2176                           ; 21E4
        sty     $A5,x                           ; 21E6
        sbc     #$3A                            ; 21E8
        .byte   $0F                             ; 21EA
        brk                                     ; 21EB
        stx     L0006                           ; 21EC
        asl     $5A,x                           ; 21EE
        .byte   $6B                             ; 21F0
        ldy     $02F0                           ; 21F1
        bmi     L2266                           ; 21F4
L21F6:  bvs     L21C0                           ; 21F6
        php                                     ; 21F8
        clc                                     ; 21F9
        cli                                     ; 21FA
        cli                                     ; 21FB
        plp                                     ; 21FC
        .byte   $82                             ; 21FD
        rol     a                               ; 21FE
        plp                                     ; 21FF
        sta     ($04,x)                         ; 2200
        ora     ($45),y                         ; 2202
        sta     ($84,x)                         ; 2204
        ora     ($45),y                         ; 2206
        ora     $55,x                           ; 2208
        eor     $55,x                           ; 220A
        ora     $85                             ; 220C
        and     ($88,x)                         ; 220E
        ldx     #$A8                            ; 2210
        tax                                     ; 2212
        tax                                     ; 2213
        bvc     L2266                           ; 2214
        bvc     L226C                           ; 2216
        bpl     L219E                           ; 2218
        jsr     L1088                           ; 221A
        .byte   $04                             ; 221D
        ora     ($80,x)                         ; 221E
        plp                                     ; 2220
L2221:  .byte   $82                             ; 2221
L2222:  php                                     ; 2222
        asl     a                               ; 2223
        ora     $C5                             ; 2224
        bmi     L2277                           ; 2226
        .byte   $13                             ; 2228
        .byte   $04                             ; 2229
        ora     ($A0,x)                         ; 222A
        rti                                     ; 222C

; ----------------------------------------------------------------------------
        .byte   $4C                             ; 222D
L222E:  and     ($C4),y                         ; 222E
        bpl     L2274                           ; 2230
        php                                     ; 2232
        asl     a                               ; 2233
        bmi     L21F6                           ; 2234
        php                                     ; 2236
L2237:  clc                                     ; 2237
        cli                                     ; 2238
        rti                                     ; 2239

; ----------------------------------------------------------------------------
        clc                                     ; 223A
        cli                                     ; 223B
        plp                                     ; 223C
        .byte   $82                             ; 223D
        rol     a                               ; 223E
        plp                                     ; 223F
        .byte   $81                             ; 2240
L2241:  .byte   $04                             ; 2241
        .byte   $13                             ; 2242
        .byte   $4F                             ; 2243
        sta     ($84,x)                         ; 2244
        ora     ($41),y                         ; 2246
        and     ($C1),y                         ; 2248
        ora     $15,x                           ; 224A
        .byte   $13                             ; 224C
        .byte   $04                             ; 224D
        ora     ($80,x)                         ; 224E
        plp                                     ; 2250
        .byte   $82                             ; 2251
        php                                     ; 2252
        asl     a                               ; 2253
        ora     $C1,x                           ; 2254
        and     ($41),y                         ; 2256
        ora     ($04),y                         ; 2258
        ora     ($A0,x)                         ; 225A
        eor     $54,x                           ; 225C
        eor     ($44),y                         ; 225E
        bpl     L22A4                           ; 2260
        php                                     ; 2262
        asl     a                               ; 2263
        .byte   $14                             ; 2264
        .byte   $41                             ; 2265
L2266:  ora     $14,x                           ; 2266
        .byte   $42                             ; 2268
        php                                     ; 2269
        .byte   $20                             ; 226A
        txa                                     ; 226B
L226C:  sta     ($84,x)                         ; 226C
        .byte   $13                             ; 226E
        .byte   $4F                             ; 226F
        bmi     L2237                           ; 2270
        ora     $55                             ; 2272
L2274:  asl     a                               ; 2274
        lsr     a                               ; 2275
        .byte   $12                             ; 2276
L2277:  cpy     $31                             ; 2277
L2279:  jmp     L5540                           ; 2279

; ----------------------------------------------------------------------------
        .byte   $22                             ; 227C
        php                                     ; 227D
        .byte   $02                             ; 227E
        rti                                     ; 227F

; ----------------------------------------------------------------------------
        .byte   $14                             ; 2280
        eor     ($04,x)                         ; 2281
        ora     L00AA                           ; 2283
        tax                                     ; 2285
        rol     a                               ; 2286
        txa                                     ; 2287
        .byte   $22                             ; 2288
        php                                     ; 2289
        .byte   $02                             ; 228A
        bvc     L22A1                           ; 228B
        eor     ($15,x)                         ; 228D
        .byte   $14                             ; 228F
        .byte   $42                             ; 2290
        php                                     ; 2291
        .byte   $22                             ; 2292
        txa                                     ; 2293
        .byte   $42                             ; 2294
        pha                                     ; 2295
        .byte   $22                             ; 2296
        txa                                     ; 2297
        rol     a                               ; 2298
        tax                                     ; 2299
        tax                                     ; 229A
        tax                                     ; 229B
        ora     $85                             ; 229C
        and     ($08,x)                         ; 229E
        .byte   $32                             ; 22A0
L22A1:  .byte   $0C                             ; 22A1
        .byte   $A3                             ; 22A2
        .byte   $A3                             ; 22A3
L22A4:  bvc     L22F6                           ; 22A4
        bvc     L22FC                           ; 22A6
        bpl     L222E                           ; 22A8
        jsr     L53C8                           ; 22AA
        .byte   $0C                             ; 22AD
        and     ($04),y                         ; 22AE
        bpl     L22F4                           ; 22B0
        php                                     ; 22B2
        asl     a                               ; 22B3
        jsr     L0882                           ; 22B4
L22B7:  asl     a                               ; 22B7
        .byte   $8B                             ; 22B8
        .byte   $0B                             ; 22B9
        txa                                     ; 22BA
        php                                     ; 22BB
        brk                                     ; 22BC
        lsr     $02,x                           ; 22BD
        .byte   $52                             ; 22BF
        .byte   $E2                             ; 22C0
        .byte   $E2                             ; 22C1
        lsr     $02,x                           ; 22C2
        brk                                     ; 22C4
        .byte   $5A                             ; 22C5
        rti                                     ; 22C6

; ----------------------------------------------------------------------------
        .byte   $57                             ; 22C7
        .byte   $57                             ; 22C8
        .byte   $57                             ; 22C9
        eor     $40,x                           ; 22CA
        brk                                     ; 22CC
        rti                                     ; 22CD

; ----------------------------------------------------------------------------
        bvc     L22E0                           ; 22CE
        jsr     LA020                           ; 22D0
        jsr     L0101                           ; 22D3
        brk                                     ; 22D6
        rti                                     ; 22D7

; ----------------------------------------------------------------------------
        .byte   $14                             ; 22D8
        rti                                     ; 22D9

; ----------------------------------------------------------------------------
        ora     $05                             ; 22DA
        .byte   $52                             ; 22DC
        .byte   $E2                             ; 22DD
        .byte   $72                             ; 22DE
        .byte   $72                             ; 22DF
L22E0:  asl     L0006,x                         ; 22E0
L22E2:  .byte   $02                             ; 22E2
        bvc     L2279                           ; 22E3
        tay                                     ; 22E5
        ldx     #$8A                            ; 22E6
        tay                                     ; 22E8
        ldy     #$83                            ; 22E9
        asl     a                               ; 22EB
        cpy     #$44                            ; 22EC
        .byte   $04                             ; 22EE
        bit     $24                             ; 22EF
        ldy     $A4E4,x                         ; 22F1
L22F4:  .byte   $14                             ; 22F4
        .byte   $41                             ; 22F5
L22F6:  ora     $15,x                           ; 22F6
        .byte   $44                             ; 22F8
L22F9:  .byte   $14                             ; 22F9
        .byte   $44                             ; 22FA
        .byte   $15                             ; 22FB
L22FC:  brk                                     ; 22FC
        .byte   $03                             ; 22FD
        .byte   $03                             ; 22FE
        asl     $8D0F                           ; 22FF
        .byte   $37                             ; 2302
        .byte   $3A                             ; 2303
        cmp     ($C1,x)                         ; 2304
        .byte   $80                             ; 2306
        bcs     L22F9                           ; 2307
        beq     L22B7                           ; 2309
        .byte   $9C                             ; 230B
        ldy     $A4                             ; 230C
        ldy     L00AC                           ; 230E
        .byte   $F4                             ; 2310
        .byte   $BC                             ; 2311
L2312:  cpx     $24                             ; 2312
        bpl     L231A                           ; 2314
        .byte   $14                             ; 2316
        .byte   $44                             ; 2317
        .byte   $14                             ; 2318
        rti                                     ; 2319

; ----------------------------------------------------------------------------
L231A:  .byte   $04                             ; 231A
        ora     $39                             ; 231B
        sbc     #$55                            ; 231D
        .byte   $57                             ; 231F
        dec     $1A,x                           ; 2320
        ora     $05,x                           ; 2322
L2324:  .byte   $54                             ; 2324
        lsr     $59,x                           ; 2325
        lda     $5494                           ; 2327
        .byte   $54                             ; 232A
        rts                                     ; 232B

; ----------------------------------------------------------------------------
        bit     $24                             ; 232C
        bit     $24                             ; 232E
        bit     $BC                             ; 2330
        cpx     $A4                             ; 2332
        brk                                     ; 2334
        rol     L0D0F                           ; 2335
        .byte   $07                             ; 2338
        rol     L393A,x                         ; 2339
        ora     ($01,x)                         ; 233C
        cpy     #$C0                            ; 233E
        bcs     L22E2                           ; 2340
        bvs     L23AC                           ; 2342
        .byte   $27                             ; 2344
        .byte   $DF                             ; 2345
        ror     $6A,x                           ; 2346
        cmp     $15,x                           ; 2348
        ora     $07,x                           ; 234A
        inx                                     ; 234C
        ldy     $5494                           ; 234D
        .byte   $64                             ; 2350
        pla                                     ; 2351
        bcs     L2324                           ; 2352
        brk                                     ; 2354
        asl     L3A0B                           ; 2355
        .byte   $2F                             ; 2358
        .byte   $27                             ; 2359
        dec     $FA,x                           ; 235A
        ora     ($11,x)                         ; 235C
        brk                                     ; 235E
        cpy     #$C0                            ; 235F
L2361:  cpy     #$B0                            ; 2361
        bvs     L2312                           ; 2363
        lda     $95,x                           ; 2365
        .byte   $5A                             ; 2367
        .byte   $6B                             ; 2368
        .byte   $57                             ; 2369
        ora     $09,x                           ; 236A
        rts                                     ; 236C

; ----------------------------------------------------------------------------
        cli                                     ; 236D
        tay                                     ; 236E
        bcs     L2361                           ; 236F
        bvc     L23C3                           ; 2371
        rti                                     ; 2373

; ----------------------------------------------------------------------------
        brk                                     ; 2374
        .byte   $03                             ; 2375
        .byte   $02                             ; 2376
        .byte   $0F                             ; 2377
        .byte   $0F                             ; 2378
        ora     #$3B                            ; 2379
        and     $C121,x                         ; 237B
        cpy     #$70                            ; 237E
        ldy     #$51                            ; 2380
        .byte   $7C                             ; 2382
        inx                                     ; 2383
        .byte   $37                             ; 2384
        dec     $5A,x                           ; 2385
        .byte   $57                             ; 2387
        cmp     L291A,x                         ; 2388
        ora     $A4                             ; 238B
        .byte   $54                             ; 238D
        adc     $7C,x                           ; 238E
        .byte   $D4                             ; 2390
        ldy     $94,x                           ; 2391
        rti                                     ; 2393

; ----------------------------------------------------------------------------
L2394:  ora     ($11),y                         ; 2394
        ora     ($11),y                         ; 2396
        ora     ($11),y                         ; 2398
        ora     ($11),y                         ; 239A
        ora     ($11),y                         ; 239C
        ora     ($11),y                         ; 239E
        ora     ($11),y                         ; 23A0
        ora     ($11),y                         ; 23A2
        ora     ($11),y                         ; 23A4
        ora     ($11),y                         ; 23A6
        ora     ($11),y                         ; 23A8
        ora     ($11),y                         ; 23AA
L23AC:  ora     ($11),y                         ; 23AC
        ora     ($11),y                         ; 23AE
        ora     ($11),y                         ; 23B0
        ora     ($11),y                         ; 23B2
        ora     ($11),y                         ; 23B4
        ora     ($11),y                         ; 23B6
        ora     ($11),y                         ; 23B8
        ora     ($11),y                         ; 23BA
        ora     ($11),y                         ; 23BC
        ora     ($11),y                         ; 23BE
        ora     ($11),y                         ; 23C0
        .byte   $11                             ; 23C2
L23C3:  ora     ($11),y                         ; 23C3
        ora     ($17),y                         ; 23C5
        ora     ($11),y                         ; 23C7
        .byte   $17                             ; 23C9
        ora     ($17),y                         ; 23CA
        ora     ($17),y                         ; 23CC
        ora     ($17),y                         ; 23CE
        ora     ($11),y                         ; 23D0
        ora     ($11),y                         ; 23D2
        ora     ($11),y                         ; 23D4
        ora     ($11),y                         ; 23D6
        ora     ($11),y                         ; 23D8
        ora     ($11),y                         ; 23DA
        ora     ($11),y                         ; 23DC
        ora     ($11),y                         ; 23DE
        adc     ($61,x)                         ; 23E0
        ora     ($21),y                         ; 23E2
        and     ($12,x)                         ; 23E4
        .byte   $12                             ; 23E6
        and     ($21,x)                         ; 23E7
        and     ($11,x)                         ; 23E9
        and     ($21,x)                         ; 23EB
        and     ($21,x)                         ; 23ED
        and     ($12,x)                         ; 23EF
        and     ($21,x)                         ; 23F1
        .byte   $12                             ; 23F3
        .byte   $12                             ; 23F4
        .byte   $12                             ; 23F5
        .byte   $12                             ; 23F6
        .byte   $12                             ; 23F7
        .byte   $12                             ; 23F8
        and     ($01,x)                         ; 23F9
        ora     ($11),y                         ; 23FB
        ora     (L0010),y                       ; 23FD
        ora     ($11),y                         ; 23FF
        ora     (L0010),y                       ; 2401
        .byte   $17                             ; 2403
        .byte   $17                             ; 2404
        ora     (L0010),y                       ; 2405
        .byte   $17                             ; 2407
        .byte   $17                             ; 2408
        ora     ($17),y                         ; 2409
        .byte   $17                             ; 240B
        .byte   $17                             ; 240C
        .byte   $17                             ; 240D
        .byte   $17                             ; 240E
        .byte   $17                             ; 240F
        .byte   $17                             ; 2410
        .byte   $17                             ; 2411
        .byte   $17                             ; 2412
        .byte   $17                             ; 2413
        .byte   $17                             ; 2414
        .byte   $17                             ; 2415
L2416:  .byte   $52                             ; 2416
        .byte   $52                             ; 2417
        .byte   $52                             ; 2418
        .byte   $52                             ; 2419
        .byte   $52                             ; 241A
        .byte   $52                             ; 241B
        .byte   $72                             ; 241C
        .byte   $52                             ; 241D
        .byte   $52                             ; 241E
        .byte   $52                             ; 241F
        .byte   $52                             ; 2420
L2421:  .byte   $52                             ; 2421
        .byte   $52                             ; 2422
        .byte   $72                             ; 2423
L2424:  .byte   $72                             ; 2424
        .byte   $72                             ; 2425
        .byte   $72                             ; 2426
        .byte   $72                             ; 2427
        .byte   $72                             ; 2428
        .byte   $72                             ; 2429
        .byte   $72                             ; 242A
        .byte   $72                             ; 242B
        .byte   $72                             ; 242C
        .byte   $72                             ; 242D
        .byte   $72                             ; 242E
        .byte   $72                             ; 242F
        .byte   $72                             ; 2430
        .byte   $72                             ; 2431
        .byte   $72                             ; 2432
        .byte   $72                             ; 2433
        .byte   $72                             ; 2434
        .byte   $72                             ; 2435
        .byte   $72                             ; 2436
        .byte   $72                             ; 2437
        .byte   $72                             ; 2438
        .byte   $72                             ; 2439
        .byte   $72                             ; 243A
        .byte   $52                             ; 243B
        adc     $52,x                           ; 243C
        adc     $52,x                           ; 243E
        adc     $52,x                           ; 2440
        adc     $52,x                           ; 2442
        adc     $52,x                           ; 2444
        .byte   $52                             ; 2446
        .byte   $52                             ; 2447
        .byte   $62                             ; 2448
        adc     $52,x                           ; 2449
        .byte   $62                             ; 244B
        .byte   $52                             ; 244C
        .byte   $62                             ; 244D
        .byte   $52                             ; 244E
        .byte   $62                             ; 244F
        .byte   $52                             ; 2450
        .byte   $62                             ; 2451
        adc     $52,x                           ; 2452
        .byte   $52                             ; 2454
        adc     $75,x                           ; 2455
        .byte   $52                             ; 2457
        adc     $52,x                           ; 2458
        .byte   $52                             ; 245A
        adc     $52,x                           ; 245B
        .byte   $72                             ; 245D
        .byte   $27                             ; 245E
        .byte   $57                             ; 245F
        .byte   $57                             ; 2460
        .byte   $27                             ; 2461
        adc     ($71),y                         ; 2462
        .byte   $57                             ; 2464
        .byte   $23                             ; 2465
        .byte   $23                             ; 2466
        and     $37,x                           ; 2467
        .byte   $23                             ; 2469
        .byte   $23                             ; 246A
        .byte   $53                             ; 246B
        .byte   $57                             ; 246C
        .byte   $23                             ; 246D
        .byte   $23                             ; 246E
        .byte   $23                             ; 246F
        .byte   $23                             ; 2470
        .byte   $53                             ; 2471
        .byte   $32                             ; 2472
        .byte   $23                             ; 2473
        .byte   $53                             ; 2474
        .byte   $32                             ; 2475
        .byte   $32                             ; 2476
        .byte   $32                             ; 2477
        .byte   $32                             ; 2478
        and     $37,x                           ; 2479
        .byte   $53                             ; 247B
        jsr     L7552                           ; 247C
        .byte   $57                             ; 247F
        .byte   $02                             ; 2480
        .byte   $52                             ; 2481
        .byte   $52                             ; 2482
        adc     $02,x                           ; 2483
        .byte   $67                             ; 2485
        .byte   $67                             ; 2486
        adc     $02,x                           ; 2487
        .byte   $67                             ; 2489
        .byte   $67                             ; 248A
        adc     $67,x                           ; 248B
        .byte   $67                             ; 248D
        .byte   $67                             ; 248E
        .byte   $67                             ; 248F
        .byte   $67                             ; 2490
        .byte   $67                             ; 2491
        .byte   $67                             ; 2492
        .byte   $67                             ; 2493
        .byte   $67                             ; 2494
        .byte   $67                             ; 2495
        .byte   $67                             ; 2496
L2497:  .byte   $67                             ; 2497
        .byte   $04                             ; 2498
        .byte   $02                             ; 2499
        asl     $70,x                           ; 249A
        .byte   $4F                             ; 249C
        bvc     L24F0                           ; 249D
        .byte   $52                             ; 249F
        .byte   $53                             ; 24A0
        .byte   $54                             ; 24A1
        eor     $56,x                           ; 24A2
        .byte   $04                             ; 24A4
        .byte   $02                             ; 24A5
        asl     $70,x                           ; 24A6
        .byte   $57                             ; 24A8
        cli                                     ; 24A9
        eor     ($52),y                         ; 24AA
        eor     $5B5A,y                         ; 24AC
        lsr     $04,x                           ; 24AF
        .byte   $02                             ; 24B1
L24B2:  asl     $70,x                           ; 24B2
        .byte   $5C                             ; 24B4
        eor     $525E,x                         ; 24B5
        .byte   $5F                             ; 24B8
        rts                                     ; 24B9

; ----------------------------------------------------------------------------
        .byte   $5B                             ; 24BA
        lsr     $04,x                           ; 24BB
        .byte   $02                             ; 24BD
        asl     $70,x                           ; 24BE
        adc     ($62,x)                         ; 24C0
        .byte   $63                             ; 24C2
        .byte   $64                             ; 24C3
        .byte   $5F                             ; 24C4
        rts                                     ; 24C5

; ----------------------------------------------------------------------------
        adc     $56                             ; 24C6
        .byte   $04                             ; 24C8
        .byte   $02                             ; 24C9
        asl     $30,x                           ; 24CA
        .byte   $47                             ; 24CC
        pha                                     ; 24CD
        eor     #$4A                            ; 24CE
        .byte   $4B                             ; 24D0
        jmp     L4E4D                           ; 24D1

; ----------------------------------------------------------------------------
        .byte   $04                             ; 24D4
        .byte   $02                             ; 24D5
        asl     $50,x                           ; 24D6
        ror     $67                             ; 24D8
L24DA:  pla                                     ; 24DA
        adc     #$6A                            ; 24DB
        .byte   $6B                             ; 24DD
        jmp     (L046D)                         ; 24DE

; ----------------------------------------------------------------------------
        .byte   $02                             ; 24E1
        asl     $08,x                           ; 24E2
L24E4:  ror     $706F                           ; 24E4
        adc     ($72),y                         ; 24E7
        .byte   $73                             ; 24E9
        .byte   $74                             ; 24EA
        adc     $04,x                           ; 24EB
        .byte   $02                             ; 24ED
        asl     $08,x                           ; 24EE
L24F0:  ror     $7776                           ; 24F0
        adc     ($72),y                         ; 24F3
        sei                                     ; 24F5
        adc     $0475,y                         ; 24F6
        .byte   $02                             ; 24F9
        asl     $08,x                           ; 24FA
        ror     $7B7A                           ; 24FC
        adc     ($72),y                         ; 24FF
        .byte   $7C                             ; 2501
        adc     $0475,x                         ; 2502
        .byte   $02                             ; 2505
        asl     $08,x                           ; 2506
        ror     $7F7E                           ; 2508
        adc     ($72),y                         ; 250B
        .byte   $80                             ; 250D
        sta     ($75,x)                         ; 250E
        .byte   $02                             ; 2510
        .byte   $02                             ; 2511
        ora     ($01,x)                         ; 2512
        brk                                     ; 2514
        ora     ($07,x)                         ; 2515
        .byte   $1D                             ; 2517
L2518:  asl     $171D,x                         ; 2518
        .byte   $07                             ; 251B
        asl     a                               ; 251C
        cpx     L4000                           ; 251D
        bcc     L24B2                           ; 2520
        bvc     L2518                           ; 2522
        .byte   $F4                             ; 2524
        .byte   $F4                             ; 2525
        .byte   $0C                             ; 2526
        .byte   $EF                             ; 2527
        ora     $07                             ; 2528
        asl     L0006                           ; 252A
        .byte   $07                             ; 252C
        .byte   $1F                             ; 252D
        ora     $00,x                           ; 252E
        .byte   $0B                             ; 2530
        cpx     $9050                           ; 2531
        bcc     L24DA                           ; 2534
        .byte   $64                             ; 2536
        .byte   $64                             ; 2537
        bpl     L253A                           ; 2538
L253A:  .byte   $0C                             ; 253A
        cpy     #$04                            ; 253B
        .byte   $03                             ; 253D
        brk                                     ; 253E
        brk                                     ; 253F
        brk                                     ; 2540
        brk                                     ; 2541
        brk                                     ; 2542
        brk                                     ; 2543
        brk                                     ; 2544
        brk                                     ; 2545
        brk                                     ; 2546
        brk                                     ; 2547
        brk                                     ; 2548
        bpl     L254B                           ; 2549
L254B:  brk                                     ; 254B
        brk                                     ; 254C
        brk                                     ; 254D
        brk                                     ; 254E
        brk                                     ; 254F
        brk                                     ; 2550
        brk                                     ; 2551
        brk                                     ; 2552
        bpl     L2555                           ; 2553
L2555:  brk                                     ; 2555
        brk                                     ; 2556
        brk                                     ; 2557
        brk                                     ; 2558
        brk                                     ; 2559
        brk                                     ; 255A
        brk                                     ; 255B
        brk                                     ; 255C
        bpl     L255F                           ; 255D
L255F:  brk                                     ; 255F
        brk                                     ; 2560
        brk                                     ; 2561
        brk                                     ; 2562
        brk                                     ; 2563
        brk                                     ; 2564
        brk                                     ; 2565
        brk                                     ; 2566
        bpl     L2569                           ; 2567
L2569:  brk                                     ; 2569
        brk                                     ; 256A
        brk                                     ; 256B
        brk                                     ; 256C
        brk                                     ; 256D
        brk                                     ; 256E
        brk                                     ; 256F
        brk                                     ; 2570
        bpl     L2573                           ; 2571
L2573:  brk                                     ; 2573
        brk                                     ; 2574
        brk                                     ; 2575
        brk                                     ; 2576
        brk                                     ; 2577
        brk                                     ; 2578
        brk                                     ; 2579
        brk                                     ; 257A
        bpl     L257D                           ; 257B
L257D:  brk                                     ; 257D
        brk                                     ; 257E
        brk                                     ; 257F
        brk                                     ; 2580
        brk                                     ; 2581
        brk                                     ; 2582
        brk                                     ; 2583
        brk                                     ; 2584
        bpl     L2587                           ; 2585
L2587:  brk                                     ; 2587
        brk                                     ; 2588
        brk                                     ; 2589
        brk                                     ; 258A
        brk                                     ; 258B
        brk                                     ; 258C
        brk                                     ; 258D
        brk                                     ; 258E
        bpl     L2591                           ; 258F
L2591:  brk                                     ; 2591
        brk                                     ; 2592
        brk                                     ; 2593
        brk                                     ; 2594
        brk                                     ; 2595
        brk                                     ; 2596
        brk                                     ; 2597
        brk                                     ; 2598
        bpl     L259B                           ; 2599
L259B:  brk                                     ; 259B
        brk                                     ; 259C
        brk                                     ; 259D
        brk                                     ; 259E
        brk                                     ; 259F
        brk                                     ; 25A0
        brk                                     ; 25A1
        brk                                     ; 25A2
        bpl     L25A5                           ; 25A3
L25A5:  brk                                     ; 25A5
        brk                                     ; 25A6
        brk                                     ; 25A7
        brk                                     ; 25A8
        brk                                     ; 25A9
        brk                                     ; 25AA
        brk                                     ; 25AB
        brk                                     ; 25AC
        bpl     L25AF                           ; 25AD
L25AF:  brk                                     ; 25AF
        brk                                     ; 25B0
        brk                                     ; 25B1
        brk                                     ; 25B2
        brk                                     ; 25B3
        brk                                     ; 25B4
        brk                                     ; 25B5
        brk                                     ; 25B6
        .byte   $10                             ; 25B7
L25B8:  sta     $20                             ; 25B8
        stx     $21                             ; 25BA
        sty     $22                             ; 25BC
        .byte   $20                             ; 25BE
L25BF:  .byte   $F3                             ; 25BF
L25C0:  and     $A5                             ; 25C0
        jsr     $21A6                           ; 25C2
        ldy     $22                             ; 25C5
        rts                                     ; 25C7

; ----------------------------------------------------------------------------
L25C8:  ldx     #$86                            ; 25C8
        ldy     #$26                            ; 25CA
        bne     L25D2                           ; 25CC
L25CE:  ldx     #$F3                            ; 25CE
        ldy     #$25                            ; 25D0
L25D2:  stx     L25BF                           ; 25D2
        sty     L25C0                           ; 25D5
        rts                                     ; 25D8

; ----------------------------------------------------------------------------
L25D9:  ldy     L265C                           ; 25D9
        beq     L25ED                           ; 25DC
        ldx     #$00                            ; 25DE
L25E0:  lda     L265D,x                         ; 25E0
        jsr     L2686                           ; 25E3
        inx                                     ; 25E6
        dey                                     ; 25E7
        bne     L25E0                           ; 25E8
        sty     L265C                           ; 25EA
L25ED:  lda     $1B                             ; 25ED
        sta     L2685                           ; 25EF
        rts                                     ; 25F2

; ----------------------------------------------------------------------------
L25F3:  ldx     L265C                           ; 25F3
        sta     L265D,x                         ; 25F6
        inc     L265C                           ; 25F9
        cmp     #$8D                            ; 25FC
        beq     L25D9                           ; 25FE
        txa                                     ; 2600
        clc                                     ; 2601
        adc     L2685                           ; 2602
        cmp     $64                             ; 2605
        bcs     L260A                           ; 2607
        rts                                     ; 2609

; ----------------------------------------------------------------------------
L260A:  dec     L265C                           ; 260A
        beq     L261C                           ; 260D
        ldx     L265C                           ; 260F
L2612:  lda     L265D,x                         ; 2612
        cmp     #$A0                            ; 2615
        beq     L2628                           ; 2617
        dex                                     ; 2619
        bpl     L2612                           ; 261A
L261C:  jsr     L25D9                           ; 261C
        lda     $20                             ; 261F
        sta     L265D                           ; 2621
        ldx     #$01                            ; 2624
        bne     L264E                           ; 2626
L2628:  txa                                     ; 2628
        pha                                     ; 2629
        beq     L2638                           ; 262A
        ldy     #$00                            ; 262C
L262E:  lda     L265D,y                         ; 262E
        jsr     L2686                           ; 2631
        iny                                     ; 2634
        dex                                     ; 2635
        bne     L262E                           ; 2636
L2638:  pla                                     ; 2638
        tay                                     ; 2639
        inc     L265C                           ; 263A
        ldx     #$00                            ; 263D
L263F:  iny                                     ; 263F
        cpy     L265C                           ; 2640
        bcs     L264E                           ; 2643
        lda     L265D,y                         ; 2645
        sta     L265D,x                         ; 2648
        inx                                     ; 264B
        bne     L263F                           ; 264C
L264E:  stx     L265C                           ; 264E
        lda     #$8D                            ; 2651
        jsr     L2686                           ; 2653
        lda     $1B                             ; 2656
        sta     L2685                           ; 2658
        rts                                     ; 265B

; ----------------------------------------------------------------------------
L265C:  brk                                     ; 265C
L265D:  brk                                     ; 265D
        brk                                     ; 265E
        brk                                     ; 265F
        brk                                     ; 2660
        brk                                     ; 2661
        brk                                     ; 2662
        brk                                     ; 2663
        brk                                     ; 2664
        brk                                     ; 2665
        brk                                     ; 2666
        brk                                     ; 2667
        brk                                     ; 2668
        brk                                     ; 2669
        brk                                     ; 266A
        brk                                     ; 266B
        brk                                     ; 266C
        brk                                     ; 266D
        brk                                     ; 266E
        brk                                     ; 266F
        brk                                     ; 2670
        brk                                     ; 2671
        brk                                     ; 2672
        brk                                     ; 2673
        brk                                     ; 2674
        brk                                     ; 2675
        brk                                     ; 2676
        brk                                     ; 2677
        brk                                     ; 2678
        brk                                     ; 2679
        brk                                     ; 267A
        brk                                     ; 267B
        brk                                     ; 267C
        brk                                     ; 267D
        brk                                     ; 267E
        brk                                     ; 267F
        brk                                     ; 2680
        brk                                     ; 2681
        brk                                     ; 2682
        brk                                     ; 2683
        brk                                     ; 2684
L2685:  brk                                     ; 2685
L2686:  sta     $23                             ; 2686
        stx     $24                             ; 2688
        sty     $25                             ; 268A
        cmp     #$8D                            ; 268C
        bne     L26A7                           ; 268E
        lda     $62                             ; 2690
        sta     $1B                             ; 2692
        lda     $1D                             ; 2694
        clc                                     ; 2696
        adc     #$08                            ; 2697
        cmp     $65                             ; 2699
        bcc     L26A2                           ; 269B
        jsr     L2769                           ; 269D
        lda     $1D                             ; 26A0
L26A2:  sta     $1D                             ; 26A2
        jmp     L26FD                           ; 26A4

; ----------------------------------------------------------------------------
L26A7:  sta     $E8                             ; 26A7
        asl     a                               ; 26A9
        asl     a                               ; 26AA
        rol     L26DF                           ; 26AB
        asl     a                               ; 26AE
        rol     L26DF                           ; 26AF
        sta     L26DE                           ; 26B2
        lda     L26DF                           ; 26B5
        and     #$03                            ; 26B8
        adc     #$0C                            ; 26BA
        sta     L26DF                           ; 26BC
        cmp     #$0D                            ; 26BF
        php                                     ; 26C1
        ldy     $1D                             ; 26C2
        ldx     $1B                             ; 26C4
        jsr     L0160                           ; 26C6
        sty     L26E3                           ; 26C9
        sta     L26E4                           ; 26CC
        plp                                     ; 26CF
        ldx     $E8                             ; 26D0
        bcc     L26D7                           ; 26D2
L26D4:  jmp     L0500                           ; 26D4

; ----------------------------------------------------------------------------
L26D7:  cpx     #$88                            ; 26D7
        bcc     L26D4                           ; 26D9
        ldx     #$07                            ; 26DB
L26DD:  .byte   $BD                             ; 26DD
L26DE:  brk                                     ; 26DE
L26DF:  .byte   $0C                             ; 26DF
        .byte   $49                             ; 26E0
L26E1:  brk                                     ; 26E1
        .byte   $9D                             ; 26E2
L26E3:  .byte   $FF                             ; 26E3
L26E4:  .byte   $FF                             ; 26E4
        dex                                     ; 26E5
        bpl     L26DD                           ; 26E6
        .byte   $A2                             ; 26E8
L26E9:  ora     ($2C),y                         ; 26E9
L26EB:  ldx     #$01                            ; 26EB
        lda     $1D                             ; 26ED
        jsr     L3EED                           ; 26EF
        ldy     $1B                             ; 26F2
        .byte   $A9                             ; 26F4
L26F5:  .byte   $72                             ; 26F5
        sta     ($DD),y                         ; 26F6
        txa                                     ; 26F8
        sta     ($DB),y                         ; 26F9
        inc     $1B                             ; 26FB
L26FD:  lda     $23                             ; 26FD
        ldx     $24                             ; 26FF
        ldy     $25                             ; 2701
        rts                                     ; 2703

; ----------------------------------------------------------------------------
L2704:  ldx     $63                             ; 2704
L2706:  txa                                     ; 2706
        pha                                     ; 2707
        tay                                     ; 2708
        ldx     $62                             ; 2709
        jsr     L0160                           ; 270B
        sty     L0006                           ; 270E
        sta     $07                             ; 2710
        nop                                     ; 2712
        nop                                     ; 2713
        nop                                     ; 2714
        nop                                     ; 2715
        nop                                     ; 2716
        nop                                     ; 2717
        nop                                     ; 2718
        nop                                     ; 2719
        nop                                     ; 271A
        ldx     $62                             ; 271B
        ldy     #$00                            ; 271D
L271F:  lda     #$AA                            ; 271F
        sta     (L0006),y                       ; 2721
        iny                                     ; 2723
        tya                                     ; 2724
        and     #$07                            ; 2725
        bne     L271F                           ; 2727
        tya                                     ; 2729
        bne     L272E                           ; 272A
        inc     $07                             ; 272C
L272E:  inx                                     ; 272E
        cpx     $64                             ; 272F
        bcc     L271F                           ; 2731
        pla                                     ; 2733
        pha                                     ; 2734
        jsr     L3EED                           ; 2735
        ldy     $62                             ; 2738
        nop                                     ; 273A
        nop                                     ; 273B
        nop                                     ; 273C
        nop                                     ; 273D
L273E:  lda     #$11                            ; 273E
        sta     ($DB),y                         ; 2740
        lda     #$72                            ; 2742
        sta     ($DD),y                         ; 2744
        iny                                     ; 2746
        cpy     $64                             ; 2747
        bcc     L273E                           ; 2749
        nop                                     ; 274B
        nop                                     ; 274C
        nop                                     ; 274D
        nop                                     ; 274E
        pla                                     ; 274F
        clc                                     ; 2750
        adc     #$08                            ; 2751
        tax                                     ; 2753
        cpx     $65                             ; 2754
        bcc     L2706                           ; 2756
        lda     $62                             ; 2758
        sta     $1B                             ; 275A
        sta     L2685                           ; 275C
        lda     $63                             ; 275F
        sta     $1D                             ; 2761
        lda     #$00                            ; 2763
        sta     L265C                           ; 2765
        rts                                     ; 2768

; ----------------------------------------------------------------------------
L2769:  lda     #$B1                            ; 2769
        sta     L27B5                           ; 276B
        lda     #$09                            ; 276E
        sta     L27B6                           ; 2770
        lda     $65                             ; 2773
        sec                                     ; 2775
        sbc     #$08                            ; 2776
        sta     $08                             ; 2778
        ldx     $63                             ; 277A
L277C:  txa                                     ; 277C
        pha                                     ; 277D
        tay                                     ; 277E
        ldx     $62                             ; 277F
        jsr     L0160                           ; 2781
        sty     L0006                           ; 2784
        sta     $07                             ; 2786
        pla                                     ; 2788
        pha                                     ; 2789
        tax                                     ; 278A
        tay                                     ; 278B
        nop                                     ; 278C
        nop                                     ; 278D
        nop                                     ; 278E
        nop                                     ; 278F
        nop                                     ; 2790
        cpx     $08                             ; 2791
        bcc     L27A1                           ; 2793
        lda     #$A9                            ; 2795
        sta     L27B5                           ; 2797
        lda     #$FF                            ; 279A
        sta     L27B6                           ; 279C
        bne     L27B1                           ; 279F
L27A1:  clc                                     ; 27A1
        tya                                     ; 27A2
        adc     #$08                            ; 27A3
        tay                                     ; 27A5
        ldx     $62                             ; 27A6
        jsr     L0160                           ; 27A8
        sty     $09                             ; 27AB
        sta     $0A                             ; 27AD
        nop                                     ; 27AF
        nop                                     ; 27B0
L27B1:  ldx     $62                             ; 27B1
        ldy     #$00                            ; 27B3
L27B5:  .byte   $B1                             ; 27B5
L27B6:  ora     #$91                            ; 27B6
        asl     $C8                             ; 27B8
        tya                                     ; 27BA
        and     #$07                            ; 27BB
        bne     L27B5                           ; 27BD
        tya                                     ; 27BF
        bne     L27C6                           ; 27C0
        inc     $0A                             ; 27C2
        inc     $07                             ; 27C4
L27C6:  inx                                     ; 27C6
        cpx     $64                             ; 27C7
        bcc     L27B5                           ; 27C9
        pla                                     ; 27CB
        clc                                     ; 27CC
        adc     #$08                            ; 27CD
        tax                                     ; 27CF
        cpx     $65                             ; 27D0
        bcc     L277C                           ; 27D2
        rts                                     ; 27D4

; ----------------------------------------------------------------------------
L27D5:  .byte   $A9                             ; 27D5
L27D6:  brk                                     ; 27D6
L27D7:  pha                                     ; 27D7
        lsr     a                               ; 27D8
        lsr     a                               ; 27D9
        lsr     a                               ; 27DA
        lsr     a                               ; 27DB
        tax                                     ; 27DC
        lda     L27ED,x                         ; 27DD
        jsr     L0199                           ; 27E0
        .byte   $A9                             ; 27E3
L27E4:  brk                                     ; 27E4
        sta     L27D6                           ; 27E5
        pla                                     ; 27E8
        sta     L27E4                           ; 27E9
        rts                                     ; 27EC

; ----------------------------------------------------------------------------
L27ED:  .byte   $FF                             ; 27ED
        brk                                     ; 27EE
L27EF:  lda     $F557                           ; 27EF
        ldx     #$68                            ; 27F2
        ldy     #$28                            ; 27F4
        bne     L27FF                           ; 27F6
L27F8:  ldx     #$7D                            ; 27F8
        ldy     #$28                            ; 27FA
        lda     $F502                           ; 27FC
L27FF:  stx     L2844                           ; 27FF
        sty     L2845                           ; 2802
        asl     a                               ; 2805
        cmp     #$50                            ; 2806
        bcs     L2867                           ; 2808
        tay                                     ; 280A
        lda     $F600,y                         ; 280B
        pha                                     ; 280E
        and     #$07                            ; 280F
        tax                                     ; 2811
        lda     L1D90,x                         ; 2812
        eor     #$FF                            ; 2815
        sta     $0C                             ; 2817
        lda     $F601,y                         ; 2819
        sta     $07                             ; 281C
        pla                                     ; 281E
        lsr     $07                             ; 281F
        ror     a                               ; 2821
        lsr     $07                             ; 2822
        ror     a                               ; 2824
        lsr     $07                             ; 2825
        ror     a                               ; 2827
L2828:  clc                                     ; 2828
        .byte   $69                             ; 2829
L282A:  bvc     L27B1                           ; 282A
        asl     $A5                             ; 282C
        .byte   $07                             ; 282E
        adc     #$F6                            ; 282F
        sta     $07                             ; 2831
        lda     #$00                            ; 2833
        sta     $09                             ; 2835
        sta     $0A                             ; 2837
L2839:  ldx     $09                             ; 2839
        ldy     $0A                             ; 283B
        jsr     L318A                           ; 283D
        dey                                     ; 2840
        ldx     #$00                            ; 2841
        .byte   $20                             ; 2843
L2844:  .byte   $7D                             ; 2844
L2845:  plp                                     ; 2845
        sec                                     ; 2846
        ror     $0C                             ; 2847
        bcs     L2853                           ; 2849
        lsr     $0C                             ; 284B
        inc     L0006                           ; 284D
        bne     L2853                           ; 284F
        inc     $07                             ; 2851
L2853:  inc     $09                             ; 2853
        lda     $09                             ; 2855
        cmp     $F521                           ; 2857
        bcc     L2839                           ; 285A
        stx     $09                             ; 285C
        inc     $0A                             ; 285E
        lda     $0A                             ; 2860
        cmp     $F522                           ; 2862
        bcc     L2839                           ; 2865
L2867:  rts                                     ; 2867

; ----------------------------------------------------------------------------
        lda     ($9B),y                         ; 2868
        and     #$08                            ; 286A
        beq     L2872                           ; 286C
        lda     $0C                             ; 286E
        eor     #$FF                            ; 2870
L2872:  sta     $0D                             ; 2872
        lda     $0C                             ; 2874
        and     (L0006,x)                       ; 2876
        ora     $0D                             ; 2878
        sta     (L0006,x)                       ; 287A
        rts                                     ; 287C

; ----------------------------------------------------------------------------
        lda     $0C                             ; 287D
        eor     #$FF                            ; 287F
        and     (L0006,x)                       ; 2881
        beq     L2887                           ; 2883
        lda     #$08                            ; 2885
L2887:  sta     $0D                             ; 2887
        lda     #$F7                            ; 2889
        and     ($9B),y                         ; 288B
        ora     $0D                             ; 288D
        sta     ($9B),y                         ; 288F
        rts                                     ; 2891

; ----------------------------------------------------------------------------
L2892:  brk                                     ; 2892
        brk                                     ; 2893
        brk                                     ; 2894
L2895:  brk                                     ; 2895
        brk                                     ; 2896
        brk                                     ; 2897
        brk                                     ; 2898
        brk                                     ; 2899
        brk                                     ; 289A
        brk                                     ; 289B
        brk                                     ; 289C
        brk                                     ; 289D
        brk                                     ; 289E
        brk                                     ; 289F
        brk                                     ; 28A0
        brk                                     ; 28A1
        brk                                     ; 28A2
L28A3:  brk                                     ; 28A3
        brk                                     ; 28A4
        brk                                     ; 28A5
L28A6:  brk                                     ; 28A6
        brk                                     ; 28A7
        brk                                     ; 28A8
        brk                                     ; 28A9
        brk                                     ; 28AA
        brk                                     ; 28AB
        brk                                     ; 28AC
        brk                                     ; 28AD
        brk                                     ; 28AE
        brk                                     ; 28AF
        brk                                     ; 28B0
        brk                                     ; 28B1
        brk                                     ; 28B2
        brk                                     ; 28B3
L28B4:  brk                                     ; 28B4
        brk                                     ; 28B5
        brk                                     ; 28B6
L28B7:  brk                                     ; 28B7
        brk                                     ; 28B8
        brk                                     ; 28B9
        brk                                     ; 28BA
        brk                                     ; 28BB
        brk                                     ; 28BC
        brk                                     ; 28BD
        brk                                     ; 28BE
        brk                                     ; 28BF
        brk                                     ; 28C0
        brk                                     ; 28C1
        brk                                     ; 28C2
        brk                                     ; 28C3
        brk                                     ; 28C4
L28C5:  brk                                     ; 28C5
        brk                                     ; 28C6
        brk                                     ; 28C7
L28C8:  brk                                     ; 28C8
        brk                                     ; 28C9
        brk                                     ; 28CA
        brk                                     ; 28CB
        brk                                     ; 28CC
        brk                                     ; 28CD
        brk                                     ; 28CE
        brk                                     ; 28CF
        brk                                     ; 28D0
        brk                                     ; 28D1
        brk                                     ; 28D2
        brk                                     ; 28D3
        brk                                     ; 28D4
        brk                                     ; 28D5
L28D6:  jsr     L28DC                           ; 28D6
        jmp     L3B60                           ; 28D9

; ----------------------------------------------------------------------------
L28DC:  lda     #$FC                            ; 28DC
        sta     L0818                           ; 28DE
        lda     #$FB                            ; 28E1
        sta     L082B                           ; 28E3
        lda     #$0B                            ; 28E6
L28E8:  sta     L096C                           ; 28E8
        lda     #$0C                            ; 28EB
        sta     L097F                           ; 28ED
        ldx     #$07                            ; 28F0
L28F2:  lda     L2902,x                         ; 28F2
        sta     $5760,x                         ; 28F5
        lda     L290A,x                         ; 28F8
        sta     $57F8,x                         ; 28FB
        dex                                     ; 28FE
        bpl     L28F2                           ; 28FF
        rts                                     ; 2901

; ----------------------------------------------------------------------------
L2902:  eor     $A9,x                           ; 2902
        lda     #$B9                            ; 2904
        lda     $FDE9,y                         ; 2906
        .byte   $03                             ; 2909
L290A:  eor     $BF,x                           ; 290A
        .byte   $BF                             ; 290C
        .byte   $BB                             ; 290D
        ldx     $AABB,y                         ; 290E
        brk                                     ; 2911
L2912:  lda     ($0C),y                         ; 2912
        bne     L291F                           ; 2914
        iny                                     ; 2916
        lda     ($0C),y                         ; 2917
        .byte   $D0                             ; 2919
L291A:  .byte   $01                             ; 291A
L291B:  rts                                     ; 291B

; ----------------------------------------------------------------------------
        dey                                     ; 291C
        lda     ($0C),y                         ; 291D
L291F:  clc                                     ; 291F
        adc     $0C                             ; 2920
        tax                                     ; 2922
        iny                                     ; 2923
        lda     ($0C),y                         ; 2924
        adc     $0D                             ; 2926
        stx     $0C                             ; 2928
        sta     $0D                             ; 292A
L292C:  ldy     #$00                            ; 292C
        lda     ($0C),y                         ; 292E
        sta     $38                             ; 2930
        asl     a                               ; 2932
        sta     L2ACA                           ; 2933
        asl     a                               ; 2936
        asl     a                               ; 2937
        clc                                     ; 2938
        adc     L2ACA                           ; 2939
        sta     L2ACA                           ; 293C
        iny                                     ; 293F
        lda     ($0C),y                         ; 2940
        sta     $1A                             ; 2942
        iny                                     ; 2944
        clc                                     ; 2945
        lda     ($0C),y                         ; 2946
        bit     $16                             ; 2948
        bpl     L294F                           ; 294A
        eor     #$FF                            ; 294C
        sec                                     ; 294E
L294F:  adc     $0E                             ; 294F
        sta     $0E                             ; 2951
        iny                                     ; 2953
        clc                                     ; 2954
        lda     ($0C),y                         ; 2955
        adc     L0010                           ; 2957
        sta     L0010                           ; 2959
        bit     $16                             ; 295B
        bmi     L2965                           ; 295D
        bit     $0E                             ; 295F
        bpl     L298B                           ; 2961
        bmi     L2968                           ; 2963
L2965:  jmp     L2AFD                           ; 2965

; ----------------------------------------------------------------------------
L2968:  sec                                     ; 2968
        lda     #$00                            ; 2969
        tax                                     ; 296B
        sbc     $0E                             ; 296C
        sta     $17                             ; 296E
        lda     $38                             ; 2970
        sec                                     ; 2972
        sbc     $17                             ; 2973
        sta     $18                             ; 2975
        beq     L291B                           ; 2977
        bmi     L291B                           ; 2979
        stx     $0E                             ; 297B
        lda     $17                             ; 297D
        asl     a                               ; 297F
        sta     $17                             ; 2980
        asl     a                               ; 2982
        asl     a                               ; 2983
        clc                                     ; 2984
        adc     $17                             ; 2985
        adc     #$04                            ; 2987
        bne     L29A6                           ; 2989
L298B:  lda     $38                             ; 298B
        sta     $18                             ; 298D
        clc                                     ; 298F
        adc     $0E                             ; 2990
        sec                                     ; 2992
        sbc     $36                             ; 2993
        bcc     L29A4                           ; 2995
        sta     $17                             ; 2997
        lda     $38                             ; 2999
        sbc     $17                             ; 299B
        sta     $18                             ; 299D
        beq     L29A3                           ; 299F
        bpl     L29A4                           ; 29A1
L29A3:  rts                                     ; 29A3

; ----------------------------------------------------------------------------
L29A4:  lda     #$04                            ; 29A4
L29A6:  clc                                     ; 29A6
        adc     $0C                             ; 29A7
        sta     $0C                             ; 29A9
        bcc     L29AF                           ; 29AB
        inc     $0D                             ; 29AD
L29AF:  ldy     L0010                           ; 29AF
        ldx     $0E                             ; 29B1
        stx     $0B                             ; 29B3
        jsr     L0181                           ; 29B5
        rol     $FF                             ; 29B8
        adc     L2892,y                         ; 29BA
        sta     L0006                           ; 29BD
        lda     L28A3,y                         ; 29BF
        adc     $FF                             ; 29C2
        sta     $07                             ; 29C4
        clc                                     ; 29C6
        lda     #$D8                            ; 29C7
        adc     L28B4,y                         ; 29C9
        sta     $DB                             ; 29CC
        lda     #$06                            ; 29CE
        adc     L28C5,y                         ; 29D0
        sta     $DC                             ; 29D3
        clc                                     ; 29D5
        lda     #$2C                            ; 29D6
        adc     L28B4,y                         ; 29D8
        sta     $DD                             ; 29DB
        lda     #$08                            ; 29DD
        adc     L28C5,y                         ; 29DF
        sta     $DE                             ; 29E2
        lda     $18                             ; 29E4
        sta     $19                             ; 29E6
        lda     $0C                             ; 29E8
        sta     $09                             ; 29EA
        lda     $0D                             ; 29EC
        sta     $0A                             ; 29EE
L29F0:  ldy     #$09                            ; 29F0
        lda     ($09),y                         ; 29F2
        beq     L2A15                           ; 29F4
        sta     $E5                             ; 29F6
        dey                                     ; 29F8
        lda     ($09),y                         ; 29F9
        sta     $E4                             ; 29FB
        dey                                     ; 29FD
        lda     $E5                             ; 29FE
        and     #$10                            ; 2A00
        beq     L2A18                           ; 2A02
L2A04:  lda     ($09),y                         ; 2A04
        sta     (L0006),y                       ; 2A06
        dey                                     ; 2A08
        bpl     L2A04                           ; 2A09
        ldy     $0B                             ; 2A0B
        lda     $E4                             ; 2A0D
        sta     ($DB),y                         ; 2A0F
        lda     $E5                             ; 2A11
        sta     ($DD),y                         ; 2A13
L2A15:  jmp     L2A95                           ; 2A15

; ----------------------------------------------------------------------------
L2A18:  ldy     $0B                             ; 2A18
        lda     ($DB),y                         ; 2A1A
        and     #$0F                            ; 2A1C
        sta     $83                             ; 2A1E
        lda     ($DB),y                         ; 2A20
        lsr     a                               ; 2A22
        lsr     a                               ; 2A23
        lsr     a                               ; 2A24
        lsr     a                               ; 2A25
        sta     $82                             ; 2A26
        lda     ($DD),y                         ; 2A28
L2A2A:  and     #$0F                            ; 2A2A
        sta     $84                             ; 2A2C
        bit     $E5                             ; 2A2E
        bpl     L2A3D                           ; 2A30
        lda     $E4                             ; 2A32
        lsr     a                               ; 2A34
        lsr     a                               ; 2A35
        lsr     a                               ; 2A36
        lsr     a                               ; 2A37
        ldx     #$00                            ; 2A38
        jsr     L2ACB                           ; 2A3A
L2A3D:  bit     $E5                             ; 2A3D
        bvc     L2A48                           ; 2A3F
        lda     $E4                             ; 2A41
        ldx     #$01                            ; 2A43
        jsr     L2ACB                           ; 2A45
L2A48:  lda     $E5                             ; 2A48
        and     #$20                            ; 2A4A
        beq     L2A55                           ; 2A4C
        lda     $E5                             ; 2A4E
        ldx     #$02                            ; 2A50
        jsr     L2ACB                           ; 2A52
L2A55:  ldy     $0B                             ; 2A55
        lda     $82                             ; 2A57
        asl     a                               ; 2A59
        asl     a                               ; 2A5A
        asl     a                               ; 2A5B
        asl     a                               ; 2A5C
        ora     $83                             ; 2A5D
        sta     ($DB),y                         ; 2A5F
        lda     $84                             ; 2A61
        sta     ($DD),y                         ; 2A63
        ldy     #$07                            ; 2A65
L2A67:  lda     ($09),y                         ; 2A67
        beq     L2A92                           ; 2A69
        ldx     #$03                            ; 2A6B
L2A6D:  lda     ($09),y                         ; 2A6D
        and     L2AF9,x                         ; 2A6F
        beq     L2A8F                           ; 2A72
        stx     $08                             ; 2A74
        cmp     #$04                            ; 2A76
        bcc     L2A80                           ; 2A78
L2A7A:  lsr     a                               ; 2A7A
        lsr     a                               ; 2A7B
        cmp     #$04                            ; 2A7C
        bcs     L2A7A                           ; 2A7E
L2A80:  tax                                     ; 2A80
        lda     L2AF2,x                         ; 2A81
        eor     (L0006),y                       ; 2A84
        ldx     $08                             ; 2A86
        and     L2AF9,x                         ; 2A88
        eor     (L0006),y                       ; 2A8B
        sta     (L0006),y                       ; 2A8D
L2A8F:  dex                                     ; 2A8F
        bpl     L2A6D                           ; 2A90
L2A92:  dey                                     ; 2A92
        bpl     L2A67                           ; 2A93
L2A95:  inc     $0B                             ; 2A95
        clc                                     ; 2A97
        lda     L0006                           ; 2A98
        adc     #$08                            ; 2A9A
        sta     L0006                           ; 2A9C
        bcc     L2AA2                           ; 2A9E
        inc     $07                             ; 2AA0
L2AA2:  clc                                     ; 2AA2
        lda     $09                             ; 2AA3
        adc     #$0A                            ; 2AA5
        sta     $09                             ; 2AA7
        bcc     L2AAD                           ; 2AA9
        inc     $0A                             ; 2AAB
L2AAD:  dec     $19                             ; 2AAD
        beq     L2AB4                           ; 2AAF
        jmp     L29F0                           ; 2AB1

; ----------------------------------------------------------------------------
L2AB4:  inc     L0010                           ; 2AB4
        clc                                     ; 2AB6
        lda     L2ACA                           ; 2AB7
        adc     $0C                             ; 2ABA
        sta     $0C                             ; 2ABC
        bcc     L2AC2                           ; 2ABE
        inc     $0D                             ; 2AC0
L2AC2:  dec     $1A                             ; 2AC2
        beq     L2AC9                           ; 2AC4
        jmp     L29AF                           ; 2AC6

; ----------------------------------------------------------------------------
L2AC9:  rts                                     ; 2AC9

; ----------------------------------------------------------------------------
L2ACA:  brk                                     ; 2ACA
L2ACB:  and     #$0F                            ; 2ACB
        beq     L2AEF                           ; 2ACD
        stx     $E7                             ; 2ACF
        ldx     #$02                            ; 2AD1
L2AD3:  cmp     $82,x                           ; 2AD3
        beq     L2AEA                           ; 2AD5
        dex                                     ; 2AD7
        bpl     L2AD3                           ; 2AD8
        inx                                     ; 2ADA
        sta     $E6                             ; 2ADB
L2ADD:  lda     $82,x                           ; 2ADD
        beq     L2AE6                           ; 2ADF
        inx                                     ; 2AE1
        cpx     #$02                            ; 2AE2
        bcc     L2ADD                           ; 2AE4
L2AE6:  lda     $E6                             ; 2AE6
        sta     $82,x                           ; 2AE8
L2AEA:  lda     L2AF6,x                         ; 2AEA
        ldx     $E7                             ; 2AED
L2AEF:  sta     L2AF3,x                         ; 2AEF
L2AF2:  rts                                     ; 2AF2

; ----------------------------------------------------------------------------
L2AF3:  brk                                     ; 2AF3
        brk                                     ; 2AF4
        brk                                     ; 2AF5
L2AF6:  eor     L00AA,x                         ; 2AF6
        .byte   $FF                             ; 2AF8
L2AF9:  cpy     #$30                            ; 2AF9
        .byte   $0C                             ; 2AFB
        .byte   $03                             ; 2AFC
L2AFD:  lda     $38                             ; 2AFD
        sta     $18                             ; 2AFF
        clc                                     ; 2B01
        adc     $0E                             ; 2B02
        sec                                     ; 2B04
        sbc     $36                             ; 2B05
        bcc     L2B15                           ; 2B07
        sta     $17                             ; 2B09
        lda     $38                             ; 2B0B
        sbc     $17                             ; 2B0D
        sta     $18                             ; 2B0F
        beq     L2AC9                           ; 2B11
        bmi     L2AC9                           ; 2B13
L2B15:  lda     #$04                            ; 2B15
        clc                                     ; 2B17
        adc     $0C                             ; 2B18
        sta     $0C                             ; 2B1A
        bcc     L2B20                           ; 2B1C
        inc     $0D                             ; 2B1E
L2B20:  ldy     L0010                           ; 2B20
        ldx     $0E                             ; 2B22
        stx     $0B                             ; 2B24
        jsr     L0181                           ; 2B26
        rol     $FF                             ; 2B29
        adc     L2892,y                         ; 2B2B
        sta     L0006                           ; 2B2E
        lda     L28A3,y                         ; 2B30
        adc     $FF                             ; 2B33
        sta     $07                             ; 2B35
        clc                                     ; 2B37
        lda     #$D8                            ; 2B38
        adc     L28B4,y                         ; 2B3A
        sta     $DB                             ; 2B3D
        lda     #$06                            ; 2B3F
        adc     L28C5,y                         ; 2B41
        sta     $DC                             ; 2B44
        clc                                     ; 2B46
        lda     #$2C                            ; 2B47
        adc     L28B4,y                         ; 2B49
        sta     $DD                             ; 2B4C
        lda     #$08                            ; 2B4E
        adc     L28C5,y                         ; 2B50
        sta     $DE                             ; 2B53
        lda     $18                             ; 2B55
        sta     $19                             ; 2B57
        sec                                     ; 2B59
        sbc     #$01                            ; 2B5A
        asl     a                               ; 2B5C
        sta     $17                             ; 2B5D
        asl     a                               ; 2B5F
        asl     a                               ; 2B60
        clc                                     ; 2B61
        adc     $17                             ; 2B62
        clc                                     ; 2B64
        adc     $0C                             ; 2B65
        sta     $09                             ; 2B67
        lda     $0D                             ; 2B69
        adc     #$00                            ; 2B6B
        sta     $0A                             ; 2B6D
L2B6F:  ldy     #$09                            ; 2B6F
        lda     ($09),y                         ; 2B71
        beq     L2B98                           ; 2B73
        sta     $E5                             ; 2B75
        dey                                     ; 2B77
        lda     ($09),y                         ; 2B78
        sta     $E4                             ; 2B7A
        dey                                     ; 2B7C
        lda     $E5                             ; 2B7D
        and     #$10                            ; 2B7F
        beq     L2B9B                           ; 2B81
L2B83:  lda     ($09),y                         ; 2B83
        tax                                     ; 2B85
        lda     L0B00,x                         ; 2B86
        sta     (L0006),y                       ; 2B89
        dey                                     ; 2B8B
        bpl     L2B83                           ; 2B8C
        ldy     $0B                             ; 2B8E
        lda     $E4                             ; 2B90
        sta     ($DB),y                         ; 2B92
        lda     $E5                             ; 2B94
        sta     ($DD),y                         ; 2B96
L2B98:  jmp     L2C1E                           ; 2B98

; ----------------------------------------------------------------------------
L2B9B:  ldy     $0B                             ; 2B9B
        lda     ($DB),y                         ; 2B9D
        and     #$0F                            ; 2B9F
        sta     $83                             ; 2BA1
        lda     ($DB),y                         ; 2BA3
        lsr     a                               ; 2BA5
        lsr     a                               ; 2BA6
        lsr     a                               ; 2BA7
        lsr     a                               ; 2BA8
        sta     $82                             ; 2BA9
        lda     ($DD),y                         ; 2BAB
        and     #$0F                            ; 2BAD
        sta     $84                             ; 2BAF
        bit     $E5                             ; 2BB1
        bpl     L2BC0                           ; 2BB3
        lda     $E4                             ; 2BB5
        lsr     a                               ; 2BB7
        lsr     a                               ; 2BB8
        lsr     a                               ; 2BB9
        lsr     a                               ; 2BBA
        ldx     #$00                            ; 2BBB
        jsr     L2ACB                           ; 2BBD
L2BC0:  bit     $E5                             ; 2BC0
        bvc     L2BCB                           ; 2BC2
        lda     $E4                             ; 2BC4
        ldx     #$01                            ; 2BC6
        jsr     L2ACB                           ; 2BC8
L2BCB:  lda     $E5                             ; 2BCB
        and     #$20                            ; 2BCD
        beq     L2BD8                           ; 2BCF
        lda     $E5                             ; 2BD1
        ldx     #$02                            ; 2BD3
        jsr     L2ACB                           ; 2BD5
L2BD8:  ldy     $0B                             ; 2BD8
        lda     $82                             ; 2BDA
        asl     a                               ; 2BDC
        asl     a                               ; 2BDD
        asl     a                               ; 2BDE
        asl     a                               ; 2BDF
        ora     $83                             ; 2BE0
        sta     ($DB),y                         ; 2BE2
        lda     $84                             ; 2BE4
        sta     ($DD),y                         ; 2BE6
        ldy     #$07                            ; 2BE8
L2BEA:  lda     ($09),y                         ; 2BEA
        beq     L2C1B                           ; 2BEC
        tax                                     ; 2BEE
        lda     L0B00,x                         ; 2BEF
        sta     $82                             ; 2BF2
        ldx     #$03                            ; 2BF4
L2BF6:  lda     $82                             ; 2BF6
        and     L2AF9,x                         ; 2BF8
        beq     L2C18                           ; 2BFB
        stx     $08                             ; 2BFD
        cmp     #$04                            ; 2BFF
        bcc     L2C09                           ; 2C01
L2C03:  lsr     a                               ; 2C03
        lsr     a                               ; 2C04
        cmp     #$04                            ; 2C05
        bcs     L2C03                           ; 2C07
L2C09:  tax                                     ; 2C09
        lda     L2AF2,x                         ; 2C0A
        eor     (L0006),y                       ; 2C0D
        ldx     $08                             ; 2C0F
        and     L2AF9,x                         ; 2C11
        eor     (L0006),y                       ; 2C14
        sta     (L0006),y                       ; 2C16
L2C18:  dex                                     ; 2C18
        bpl     L2BF6                           ; 2C19
L2C1B:  dey                                     ; 2C1B
        bpl     L2BEA                           ; 2C1C
L2C1E:  inc     $0B                             ; 2C1E
        clc                                     ; 2C20
        lda     L0006                           ; 2C21
        adc     #$08                            ; 2C23
        sta     L0006                           ; 2C25
        bcc     L2C2B                           ; 2C27
        inc     $07                             ; 2C29
L2C2B:  sec                                     ; 2C2B
        lda     $09                             ; 2C2C
        sbc     #$0A                            ; 2C2E
        sta     $09                             ; 2C30
        bcs     L2C36                           ; 2C32
        dec     $0A                             ; 2C34
L2C36:  dec     $19                             ; 2C36
        beq     L2C3D                           ; 2C38
        jmp     L2B6F                           ; 2C3A

; ----------------------------------------------------------------------------
L2C3D:  inc     L0010                           ; 2C3D
        clc                                     ; 2C3F
        lda     L2ACA                           ; 2C40
        adc     $0C                             ; 2C43
        sta     $0C                             ; 2C45
        bcc     L2C4B                           ; 2C47
        inc     $0D                             ; 2C49
L2C4B:  dec     $1A                             ; 2C4B
        beq     L2C52                           ; 2C4D
        jmp     L2B20                           ; 2C4F

; ----------------------------------------------------------------------------
L2C52:  rts                                     ; 2C52

; ----------------------------------------------------------------------------
L2C53:  ldx     #$DB                            ; 2C53
        ldy     #$2C                            ; 2C55
        jsr     L3BFA                           ; 2C57
        lda     $F500                           ; 2C5A
        sta     L2E9A                           ; 2C5D
        lda     $F501                           ; 2C60
        sta     L2E9B                           ; 2C63
        jsr     L2CE2                           ; 2C66
        jsr     L34EA                           ; 2C69
L2C6C:  jsr     L2D32                           ; 2C6C
L2C6F:  ldx     #$7D                            ; 2C6F
        ldy     #$2C                            ; 2C71
        jsr     L45C7                           ; 2C73
L2C76:  stx     L0006                           ; 2C76
        sty     $07                             ; 2C78
        jmp     (L0006)                         ; 2C7A

; ----------------------------------------------------------------------------
        .byte   $80                             ; 2C7D
        .byte   $80                             ; 2C7E
        .byte   $9B                             ; 2C7F
        lda     ($2C,x)                         ; 2C80
        dey                                     ; 2C82
        lda     $CA2C                           ; 2C83
        lda     $952C                           ; 2C86
        lda     $CC2C,y                         ; 2C89
        lda     $8A2C,y                         ; 2C8C
        cpy     $2C                             ; 2C8F
        .byte   $DA                             ; 2C91
        cpy     $2C                             ; 2C92
        .byte   $CB                             ; 2C94
        cpy     $2C                             ; 2C95
        .byte   $8B                             ; 2C97
        bne     L2CC6                           ; 2C98
        cmp     ($D0,x)                         ; 2C9A
        bit     $D0C9                           ; 2C9C
        bit     L20FF                           ; 2C9F
        .byte   $DF                             ; 2CA2
        bit     $5120                           ; 2CA3
        .byte   $3F                             ; 2CA6
        jsr     L34B5                           ; 2CA7
        jmp     L3C97                           ; 2CAA

; ----------------------------------------------------------------------------
        ldx     L2E9B                           ; 2CAD
        dex                                     ; 2CB0
        bmi     L2C6F                           ; 2CB1
L2CB3:  stx     L2E9B                           ; 2CB3
        jmp     L2C6C                           ; 2CB6

; ----------------------------------------------------------------------------
        ldx     L2E9B                           ; 2CB9
        inx                                     ; 2CBC
        cpx     $F521                           ; 2CBD
        bcc     L2CB3                           ; 2CC0
        bcs     L2C6F                           ; 2CC2
        .byte   $AC                             ; 2CC4
        txs                                     ; 2CC5
L2CC6:  rol     L3088                           ; 2CC6
        lda     $8C                             ; 2CC9
        txs                                     ; 2CCB
        rol     $6C4C                           ; 2CCC
        bit     $9AAC                           ; 2CCF
        rol     $CCC8                           ; 2CD2
        .byte   $22                             ; 2CD5
        sbc     $90,x                           ; 2CD6
        sbc     ($B0),y                         ; 2CD8
        sty     $01,x                           ; 2CDA
        brk                                     ; 2CDC
        .byte   $27                             ; 2CDD
        cpy     #$A9                            ; 2CDE
        .byte   $14                             ; 2CE0
        .byte   $2C                             ; 2CE1
L2CE2:  lda     #$24                            ; 2CE2
        sta     $36                             ; 2CE4
        asl     a                               ; 2CE6
        asl     a                               ; 2CE7
        asl     a                               ; 2CE8
        sta     $34                             ; 2CE9
        ldx     #$00                            ; 2CEB
        bcc     L2CF0                           ; 2CED
        inx                                     ; 2CEF
L2CF0:  stx     $35                             ; 2CF0
        ldx     #$60                            ; 2CF2
        ldy     #$4D                            ; 2CF4
        stx     L0006                           ; 2CF6
        sty     $07                             ; 2CF8
        ldx     #$00                            ; 2CFA
        stx     $09                             ; 2CFC
        stx     $0A                             ; 2CFE
L2D00:  lda     L0006                           ; 2D00
        sta     L2892,x                         ; 2D02
        lda     $07                             ; 2D05
        sta     L28A3,x                         ; 2D07
        lda     $09                             ; 2D0A
        sta     L28B4,x                         ; 2D0C
        lda     $0A                             ; 2D0F
        sta     L28C5,x                         ; 2D11
        clc                                     ; 2D14
        lda     $09                             ; 2D15
        adc     $36                             ; 2D17
        sta     $09                             ; 2D19
        bcc     L2D1F                           ; 2D1B
        inc     $0A                             ; 2D1D
L2D1F:  clc                                     ; 2D1F
        lda     L0006                           ; 2D20
        adc     $34                             ; 2D22
        sta     L0006                           ; 2D24
        lda     $07                             ; 2D26
        adc     $35                             ; 2D28
        sta     $07                             ; 2D2A
        inx                                     ; 2D2C
L2D2D:  cpx     #$11                            ; 2D2D
        bcc     L2D00                           ; 2D2F
        rts                                     ; 2D31

; ----------------------------------------------------------------------------
L2D32:  lda     #$00                            ; 2D32
        sta     $16                             ; 2D34
        sta     L2E9D                           ; 2D36
        beq     L2D3E                           ; 2D39
L2D3B:  jsr     L2D5E                           ; 2D3B
L2D3E:  .byte   $A9                             ; 2D3E
L2D3F:  brk                                     ; 2D3F
        sta     L2E9C                           ; 2D40
L2D43:  jsr     L2DD9                           ; 2D43
        inc     L2E9C                           ; 2D46
        lda     L2E9C                           ; 2D49
        cmp     #$09                            ; 2D4C
        bcc     L2D43                           ; 2D4E
        jsr     L2E9F                           ; 2D50
        inc     L2E9D                           ; 2D53
        lda     L2E9D                           ; 2D56
        cmp     #$08                            ; 2D59
        bcc     L2D3B                           ; 2D5B
        rts                                     ; 2D5D

; ----------------------------------------------------------------------------
L2D5E:  ldx     #$00                            ; 2D5E
L2D60:  lda     L2892,x                         ; 2D60
        sta     $09                             ; 2D63
        lda     L28A3,x                         ; 2D65
        sta     $0A                             ; 2D68
        lda     L2895,x                         ; 2D6A
        sta     L0006                           ; 2D6D
        lda     L28A6,x                         ; 2D6F
        sta     $07                             ; 2D72
        ldy     #$00                            ; 2D74
L2D76:  lda     (L0006),y                       ; 2D76
        sta     ($09),y                         ; 2D78
        iny                                     ; 2D7A
        bne     L2D76                           ; 2D7B
        inc     $07                             ; 2D7D
        inc     $0A                             ; 2D7F
        ldy     #$1F                            ; 2D81
L2D83:  lda     (L0006),y                       ; 2D83
        sta     ($09),y                         ; 2D85
        dey                                     ; 2D87
        bpl     L2D83                           ; 2D88
        clc                                     ; 2D8A
        lda     L28B4,x                         ; 2D8B
        adc     #$D8                            ; 2D8E
        sta     $09                             ; 2D90
        lda     L28C5,x                         ; 2D92
        adc     #$06                            ; 2D95
        sta     $0A                             ; 2D97
        clc                                     ; 2D99
        lda     L28B7,x                         ; 2D9A
        adc     #$D8                            ; 2D9D
        sta     L0006                           ; 2D9F
        lda     L28C8,x                         ; 2DA1
        adc     #$06                            ; 2DA4
        sta     $07                             ; 2DA6
        clc                                     ; 2DA8
        lda     L28B4,x                         ; 2DA9
        adc     #$2C                            ; 2DAC
        sta     $DD                             ; 2DAE
        lda     L28C5,x                         ; 2DB0
        adc     #$08                            ; 2DB3
        sta     $DE                             ; 2DB5
        clc                                     ; 2DB7
        lda     L28B7,x                         ; 2DB8
        adc     #$2C                            ; 2DBB
        sta     $DB                             ; 2DBD
        lda     L28C8,x                         ; 2DBF
        adc     #$08                            ; 2DC2
        sta     $DC                             ; 2DC4
        ldy     #$23                            ; 2DC6
L2DC8:  lda     (L0006),y                       ; 2DC8
        sta     ($09),y                         ; 2DCA
        lda     ($DB),y                         ; 2DCC
        sta     ($DD),y                         ; 2DCE
        dey                                     ; 2DD0
        bpl     L2DC8                           ; 2DD1
        inx                                     ; 2DD3
        cpx     #$03                            ; 2DD4
        bcc     L2D60                           ; 2DD6
        rts                                     ; 2DD8

; ----------------------------------------------------------------------------
L2DD9:  jsr     L2E83                           ; 2DD9
        lda     #$00                            ; 2DDC
        cpy     $F500                           ; 2DDE
        bne     L2DEA                           ; 2DE1
        cpx     $F501                           ; 2DE3
        bne     L2DEA                           ; 2DE6
        lda     #$FF                            ; 2DE8
L2DEA:  sta     L2E9E                           ; 2DEA
        jsr     L318A                           ; 2DED
        lda     $7B                             ; 2DF0
        and     #$08                            ; 2DF2
        beq     L2E38                           ; 2DF4
        ldx     $7B                             ; 2DF6
        jsr     L018C                           ; 2DF8
        and     #$03                            ; 2DFB
        tay                                     ; 2DFD
        lda     L32EB,y                         ; 2DFE
        ldx     #$00                            ; 2E01
        jsr     L2EE7                           ; 2E03
        ldx     $7A                             ; 2E06
        jsr     L0192                           ; 2E08
        beq     L2E15                           ; 2E0B
        lda     L32C8,y                         ; 2E0D
        ldx     #$03                            ; 2E10
        jsr     L2EE7                           ; 2E12
L2E15:  lda     $7A                             ; 2E15
        and     #$0F                            ; 2E17
        beq     L2E24                           ; 2E19
        tay                                     ; 2E1B
        lda     L32C8,y                         ; 2E1C
        ldx     #$06                            ; 2E1F
        jsr     L2EE7                           ; 2E21
L2E24:  bit     L2E9E                           ; 2E24
        bmi     L2E80                           ; 2E27
        lda     $7B                             ; 2E29
        and     #$07                            ; 2E2B
L2E2D:  beq     L2E99                           ; 2E2D
        tay                                     ; 2E2F
        lda     L32EE,y                         ; 2E30
        ldx     #$00                            ; 2E33
        jmp     L2EE7                           ; 2E35

; ----------------------------------------------------------------------------
L2E38:  ldx     #$3C                            ; 2E38
        ldy     #$25                            ; 2E3A
        jsr     L2F19                           ; 2E3C
        lda     $7A                             ; 2E3F
        sta     $37                             ; 2E41
        jsr     L2E83                           ; 2E43
        iny                                     ; 2E46
        jsr     L318A                           ; 2E47
        lda     $7B                             ; 2E4A
        and     #$08                            ; 2E4C
        beq     L2E5F                           ; 2E4E
        ldx     $37                             ; 2E50
        jsr     L0192                           ; 2E52
        beq     L2E5F                           ; 2E55
        lda     L32C8,y                         ; 2E57
        ldx     #$03                            ; 2E5A
        jsr     L2EE7                           ; 2E5C
L2E5F:  jsr     L2E83                           ; 2E5F
        dex                                     ; 2E62
        jsr     L318A                           ; 2E63
        lda     $7B                             ; 2E66
        and     #$08                            ; 2E68
        beq     L2E7B                           ; 2E6A
        lda     $37                             ; 2E6C
        and     #$0F                            ; 2E6E
        beq     L2E7B                           ; 2E70
        tay                                     ; 2E72
        lda     L32C8,y                         ; 2E73
        ldx     #$06                            ; 2E76
        jsr     L2EE7                           ; 2E78
L2E7B:  bit     L2E9E                           ; 2E7B
        bpl     L2E99                           ; 2E7E
L2E80:  jmp     L2F15                           ; 2E80

; ----------------------------------------------------------------------------
L2E83:  lda     #$03                            ; 2E83
        sec                                     ; 2E85
        sbc     L2E9D                           ; 2E86
        clc                                     ; 2E89
        adc     L2E9A                           ; 2E8A
        tay                                     ; 2E8D
        lda     L2E9B                           ; 2E8E
        sec                                     ; 2E91
        sbc     #$04                            ; 2E92
        clc                                     ; 2E94
        adc     L2E9C                           ; 2E95
        tax                                     ; 2E98
L2E99:  rts                                     ; 2E99

; ----------------------------------------------------------------------------
L2E9A:  brk                                     ; 2E9A
L2E9B:  brk                                     ; 2E9B
L2E9C:  brk                                     ; 2E9C
L2E9D:  brk                                     ; 2E9D
L2E9E:  brk                                     ; 2E9E
L2E9F:  lda     #$24                            ; 2E9F
        sta     L3BF8                           ; 2EA1
        ldy     L2E9D                           ; 2EA4
        lda     L2ECF,y                         ; 2EA7
        sta     L3BF6                           ; 2EAA
        lda     L2ED7,y                         ; 2EAD
        sta     L3BF7                           ; 2EB0
        lda     L2EDF,y                         ; 2EB3
        sta     L3BF9                           ; 2EB6
        jsr     L3B68                           ; 2EB9
        lda     #$00                            ; 2EBC
        sta     L3BF6                           ; 2EBE
        sta     L3BF9                           ; 2EC1
        lda     #$11                            ; 2EC4
        sta     L3BF7                           ; 2EC6
        lda     #$14                            ; 2EC9
        sta     L3BF8                           ; 2ECB
L2ECE:  rts                                     ; 2ECE

; ----------------------------------------------------------------------------
L2ECF:  .byte   $03                             ; 2ECF
        .byte   $02                             ; 2ED0
        .byte   $02                             ; 2ED1
        .byte   $02                             ; 2ED2
        .byte   $02                             ; 2ED3
        .byte   $02                             ; 2ED4
        .byte   $02                             ; 2ED5
        .byte   $02                             ; 2ED6
L2ED7:  ora     $05                             ; 2ED7
        ora     $05                             ; 2ED9
        ora     $05                             ; 2EDB
        ora     $03                             ; 2EDD
L2EDF:  sbc     $0300,x                         ; 2EDF
        asl     $09                             ; 2EE2
        .byte   $0C                             ; 2EE4
        .byte   $0F                             ; 2EE5
        .byte   $12                             ; 2EE6
L2EE7:  cmp     #$7F                            ; 2EE7
        bcs     L2ECE                           ; 2EE9
        asl     a                               ; 2EEB
        tay                                     ; 2EEC
        lda     $0338,y                         ; 2EED
        sta     $0C                             ; 2EF0
        lda     $0339,y                         ; 2EF2
        sta     $0D                             ; 2EF5
        lda     L2E9C                           ; 2EF7
        asl     a                               ; 2EFA
        asl     a                               ; 2EFB
        adc     L2F0C,x                         ; 2EFC
        sta     $0E                             ; 2EFF
        lda     L2F0D,x                         ; 2F01
        sta     L0010                           ; 2F04
        ldy     L2F0E,x                         ; 2F06
        jmp     L2912                           ; 2F09

; ----------------------------------------------------------------------------
L2F0C:  brk                                     ; 2F0C
L2F0D:  .byte   $03                             ; 2F0D
L2F0E:  brk                                     ; 2F0E
        .byte   $FF                             ; 2F0F
        .byte   $02                             ; 2F10
        brk                                     ; 2F11
L2F12:  .byte   $FF                             ; 2F12
        .byte   $02                             ; 2F13
        .byte   $02                             ; 2F14
L2F15:  ldx     #$10                            ; 2F15
        ldy     #$25                            ; 2F17
L2F19:  stx     $0C                             ; 2F19
        sty     $0D                             ; 2F1B
        lda     L2E9C                           ; 2F1D
        asl     a                               ; 2F20
        asl     a                               ; 2F21
        sta     $0E                             ; 2F22
        lda     #$03                            ; 2F24
        sta     L0010                           ; 2F26
        jmp     L292C                           ; 2F28

; ----------------------------------------------------------------------------
L2F2B:  jsr     L386B                           ; 2F2B
        jsr     L33A0                           ; 2F2E
        ldx     $51                             ; 2F31
        ldy     $52                             ; 2F33
        jsr     L3D8E                           ; 2F35
        ldx     $F503                           ; 2F38
        ldy     L3033,x                         ; 2F3B
        ldx     #$0B                            ; 2F3E
L2F40:  stx     $09                             ; 2F40
        sty     $0A                             ; 2F42
        clc                                     ; 2F44
        lda     $F501                           ; 2F45
        adc     L3037,y                         ; 2F48
        tax                                     ; 2F4B
        clc                                     ; 2F4C
        lda     $F500                           ; 2F4D
        adc     L3038,y                         ; 2F50
        tay                                     ; 2F53
        jsr     L3097                           ; 2F54
        ldy     $0A                             ; 2F57
        ldx     $09                             ; 2F59
        lda     $7E                             ; 2F5B
        sta     $0320,x                         ; 2F5D
        lda     $7F                             ; 2F60
        and     #$F7                            ; 2F62
        sta     $032C,x                         ; 2F64
        dey                                     ; 2F67
        dey                                     ; 2F68
        dex                                     ; 2F69
        bpl     L2F40                           ; 2F6A
        ldx     $032A                           ; 2F6C
        jsr     L018C                           ; 2F6F
        beq     L2F78                           ; 2F72
        tax                                     ; 2F74
        lda     L32D7,x                         ; 2F75
L2F78:  sta     $F526                           ; 2F78
        lda     $F523                           ; 2F7B
        and     #$08                            ; 2F7E
        bne     L2F8A                           ; 2F80
        ldx     $F5C1                           ; 2F82
        bne     L2F8A                           ; 2F85
        jmp     L3F51                           ; 2F87

; ----------------------------------------------------------------------------
L2F8A:  ldx     $F501                           ; 2F8A
        ldy     $F500                           ; 2F8D
        jsr     L318A                           ; 2F90
        bcs     L2F9C                           ; 2F93
        dey                                     ; 2F95
        lda     ($9B),y                         ; 2F96
        ora     #$08                            ; 2F98
        sta     ($9B),y                         ; 2F9A
L2F9C:  jsr     L34EA                           ; 2F9C
        jsr     L32FE                           ; 2F9F
        ldy     #$08                            ; 2FA2
L2FA4:  sty     $37                             ; 2FA4
        ldx     L32B7,y                         ; 2FA6
        ldy     $032C,x                         ; 2FA9
        jsr     L018A                           ; 2FAC
        and     #$03                            ; 2FAF
        tax                                     ; 2FB1
        lda     L32EB,x                         ; 2FB2
        asl     a                               ; 2FB5
        tay                                     ; 2FB6
        lda     $0338,y                         ; 2FB7
        sta     $0C                             ; 2FBA
        lda     $0339,y                         ; 2FBC
        sta     $0D                             ; 2FBF
        ldx     $37                             ; 2FC1
        lda     L32A5,x                         ; 2FC3
        sta     $0E                             ; 2FC6
        lda     L32AE,x                         ; 2FC8
        sta     L0010                           ; 2FCB
        lda     #$00                            ; 2FCD
        sta     $16                             ; 2FCF
        ldy     L32C0,x                         ; 2FD1
        jsr     L2912                           ; 2FD4
        ldy     $37                             ; 2FD7
        dey                                     ; 2FD9
        bpl     L2FA4                           ; 2FDA
        ldx     #$17                            ; 2FDC
L2FDE:  stx     $37                             ; 2FDE
        lda     L325D,x                         ; 2FE0
        cmp     #$80                            ; 2FE3
        and     #$7F                            ; 2FE5
        tay                                     ; 2FE7
        lda     $0320,y                         ; 2FE8
        bcc     L2FF1                           ; 2FEB
        lsr     a                               ; 2FED
        lsr     a                               ; 2FEE
        lsr     a                               ; 2FEF
        lsr     a                               ; 2FF0
L2FF1:  and     #$0F                            ; 2FF1
        beq     L3026                           ; 2FF3
        tay                                     ; 2FF5
        lda     L328D,x                         ; 2FF6
        sta     $16                             ; 2FF9
        lsr     a                               ; 2FFB
        lda     L32C8,y                         ; 2FFC
        bcc     L3004                           ; 2FFF
        lda     L32EE,y                         ; 3001
L3004:  cmp     #$7F                            ; 3004
        bcs     L3026                           ; 3006
        asl     a                               ; 3008
        tay                                     ; 3009
        lda     $0338,y                         ; 300A
        sta     $0C                             ; 300D
        lda     $0339,y                         ; 300F
        sta     $0D                             ; 3012
        lda     L322D,x                         ; 3014
        sta     $0E                             ; 3017
        lda     L3245,x                         ; 3019
        sta     L0010                           ; 301C
        ldy     L3275,x                         ; 301E
        jsr     L2912                           ; 3021
        ldx     $37                             ; 3024
L3026:  dex                                     ; 3026
        bpl     L2FDE                           ; 3027
        lda     #$FF                            ; 3029
        sta     $39                             ; 302B
        jsr     L34B5                           ; 302D
        jmp     L28D6                           ; 3030

; ----------------------------------------------------------------------------
L3033:  asl     $2E,x                           ; 3033
        lsr     $5E                             ; 3035
L3037:  .byte   $FF                             ; 3037
L3038:  .byte   $03                             ; 3038
        brk                                     ; 3039
        .byte   $03                             ; 303A
        ora     ($03,x)                         ; 303B
        .byte   $FF                             ; 303D
        .byte   $02                             ; 303E
        brk                                     ; 303F
        .byte   $02                             ; 3040
        ora     ($02,x)                         ; 3041
        .byte   $FF                             ; 3043
        ora     ($00,x)                         ; 3044
        ora     ($01,x)                         ; 3046
        ora     ($FF,x)                         ; 3048
        brk                                     ; 304A
        brk                                     ; 304B
        brk                                     ; 304C
        ora     ($00,x)                         ; 304D
        .byte   $03                             ; 304F
        ora     ($03,x)                         ; 3050
        brk                                     ; 3052
        .byte   $03                             ; 3053
        .byte   $FF                             ; 3054
        .byte   $02                             ; 3055
        ora     ($02,x)                         ; 3056
        brk                                     ; 3058
        .byte   $02                             ; 3059
        .byte   $FF                             ; 305A
        ora     ($01,x)                         ; 305B
        ora     ($00,x)                         ; 305D
        ora     ($FF,x)                         ; 305F
        brk                                     ; 3061
        ora     ($00,x)                         ; 3062
        brk                                     ; 3064
        brk                                     ; 3065
        .byte   $FF                             ; 3066
        ora     ($FD,x)                         ; 3067
        brk                                     ; 3069
        sbc     $FDFF,x                         ; 306A
        ora     ($FE,x)                         ; 306D
        brk                                     ; 306F
        inc     $FEFF,x                         ; 3070
        ora     ($FF,x)                         ; 3073
        brk                                     ; 3075
        .byte   $FF                             ; 3076
        .byte   $FF                             ; 3077
        .byte   $FF                             ; 3078
        ora     ($00,x)                         ; 3079
        brk                                     ; 307B
        brk                                     ; 307C
        .byte   $FF                             ; 307D
        brk                                     ; 307E
        sbc     $FDFF,x                         ; 307F
        brk                                     ; 3082
        sbc     $FE01,x                         ; 3083
        .byte   $FF                             ; 3086
        .byte   $FE                             ; 3087
L3088:  brk                                     ; 3088
        inc     $FF01,x                         ; 3089
        .byte   $FF                             ; 308C
        .byte   $FF                             ; 308D
        brk                                     ; 308E
        .byte   $FF                             ; 308F
        ora     ($00,x)                         ; 3090
        .byte   $FF                             ; 3092
        brk                                     ; 3093
        brk                                     ; 3094
        brk                                     ; 3095
        .byte   $01                             ; 3096
L3097:  stx     $0C                             ; 3097
        sty     $0D                             ; 3099
        jsr     L318A                           ; 309B
        lda     $7C                             ; 309E
        sta     $80                             ; 30A0
        lda     $7B                             ; 30A2
        sta     $7F                             ; 30A4
        lda     $7A                             ; 30A6
        sta     $7E                             ; 30A8
        lda     $F503                           ; 30AA
        beq     L30EB                           ; 30AD
        ldx     $0C                             ; 30AF
        ldy     $0D                             ; 30B1
        inx                                     ; 30B3
        jsr     L318A                           ; 30B4
        lda     $7A                             ; 30B7
        and     #$0F                            ; 30B9
        sta     $81                             ; 30BB
        ldx     $0C                             ; 30BD
        ldy     $0D                             ; 30BF
        dey                                     ; 30C1
        jsr     L318A                           ; 30C2
        lda     $7A                             ; 30C5
        and     #$F0                            ; 30C7
        ora     $81                             ; 30C9
        tay                                     ; 30CB
        ldx     $7E                             ; 30CC
        lda     $F503                           ; 30CE
        cmp     #$02                            ; 30D1
        bcc     L30DD                           ; 30D3
        beq     L3150                           ; 30D5
        stx     $FF                             ; 30D7
        tya                                     ; 30D9
        ldy     $FF                             ; 30DA
        tax                                     ; 30DC
L30DD:  jsr     L018C                           ; 30DD
        sta     $FF                             ; 30E0
        tya                                     ; 30E2
        asl     a                               ; 30E3
        asl     a                               ; 30E4
        asl     a                               ; 30E5
        asl     a                               ; 30E6
        ora     $FF                             ; 30E7
        sta     $7E                             ; 30E9
L30EB:  rts                                     ; 30EB

; ----------------------------------------------------------------------------
L30EC:  stx     $0C                             ; 30EC
        sty     $0D                             ; 30EE
        jsr     L318A                           ; 30F0
        bcs     L30FF                           ; 30F3
        lda     $80                             ; 30F5
        sta     ($9B),y                         ; 30F7
        dey                                     ; 30F9
        lda     $7F                             ; 30FA
        sta     ($9B),y                         ; 30FC
        iny                                     ; 30FE
L30FF:  dey                                     ; 30FF
        dey                                     ; 3100
        ldx     $F503                           ; 3101
        beq     L3183                           ; 3104
        dex                                     ; 3106
        beq     L312E                           ; 3107
        dex                                     ; 3109
        beq     L3156                           ; 310A
        bcs     L3111                           ; 310C
        jsr     L313F                           ; 310E
L3111:  ldx     $0C                             ; 3111
        ldy     $0D                             ; 3113
        dey                                     ; 3115
        jsr     L318A                           ; 3116
        bcs     L312D                           ; 3119
        dey                                     ; 311B
        dey                                     ; 311C
L311D:  lda     $7E                             ; 311D
        asl     a                               ; 311F
        asl     a                               ; 3120
        asl     a                               ; 3121
        asl     a                               ; 3122
        sta     $FF                             ; 3123
        lda     ($9B),y                         ; 3125
        and     #$0F                            ; 3127
        ora     $FF                             ; 3129
        sta     ($9B),y                         ; 312B
L312D:  rts                                     ; 312D

; ----------------------------------------------------------------------------
L312E:  bcs     L3133                           ; 312E
L3130:  jsr     L311D                           ; 3130
L3133:  ldx     $0C                             ; 3133
        ldy     $0D                             ; 3135
        inx                                     ; 3137
        jsr     L318A                           ; 3138
        bcs     L314F                           ; 313B
        dey                                     ; 313D
        dey                                     ; 313E
L313F:  lda     $7E                             ; 313F
        lsr     a                               ; 3141
        lsr     a                               ; 3142
        lsr     a                               ; 3143
        lsr     a                               ; 3144
        sta     $FF                             ; 3145
        lda     ($3B),y                         ; 3147
        and     #$F0                            ; 3149
        ora     $FF                             ; 314B
        sta     ($9B),y                         ; 314D
L314F:  rts                                     ; 314F

; ----------------------------------------------------------------------------
L3150:  sty     $7E                             ; 3150
        rts                                     ; 3152

; ----------------------------------------------------------------------------
        brk                                     ; 3153
        brk                                     ; 3154
        brk                                     ; 3155
L3156:  ldx     $0C                             ; 3156
        ldy     $0D                             ; 3158
        inx                                     ; 315A
        jsr     L318A                           ; 315B
        bcs     L316C                           ; 315E
        dey                                     ; 3160
        dey                                     ; 3161
        lda     $7E                             ; 3162
        eor     ($9B),y                         ; 3164
        and     #$0F                            ; 3166
        eor     ($9B),y                         ; 3168
        sta     ($9B),y                         ; 316A
L316C:  ldx     $0C                             ; 316C
        ldy     $0D                             ; 316E
        dey                                     ; 3170
        jsr     L318A                           ; 3171
        bcs     L3182                           ; 3174
        dey                                     ; 3176
        dey                                     ; 3177
        lda     $7E                             ; 3178
        eor     ($9B),y                         ; 317A
        and     #$F0                            ; 317C
        eor     ($9B),y                         ; 317E
        sta     ($9B),y                         ; 3180
L3182:  rts                                     ; 3182

; ----------------------------------------------------------------------------
L3183:  bcs     L3189                           ; 3183
        lda     $7E                             ; 3185
        sta     ($9B),y                         ; 3187
L3189:  rts                                     ; 3189

; ----------------------------------------------------------------------------
L318A:  jsr     L31C5                           ; 318A
        jsr     L31F9                           ; 318D
        tya                                     ; 3190
        asl     a                               ; 3191
        tay                                     ; 3192
        lda     $035A,y                         ; 3193
        sta     $9B                             ; 3196
        lda     $035B,y                         ; 3198
        sta     $9C                             ; 319B
        txa                                     ; 319D
        sta     $7A                             ; 319E
        asl     a                               ; 31A0
        adc     $7A                             ; 31A1
        jsr     L0629                           ; 31A3
        sta     $7A                             ; 31A6
        iny                                     ; 31A8
        lda     ($9B),y                         ; 31A9
        sta     $7B                             ; 31AB
        iny                                     ; 31AD
        lda     ($9B),y                         ; 31AE
        sta     $7C                             ; 31B0
        asl     L31C4                           ; 31B2
        bcc     L31C3                           ; 31B5
        lda     #$00                            ; 31B7
        sta     $7C                             ; 31B9
        sta     $7A                             ; 31BB
        lda     $7B                             ; 31BD
        and     #$30                            ; 31BF
        sta     $7B                             ; 31C1
L31C3:  rts                                     ; 31C3

; ----------------------------------------------------------------------------
L31C4:  brk                                     ; 31C4
L31C5:  cpy     $F522                           ; 31C5
        bcc     L31F8                           ; 31C8
        lda     $F523                           ; 31CA
        and     #$02                            ; 31CD
        beq     L31E9                           ; 31CF
L31D1:  cpy     $F522                           ; 31D1
        bcc     L31F8                           ; 31D4
        tya                                     ; 31D6
        bmi     L31E1                           ; 31D7
        sec                                     ; 31D9
        sbc     $F522                           ; 31DA
        tay                                     ; 31DD
        jmp     L31D1                           ; 31DE

; ----------------------------------------------------------------------------
L31E1:  clc                                     ; 31E1
        adc     $F522                           ; 31E2
        tay                                     ; 31E5
        jmp     L31D1                           ; 31E6

; ----------------------------------------------------------------------------
L31E9:  lda     #$80                            ; 31E9
        sta     L31C4                           ; 31EB
        tya                                     ; 31EE
        bmi     L31F6                           ; 31EF
        ldy     $F522                           ; 31F1
        dey                                     ; 31F4
        rts                                     ; 31F5

; ----------------------------------------------------------------------------
L31F6:  ldy     #$00                            ; 31F6
L31F8:  rts                                     ; 31F8

; ----------------------------------------------------------------------------
L31F9:  cpx     $F521                           ; 31F9
        bcc     L3229                           ; 31FC
        lda     $F523                           ; 31FE
        and     #$02                            ; 3201
        beq     L321D                           ; 3203
L3205:  cpx     $F521                           ; 3205
        bcc     L3229                           ; 3208
        txa                                     ; 320A
        bmi     L3215                           ; 320B
        sec                                     ; 320D
        sbc     $F521                           ; 320E
        tax                                     ; 3211
        jmp     L3205                           ; 3212

; ----------------------------------------------------------------------------
L3215:  clc                                     ; 3215
        adc     $F521                           ; 3216
        tax                                     ; 3219
        jmp     L3205                           ; 321A

; ----------------------------------------------------------------------------
L321D:  lda     #$80                            ; 321D
        sta     L31C4                           ; 321F
        txa                                     ; 3222
        bmi     L322A                           ; 3223
        ldx     $F521                           ; 3225
        dex                                     ; 3228
L3229:  rts                                     ; 3229

; ----------------------------------------------------------------------------
L322A:  ldx     #$00                            ; 322A
        rts                                     ; 322C

; ----------------------------------------------------------------------------
L322D:  .byte   $04                             ; 322D
        brk                                     ; 322E
        bpl     L3229                           ; 322F
        bpl     L3237                           ; 3231
        sed                                     ; 3233
        bpl     L323C                           ; 3234
        .byte   $04                             ; 3236
L3237:  asl     L0EFE                           ; 3237
        asl     $FE                             ; 323A
L323C:  asl     L0608                           ; 323C
        .byte   $0C                             ; 323F
        .byte   $04                             ; 3240
        .byte   $0C                             ; 3241
        php                                     ; 3242
        .byte   $04                             ; 3243
        .byte   $0C                             ; 3244
L3245:  .byte   $02                             ; 3245
        brk                                     ; 3246
        brk                                     ; 3247
        .byte   $02                             ; 3248
        .byte   $02                             ; 3249
        .byte   $02                             ; 324A
        .byte   $02                             ; 324B
        .byte   $02                             ; 324C
        .byte   $04                             ; 324D
        .byte   $02                             ; 324E
        .byte   $02                             ; 324F
        .byte   $04                             ; 3250
        .byte   $04                             ; 3251
        .byte   $04                             ; 3252
        .byte   $04                             ; 3253
        .byte   $04                             ; 3254
        asl     $04                             ; 3255
        .byte   $04                             ; 3257
        asl     L0006                           ; 3258
        asl     L0006                           ; 325A
        .byte   $06                             ; 325C
L325D:  asl     $0A,x                           ; 325D
        .byte   $0B                             ; 325F
        ora     $17,x                           ; 3260
        txa                                     ; 3262
        .byte   $89                             ; 3263
        .byte   $8B                             ; 3264
        .byte   $13                             ; 3265
        .byte   $07                             ; 3266
        php                                     ; 3267
        .byte   $12                             ; 3268
        .byte   $14                             ; 3269
        .byte   $87                             ; 326A
        stx     $88                             ; 326B
        bpl     L3273                           ; 326D
        ora     $0F                             ; 326F
        ora     ($84),y                         ; 3271
L3273:  .byte   $83                             ; 3273
        .byte   $85                             ; 3274
L3275:  .byte   $04                             ; 3275
        .byte   $0C                             ; 3276
        .byte   $0C                             ; 3277
        .byte   $04                             ; 3278
        .byte   $04                             ; 3279
        .byte   $04                             ; 327A
        .byte   $04                             ; 327B
        .byte   $04                             ; 327C
        asl     $0E                             ; 327D
        asl     L0606                           ; 327F
        asl     L0006                           ; 3282
        asl     $08                             ; 3284
        bpl     L3298                           ; 3286
        php                                     ; 3288
        php                                     ; 3289
        php                                     ; 328A
        php                                     ; 328B
        php                                     ; 328C
L328D:  ora     ($00,x)                         ; 328D
        .byte   $80                             ; 328F
        ora     ($01,x)                         ; 3290
        brk                                     ; 3292
        brk                                     ; 3293
        brk                                     ; 3294
        ora     ($00,x)                         ; 3295
        .byte   $80                             ; 3297
L3298:  ora     ($01,x)                         ; 3298
        brk                                     ; 329A
        brk                                     ; 329B
        brk                                     ; 329C
        ora     ($00,x)                         ; 329D
        .byte   $80                             ; 329F
        ora     ($01,x)                         ; 32A0
        brk                                     ; 32A2
        brk                                     ; 32A3
        brk                                     ; 32A4
L32A5:  .byte   $02                             ; 32A5
        brk                                     ; 32A6
        bpl     L32AD                           ; 32A7
        brk                                     ; 32A9
        asl     a:L0006                         ; 32AA
L32AD:  .byte   $0C                             ; 32AD
L32AE:  .byte   $0F                             ; 32AE
        .byte   $0F                             ; 32AF
        .byte   $0F                             ; 32B0
        ora     L0D0D                           ; 32B1
        .byte   $0B                             ; 32B4
        .byte   $0B                             ; 32B5
        .byte   $0B                             ; 32B6
L32B7:  asl     a                               ; 32B7
        ora     #$0B                            ; 32B8
        .byte   $07                             ; 32BA
        asl     $08                             ; 32BB
        .byte   $04                             ; 32BD
        .byte   $03                             ; 32BE
        .byte   $05                             ; 32BF
L32C0:  .byte   $12                             ; 32C0
        bpl     L32D7                           ; 32C1
        .byte   $0C                             ; 32C3
        asl     a                               ; 32C4
        asl     $0406                           ; 32C5
L32C8:  php                                     ; 32C8
L32C9:  brk                                     ; 32C9
        brk                                     ; 32CA
        brk                                     ; 32CB
        brk                                     ; 32CC
        brk                                     ; 32CD
        brk                                     ; 32CE
        brk                                     ; 32CF
        brk                                     ; 32D0
        brk                                     ; 32D1
        brk                                     ; 32D2
        brk                                     ; 32D3
        brk                                     ; 32D4
        brk                                     ; 32D5
        brk                                     ; 32D6
L32D7:  brk                                     ; 32D7
L32D8:  brk                                     ; 32D8
        brk                                     ; 32D9
        brk                                     ; 32DA
        brk                                     ; 32DB
        brk                                     ; 32DC
        brk                                     ; 32DD
        brk                                     ; 32DE
        brk                                     ; 32DF
        brk                                     ; 32E0
        brk                                     ; 32E1
        brk                                     ; 32E2
        brk                                     ; 32E3
        brk                                     ; 32E4
        brk                                     ; 32E5
        brk                                     ; 32E6
L32E7:  brk                                     ; 32E7
        brk                                     ; 32E8
        brk                                     ; 32E9
        brk                                     ; 32EA
L32EB:  brk                                     ; 32EB
        brk                                     ; 32EC
        brk                                     ; 32ED
L32EE:  brk                                     ; 32EE
        brk                                     ; 32EF
        brk                                     ; 32F0
        brk                                     ; 32F1
        brk                                     ; 32F2
        brk                                     ; 32F3
        brk                                     ; 32F4
        brk                                     ; 32F5
        brk                                     ; 32F6
        brk                                     ; 32F7
        brk                                     ; 32F8
        brk                                     ; 32F9
        brk                                     ; 32FA
        brk                                     ; 32FB
        brk                                     ; 32FC
        brk                                     ; 32FD
L32FE:  lda     $0336                           ; 32FE
        rol     a                               ; 3301
        rol     a                               ; 3302
        rol     a                               ; 3303
        and     #$03                            ; 3304
        tax                                     ; 3306
        ldy     L32E7,x                         ; 3307
        lda     L34CC,y                         ; 330A
        and     #$7F                            ; 330D
        cmp     #$01                            ; 330F
        bne     L3330                           ; 3311
        tya                                     ; 3313
        asl     a                               ; 3314
        tay                                     ; 3315
        lda     $0338,y                         ; 3316
        sta     $0C                             ; 3319
        lda     $0339,y                         ; 331B
        sta     $0D                             ; 331E
        lda     #$00                            ; 3320
        sta     $0E                             ; 3322
        sta     L0010                           ; 3324
        sta     $16                             ; 3326
        ldy     #$04                            ; 3328
        jsr     L2912                           ; 332A
        ldx     #$0B                            ; 332D
        .byte   $2C                             ; 332F
L3330:  ldx     #$00                            ; 3330
L3332:  lda     L2892,x                         ; 3332
        sta     L3358                           ; 3335
        sta     L335E                           ; 3338
        lda     L28A3,x                         ; 333B
        sta     L3359                           ; 333E
        sta     L335F                           ; 3341
        lda     #$11                            ; 3344
        ldy     #$44                            ; 3346
        cpx     #$06                            ; 3348
        bcc     L334F                           ; 334A
        lda     #$00                            ; 334C
        tay                                     ; 334E
L334F:  sta     L0006                           ; 334F
        sty     $07                             ; 3351
        ldy     #$00                            ; 3353
L3355:  lda     L0006                           ; 3355
        .byte   $99                             ; 3357
L3358:  .byte   $FF                             ; 3358
L3359:  .byte   $FF                             ; 3359
        iny                                     ; 335A
        lda     $07                             ; 335B
        .byte   $99                             ; 335D
L335E:  .byte   $FF                             ; 335E
L335F:  .byte   $FF                             ; 335F
        iny                                     ; 3360
        cpy     #$A0                            ; 3361
        bcc     L3355                           ; 3363
        clc                                     ; 3365
        lda     L28B4,x                         ; 3366
        adc     #$D8                            ; 3369
        sta     L0006                           ; 336B
        lda     L28C5,x                         ; 336D
        adc     #$06                            ; 3370
        sta     $07                             ; 3372
        clc                                     ; 3374
        lda     L28B4,x                         ; 3375
        adc     #$2C                            ; 3378
        sta     $09                             ; 337A
        lda     L28C5,x                         ; 337C
        adc     #$08                            ; 337F
        sta     $0A                             ; 3381
        lda     #$90                            ; 3383
        cpx     #$06                            ; 3385
        bcc     L338B                           ; 3387
        lda     #$00                            ; 3389
L338B:  sta     $82                             ; 338B
        ldy     #$13                            ; 338D
L338F:  lda     $82                             ; 338F
        sta     (L0006),y                       ; 3391
        lda     #$00                            ; 3393
        sta     ($09),y                         ; 3395
        dey                                     ; 3397
        bpl     L338F                           ; 3398
        inx                                     ; 339A
        cpx     #$11                            ; 339B
        bcc     L3332                           ; 339D
        rts                                     ; 339F

; ----------------------------------------------------------------------------
L33A0:  jsr     L3411                           ; 33A0
        lda     $F502                           ; 33A3
        cmp     $F557                           ; 33A6
        beq     L33EE                           ; 33A9
        eor     $F557                           ; 33AB
        asl     a                               ; 33AE
        beq     L33E5                           ; 33AF
        bit     $F556                           ; 33B1
        bmi     L33C4                           ; 33B4
        jsr     L27EF                           ; 33B6
        lda     $F556                           ; 33B9
        jsr     L43E8                           ; 33BC
        lda     #$FF                            ; 33BF
        sta     $F556                           ; 33C1
L33C4:  lda     $F502                           ; 33C4
        clc                                     ; 33C7
        adc     #$46                            ; 33C8
        tax                                     ; 33CA
        ldy     #$00                            ; 33CB
        lda     #$01                            ; 33CD
        jsr     L3F85                           ; 33CF
        sta     $F556                           ; 33D2
        jsr     L3411                           ; 33D5
        jsr     L27F8                           ; 33D8
        ldx     #$03                            ; 33DB
        lda     #$00                            ; 33DD
L33DF:  sta     $F5B9,x                         ; 33DF
        dex                                     ; 33E2
        bpl     L33DF                           ; 33E3
L33E5:  lda     $F502                           ; 33E5
        sta     $F504                           ; 33E8
        sta     $F557                           ; 33EB
L33EE:  lda     $F504                           ; 33EE
        cmp     $F55B                           ; 33F1
        beq     L3410                           ; 33F4
        sta     $F55B                           ; 33F6
        lda     $F55A                           ; 33F9
        jsr     L4407                           ; 33FC
        lda     $F504                           ; 33FF
        clc                                     ; 3402
        adc     #$1E                            ; 3403
        tax                                     ; 3405
        ldy     #$00                            ; 3406
        lda     #$01                            ; 3408
        jsr     L3F85                           ; 340A
        sta     $F55A                           ; 340D
L3410:  rts                                     ; 3410

; ----------------------------------------------------------------------------
L3411:  lda     $F556                           ; 3411
        bmi     L3410                           ; 3414
        jsr     L441B                           ; 3416
        stx     $E0                             ; 3419
        .byte   $84                             ; 341B
L341C:  sbc     ($A0,x)                         ; 341C
        brk                                     ; 341E
L341F:  lda     ($E0),y                         ; 341F
        sta     $F521,y                         ; 3421
        iny                                     ; 3424
        cpy     #$04                            ; 3425
        bcc     L341F                           ; 3427
        jsr     L34A8                           ; 3429
L342C:  lda     ($E0),y                         ; 342C
        sta     L34CC,y                         ; 342E
        iny                                     ; 3431
        tax                                     ; 3432
        bpl     L342C                           ; 3433
        ldx     #$00                            ; 3435
L3437:  lda     ($E0),y                         ; 3437
        pha                                     ; 3439
        and     #$7F                            ; 343A
        sta     L32C9,x                         ; 343C
        iny                                     ; 343F
        lda     ($E0),y                         ; 3440
        sta     L32D8,x                         ; 3442
        iny                                     ; 3445
        inx                                     ; 3446
        pla                                     ; 3447
        bpl     L3437                           ; 3448
        ldx     #$00                            ; 344A
        jsr     L349B                           ; 344C
        ldx     #$04                            ; 344F
        jsr     L349B                           ; 3451
        ldx     #$08                            ; 3454
        jsr     L349B                           ; 3456
        lda     $F556                           ; 3459
        jsr     L441B                           ; 345C
        tya                                     ; 345F
        pha                                     ; 3460
        ldy     #$00                            ; 3461
        clc                                     ; 3463
        txa                                     ; 3464
        adc     ($E0),y                         ; 3465
        sta     $51                             ; 3467
        iny                                     ; 3469
        pla                                     ; 346A
        adc     ($E0),y                         ; 346B
        sta     $52                             ; 346D
        iny                                     ; 346F
        jsr     L34A8                           ; 3470
        lda     $F521                           ; 3473
        asl     a                               ; 3476
        adc     $F521                           ; 3477
        sta     $DF                             ; 347A
        lda     $F522                           ; 347C
        asl     a                               ; 347F
        tax                                     ; 3480
L3481:  lda     $E0                             ; 3481
        sta     $0358,x                         ; 3483
        lda     $E1                             ; 3486
        sta     $0359,x                         ; 3488
        clc                                     ; 348B
        lda     $E0                             ; 348C
        adc     $DF                             ; 348E
        sta     $E0                             ; 3490
        bcc     L3496                           ; 3492
        inc     $E1                             ; 3494
L3496:  dex                                     ; 3496
        dex                                     ; 3497
        bpl     L3481                           ; 3498
        rts                                     ; 349A

; ----------------------------------------------------------------------------
L349B:  lda     ($E0),y                         ; 349B
        pha                                     ; 349D
        and     #$7F                            ; 349E
        sta     L32E7,x                         ; 34A0
        iny                                     ; 34A3
        inx                                     ; 34A4
        pla                                     ; 34A5
        bpl     L349B                           ; 34A6
L34A8:  clc                                     ; 34A8
        tya                                     ; 34A9
        adc     $E0                             ; 34AA
        sta     $E0                             ; 34AC
        bcc     L34B2                           ; 34AE
        inc     $E1                             ; 34B0
L34B2:  ldy     #$00                            ; 34B2
        rts                                     ; 34B4

; ----------------------------------------------------------------------------
L34B5:  ldx     #$0E                            ; 34B5
L34B7:  txa                                     ; 34B7
        pha                                     ; 34B8
        lda     L34DB,x                         ; 34B9
        bmi     L34C1                           ; 34BC
        jsr     L4407                           ; 34BE
L34C1:  pla                                     ; 34C1
        tax                                     ; 34C2
        lda     #$FF                            ; 34C3
        sta     L34DB,x                         ; 34C5
        dex                                     ; 34C8
        bpl     L34B7                           ; 34C9
        rts                                     ; 34CB

; ----------------------------------------------------------------------------
L34CC:  brk                                     ; 34CC
        brk                                     ; 34CD
        brk                                     ; 34CE
        brk                                     ; 34CF
        brk                                     ; 34D0
        brk                                     ; 34D1
        brk                                     ; 34D2
        brk                                     ; 34D3
        brk                                     ; 34D4
        brk                                     ; 34D5
        brk                                     ; 34D6
        brk                                     ; 34D7
        brk                                     ; 34D8
        brk                                     ; 34D9
        brk                                     ; 34DA
L34DB:  .byte   $FF                             ; 34DB
        .byte   $FF                             ; 34DC
        .byte   $FF                             ; 34DD
        .byte   $FF                             ; 34DE
        .byte   $FF                             ; 34DF
        .byte   $FF                             ; 34E0
        .byte   $FF                             ; 34E1
        .byte   $FF                             ; 34E2
        .byte   $FF                             ; 34E3
        .byte   $FF                             ; 34E4
        .byte   $FF                             ; 34E5
        .byte   $FF                             ; 34E6
        .byte   $FF                             ; 34E7
        .byte   $FF                             ; 34E8
        .byte   $FF                             ; 34E9
L34EA:  ldy     #$FF                            ; 34EA
L34EC:  iny                                     ; 34EC
        tya                                     ; 34ED
        pha                                     ; 34EE
        lda     L34CC,y                         ; 34EF
        asl     a                               ; 34F2
        lsr     a                               ; 34F3
        adc     #$6E                            ; 34F4
        sta     $56                             ; 34F6
        lda     #$00                            ; 34F8
        sta     $57                             ; 34FA
        jsr     L442D                           ; 34FC
        bcs     L3506                           ; 34FF
        lda     #$01                            ; 3501
        sta     $0280,x                         ; 3503
L3506:  pla                                     ; 3506
        tay                                     ; 3507
        lda     L34CC,y                         ; 3508
        bpl     L34EC                           ; 350B
        ldy     #$FF                            ; 350D
L350F:  iny                                     ; 350F
        tya                                     ; 3510
        pha                                     ; 3511
        lda     L34CC,y                         ; 3512
        asl     a                               ; 3515
        lsr     a                               ; 3516
        adc     #$6E                            ; 3517
        tax                                     ; 3519
        ldy     #$00                            ; 351A
        lda     #$01                            ; 351C
        jsr     L3F85                           ; 351E
        tax                                     ; 3521
        pla                                     ; 3522
        tay                                     ; 3523
        txa                                     ; 3524
        sta     L34DB,y                         ; 3525
        lda     L34CC,y                         ; 3528
        bpl     L350F                           ; 352B
        ldx     #$0E                            ; 352D
L352F:  txa                                     ; 352F
        pha                                     ; 3530
        lda     L34DB,x                         ; 3531
        bmi     L3548                           ; 3534
        jsr     L441B                           ; 3536
        stx     $E0                             ; 3539
        pla                                     ; 353B
        pha                                     ; 353C
        asl     a                               ; 353D
        tax                                     ; 353E
        lda     $E0                             ; 353F
        sta     $0338,x                         ; 3541
        tya                                     ; 3544
        sta     $0339,x                         ; 3545
L3548:  pla                                     ; 3548
        tax                                     ; 3549
        dex                                     ; 354A
        bpl     L352F                           ; 354B
        rts                                     ; 354D

; ----------------------------------------------------------------------------
L354E:  jmp     L3F51                           ; 354E

; ----------------------------------------------------------------------------
L3551:  rts                                     ; 3551

; ----------------------------------------------------------------------------
L3552:  cmp     $39                             ; 3552
        beq     L3551                           ; 3554
        sta     $39                             ; 3556
        jsr     L386B                           ; 3558
        ldy     #$00                            ; 355B
        lda     $39                             ; 355D
        cmp     #$FE                            ; 355F
        bcs     L354E                           ; 3561
        asl     a                               ; 3563
        clc                                     ; 3564
        adc     #$8A                            ; 3565
        tax                                     ; 3567
        bcc     L356B                           ; 3568
        iny                                     ; 356A
L356B:  lda     #$01                            ; 356B
        jsr     L3F85                           ; 356D
        bcs     L354E                           ; 3570
        pha                                     ; 3572
        jsr     L359C                           ; 3573
        pla                                     ; 3576
        jsr     L4407                           ; 3577
        ldx     $56                             ; 357A
        ldy     $57                             ; 357C
        inx                                     ; 357E
        bne     L3582                           ; 357F
        iny                                     ; 3581
L3582:  lda     #$01                            ; 3582
        jsr     L3F85                           ; 3584
        bcs     L359B                           ; 3587
        sta     $4E                             ; 3589
        ldx     #$03                            ; 358B
L358D:  txa                                     ; 358D
        pha                                     ; 358E
        lda     #$00                            ; 358F
        jsr     L3800                           ; 3591
        pla                                     ; 3594
        tax                                     ; 3595
        dex                                     ; 3596
        bpl     L358D                           ; 3597
        stx     $4D                             ; 3599
L359B:  rts                                     ; 359B

; ----------------------------------------------------------------------------
L359C:  stx     $4A                             ; 359C
        sty     $4B                             ; 359E
        jsr     L4255                           ; 35A0
        jsr     L360D                           ; 35A3
        jsr     L3706                           ; 35A6
        jsr     L3679                           ; 35A9
        jsr     L4272                           ; 35AC
        sta     $EE                             ; 35AF
        jsr     L4272                           ; 35B1
        sta     $ED                             ; 35B4
        ldx     #$00                            ; 35B6
        stx     $4C                             ; 35B8
        lsr     a                               ; 35BA
        sta     $EB                             ; 35BB
        bcc     L35C1                           ; 35BD
        ldx     #$02                            ; 35BF
L35C1:  stx     $F1                             ; 35C1
        jsr     L4272                           ; 35C3
        sta     $EF                             ; 35C6
        jsr     L4272                           ; 35C8
        sta     $F0                             ; 35CB
L35CD:  lda     $EE                             ; 35CD
        sta     $EC                             ; 35CF
L35D1:  jsr     L4272                           ; 35D1
        eor     $4C                             ; 35D4
        sta     $4C                             ; 35D6
        lsr     a                               ; 35D8
        lsr     a                               ; 35D9
        lsr     a                               ; 35DA
        lsr     a                               ; 35DB
        cmp     #$09                            ; 35DC
        beq     L35E3                           ; 35DE
        jsr     L39BD                           ; 35E0
L35E3:  lda     $4C                             ; 35E3
        and     #$0F                            ; 35E5
        cmp     #$09                            ; 35E7
        beq     L35F2                           ; 35E9
        inc     $F1                             ; 35EB
        jsr     L39BD                           ; 35ED
        dec     $F1                             ; 35F0
L35F2:  inc     $EC                             ; 35F2
        lda     $EC                             ; 35F4
        cmp     $EF                             ; 35F6
        bcc     L35D1                           ; 35F8
        lda     $F1                             ; 35FA
        eor     #$02                            ; 35FC
        sta     $F1                             ; 35FE
        bne     L3604                           ; 3600
        inc     $EB                             ; 3602
L3604:  inc     $ED                             ; 3604
        lda     $ED                             ; 3606
        cmp     $F0                             ; 3608
        bcc     L35CD                           ; 360A
        rts                                     ; 360C

; ----------------------------------------------------------------------------
L360D:  ldx     #$00                            ; 360D
L360F:  lda     L2892,x                         ; 360F
        sta     L3620                           ; 3612
        lda     L28A3,x                         ; 3615
        sta     L3621                           ; 3618
        ldy     #$00                            ; 361B
        lda     #$55                            ; 361D
L361F:  .byte   $99                             ; 361F
L3620:  .byte   $FF                             ; 3620
L3621:  .byte   $FF                             ; 3621
        iny                                     ; 3622
        cpy     #$A0                            ; 3623
        bcc     L361F                           ; 3625
        clc                                     ; 3627
        lda     L28B4,x                         ; 3628
        adc     #$D8                            ; 362B
        sta     L0006                           ; 362D
        lda     L28C5,x                         ; 362F
        adc     #$06                            ; 3632
        sta     $07                             ; 3634
        clc                                     ; 3636
        lda     L28B4,x                         ; 3637
        adc     #$2C                            ; 363A
        sta     $09                             ; 363C
        lda     L28C5,x                         ; 363E
        adc     #$08                            ; 3641
        sta     $0A                             ; 3643
        lda     #$36                            ; 3645
        cpx     #$0B                            ; 3647
        bcc     L364D                           ; 3649
        lda     #$B6                            ; 364B
L364D:  sta     $DB                             ; 364D
        ldy     #$13                            ; 364F
L3651:  lda     $DB                             ; 3651
        sta     (L0006),y                       ; 3653
        lda     #$01                            ; 3655
        sta     ($09),y                         ; 3657
        dey                                     ; 3659
        bpl     L3651                           ; 365A
        inx                                     ; 365C
        cpx     #$11                            ; 365D
        bcc     L360F                           ; 365F
        jsr     L28D6                           ; 3661
        lda     #$00                            ; 3664
        sta     L0006                           ; 3666
        ldy     #$80                            ; 3668
        ldx     #$4D                            ; 366A
L366C:  stx     $07                             ; 366C
L366E:  sta     (L0006),y                       ; 366E
        iny                                     ; 3670
        bne     L366E                           ; 3671
        inx                                     ; 3673
        cpx     #$58                            ; 3674
        bne     L366C                           ; 3676
        rts                                     ; 3678

; ----------------------------------------------------------------------------
L3679:  ldx     #$0F                            ; 3679
L367B:  txa                                     ; 367B
        pha                                     ; 367C
        jsr     L4272                           ; 367D
        tay                                     ; 3680
        pla                                     ; 3681
        tax                                     ; 3682
        tya                                     ; 3683
        pha                                     ; 3684
        lsr     a                               ; 3685
        lsr     a                               ; 3686
        lsr     a                               ; 3687
        lsr     a                               ; 3688
        sta     L36CC,x                         ; 3689
        dex                                     ; 368C
        pla                                     ; 368D
        and     #$0F                            ; 368E
        sta     L36CC,x                         ; 3690
        dex                                     ; 3693
        bpl     L367B                           ; 3694
        ldx     #$29                            ; 3696
L3698:  txa                                     ; 3698
        pha                                     ; 3699
        jsr     L4272                           ; 369A
        tay                                     ; 369D
        pla                                     ; 369E
        tax                                     ; 369F
        tya                                     ; 36A0
        pha                                     ; 36A1
        lsr     a                               ; 36A2
        lsr     a                               ; 36A3
        lsr     a                               ; 36A4
        lsr     a                               ; 36A5
        sta     L36DC,x                         ; 36A6
        dex                                     ; 36A9
        pla                                     ; 36AA
        and     #$0F                            ; 36AB
        sta     L36DC,x                         ; 36AD
        dex                                     ; 36B0
        bpl     L3698                           ; 36B1
        jsr     L4272                           ; 36B3
        pha                                     ; 36B6
        lsr     a                               ; 36B7
        lsr     a                               ; 36B8
        lsr     a                               ; 36B9
        lsr     a                               ; 36BA
        nop                                     ; 36BB
        nop                                     ; 36BC
        nop                                     ; 36BD
        nop                                     ; 36BE
        sta     L36C9                           ; 36BF
        pla                                     ; 36C2
        and     #$0F                            ; 36C3
        sta     L36CA                           ; 36C5
        rts                                     ; 36C8

; ----------------------------------------------------------------------------
L36C9:  brk                                     ; 36C9
L36CA:  brk                                     ; 36CA
        brk                                     ; 36CB
L36CC:  brk                                     ; 36CC
        brk                                     ; 36CD
        brk                                     ; 36CE
        brk                                     ; 36CF
        brk                                     ; 36D0
        brk                                     ; 36D1
        brk                                     ; 36D2
        brk                                     ; 36D3
        brk                                     ; 36D4
        brk                                     ; 36D5
        brk                                     ; 36D6
        brk                                     ; 36D7
        brk                                     ; 36D8
        brk                                     ; 36D9
        brk                                     ; 36DA
        brk                                     ; 36DB
L36DC:  brk                                     ; 36DC
        brk                                     ; 36DD
        brk                                     ; 36DE
        brk                                     ; 36DF
        brk                                     ; 36E0
        brk                                     ; 36E1
        brk                                     ; 36E2
        brk                                     ; 36E3
        brk                                     ; 36E4
        brk                                     ; 36E5
        brk                                     ; 36E6
        brk                                     ; 36E7
        brk                                     ; 36E8
        brk                                     ; 36E9
        brk                                     ; 36EA
        brk                                     ; 36EB
        brk                                     ; 36EC
        brk                                     ; 36ED
        brk                                     ; 36EE
        brk                                     ; 36EF
        brk                                     ; 36F0
        brk                                     ; 36F1
        brk                                     ; 36F2
        brk                                     ; 36F3
        brk                                     ; 36F4
        brk                                     ; 36F5
        brk                                     ; 36F6
        brk                                     ; 36F7
        brk                                     ; 36F8
        brk                                     ; 36F9
        brk                                     ; 36FA
        brk                                     ; 36FB
        brk                                     ; 36FC
        brk                                     ; 36FD
        brk                                     ; 36FE
        brk                                     ; 36FF
        brk                                     ; 3700
        brk                                     ; 3701
        brk                                     ; 3702
        brk                                     ; 3703
        brk                                     ; 3704
        brk                                     ; 3705
L3706:  sei                                     ; 3706
        ldx     #$25                            ; 3707
        lda     #$37                            ; 3709
        stx     $FFFE                           ; 370B
        sta     $FFFF                           ; 370E
        lda     #$58                            ; 3711
        sta     $FF14                           ; 3713
        lda     #$37                            ; 3716
        sta     $FF06                           ; 3718
        lda     #$18                            ; 371B
        sta     $FF12                           ; 371D
        sta     $FF07                           ; 3720
        cli                                     ; 3723
        rts                                     ; 3724

; ----------------------------------------------------------------------------
        sta     L3743                           ; 3725
        stx     L3741                           ; 3728
        sty     L373F                           ; 372B
        cld                                     ; 372E
        jsr     L4C31                           ; 372F
        jsr     L4CD7                           ; 3732
        jsr     L4B7A                           ; 3735
        lda     $FF09                           ; 3738
        sta     $FF09                           ; 373B
        .byte   $A0                             ; 373E
L373F:  brk                                     ; 373F
        .byte   $A2                             ; 3740
L3741:  brk                                     ; 3741
        .byte   $A9                             ; 3742
L3743:  brk                                     ; 3743
        rti                                     ; 3744

; ----------------------------------------------------------------------------
        brk                                     ; 3745
        brk                                     ; 3746
        brk                                     ; 3747
        brk                                     ; 3748
        brk                                     ; 3749
        brk                                     ; 374A
        brk                                     ; 374B
        brk                                     ; 374C
        brk                                     ; 374D
        brk                                     ; 374E
        brk                                     ; 374F
        brk                                     ; 3750
        brk                                     ; 3751
        brk                                     ; 3752
        brk                                     ; 3753
        brk                                     ; 3754
        brk                                     ; 3755
        brk                                     ; 3756
        brk                                     ; 3757
        brk                                     ; 3758
        brk                                     ; 3759
        brk                                     ; 375A
        brk                                     ; 375B
        brk                                     ; 375C
        brk                                     ; 375D
        brk                                     ; 375E
        brk                                     ; 375F
        brk                                     ; 3760
        brk                                     ; 3761
        brk                                     ; 3762
        brk                                     ; 3763
        brk                                     ; 3764
        brk                                     ; 3765
        brk                                     ; 3766
        brk                                     ; 3767
        brk                                     ; 3768
        brk                                     ; 3769
        brk                                     ; 376A
        brk                                     ; 376B
        brk                                     ; 376C
        brk                                     ; 376D
        brk                                     ; 376E
        brk                                     ; 376F
        brk                                     ; 3770
        brk                                     ; 3771
        brk                                     ; 3772
        brk                                     ; 3773
        brk                                     ; 3774
        brk                                     ; 3775
        brk                                     ; 3776
        brk                                     ; 3777
        brk                                     ; 3778
        brk                                     ; 3779
        brk                                     ; 377A
        brk                                     ; 377B
        brk                                     ; 377C
        brk                                     ; 377D
        brk                                     ; 377E
        brk                                     ; 377F
        brk                                     ; 3780
        brk                                     ; 3781
        brk                                     ; 3782
        brk                                     ; 3783
        brk                                     ; 3784
        brk                                     ; 3785
        brk                                     ; 3786
        brk                                     ; 3787
        brk                                     ; 3788
        brk                                     ; 3789
        brk                                     ; 378A
        brk                                     ; 378B
        brk                                     ; 378C
        brk                                     ; 378D
        brk                                     ; 378E
        sta     $FF3E                           ; 378F
        jmp     LFFF6                           ; 3792

; ----------------------------------------------------------------------------
L3795:  lda     $D6                             ; 3795
        sta     L37B7                           ; 3797
        sta     L37C8                           ; 379A
        lda     $D7                             ; 379D
        sta     L37B8                           ; 379F
        sta     L37C9                           ; 37A2
        jsr     LFFE4                           ; 37A5
        lda     $D5                             ; 37A8
        cmp     #$03                            ; 37AA
        beq     L37BF                           ; 37AC
        bcs     L37D3                           ; 37AE
        cmp     #$02                            ; 37B0
        bne     L37C2                           ; 37B2
        ldx     #$00                            ; 37B4
L37B6:  .byte   $BD                             ; 37B6
L37B7:  .byte   $FF                             ; 37B7
L37B8:  .byte   $FF                             ; 37B8
        jsr     LFF20                           ; 37B9
        inx                                     ; 37BC
        bne     L37B6                           ; 37BD
L37BF:  jmp     L37CD                           ; 37BF

; ----------------------------------------------------------------------------
L37C2:  ldx     #$00                            ; 37C2
L37C4:  jsr     LFF5A                           ; 37C4
        .byte   $9D                             ; 37C7
L37C8:  .byte   $FF                             ; 37C8
L37C9:  .byte   $FF                             ; 37C9
        inx                                     ; 37CA
        bne     L37C4                           ; 37CB
L37CD:  jsr     LFF5A                           ; 37CD
        sta     $FFFB                           ; 37D0
L37D3:  lda     #$C8                            ; 37D3
L37D5:  sta     $01                             ; 37D5
        lda     $FFFB                           ; 37D7
        cmp     #$01                            ; 37DA
        rts                                     ; 37DC

; ----------------------------------------------------------------------------
L37DD:  ora     $15,x                           ; 37DD
        ora     $15,x                           ; 37DF
        ora     $15,x                           ; 37E1
        ora     $15,x                           ; 37E3
        ora     $15,x                           ; 37E5
        ora     $15,x                           ; 37E7
        ora     $15,x                           ; 37E9
        ora     $15,x                           ; 37EB
        ora     $13,x                           ; 37ED
        .byte   $13                             ; 37EF
        .byte   $13                             ; 37F0
        .byte   $13                             ; 37F1
        .byte   $13                             ; 37F2
        .byte   $13                             ; 37F3
        .byte   $12                             ; 37F4
        .byte   $12                             ; 37F5
        .byte   $12                             ; 37F6
        .byte   $12                             ; 37F7
        .byte   $12                             ; 37F8
        .byte   $12                             ; 37F9
        ora     ($11),y                         ; 37FA
        ora     ($11),y                         ; 37FC
        ora     ($FF),y                         ; 37FE
L3800:  sta     $07                             ; 3800
        stx     L0006                           ; 3802
        txa                                     ; 3804
        asl     a                               ; 3805
        sta     $4A                             ; 3806
        ldy     #$00                            ; 3808
        sty     $4B                             ; 380A
        jsr     L38ED                           ; 380C
        lda     ($4A),y                         ; 380F
        tax                                     ; 3811
        iny                                     ; 3812
        ora     ($4A),y                         ; 3813
        beq     L3828                           ; 3815
        lda     ($4A),y                         ; 3817
        stx     $4A                             ; 3819
        sta     $4B                             ; 381B
        jsr     L38ED                           ; 381D
        ldx     L0006                           ; 3820
        lda     $07                             ; 3822
        sta     $42,x                           ; 3824
        lda     #$FF                            ; 3826
L3828:  ldx     L0006                           ; 3828
        sta     $46,x                           ; 382A
L382C:  txa                                     ; 382C
        asl     a                               ; 382D
        tay                                     ; 382E
        ldx     $4E                             ; 382F
        sec                                     ; 3831
        lda     $4A                             ; 3832
        sbc     $0200,x                         ; 3834
        sta     $3A,y                           ; 3837
        lda     $4B                             ; 383A
        sbc     $0220,x                         ; 383C
        sta     $3B,y                           ; 383F
L3842:  rts                                     ; 3842

; ----------------------------------------------------------------------------
L3843:  lda     $4D                             ; 3843
        beq     L3842                           ; 3845
        lda     #$0A                            ; 3847
        jsr     L3D13                           ; 3849
        bcs     L3865                           ; 384C
        lda     L4C27                           ; 384E
        bne     L3842                           ; 3851
        lda     #$06                            ; 3853
        sta     L4C27                           ; 3855
        ldx     #$03                            ; 3858
L385A:  txa                                     ; 385A
        pha                                     ; 385B
        jsr     L3895                           ; 385C
        pla                                     ; 385F
        tax                                     ; 3860
        dex                                     ; 3861
        bpl     L385A                           ; 3862
        rts                                     ; 3864

; ----------------------------------------------------------------------------
L3865:  jsr     L386B                           ; 3865
        jmp     L3F51                           ; 3868

; ----------------------------------------------------------------------------
L386B:  lda     $4E                             ; 386B
        bmi     L3872                           ; 386D
        jsr     L4407                           ; 386F
L3872:  ldx     #$00                            ; 3872
        stx     $4D                             ; 3874
        dex                                     ; 3876
        stx     $4E                             ; 3877
        sei                                     ; 3879
        ldx     #$25                            ; 387A
        ldy     #$37                            ; 387C
        stx     $FFFE                           ; 387E
        sty     $FFFF                           ; 3881
        lda     #$CB                            ; 3884
        sta     $FF0B                           ; 3886
        cli                                     ; 3889
        rts                                     ; 388A

; ----------------------------------------------------------------------------
        brk                                     ; 388B
        brk                                     ; 388C
        brk                                     ; 388D
        brk                                     ; 388E
        brk                                     ; 388F
        brk                                     ; 3890
        brk                                     ; 3891
        brk                                     ; 3892
        brk                                     ; 3893
        brk                                     ; 3894
L3895:  lda     $46,x                           ; 3895
        beq     L389F                           ; 3897
        lda     $42,x                           ; 3899
        beq     L38A0                           ; 389B
        dec     $42,x                           ; 389D
L389F:  rts                                     ; 389F

; ----------------------------------------------------------------------------
L38A0:  txa                                     ; 38A0
        pha                                     ; 38A1
        asl     a                               ; 38A2
        tay                                     ; 38A3
        lda     $3A,y                           ; 38A4
        sta     $4A                             ; 38A7
        lda     $3B,y                           ; 38A9
        sta     $4B                             ; 38AC
        jsr     L38ED                           ; 38AE
        ldx     $4E                             ; 38B1
        ldy     #$01                            ; 38B3
        lda     ($4A),y                         ; 38B5
        adc     $0200,x                         ; 38B7
        sta     L3B54                           ; 38BA
        iny                                     ; 38BD
        lda     ($4A),y                         ; 38BE
        adc     $0220,x                         ; 38C0
        sta     L3B55                           ; 38C3
        jsr     L3914                           ; 38C6
        pla                                     ; 38C9
        tax                                     ; 38CA
        ldy     #$03                            ; 38CB
        lda     ($4A),y                         ; 38CD
        cmp     #$FF                            ; 38CF
        bcc     L38DA                           ; 38D1
        ldy     #$00                            ; 38D3
        lda     ($4A),y                         ; 38D5
        jmp     L3800                           ; 38D7

; ----------------------------------------------------------------------------
L38DA:  ldy     #$00                            ; 38DA
        lda     ($4A),y                         ; 38DC
        sta     $42,x                           ; 38DE
        lda     $4A                             ; 38E0
        adc     #$03                            ; 38E2
        sta     $4A                             ; 38E4
        bcc     L38EA                           ; 38E6
        inc     $4B                             ; 38E8
L38EA:  jmp     L382C                           ; 38EA

; ----------------------------------------------------------------------------
L38ED:  ldx     $4E                             ; 38ED
        clc                                     ; 38EF
        lda     $4A                             ; 38F0
        adc     $0200,x                         ; 38F2
        sta     $4A                             ; 38F5
        lda     $4B                             ; 38F7
        adc     $0220,x                         ; 38F9
        sta     $4B                             ; 38FC
L38FE:  rts                                     ; 38FE

; ----------------------------------------------------------------------------
L38FF:  jsr     L3B53                           ; 38FF
        cmp     #$FF                            ; 3902
        beq     L38FE                           ; 3904
        lsr     a                               ; 3906
        sta     $EB                             ; 3907
        lda     #$00                            ; 3909
        rol     a                               ; 390B
        rol     a                               ; 390C
        sta     $F1                             ; 390D
        jsr     L3B53                           ; 390F
        sta     $EC                             ; 3912
L3914:  jsr     L3B53                           ; 3914
        cmp     #$00                            ; 3917
        beq     L38FF                           ; 3919
        cmp     #$FF                            ; 391B
        beq     L394F                           ; 391D
        tax                                     ; 391F
        and     #$0F                            ; 3920
        sta     $DB                             ; 3922
        jsr     L018C                           ; 3924
        sta     $DC                             ; 3927
        jsr     L3968                           ; 3929
        eor     $DC                             ; 392C
        cmp     #$05                            ; 392E
        bcs     L3937                           ; 3930
        jsr     L39BD                           ; 3932
        lda     #$05                            ; 3935
L3937:  jsr     L39BD                           ; 3937
L393A:  inc     $F1                             ; 393A
        jsr     L3968                           ; 393C
        eor     $DB                             ; 393F
        cmp     #$05                            ; 3941
        bcs     L394A                           ; 3943
        jsr     L39BD                           ; 3945
        lda     #$05                            ; 3948
L394A:  jsr     L39BD                           ; 394A
        dec     $F1                             ; 394D
L394F:  inc     $EC                             ; 394F
        lda     $EC                             ; 3951
        cmp     #$88                            ; 3953
        bcc     L3914                           ; 3955
        lda     $F1                             ; 3957
        eor     #$02                            ; 3959
        sta     $F1                             ; 395B
        bne     L3961                           ; 395D
        inc     $EB                             ; 395F
L3961:  lda     $EB                             ; 3961
        cmp     #$12                            ; 3963
        bcc     L3914                           ; 3965
        rts                                     ; 3967

; ----------------------------------------------------------------------------
L3968:  clc                                     ; 3968
        lda     $EB                             ; 3969
        adc     #$03                            ; 396B
        tax                                     ; 396D
        lda     $EC                             ; 396E
        adc     #$08                            ; 3970
        tay                                     ; 3972
        jsr     L0160                           ; 3973
        sty     L0006                           ; 3976
        sta     $07                             ; 3978
        ldx     $EB                             ; 397A
        ldy     $EC                             ; 397C
        lda     L3A09,x                         ; 397E
        adc     L3A2E,y                         ; 3981
        sta     $09                             ; 3984
        lda     L3A1B,x                         ; 3986
        adc     L3AC1,y                         ; 3989
        sta     $0A                             ; 398C
        ldx     $F1                             ; 398E
        ldy     #$00                            ; 3990
        lda     ($09),y                         ; 3992
        and     L3A05,x                         ; 3994
        bne     L39A0                           ; 3997
        lda     (L0006),y                       ; 3999
        and     L3A05,x                         ; 399B
        iny                                     ; 399E
        .byte   $2C                             ; 399F
L39A0:  ldy     #$05                            ; 39A0
        sty     L39BB                           ; 39A2
        cpx     #$03                            ; 39A5
        bcs     L39B7                           ; 39A7
        lsr     a                               ; 39A9
        lsr     a                               ; 39AA
        cpx     #$02                            ; 39AB
        bcs     L39B7                           ; 39AD
        lsr     a                               ; 39AF
        lsr     a                               ; 39B0
        cpx     #$01                            ; 39B1
        bcs     L39B7                           ; 39B3
        lsr     a                               ; 39B5
        lsr     a                               ; 39B6
L39B7:  and     #$0F                            ; 39B7
        clc                                     ; 39B9
        .byte   $69                             ; 39BA
L39BB:  brk                                     ; 39BB
        rts                                     ; 39BC

; ----------------------------------------------------------------------------
L39BD:  tax                                     ; 39BD
        lda     L39FC,x                         ; 39BE
        sta     L39F4                           ; 39C1
        cpx     #$05                            ; 39C4
        ldx     $EB                             ; 39C6
        ldy     $EC                             ; 39C8
        bcs     L39DC                           ; 39CA
        inx                                     ; 39CC
        inx                                     ; 39CD
        inx                                     ; 39CE
        tya                                     ; 39CF
        adc     #$08                            ; 39D0
        tay                                     ; 39D2
        jsr     L0160                           ; 39D3
        sty     L0006                           ; 39D6
        sta     $07                             ; 39D8
        bne     L39ED                           ; 39DA
L39DC:  clc                                     ; 39DC
        lda     L3A09,x                         ; 39DD
        adc     L3A2E,y                         ; 39E0
        sta     L0006                           ; 39E3
        lda     L3A1B,x                         ; 39E5
        adc     L3AC1,y                         ; 39E8
        sta     $07                             ; 39EB
L39ED:  ldx     $F1                             ; 39ED
        ldy     #$00                            ; 39EF
        lda     (L0006),y                       ; 39F1
        .byte   $49                             ; 39F3
L39F4:  brk                                     ; 39F4
        and     L3A05,x                         ; 39F5
        eor     (L0006),y                       ; 39F8
        sta     (L0006),y                       ; 39FA
L39FC:  rts                                     ; 39FC

; ----------------------------------------------------------------------------
        brk                                     ; 39FD
        eor     L00AA,x                         ; 39FE
        .byte   $FF                             ; 3A00
        brk                                     ; 3A01
        eor     L00AA,x                         ; 3A02
        .byte   $FF                             ; 3A04
L3A05:  cpy     #$30                            ; 3A05
        .byte   $0C                             ; 3A07
        .byte   $03                             ; 3A08
L3A09:  brk                                     ; 3A09
        .byte   $01                             ; 3A0A
L3A0B:  .byte   $02                             ; 3A0B
        rti                                     ; 3A0C

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; 3A0D
        .byte   $80                             ; 3A0F
        sta     ($82,x)                         ; 3A10
        cpy     #$C1                            ; 3A12
        .byte   $C2                             ; 3A14
        brk                                     ; 3A15
        ora     ($02,x)                         ; 3A16
        rti                                     ; 3A18

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; 3A19
L3A1B:  brk                                     ; 3A1B
        brk                                     ; 3A1C
        brk                                     ; 3A1D
        brk                                     ; 3A1E
        brk                                     ; 3A1F
        brk                                     ; 3A20
        brk                                     ; 3A21
        brk                                     ; 3A22
        brk                                     ; 3A23
        brk                                     ; 3A24
        brk                                     ; 3A25
        brk                                     ; 3A26
        ora     ($01,x)                         ; 3A27
        ora     ($01,x)                         ; 3A29
        ora     ($01,x)                         ; 3A2B
        .byte   $80                             ; 3A2D
L3A2E:  .byte   $83                             ; 3A2E
        stx     $89                             ; 3A2F
        sty     $928F                           ; 3A31
        sta     $98,x                           ; 3A34
        .byte   $9B                             ; 3A36
        .byte   $9E                             ; 3A37
        lda     ($A4,x)                         ; 3A38
        .byte   $A7                             ; 3A3A
        tax                                     ; 3A3B
        lda     $B3B0                           ; 3A3C
        ldx     $B9,y                           ; 3A3F
        ldy     $0300,x                         ; 3A41
        asl     $09                             ; 3A44
        .byte   $0C                             ; 3A46
        .byte   $0F                             ; 3A47
        .byte   $12                             ; 3A48
        ora     $18,x                           ; 3A49
        .byte   $1B                             ; 3A4B
        asl     L2421,x                         ; 3A4C
        .byte   $27                             ; 3A4F
        rol     a                               ; 3A50
        and     L3330                           ; 3A51
        rol     $39,x                           ; 3A54
        .byte   $3C                             ; 3A56
        .byte   $80                             ; 3A57
        .byte   $83                             ; 3A58
        stx     $89                             ; 3A59
        sty     $928F                           ; 3A5B
        sta     $98,x                           ; 3A5E
        .byte   $9B                             ; 3A60
        .byte   $9E                             ; 3A61
        lda     ($A4,x)                         ; 3A62
        .byte   $A7                             ; 3A64
        tax                                     ; 3A65
        lda     $B3B0                           ; 3A66
        ldx     $B9,y                           ; 3A69
        ldy     $0300,x                         ; 3A6B
        asl     $09                             ; 3A6E
        .byte   $0C                             ; 3A70
        .byte   $0F                             ; 3A71
        .byte   $12                             ; 3A72
        ora     $18,x                           ; 3A73
        .byte   $1B                             ; 3A75
        asl     L2421,x                         ; 3A76
        .byte   $27                             ; 3A79
        rol     a                               ; 3A7A
        and     L3330                           ; 3A7B
        rol     $39,x                           ; 3A7E
        .byte   $3C                             ; 3A80
        .byte   $80                             ; 3A81
        .byte   $83                             ; 3A82
        stx     $89                             ; 3A83
        sty     $928F                           ; 3A85
        sta     $98,x                           ; 3A88
        .byte   $9B                             ; 3A8A
        .byte   $9E                             ; 3A8B
        lda     ($A4,x)                         ; 3A8C
        .byte   $A7                             ; 3A8E
        tax                                     ; 3A8F
        lda     $B3B0                           ; 3A90
        ldx     $B9,y                           ; 3A93
        ldy     $0300,x                         ; 3A95
        asl     $09                             ; 3A98
        .byte   $0C                             ; 3A9A
        .byte   $0F                             ; 3A9B
        .byte   $12                             ; 3A9C
        ora     $18,x                           ; 3A9D
        .byte   $1B                             ; 3A9F
        asl     L2421,x                         ; 3AA0
        .byte   $27                             ; 3AA3
        rol     a                               ; 3AA4
        and     L3330                           ; 3AA5
        rol     $39,x                           ; 3AA8
        .byte   $3C                             ; 3AAA
        .byte   $80                             ; 3AAB
        .byte   $83                             ; 3AAC
        stx     $89                             ; 3AAD
        sty     $928F                           ; 3AAF
        sta     $98,x                           ; 3AB2
        .byte   $9B                             ; 3AB4
        .byte   $9E                             ; 3AB5
        lda     ($A4,x)                         ; 3AB6
        .byte   $A7                             ; 3AB8
        tax                                     ; 3AB9
        lda     $B3B0                           ; 3ABA
        ldx     $B9,y                           ; 3ABD
        .byte   $BC                             ; 3ABF
        .byte   $4D                             ; 3AC0
L3AC1:  eor     L4D4D                           ; 3AC1
        eor     L4D4D                           ; 3AC4
        eor     L4D4D                           ; 3AC7
        eor     L4D4D                           ; 3ACA
        eor     L4D4D                           ; 3ACD
        eor     L4D4D                           ; 3AD0
        eor     L4F4D                           ; 3AD3
        .byte   $4F                             ; 3AD6
        .byte   $4F                             ; 3AD7
        .byte   $4F                             ; 3AD8
        .byte   $4F                             ; 3AD9
        .byte   $4F                             ; 3ADA
        .byte   $4F                             ; 3ADB
        .byte   $4F                             ; 3ADC
        .byte   $4F                             ; 3ADD
        .byte   $4F                             ; 3ADE
        .byte   $4F                             ; 3ADF
        .byte   $4F                             ; 3AE0
        .byte   $4F                             ; 3AE1
        .byte   $4F                             ; 3AE2
        .byte   $4F                             ; 3AE3
        .byte   $4F                             ; 3AE4
        .byte   $4F                             ; 3AE5
        .byte   $4F                             ; 3AE6
        .byte   $4F                             ; 3AE7
        .byte   $4F                             ; 3AE8
        .byte   $4F                             ; 3AE9
        bvc     L3B3C                           ; 3AEA
        bvc     L3B3E                           ; 3AEC
        bvc     L3B40                           ; 3AEE
        bvc     L3B42                           ; 3AF0
        bvc     L3B44                           ; 3AF2
        bvc     L3B46                           ; 3AF4
        bvc     L3B48                           ; 3AF6
        bvc     L3B4A                           ; 3AF8
        bvc     L3B4C                           ; 3AFA
        bvc     L3B4E                           ; 3AFC
        bvc     L3B52                           ; 3AFE
        .byte   $52                             ; 3B00
        .byte   $52                             ; 3B01
        .byte   $52                             ; 3B02
        .byte   $52                             ; 3B03
        .byte   $52                             ; 3B04
        .byte   $52                             ; 3B05
        .byte   $52                             ; 3B06
        .byte   $52                             ; 3B07
        .byte   $52                             ; 3B08
        .byte   $52                             ; 3B09
        .byte   $52                             ; 3B0A
        .byte   $52                             ; 3B0B
        .byte   $52                             ; 3B0C
        .byte   $52                             ; 3B0D
        .byte   $52                             ; 3B0E
        .byte   $52                             ; 3B0F
        .byte   $52                             ; 3B10
        .byte   $52                             ; 3B11
        .byte   $52                             ; 3B12
        .byte   $52                             ; 3B13
        .byte   $53                             ; 3B14
        .byte   $53                             ; 3B15
        .byte   $53                             ; 3B16
        .byte   $53                             ; 3B17
        .byte   $53                             ; 3B18
        .byte   $53                             ; 3B19
        .byte   $53                             ; 3B1A
        .byte   $53                             ; 3B1B
        .byte   $53                             ; 3B1C
        .byte   $53                             ; 3B1D
        .byte   $53                             ; 3B1E
        .byte   $53                             ; 3B1F
        .byte   $53                             ; 3B20
        .byte   $53                             ; 3B21
        .byte   $53                             ; 3B22
        .byte   $53                             ; 3B23
        .byte   $53                             ; 3B24
        .byte   $53                             ; 3B25
        .byte   $53                             ; 3B26
        .byte   $53                             ; 3B27
        .byte   $53                             ; 3B28
        eor     $55,x                           ; 3B29
        eor     $55,x                           ; 3B2B
        eor     $55,x                           ; 3B2D
        eor     $55,x                           ; 3B2F
        eor     $55,x                           ; 3B31
        eor     $55,x                           ; 3B33
        eor     $55,x                           ; 3B35
        eor     $55,x                           ; 3B37
        eor     $55,x                           ; 3B39
        .byte   $55                             ; 3B3B
L3B3C:  eor     $55,x                           ; 3B3C
L3B3E:  lsr     $56,x                           ; 3B3E
L3B40:  lsr     $56,x                           ; 3B40
L3B42:  lsr     $56,x                           ; 3B42
L3B44:  lsr     $56,x                           ; 3B44
L3B46:  lsr     $56,x                           ; 3B46
L3B48:  lsr     $56,x                           ; 3B48
L3B4A:  lsr     $56,x                           ; 3B4A
L3B4C:  lsr     $56,x                           ; 3B4C
L3B4E:  lsr     $56,x                           ; 3B4E
        lsr     $56,x                           ; 3B50
L3B52:  .byte   $56                             ; 3B52
L3B53:  .byte   $AD                             ; 3B53
L3B54:  .byte   $FF                             ; 3B54
L3B55:  .byte   $FF                             ; 3B55
        inc     L3B54                           ; 3B56
        beq     L3B5C                           ; 3B59
        rts                                     ; 3B5B

; ----------------------------------------------------------------------------
L3B5C:  inc     L3B55                           ; 3B5C
        rts                                     ; 3B5F

; ----------------------------------------------------------------------------
L3B60:  lda     #$0A                            ; 3B60
        jsr     L3D13                           ; 3B62
        bcc     L3B68                           ; 3B65
        rts                                     ; 3B67

; ----------------------------------------------------------------------------
L3B68:  ldx     L3BF6                           ; 3B68
L3B6B:  lda     L2892,x                         ; 3B6B
        sta     a:$E4                           ; 3B6E
        lda     L28A3,x                         ; 3B71
        sta     a:$E5                           ; 3B74
        clc                                     ; 3B77
        lda     L28B4,x                         ; 3B78
        adc     #$D6                            ; 3B7B
        sta     $2E                             ; 3B7D
        lda     L28C5,x                         ; 3B7F
        adc     #$06                            ; 3B82
        sta     $2F                             ; 3B84
        clc                                     ; 3B86
        lda     L28B4,x                         ; 3B87
        adc     #$2A                            ; 3B8A
        sta     $30                             ; 3B8C
        lda     L28C5,x                         ; 3B8E
        adc     #$08                            ; 3B91
        sta     $31                             ; 3B93
        txa                                     ; 3B95
        pha                                     ; 3B96
        sec                                     ; 3B97
        adc     L3BF9                           ; 3B98
        pha                                     ; 3B9B
        jsr     L3EF0                           ; 3B9C
        pla                                     ; 3B9F
        tay                                     ; 3BA0
        lda     #$10                            ; 3BA1
        adc     $0100,y                         ; 3BA3
        sta     L0006                           ; 3BA6
        lda     $0118,y                         ; 3BA8
        sta     $07                             ; 3BAB
        jsr     L0543                           ; 3BAD
        jmp     L3BEA                           ; 3BB0

; ----------------------------------------------------------------------------
        nop                                     ; 3BB3
        nop                                     ; 3BB4
        nop                                     ; 3BB5
        nop                                     ; 3BB6
        nop                                     ; 3BB7
        nop                                     ; 3BB8
        nop                                     ; 3BB9
        nop                                     ; 3BBA
        nop                                     ; 3BBB
        nop                                     ; 3BBC
        nop                                     ; 3BBD
        nop                                     ; 3BBE
        nop                                     ; 3BBF
        nop                                     ; 3BC0
        nop                                     ; 3BC1
        nop                                     ; 3BC2
        nop                                     ; 3BC3
        nop                                     ; 3BC4
        nop                                     ; 3BC5
        nop                                     ; 3BC6
        nop                                     ; 3BC7
        nop                                     ; 3BC8
        nop                                     ; 3BC9
        nop                                     ; 3BCA
        nop                                     ; 3BCB
        nop                                     ; 3BCC
        nop                                     ; 3BCD
        nop                                     ; 3BCE
        nop                                     ; 3BCF
        nop                                     ; 3BD0
        nop                                     ; 3BD1
        nop                                     ; 3BD2
        nop                                     ; 3BD3
        nop                                     ; 3BD4
        nop                                     ; 3BD5
        nop                                     ; 3BD6
        nop                                     ; 3BD7
        nop                                     ; 3BD8
        nop                                     ; 3BD9
        nop                                     ; 3BDA
        nop                                     ; 3BDB
        nop                                     ; 3BDC
        nop                                     ; 3BDD
        nop                                     ; 3BDE
        nop                                     ; 3BDF
        nop                                     ; 3BE0
        nop                                     ; 3BE1
        nop                                     ; 3BE2
        nop                                     ; 3BE3
        nop                                     ; 3BE4
        nop                                     ; 3BE5
        nop                                     ; 3BE6
        nop                                     ; 3BE7
        nop                                     ; 3BE8
        nop                                     ; 3BE9
L3BEA:  pla                                     ; 3BEA
        tax                                     ; 3BEB
        inx                                     ; 3BEC
        cpx     L3BF7                           ; 3BED
        bcs     L3BF5                           ; 3BF0
        jmp     L3B6B                           ; 3BF2

; ----------------------------------------------------------------------------
L3BF5:  rts                                     ; 3BF5

; ----------------------------------------------------------------------------
L3BF6:  brk                                     ; 3BF6
L3BF7:  .byte   $11                             ; 3BF7
L3BF8:  .byte   $14                             ; 3BF8
L3BF9:  brk                                     ; 3BF9
L3BFA:  stx     L0006                           ; 3BFA
        sty     $07                             ; 3BFC
        ldy     #$03                            ; 3BFE
L3C00:  lda     (L0006),y                       ; 3C00
        sta     $67,y                           ; 3C02
        dey                                     ; 3C05
        bpl     L3C00                           ; 3C06
        jsr     L25D9                           ; 3C08
        lda     $66                             ; 3C0B
        beq     L3C3D                           ; 3C0D
        jsr     L3CED                           ; 3C0F
        lda     $62                             ; 3C12
        cmp     $67                             ; 3C14
        bcc     L3C37                           ; 3C16
        lda     $63                             ; 3C18
        cmp     $68                             ; 3C1A
        bcc     L3C37                           ; 3C1C
        lda     $69                             ; 3C1E
        cmp     $64                             ; 3C20
        bcc     L3C37                           ; 3C22
        lda     $6A                             ; 3C24
        cmp     $65                             ; 3C26
        bcc     L3C37                           ; 3C28
        ldx     #$04                            ; 3C2A
L3C2C:  dex                                     ; 3C2C
        bmi     L3C7C                           ; 3C2D
        lda     $67,x                           ; 3C2F
        cmp     $62,x                           ; 3C31
        beq     L3C2C                           ; 3C33
        bne     L3C3D                           ; 3C35
L3C37:  jsr     L3D00                           ; 3C37
        jsr     L3CB9                           ; 3C3A
L3C3D:  ldx     #$03                            ; 3C3D
L3C3F:  tay                                     ; 3C3F
        lda     $67,x                           ; 3C40
        sta     $62,x                           ; 3C42
        dex                                     ; 3C44
        bpl     L3C3F                           ; 3C45
        sta     $1B                             ; 3C47
        sty     $1D                             ; 3C49
        lda     #$80                            ; 3C4B
        jsr     L3C82                           ; 3C4D
        jmp     L3C62                           ; 3C50

; ----------------------------------------------------------------------------
L3C53:  lda     #$83                            ; 3C53
        jsr     L2686                           ; 3C55
        ldx     $64                             ; 3C58
        dex                                     ; 3C5A
        stx     $1B                             ; 3C5B
        lda     #$84                            ; 3C5D
        jsr     L2686                           ; 3C5F
L3C62:  lda     $62                             ; 3C62
        sta     $1B                             ; 3C64
        lda     $1D                             ; 3C66
        clc                                     ; 3C68
        adc     #$08                            ; 3C69
        sta     $1D                             ; 3C6B
        adc     #$08                            ; 3C6D
        cmp     $65                             ; 3C6F
        bcc     L3C53                           ; 3C71
        lda     #$85                            ; 3C73
        jsr     L3C82                           ; 3C75
        lda     #$FF                            ; 3C78
        sta     $66                             ; 3C7A
L3C7C:  jsr     L3D00                           ; 3C7C
        jmp     L2704                           ; 3C7F

; ----------------------------------------------------------------------------
L3C82:  jsr     L2686                           ; 3C82
        clc                                     ; 3C85
        adc     #$01                            ; 3C86
L3C88:  jsr     L2686                           ; 3C88
        ldx     $1B                             ; 3C8B
        inx                                     ; 3C8D
        cpx     $64                             ; 3C8E
        bcc     L3C88                           ; 3C90
        adc     #$00                            ; 3C92
        jmp     L2686                           ; 3C94

; ----------------------------------------------------------------------------
L3C97:  jsr     L25D9                           ; 3C97
        lda     $66                             ; 3C9A
        beq     L3CA1                           ; 3C9C
        jsr     L3CB9                           ; 3C9E
L3CA1:  ldy     #$00                            ; 3CA1
        sty     $66                             ; 3CA3
        iny                                     ; 3CA5
        sty     $62                             ; 3CA6
        sty     $1B                             ; 3CA8
        lda     #$27                            ; 3CAA
        sta     $64                             ; 3CAC
        lda     #$98                            ; 3CAE
        sta     $63                             ; 3CB0
        sta     $1D                             ; 3CB2
        lda     #$B8                            ; 3CB4
        sta     $65                             ; 3CB6
        rts                                     ; 3CB8

; ----------------------------------------------------------------------------
L3CB9:  lda     #$00                            ; 3CB9
        sta     $66                             ; 3CBB
        pha                                     ; 3CBD
        jsr     L3D17                           ; 3CBE
        bcc     L3CDA                           ; 3CC1
        pla                                     ; 3CC3
        pha                                     ; 3CC4
        cmp     #$09                            ; 3CC5
        bcc     L3CD7                           ; 3CC7
        tay                                     ; 3CC9
        ldx     L3CDA,y                         ; 3CCA
        lda     L3CDF,y                         ; 3CCD
        tay                                     ; 3CD0
        jsr     L2C76                           ; 3CD1
        jmp     L3CDA                           ; 3CD4

; ----------------------------------------------------------------------------
L3CD7:  jsr     L3E58                           ; 3CD7
L3CDA:  pla                                     ; 3CDA
        clc                                     ; 3CDB
        adc     #$01                            ; 3CDC
        .byte   $C9                             ; 3CDE
L3CDF:  asl     $DB90                           ; 3CDF
        rts                                     ; 3CE2

; ----------------------------------------------------------------------------
        ora     ($60),y                         ; 3CE3
        cmp     ($CA),y                         ; 3CE5
        .byte   $7B                             ; 3CE7
        jmp     L493B                           ; 3CE8

; ----------------------------------------------------------------------------
        .byte   $3D                             ; 3CEB
        .byte   $3D                             ; 3CEC
L3CED:  lda     $65                             ; 3CED
        clc                                     ; 3CEF
        adc     #$08                            ; 3CF0
        sta     $65                             ; 3CF2
        lda     $63                             ; 3CF4
        sec                                     ; 3CF6
        sbc     #$08                            ; 3CF7
        sta     $63                             ; 3CF9
        inc     $64                             ; 3CFB
        dec     $62                             ; 3CFD
        rts                                     ; 3CFF

; ----------------------------------------------------------------------------
L3D00:  lda     $63                             ; 3D00
        clc                                     ; 3D02
        adc     #$08                            ; 3D03
        sta     $63                             ; 3D05
        lda     $65                             ; 3D07
        sec                                     ; 3D09
        sbc     #$08                            ; 3D0A
        sta     $65                             ; 3D0C
        dec     $64                             ; 3D0E
        inc     $62                             ; 3D10
        rts                                     ; 3D12

; ----------------------------------------------------------------------------
L3D13:  ldx     $66                             ; 3D13
        beq     L3D41                           ; 3D15
L3D17:  asl     a                               ; 3D17
        asl     a                               ; 3D18
        tax                                     ; 3D19
        jsr     L3CED                           ; 3D1A
        lda     L3D43,x                         ; 3D1D
        cmp     $64                             ; 3D20
        bcs     L3D3E                           ; 3D22
        lda     L3D44,x                         ; 3D24
        cmp     $65                             ; 3D27
        bcs     L3D3E                           ; 3D29
        lda     $62                             ; 3D2B
        cmp     L3D45,x                         ; 3D2D
        bcs     L3D3E                           ; 3D30
        lda     $63                             ; 3D32
        cmp     L3D46,x                         ; 3D34
        bcs     L3D3E                           ; 3D37
        jsr     L3D00                           ; 3D39
        sec                                     ; 3D3C
        rts                                     ; 3D3D

; ----------------------------------------------------------------------------
L3D3E:  jsr     L3D00                           ; 3D3E
L3D41:  clc                                     ; 3D41
        rts                                     ; 3D42

; ----------------------------------------------------------------------------
L3D43:  brk                                     ; 3D43
L3D44:  clv                                     ; 3D44
L3D45:  plp                                     ; 3D45
L3D46:  cpy     #$00                            ; 3D46
        tya                                     ; 3D48
        ora     ($B8,x)                         ; 3D49
        .byte   $27                             ; 3D4B
        tya                                     ; 3D4C
        plp                                     ; 3D4D
        clv                                     ; 3D4E
        brk                                     ; 3D4F
        bcc     L3D7A                           ; 3D50
        tya                                     ; 3D52
        .byte   $27                             ; 3D53
        brk                                     ; 3D54
        plp                                     ; 3D55
        bcc     L3D73                           ; 3D56
        brk                                     ; 3D58
        .byte   $27                             ; 3D59
        jsr     L0800                           ; 3D5A
        .byte   $02                             ; 3D5D
        bcc     L3D60                           ; 3D5E
L3D60:  brk                                     ; 3D60
        .byte   $04                             ; 3D61
        php                                     ; 3D62
        .byte   $14                             ; 3D63
        brk                                     ; 3D64
        asl     $08,x                           ; 3D65
        asl     $00,x                           ; 3D67
        .byte   $1B                             ; 3D69
        bcc     L3D71                           ; 3D6A
        php                                     ; 3D6C
        asl     $90,x                           ; 3D6D
        .byte   $1B                             ; 3D6F
        php                                     ; 3D70
L3D71:  .byte   $27                             ; 3D71
        sei                                     ; 3D72
L3D73:  asl     $00                             ; 3D73
        .byte   $14                             ; 3D75
        php                                     ; 3D76
        ora     ($98,x)                         ; 3D77
        .byte   $27                             ; 3D79
L3D7A:  clv                                     ; 3D7A
        lda     #$01                            ; 3D7B
        sta     $62                             ; 3D7D
        lda     #$27                            ; 3D7F
        sta     $64                             ; 3D81
        lda     #$98                            ; 3D83
        sta     $63                             ; 3D85
        lda     #$B8                            ; 3D87
        sta     $65                             ; 3D89
        jmp     L2704                           ; 3D8B

; ----------------------------------------------------------------------------
L3D8E:  lda     #$A9                            ; 3D8E
        sta     L25BF                           ; 3D90
        lda     #$3D                            ; 3D93
        sta     L25C0                           ; 3D95
        lda     #$00                            ; 3D98
        sta     L3E36                           ; 3D9A
        jsr     L476C                           ; 3D9D
        jsr     L25CE                           ; 3DA0
        jsr     L3DB7                           ; 3DA3
        jmp     L47C5                           ; 3DA6

; ----------------------------------------------------------------------------
        ldx     L3E36                           ; 3DA9
        cpx     #$10                            ; 3DAC
        bcs     L3DB6                           ; 3DAE
        sta     L3E37,x                         ; 3DB0
        inc     L3E36                           ; 3DB3
L3DB6:  rts                                     ; 3DB6

; ----------------------------------------------------------------------------
L3DB7:  ldx     L3E36                           ; 3DB7
        cpx     L3E47                           ; 3DBA
        bne     L3DCA                           ; 3DBD
L3DBF:  dex                                     ; 3DBF
        bmi     L3DB6                           ; 3DC0
        lda     L3E37,x                         ; 3DC2
        cmp     L3E48,x                         ; 3DC5
        beq     L3DBF                           ; 3DC8
L3DCA:  lda     $1D                             ; 3DCA
        pha                                     ; 3DCC
        lda     $1B                             ; 3DCD
        pha                                     ; 3DCF
        lda     #$10                            ; 3DD0
        jsr     L27D7                           ; 3DD2
        lda     #$00                            ; 3DD5
        sta     $1D                             ; 3DD7
        lda     #$04                            ; 3DD9
        sta     $1B                             ; 3DDB
        lda     #$10                            ; 3DDD
        sec                                     ; 3DDF
        sbc     L3E36                           ; 3DE0
        lsr     a                               ; 3DE3
        clc                                     ; 3DE4
        adc     #$04                            ; 3DE5
        jsr     L3E25                           ; 3DE7
        ldx     L3E36                           ; 3DEA
        stx     L3E47                           ; 3DED
        beq     L3E01                           ; 3DF0
        ldy     #$00                            ; 3DF2
L3DF4:  lda     L3E37,y                         ; 3DF4
        sta     L3E48,y                         ; 3DF7
        jsr     L2686                           ; 3DFA
        iny                                     ; 3DFD
        dex                                     ; 3DFE
        bne     L3DF4                           ; 3DFF
L3E01:  lda     #$14                            ; 3E01
        jsr     L3E25                           ; 3E03
        jsr     L27D5                           ; 3E06
        pla                                     ; 3E09
        sta     $1B                             ; 3E0A
        pla                                     ; 3E0C
        sta     $1D                             ; 3E0D
        rts                                     ; 3E0F

; ----------------------------------------------------------------------------
L3E10:  pha                                     ; 3E10
        lda     #$11                            ; 3E11
        sta     L26E9                           ; 3E13
        lda     #$25                            ; 3E16
        sta     L26F5                           ; 3E18
        lda     $1B                             ; 3E1B
        and     #$01                            ; 3E1D
        ora     #$88                            ; 3E1F
        jsr     L2686                           ; 3E21
        pla                                     ; 3E24
L3E25:  cmp     $1B                             ; 3E25
        beq     L3E2B                           ; 3E27
        bcs     L3E10                           ; 3E29
L3E2B:  lda     #$11                            ; 3E2B
        sta     L26E9                           ; 3E2D
        lda     #$72                            ; 3E30
        sta     L26F5                           ; 3E32
        rts                                     ; 3E35

; ----------------------------------------------------------------------------
L3E36:  asl     a                               ; 3E36
L3E37:  cpy     $E1EF                           ; 3E37
        cpx     $E9                             ; 3E3A
        inc     $AEE7                           ; 3E3C
        ldx     a:$AE                           ; 3E3F
        brk                                     ; 3E42
        brk                                     ; 3E43
        brk                                     ; 3E44
        brk                                     ; 3E45
        brk                                     ; 3E46
L3E47:  .byte   $FF                             ; 3E47
L3E48:  .byte   $FF                             ; 3E48
        .byte   $FF                             ; 3E49
        .byte   $FF                             ; 3E4A
        .byte   $FF                             ; 3E4B
        .byte   $FF                             ; 3E4C
        .byte   $FF                             ; 3E4D
        .byte   $FF                             ; 3E4E
        .byte   $FF                             ; 3E4F
        .byte   $FF                             ; 3E50
        .byte   $FF                             ; 3E51
        .byte   $FF                             ; 3E52
        .byte   $FF                             ; 3E53
        .byte   $FF                             ; 3E54
        .byte   $FF                             ; 3E55
        .byte   $FF                             ; 3E56
        .byte   $FF                             ; 3E57
L3E58:  tay                                     ; 3E58
        lda     L1E18,y                         ; 3E59
        sta     $0C                             ; 3E5C
        lda     L1E2C,y                         ; 3E5E
        sta     $0D                             ; 3E61
        ldy     #$01                            ; 3E63
        lda     ($0C),y                         ; 3E65
        sta     $0B                             ; 3E67
        ldy     #$03                            ; 3E69
        lda     ($0C),y                         ; 3E6B
        sta     L0010                           ; 3E6D
        ldx     #$04                            ; 3E6F
L3E71:  ldy     #$00                            ; 3E71
        lda     ($0C),y                         ; 3E73
        sta     $18                             ; 3E75
        ldy     #$02                            ; 3E77
        lda     ($0C),y                         ; 3E79
        sta     $0E                             ; 3E7B
        txa                                     ; 3E7D
        tay                                     ; 3E7E
L3E7F:  tya                                     ; 3E7F
        pha                                     ; 3E80
        lda     ($0C),y                         ; 3E81
        jsr     L3E9B                           ; 3E83
        pla                                     ; 3E86
        tay                                     ; 3E87
        iny                                     ; 3E88
        dec     $18                             ; 3E89
        bne     L3E7F                           ; 3E8B
        tya                                     ; 3E8D
        tax                                     ; 3E8E
        clc                                     ; 3E8F
        lda     L0010                           ; 3E90
        adc     #$08                            ; 3E92
        sta     L0010                           ; 3E94
        dec     $0B                             ; 3E96
        bne     L3E71                           ; 3E98
        rts                                     ; 3E9A

; ----------------------------------------------------------------------------
L3E9B:  pha                                     ; 3E9B
        ldy     #$00                            ; 3E9C
        sty     $0A                             ; 3E9E
        asl     a                               ; 3EA0
        rol     $0A                             ; 3EA1
        asl     a                               ; 3EA3
        rol     $0A                             ; 3EA4
        asl     a                               ; 3EA6
        rol     $0A                             ; 3EA7
        adc     #$84                            ; 3EA9
        sta     $09                             ; 3EAB
        lda     $0A                             ; 3EAD
        adc     #$1F                            ; 3EAF
        sta     $0A                             ; 3EB1
        ldy     L0010                           ; 3EB3
        ldx     $0E                             ; 3EB5
        jsr     L0160                           ; 3EB7
        sty     L0006                           ; 3EBA
        sta     $07                             ; 3EBC
        nop                                     ; 3EBE
        nop                                     ; 3EBF
        nop                                     ; 3EC0
        nop                                     ; 3EC1
        nop                                     ; 3EC2
        nop                                     ; 3EC3
        nop                                     ; 3EC4
        nop                                     ; 3EC5
        nop                                     ; 3EC6
        nop                                     ; 3EC7
        ldy     #$07                            ; 3EC8
L3ECA:  lda     ($09),y                         ; 3ECA
        sta     (L0006),y                       ; 3ECC
        dey                                     ; 3ECE
        bpl     L3ECA                           ; 3ECF
        lda     L0010                           ; 3ED1
        jsr     L3EED                           ; 3ED3
        pla                                     ; 3ED6
        tax                                     ; 3ED7
        lda     L2394,x                         ; 3ED8
        sta     ($DB),y                         ; 3EDB
        nop                                     ; 3EDD
        nop                                     ; 3EDE
        nop                                     ; 3EDF
        nop                                     ; 3EE0
        lda     L2416,x                         ; 3EE1
        sta     ($DD),y                         ; 3EE4
        nop                                     ; 3EE6
        nop                                     ; 3EE7
        nop                                     ; 3EE8
        nop                                     ; 3EE9
        inc     $0E                             ; 3EEA
        rts                                     ; 3EEC

; ----------------------------------------------------------------------------
L3EED:  lsr     a                               ; 3EED
L3EEE:  lsr     a                               ; 3EEE
        lsr     a                               ; 3EEF
L3EF0:  tay                                     ; 3EF0
        lda     $0130,y                         ; 3EF1
        sta     $DB                             ; 3EF4
        sta     $DD                             ; 3EF6
        lda     $0148,y                         ; 3EF8
        ora     #$5C                            ; 3EFB
        sta     $DC                             ; 3EFD
        lda     $0148,y                         ; 3EFF
        ora     #$58                            ; 3F02
        sta     $DE                             ; 3F04
        ldy     $0E                             ; 3F06
        rts                                     ; 3F08

; ----------------------------------------------------------------------------
L3F09:  lda     L0010                           ; 3F09
        jsr     L3EED                           ; 3F0B
        cpy     $12                             ; 3F0E
        bcs     L3F50                           ; 3F10
        nop                                     ; 3F12
        nop                                     ; 3F13
        nop                                     ; 3F14
        nop                                     ; 3F15
L3F16:  lda     #$26                            ; 3F16
        sta     ($DB),y                         ; 3F18
        lda     #$05                            ; 3F1A
        sta     ($DD),y                         ; 3F1C
        iny                                     ; 3F1E
        cpy     $12                             ; 3F1F
        bcc     L3F16                           ; 3F21
        nop                                     ; 3F23
        nop                                     ; 3F24
        nop                                     ; 3F25
        nop                                     ; 3F26
        ldy     L0010                           ; 3F27
        ldx     $0E                             ; 3F29
        jsr     L0160                           ; 3F2B
        sty     L0006                           ; 3F2E
        sta     $07                             ; 3F30
        ldx     $0E                             ; 3F32
        nop                                     ; 3F34
        nop                                     ; 3F35
        nop                                     ; 3F36
        nop                                     ; 3F37
        nop                                     ; 3F38
        nop                                     ; 3F39
        nop                                     ; 3F3A
        nop                                     ; 3F3B
        ldy     #$00                            ; 3F3C
L3F3E:  lda     $17                             ; 3F3E
        sta     (L0006),y                       ; 3F40
        tya                                     ; 3F42
        clc                                     ; 3F43
        adc     #$08                            ; 3F44
        tay                                     ; 3F46
        bcc     L3F4B                           ; 3F47
        inc     $07                             ; 3F49
L3F4B:  inx                                     ; 3F4B
        cpx     $12                             ; 3F4C
        bcc     L3F3E                           ; 3F4E
L3F50:  rts                                     ; 3F50

; ----------------------------------------------------------------------------
L3F51:  jsr     L386B                           ; 3F51
        ldx     #$00                            ; 3F54
L3F56:  lda     L2892,x                         ; 3F56
        sta     L0006                           ; 3F59
        lda     L28A3,x                         ; 3F5B
        sta     $07                             ; 3F5E
        lda     #$00                            ; 3F60
        tay                                     ; 3F62
L3F63:  sta     (L0006),y                       ; 3F63
        iny                                     ; 3F65
        cpy     #$A0                            ; 3F66
        bcc     L3F63                           ; 3F68
        inx                                     ; 3F6A
        cpx     #$11                            ; 3F6B
        bcc     L3F56                           ; 3F6D
        tax                                     ; 3F6F
L3F70:  sta     L06D8,x                         ; 3F70
        sta     L072C,x                         ; 3F73
        sta     L082C,x                         ; 3F76
        sta     L0880,x                         ; 3F79
        inx                                     ; 3F7C
        bne     L3F70                           ; 3F7D
        dex                                     ; 3F7F
        stx     $39                             ; 3F80
        jmp     L28D6                           ; 3F82

; ----------------------------------------------------------------------------
L3F85:  pha                                     ; 3F85
        stx     $56                             ; 3F86
        sty     $57                             ; 3F88
        jsr     L3FA4                           ; 3F8A
        pla                                     ; 3F8D
        bcs     L3FA3                           ; 3F8E
        jsr     L444B                           ; 3F90
        bcs     L3FA2                           ; 3F93
        pha                                     ; 3F95
        txa                                     ; 3F96
        pha                                     ; 3F97
        tya                                     ; 3F98
        pha                                     ; 3F99
        jsr     L3FBC                           ; 3F9A
        pla                                     ; 3F9D
        tay                                     ; 3F9E
        pla                                     ; 3F9F
        tax                                     ; 3FA0
        pla                                     ; 3FA1
L3FA2:  clc                                     ; 3FA2
L3FA3:  rts                                     ; 3FA3

; ----------------------------------------------------------------------------
L3FA4:  jsr     L3FB6                           ; 3FA4
        ldx     L4205                           ; 3FA7
        ldy     L4206                           ; 3FAA
        clc                                     ; 3FAD
        txa                                     ; 3FAE
        bne     L3FB5                           ; 3FAF
        tya                                     ; 3FB1
        bne     L3FB5                           ; 3FB2
        sec                                     ; 3FB4
L3FB5:  rts                                     ; 3FB5

; ----------------------------------------------------------------------------
L3FB6:  lda     #$00                            ; 3FB6
        .byte   $2C                             ; 3FB8
L3FB9:  lda     #$02                            ; 3FB9
        .byte   $2C                             ; 3FBB
L3FBC:  lda     #$01                            ; 3FBC
        sta     $58                             ; 3FBE
        stx     $59                             ; 3FC0
        sty     $5A                             ; 3FC2
L3FC4:  ldx     #$00                            ; 3FC4
        stx     L4207                           ; 3FC6
        stx     L4209                           ; 3FC9
        lda     #$03                            ; 3FCC
        sta     L4208                           ; 3FCE
        stx     $7A                             ; 3FD1
        lda     #$7E                            ; 3FD3
        sta     $7B                             ; 3FD5
        lda     $56                             ; 3FD7
        eor     #$FF                            ; 3FD9
        sta     $7C                             ; 3FDB
        lda     $57                             ; 3FDD
        eor     #$FF                            ; 3FDF
        sta     $7D                             ; 3FE1
        ldy     #$01                            ; 3FE3
L3FE5:  inc     $7C                             ; 3FE5
        bne     L3FED                           ; 3FE7
        inc     $7D                             ; 3FE9
        beq     L4012                           ; 3FEB
L3FED:  lda     ($7A),y                         ; 3FED
        cmp     #$FF                            ; 3FEF
        bcs     L4008                           ; 3FF1
        lda     ($7A,x)                         ; 3FF3
        adc     L4207                           ; 3FF5
        sta     L4207                           ; 3FF8
        lda     ($7A),y                         ; 3FFB
        adc     L4208                           ; 3FFD
L4000:  sta     L4208                           ; 4000
        bcc     L4008                           ; 4003
        inc     L4209                           ; 4005
L4008:  inc     $7A                             ; 4008
        inc     $7A                             ; 400A
        bne     L3FE5                           ; 400C
        inc     $7B                             ; 400E
        bne     L3FE5                           ; 4010
L4012:  lda     ($7A,x)                         ; 4012
        sta     L4205                           ; 4014
        lda     ($7A),y                         ; 4017
        sta     L4206                           ; 4019
        ora     L4205                           ; 401C
        sec                                     ; 401F
        beq     L4045                           ; 4020
        lda     ($7A),y                         ; 4022
        cmp     #$FF                            ; 4024
        bne     L4032                           ; 4026
        lda     ($7A,x)                         ; 4028
        eor     #$FF                            ; 402A
        jsr     L404C                           ; 402C
        jmp     L3FC4                           ; 402F

; ----------------------------------------------------------------------------
L4032:  lda     $58                             ; 4032
        beq     L4045                           ; 4034
        ldx     $59                             ; 4036
        .byte   $A4                             ; 4038
L4039:  .byte   $5A                             ; 4039
        stx     L4203                           ; 403A
        sty     L4204                           ; 403D
        jsr     L40D8                           ; 4040
        bcs     L4046                           ; 4043
L4045:  rts                                     ; 4045

; ----------------------------------------------------------------------------
L4046:  jsr     L4093                           ; 4046
        jmp     L3FC4                           ; 4049

; ----------------------------------------------------------------------------
L404C:  sta     $F5DF                           ; 404C
        sta     L40C9                           ; 404F
L4052:  jsr     L405B                           ; 4052
        jsr     L4093                           ; 4055
        jmp     L4052                           ; 4058

; ----------------------------------------------------------------------------
L405B:  ldx     #$01                            ; 405B
        ldy     #$00                            ; 405D
        jsr     L41D6                           ; 405F
        bcs     L4092                           ; 4062
        lda     #$00                            ; 4064
        ldx     $04FF                           ; 4066
        cpx     $F5DF                           ; 4069
        bne     L4092                           ; 406C
        ldy     #$00                            ; 406E
        sty     L4207                           ; 4070
        sty     L4208                           ; 4073
        sty     L4209                           ; 4076
        sty     L4205                           ; 4079
        lda     #$02                            ; 407C
        sta     L4206                           ; 407E
        sty     L4203                           ; 4081
        lda     #$7E                            ; 4084
        sta     L4204                           ; 4086
        lda     #$01                            ; 4089
        jsr     L40D8                           ; 408B
        bcs     L4092                           ; 408E
        pla                                     ; 4090
        pla                                     ; 4091
L4092:  rts                                     ; 4092

; ----------------------------------------------------------------------------
L4093:  pha                                     ; 4093
        ldx     #$D4                            ; 4094
        ldy     #$40                            ; 4096
        jsr     L3BFA                           ; 4098
        pla                                     ; 409B
        cmp     #$2B                            ; 409C
        bne     L40B7                           ; 409E
        jsr     L475D                           ; 40A0
        sbc     ($55),y                         ; 40A3
        and     $85                             ; 40A5
        .byte   $52                             ; 40A7
        ora     $A9A2                           ; 40A8
        tya                                     ; 40AB
        bmi     L4039                           ; 40AC
        inc     $62                             ; 40AE
        jmp     LC0C5                           ; 40B0

; ----------------------------------------------------------------------------
        brk                                     ; 40B3
        jmp     L40CE                           ; 40B4

; ----------------------------------------------------------------------------
L40B7:  jsr     L475D                           ; 40B7
        .byte   $F4                             ; 40BA
        clc                                     ; 40BB
        adc     ($48,x)                         ; 40BC
        cmp     ($53,x)                         ; 40BE
        ldy     $68                             ; 40C0
        cpy     $5132                           ; 40C2
        jmp     L0010                           ; 40C5

; ----------------------------------------------------------------------------
        .byte   $A2                             ; 40C8
L40C9:  brk                                     ; 40C9
        inx                                     ; 40CA
        jsr     L487A                           ; 40CB
L40CE:  jsr     L474A                           ; 40CE
        jmp     L3C97                           ; 40D1

; ----------------------------------------------------------------------------
        asl     $28,x                           ; 40D4
        plp                                     ; 40D6
        rts                                     ; 40D7

; ----------------------------------------------------------------------------
L40D8:  sta     L41D5                           ; 40D8
        ldy     $F5DF                           ; 40DB
        clc                                     ; 40DE
        lda     L4208                           ; 40DF
        adc     L41C9,y                         ; 40E2
        sta     $D8                             ; 40E5
        lda     L4209                           ; 40E7
        adc     L41CF,y                         ; 40EA
        sta     $D9                             ; 40ED
        lda     L4207                           ; 40EF
        beq     L4164                           ; 40F2
        lda     #$01                            ; 40F4
        jsr     L41DC                           ; 40F6
        bcs     L4139                           ; 40F9
        lda     L4203                           ; 40FB
        sta     $D6                             ; 40FE
        lda     L4204                           ; 4100
        sta     $D7                             ; 4103
        sec                                     ; 4105
        lda     #$00                            ; 4106
        sbc     L4207                           ; 4108
        sta     $E6                             ; 410B
        lda     L4206                           ; 410D
        bne     L411B                           ; 4110
        lda     L4205                           ; 4112
        cmp     $E6                             ; 4115
        bcs     L411B                           ; 4117
        sta     $E6                             ; 4119
L411B:  ldx     L4207                           ; 411B
        ldy     #$00                            ; 411E
        lda     L41D5                           ; 4120
        cmp     #$02                            ; 4123
        bne     L413A                           ; 4125
L4127:  lda     ($D6),y                         ; 4127
        sta     $0400,x                         ; 4129
        inx                                     ; 412C
        iny                                     ; 412D
        cpy     $E6                             ; 412E
        bne     L4127                           ; 4130
        lda     #$02                            ; 4132
        jsr     L41DC                           ; 4134
        bcc     L4145                           ; 4137
L4139:  rts                                     ; 4139

; ----------------------------------------------------------------------------
L413A:  lda     $0400,x                         ; 413A
        sta     ($D6),y                         ; 413D
        inx                                     ; 413F
        iny                                     ; 4140
        cpy     $E6                             ; 4141
        bne     L413A                           ; 4143
L4145:  sec                                     ; 4145
        lda     L4205                           ; 4146
        sbc     $E6                             ; 4149
        sta     L4205                           ; 414B
        bcs     L4153                           ; 414E
        dec     L4206                           ; 4150
L4153:  clc                                     ; 4153
        lda     L4203                           ; 4154
        adc     $E6                             ; 4157
        sta     L4203                           ; 4159
        bcc     L4161                           ; 415C
        inc     L4204                           ; 415E
L4161:  jsr     L41C2                           ; 4161
L4164:  lda     L4203                           ; 4164
        sta     $D6                             ; 4167
        lda     L4204                           ; 4169
        sta     $D7                             ; 416C
        lda     L4206                           ; 416E
        beq     L4188                           ; 4171
        lda     L41D5                           ; 4173
        sta     $D5                             ; 4176
        jsr     LFF9F                           ; 4178
        bcs     L41C1                           ; 417B
        jsr     L41C2                           ; 417D
        inc     L4204                           ; 4180
        dec     L4206                           ; 4183
        bne     L4164                           ; 4186
L4188:  lda     L4205                           ; 4188
        beq     L41C0                           ; 418B
        lda     #$01                            ; 418D
        jsr     L41DC                           ; 418F
        lda     L4203                           ; 4192
        sta     $D6                             ; 4195
        lda     L4204                           ; 4197
        sta     $D7                             ; 419A
        ldy     L4205                           ; 419C
        dey                                     ; 419F
        lda     L41D5                           ; 41A0
        cmp     #$02                            ; 41A3
        bne     L41B6                           ; 41A5
L41A7:  lda     ($D6),y                         ; 41A7
        sta     $0400,y                         ; 41A9
        dey                                     ; 41AC
        cpy     #$FF                            ; 41AD
        bne     L41A7                           ; 41AF
        lda     #$02                            ; 41B1
        jmp     L41DC                           ; 41B3

; ----------------------------------------------------------------------------
L41B6:  lda     $0400,y                         ; 41B6
        sta     ($D6),y                         ; 41B9
        dey                                     ; 41BB
        cpy     #$FF                            ; 41BC
        bne     L41B6                           ; 41BE
L41C0:  clc                                     ; 41C0
L41C1:  rts                                     ; 41C1

; ----------------------------------------------------------------------------
L41C2:  inc     $D8                             ; 41C2
        bne     L41C8                           ; 41C4
        inc     $D9                             ; 41C6
L41C8:  rts                                     ; 41C8

; ----------------------------------------------------------------------------
L41C9:  bcs     L41CD                           ; 41C9
        .byte   $02                             ; 41CB
        .byte   $02                             ; 41CC
L41CD:  .byte   $02                             ; 41CD
        .byte   $02                             ; 41CE
L41CF:  brk                                     ; 41CF
        brk                                     ; 41D0
        brk                                     ; 41D1
        brk                                     ; 41D2
        brk                                     ; 41D3
        brk                                     ; 41D4
L41D5:  brk                                     ; 41D5
L41D6:  stx     $D8                             ; 41D6
        sty     $D9                             ; 41D8
        lda     #$01                            ; 41DA
L41DC:  sta     $D5                             ; 41DC
        ldx     #$00                            ; 41DE
        stx     $D6                             ; 41E0
        ldx     #$04                            ; 41E2
        stx     $D7                             ; 41E4
        jmp     LFF9F                           ; 41E6

; ----------------------------------------------------------------------------
        jsr     L0E40                           ; 41E9
L41EC:  jsr     L4C2A                           ; 41EC
        lda     #$04                            ; 41EF
        sta     $D5                             ; 41F1
        lda     #$00                            ; 41F3
        sta     $D8                             ; 41F5
        sta     $D9                             ; 41F7
        jsr     LFF9F                           ; 41F9
        nop                                     ; 41FC
        nop                                     ; 41FD
        nop                                     ; 41FE
        nop                                     ; 41FF
        jmp     (LFFFC)                         ; 4200

; ----------------------------------------------------------------------------
L4203:  brk                                     ; 4203
L4204:  brk                                     ; 4204
L4205:  brk                                     ; 4205
L4206:  brk                                     ; 4206
L4207:  brk                                     ; 4207
L4208:  brk                                     ; 4208
L4209:  brk                                     ; 4209
L420A:  tay                                     ; 420A
        ldx     L4215,y                         ; 420B
        lda     L4219,y                         ; 420E
        tay                                     ; 4211
        jmp     L2C76                           ; 4212

; ----------------------------------------------------------------------------
L4215:  .byte   $4B                             ; 4215
        .byte   $23                             ; 4216
        .byte   $1D                             ; 4217
        .byte   $29                             ; 4218
L4219:  .byte   $42                             ; 4219
        .byte   $42                             ; 421A
        .byte   $42                             ; 421B
        .byte   $42                             ; 421C
        ldx     #$28                            ; 421D
        ldy     #$04                            ; 421F
        bne     L422D                           ; 4221
        ldx     #$F0                            ; 4223
        ldy     #$02                            ; 4225
        bne     L422D                           ; 4227
        ldx     #$C8                            ; 4229
        ldy     #$08                            ; 422B
L422D:  stx     L0006                           ; 422D
        sty     $07                             ; 422F
        nop                                     ; 4231
        nop                                     ; 4232
        nop                                     ; 4233
        ldy     #$00                            ; 4234
        lda     #$30                            ; 4236
L4238:  ldx     L0006                           ; 4238
        eor     #$0F                            ; 423A
        sta     $FF11                           ; 423C
L423F:  dey                                     ; 423F
        .byte   $D0                             ; 4240
L4241:  .byte   $04                             ; 4241
        dec     $07                             ; 4242
        beq     L424B                           ; 4244
L4246:  dex                                     ; 4246
        bne     L423F                           ; 4247
        beq     L4238                           ; 4249
L424B:  lda     #$00                            ; 424B
        sta     $FF11                           ; 424D
        nop                                     ; 4250
        nop                                     ; 4251
        nop                                     ; 4252
        nop                                     ; 4253
        rts                                     ; 4254

; ----------------------------------------------------------------------------
L4255:  stx     L42EC                           ; 4255
        sty     L42ED                           ; 4258
        ldy     #$FF                            ; 425B
        sty     $5E                             ; 425D
        iny                                     ; 425F
        sty     $5B                             ; 4260
        sty     $5D                             ; 4262
L4264:  ldx     #$08                            ; 4264
        jsr     L42E0                           ; 4266
        sta     $039E,y                         ; 4269
        iny                                     ; 426C
        cpy     #$14                            ; 426D
        bcc     L4264                           ; 426F
        rts                                     ; 4271

; ----------------------------------------------------------------------------
L4272:  lda     $5B                             ; 4272
        beq     L427B                           ; 4274
        dec     $5B                             ; 4276
        lda     $5C                             ; 4278
        rts                                     ; 427A

; ----------------------------------------------------------------------------
L427B:  ldx     #$01                            ; 427B
        jsr     L42E0                           ; 427D
        lsr     a                               ; 4280
        bcs     L4288                           ; 4281
        ldx     #$08                            ; 4283
        jmp     L42E0                           ; 4285

; ----------------------------------------------------------------------------
L4288:  ldx     #$03                            ; 4288
        jsr     L42E0                           ; 428A
        cmp     #$02                            ; 428D
        bcc     L42CA                           ; 428F
        pha                                     ; 4291
        ldx     #$01                            ; 4292
        jsr     L42E0                           ; 4294
        lsr     a                               ; 4297
        pla                                     ; 4298
        rol     a                               ; 4299
        cmp     #$0B                            ; 429A
        bcs     L42A6                           ; 429C
        cmp     #$04                            ; 429E
        bcc     L42A6                           ; 42A0
        sbc     #$02                            ; 42A2
        bcs     L42CA                           ; 42A4
L42A6:  pha                                     ; 42A6
        ldx     #$01                            ; 42A7
        jsr     L42E0                           ; 42A9
        lsr     a                               ; 42AC
        pla                                     ; 42AD
        rol     a                               ; 42AE
        cmp     #$1E                            ; 42AF
        bcs     L42BB                           ; 42B1
        cmp     #$16                            ; 42B3
        bcc     L42BB                           ; 42B5
        sbc     #$0D                            ; 42B7
        bcs     L42CA                           ; 42B9
L42BB:  pha                                     ; 42BB
        ldx     #$01                            ; 42BC
        jsr     L42E0                           ; 42BE
        lsr     a                               ; 42C1
        pla                                     ; 42C2
        rol     a                               ; 42C3
        cmp     #$3F                            ; 42C4
        bcs     L42CF                           ; 42C6
        sbc     #$2A                            ; 42C8
L42CA:  tay                                     ; 42CA
        lda     $039E,y                         ; 42CB
        rts                                     ; 42CE

; ----------------------------------------------------------------------------
L42CF:  ldx     #$08                            ; 42CF
        jsr     L42E0                           ; 42D1
        sta     $5B                             ; 42D4
        dec     $5B                             ; 42D6
        ldx     #$08                            ; 42D8
        jsr     L42E0                           ; 42DA
        sta     $5C                             ; 42DD
        rts                                     ; 42DF

; ----------------------------------------------------------------------------
L42E0:  lda     #$00                            ; 42E0
L42E2:  bit     $5E                             ; 42E2
        bpl     L42F9                           ; 42E4
        pha                                     ; 42E6
        lda     #$07                            ; 42E7
        sta     $5E                             ; 42E9
        .byte   $AD                             ; 42EB
L42EC:  .byte   $FF                             ; 42EC
L42ED:  .byte   $FF                             ; 42ED
        inc     L42EC                           ; 42EE
        bne     L42F6                           ; 42F1
        inc     L42ED                           ; 42F3
L42F6:  sta     $5D                             ; 42F6
        pla                                     ; 42F8
L42F9:  asl     $5D                             ; 42F9
        rol     a                               ; 42FB
        dec     $5E                             ; 42FC
        dex                                     ; 42FE
        bne     L42E2                           ; 42FF
        rts                                     ; 4301

; ----------------------------------------------------------------------------
L4302:  lda     #$00                            ; 4302
        sta     $84                             ; 4304
        sta     $85                             ; 4306
L4308:  lda     $86                             ; 4308
        sta     $88                             ; 430A
        lda     $87                             ; 430C
        sta     $89                             ; 430E
        lda     #$00                            ; 4310
        sta     $7A                             ; 4312
        sta     $7B                             ; 4314
        sta     $7C                             ; 4316
        sta     $7D                             ; 4318
        ldy     #$10                            ; 431A
L431C:  asl     $7A                             ; 431C
        rol     $7B                             ; 431E
        rol     $7C                             ; 4320
        rol     $7D                             ; 4322
        asl     $88                             ; 4324
        rol     $89                             ; 4326
        bcc     L4343                           ; 4328
        clc                                     ; 432A
        lda     $82                             ; 432B
        adc     $7A                             ; 432D
        sta     $7A                             ; 432F
        lda     $83                             ; 4331
        adc     $7B                             ; 4333
        sta     $7B                             ; 4335
        lda     $84                             ; 4337
        adc     $7C                             ; 4339
        sta     $7C                             ; 433B
        lda     $85                             ; 433D
        adc     $7D                             ; 433F
        sta     $7D                             ; 4341
L4343:  dey                                     ; 4343
        bne     L431C                           ; 4344
        rts                                     ; 4346

; ----------------------------------------------------------------------------
L4347:  lda     #$00                            ; 4347
        sta     $7E                             ; 4349
        sta     $7F                             ; 434B
        sta     $80                             ; 434D
        sta     $81                             ; 434F
        ldy     #$20                            ; 4351
L4353:  asl     $7A                             ; 4353
        rol     $7B                             ; 4355
        rol     $7C                             ; 4357
        rol     $7D                             ; 4359
        rol     $7E                             ; 435B
        rol     $7F                             ; 435D
        rol     $80                             ; 435F
        rol     $81                             ; 4361
        sec                                     ; 4363
        lda     $7E                             ; 4364
        sbc     $86                             ; 4366
        sta     $88                             ; 4368
        lda     $7F                             ; 436A
        sbc     $87                             ; 436C
        sta     $89                             ; 436E
        lda     $80                             ; 4370
        sbc     #$00                            ; 4372
        tax                                     ; 4374
        lda     $81                             ; 4375
        sbc     #$00                            ; 4377
        bcc     L4389                           ; 4379
        sta     $81                             ; 437B
        stx     $80                             ; 437D
        lda     $89                             ; 437F
        sta     $7F                             ; 4381
        lda     $88                             ; 4383
        sta     $7E                             ; 4385
        inc     $7A                             ; 4387
L4389:  dey                                     ; 4389
        bne     L4353                           ; 438A
        rts                                     ; 438C

; ----------------------------------------------------------------------------
L438D:  ldy     #$00                            ; 438D
        sty     $82                             ; 438F
        sty     $83                             ; 4391
        sty     $84                             ; 4393
        sty     $85                             ; 4395
        sty     $87                             ; 4397
        lda     #$0A                            ; 4399
        sta     $86                             ; 439B
        dey                                     ; 439D
L439E:  iny                                     ; 439E
        lda     $F5C6,y                         ; 439F
        cmp     #$A0                            ; 43A2
        beq     L439E                           ; 43A4
L43A6:  lda     $F5C6,y                         ; 43A6
        iny                                     ; 43A9
        eor     #$B0                            ; 43AA
        cmp     #$0A                            ; 43AC
        bcs     L43DD                           ; 43AE
        pha                                     ; 43B0
        tya                                     ; 43B1
        pha                                     ; 43B2
        jsr     L4308                           ; 43B3
        pla                                     ; 43B6
        tay                                     ; 43B7
        pla                                     ; 43B8
        clc                                     ; 43B9
        adc     $7A                             ; 43BA
        sta     $82                             ; 43BC
        lda     $7B                             ; 43BE
        adc     #$00                            ; 43C0
        sta     $83                             ; 43C2
        lda     $7C                             ; 43C4
        adc     #$00                            ; 43C6
        sta     $84                             ; 43C8
        lda     $7D                             ; 43CA
        adc     #$00                            ; 43CC
        sta     $85                             ; 43CE
        bcc     L43A6                           ; 43D0
        ldx     #$03                            ; 43D2
        lda     #$FF                            ; 43D4
L43D6:  sta     $F537,x                         ; 43D6
        dex                                     ; 43D9
        bpl     L43D6                           ; 43DA
        rts                                     ; 43DC

; ----------------------------------------------------------------------------
L43DD:  ldx     #$03                            ; 43DD
L43DF:  lda     $82,x                           ; 43DF
        sta     $F537,x                         ; 43E1
        dex                                     ; 43E4
        bpl     L43DF                           ; 43E5
        rts                                     ; 43E7

; ----------------------------------------------------------------------------
L43E8:  cmp     #$FF                            ; 43E8
        beq     L4406                           ; 43EA
        tax                                     ; 43EC
        beq     L4406                           ; 43ED
        lda     #$00                            ; 43EF
        sta     $0280,x                         ; 43F1
        ldy     $02C0,x                         ; 43F4
        lda     $02A0,x                         ; 43F7
        sta     $02A0,y                         ; 43FA
        ldy     $02A0,x                         ; 43FD
        lda     $02C0,x                         ; 4400
        sta     $02C0,y                         ; 4403
L4406:  rts                                     ; 4406

; ----------------------------------------------------------------------------
L4407:  ldy     #$02                            ; 4407
        bit     $01A0                           ; 4409
        bit     $FFA0                           ; 440C
        tax                                     ; 440F
        beq     L441A                           ; 4410
        cpx     #$FF                            ; 4412
        beq     L441A                           ; 4414
        tya                                     ; 4416
        sta     $0280,x                         ; 4417
L441A:  rts                                     ; 441A

; ----------------------------------------------------------------------------
L441B:  tax                                     ; 441B
        lda     $0200,x                         ; 441C
        ldy     $0220,x                         ; 441F
        tax                                     ; 4422
        rts                                     ; 4423

; ----------------------------------------------------------------------------
L4424:  tax                                     ; 4424
        lda     $0240,x                         ; 4425
        ldy     $0260,x                         ; 4428
        tax                                     ; 442B
        rts                                     ; 442C

; ----------------------------------------------------------------------------
L442D:  lda     #$00                            ; 442D
L442F:  tax                                     ; 442F
        lda     $02E0,x                         ; 4430
        cmp     $56                             ; 4433
        bne     L443E                           ; 4435
        lda     $0300,x                         ; 4437
        cmp     $57                             ; 443A
        beq     L4445                           ; 443C
L443E:  lda     $02A0,x                         ; 443E
        bpl     L442F                           ; 4441
        sec                                     ; 4443
        rts                                     ; 4444

; ----------------------------------------------------------------------------
L4445:  txa                                     ; 4445
        ldy     $0280,x                         ; 4446
        clc                                     ; 4449
        rts                                     ; 444A

; ----------------------------------------------------------------------------
L444B:  sta     $9F                             ; 444B
        stx     $A0                             ; 444D
        sty     $A1                             ; 444F
        lda     $57                             ; 4451
        bmi     L445A                           ; 4453
        jsr     L442D                           ; 4455
        bcc     L447A                           ; 4458
L445A:  jsr     L4487                           ; 445A
        bcc     L4486                           ; 445D
L445F:  jsr     L4530                           ; 445F
        jsr     L4487                           ; 4462
        bcc     L4486                           ; 4465
        jsr     L450A                           ; 4467
        bcc     L445F                           ; 446A
        jsr     L4530                           ; 446C
        jsr     L4487                           ; 446F
        bcc     L4486                           ; 4472
L4474:  inc     $6000                           ; 4474
        jmp     L4474                           ; 4477

; ----------------------------------------------------------------------------
L447A:  lda     $9F                             ; 447A
        sta     $0280,x                         ; 447C
        txa                                     ; 447F
        pha                                     ; 4480
        jsr     L441B                           ; 4481
        pla                                     ; 4484
        sec                                     ; 4485
L4486:  rts                                     ; 4486

; ----------------------------------------------------------------------------
L4487:  ldy     #$00                            ; 4487
L4489:  tya                                     ; 4489
        tax                                     ; 448A
        ldy     $02A0,x                         ; 448B
        bmi     L44CA                           ; 448E
        clc                                     ; 4490
        lda     $0200,x                         ; 4491
        adc     $0240,x                         ; 4494
        sta     $A3                             ; 4497
        lda     $0220,x                         ; 4499
        adc     $0260,x                         ; 449C
        sta     $A4                             ; 449F
        sec                                     ; 44A1
        lda     $0200,y                         ; 44A2
        sbc     $A3                             ; 44A5
        sta     $A5                             ; 44A7
        lda     $0220,y                         ; 44A9
        sbc     $A4                             ; 44AC
        sta     $A6                             ; 44AE
        lda     $A5                             ; 44B0
        cmp     $A0                             ; 44B2
        lda     $A6                             ; 44B4
        sbc     $A1                             ; 44B6
        bcc     L4489                           ; 44B8
        stx     $A7                             ; 44BA
        sty     $A8                             ; 44BC
        ldx     #$00                            ; 44BE
L44C0:  lda     $0280,x                         ; 44C0
        beq     L44CC                           ; 44C3
        inx                                     ; 44C5
        cpx     #$20                            ; 44C6
        bcc     L44C0                           ; 44C8
L44CA:  sec                                     ; 44CA
        rts                                     ; 44CB

; ----------------------------------------------------------------------------
L44CC:  lda     $A3                             ; 44CC
        sta     $0200,x                         ; 44CE
        lda     $A4                             ; 44D1
        sta     $0220,x                         ; 44D3
        lda     $A0                             ; 44D6
        sta     $0240,x                         ; 44D8
        lda     $A1                             ; 44DB
        sta     $0260,x                         ; 44DD
        lda     $9F                             ; 44E0
        sta     $0280,x                         ; 44E2
        lda     $56                             ; 44E5
        sta     $02E0,x                         ; 44E7
        lda     $57                             ; 44EA
        sta     $0300,x                         ; 44EC
        lda     $A7                             ; 44EF
        sta     $02C0,x                         ; 44F1
        tay                                     ; 44F4
        txa                                     ; 44F5
        sta     $02A0,y                         ; 44F6
        lda     $A8                             ; 44F9
        sta     $02A0,x                         ; 44FB
        tay                                     ; 44FE
        txa                                     ; 44FF
        sta     $02C0,y                         ; 4500
        pha                                     ; 4503
        jsr     L441B                           ; 4504
        pla                                     ; 4507
        clc                                     ; 4508
        rts                                     ; 4509

; ----------------------------------------------------------------------------
L450A:  ldy     #$20                            ; 450A
        .byte   $A2                             ; 450C
L450D:  brk                                     ; 450D
L450E:  inx                                     ; 450E
        cpx     #$20                            ; 450F
        bcc     L4515                           ; 4511
        ldx     #$00                            ; 4513
L4515:  lda     $0280,x                         ; 4515
        cmp     #$02                            ; 4518
        beq     L4521                           ; 451A
        dey                                     ; 451C
        bne     L450E                           ; 451D
        sec                                     ; 451F
        rts                                     ; 4520

; ----------------------------------------------------------------------------
L4521:  txa                                     ; 4521
        sta     L450D                           ; 4522
        jsr     L43E8                           ; 4525
        clc                                     ; 4528
        rts                                     ; 4529

; ----------------------------------------------------------------------------
L452A:  jsr     L3411                           ; 452A
        jmp     L1D98                           ; 452D

; ----------------------------------------------------------------------------
L4530:  ldy     #$00                            ; 4530
L4532:  tya                                     ; 4532
        tax                                     ; 4533
        ldy     $02A0,x                         ; 4534
        bmi     L452A                           ; 4537
        lda     $0280,y                         ; 4539
        bmi     L4532                           ; 453C
        clc                                     ; 453E
        lda     $0200,x                         ; 453F
        .byte   $7D                             ; 4542
        rti                                     ; 4543

; ----------------------------------------------------------------------------
L4544:  .byte   $02                             ; 4544
        sta     L45B2                           ; 4545
        lda     $0220,x                         ; 4548
        adc     $0260,x                         ; 454B
        sta     L45B3                           ; 454E
        sec                                     ; 4551
        lda     $0200,y                         ; 4552
        sta     L45AF                           ; 4555
        sbc     L45B2                           ; 4558
        sta     L45A3                           ; 455B
        lda     $0220,y                         ; 455E
        sta     L45B0                           ; 4561
        sbc     L45B3                           ; 4564
        sta     L45A9                           ; 4567
        ora     L45A3                           ; 456A
        beq     L4532                           ; 456D
        lda     L45B2                           ; 456F
        sta     $0200,y                         ; 4572
        lda     L45B3                           ; 4575
        sta     $0220,y                         ; 4578
        sec                                     ; 457B
        lda     #$00                            ; 457C
        sbc     $0240,y                         ; 457E
        tax                                     ; 4581
        lda     #$00                            ; 4582
        sbc     $0260,y                         ; 4584
        sta     $D4                             ; 4587
        cpy     $F556                           ; 4589
        bne     L459C                           ; 458C
        lda     $9D                             ; 458E
        sbc     L45A3                           ; 4590
        sta     $9D                             ; 4593
        lda     $9E                             ; 4595
        sbc     L45A9                           ; 4597
        sta     $9E                             ; 459A
L459C:  cpy     $8A                             ; 459C
        bne     L45AC                           ; 459E
        lda     $BC                             ; 45A0
        .byte   $E9                             ; 45A2
L45A3:  brk                                     ; 45A3
        sta     $BC                             ; 45A4
        lda     $BD                             ; 45A6
        .byte   $E9                             ; 45A8
L45A9:  brk                                     ; 45A9
        sta     $BD                             ; 45AA
L45AC:  ldy     #$00                            ; 45AC
L45AE:  .byte   $B9                             ; 45AE
L45AF:  .byte   $FF                             ; 45AF
L45B0:  .byte   $FF                             ; 45B0
        .byte   $99                             ; 45B1
L45B2:  .byte   $FF                             ; 45B2
L45B3:  .byte   $FF                             ; 45B3
        iny                                     ; 45B4
        bne     L45BD                           ; 45B5
        inc     L45B0                           ; 45B7
        inc     L45B3                           ; 45BA
L45BD:  inx                                     ; 45BD
        bne     L45AE                           ; 45BE
        inc     $D4                             ; 45C0
        bne     L45AE                           ; 45C2
        jmp     L4530                           ; 45C4

; ----------------------------------------------------------------------------
L45C7:  stx     $6B                             ; 45C7
        sty     $6C                             ; 45C9
        jsr     L25D9                           ; 45CB
        ldy     #$00                            ; 45CE
        lda     ($6B),y                         ; 45D0
        sta     $6D                             ; 45D2
        iny                                     ; 45D4
        lda     ($6B),y                         ; 45D5
        sta     $6E                             ; 45D7
        and     #$20                            ; 45D9
        sta     $79                             ; 45DB
        lda     $6E                             ; 45DD
        and     #$10                            ; 45DF
        beq     L45E6                           ; 45E1
        iny                                     ; 45E3
        lda     ($6B),y                         ; 45E4
L45E6:  sta     $6F                             ; 45E6
        tya                                     ; 45E8
        sec                                     ; 45E9
        adc     $6B                             ; 45EA
        sta     $6B                             ; 45EC
        bcc     L45F2                           ; 45EE
        inc     $6C                             ; 45F0
L45F2:  bit     $6E                             ; 45F2
        bpl     L4625                           ; 45F4
        lda     $65                             ; 45F6
        sec                                     ; 45F8
        sbc     #$08                            ; 45F9
        sta     $1D                             ; 45FB
        ldx     #$00                            ; 45FD
        stx     L2685                           ; 45FF
        lda     $6E                             ; 4602
        and     #$03                            ; 4604
        tay                                     ; 4606
        sec                                     ; 4607
        lda     $64                             ; 4608
        sbc     $62                             ; 460A
        sbc     L46E5,y                         ; 460C
        bcs     L4612                           ; 460F
        txa                                     ; 4611
L4612:  lsr     a                               ; 4612
        clc                                     ; 4613
        adc     $62                             ; 4614
        sta     $1B                             ; 4616
        lda     L46ED,y                         ; 4618
        ldx     L46E9,y                         ; 461B
        tay                                     ; 461E
        jsr     L476C                           ; 461F
        jsr     L25D9                           ; 4622
L4625:  jsr     L4D4C                           ; 4625
        jsr     L4D41                           ; 4628
        bpl     L464D                           ; 462B
        cmp     #$E1                            ; 462D
L462F:  bcc     L463F                           ; 462F
        cmp     #$FB                            ; 4631
        bcs     L463F                           ; 4633
        tax                                     ; 4635
        lda     $6D                             ; 4636
        lsr     a                               ; 4638
        lsr     a                               ; 4639
        txa                                     ; 463A
        bcs     L463F                           ; 463B
        and     #$DF                            ; 463D
L463F:  bit     $6E                             ; 463F
        bpl     L4654                           ; 4641
        bvs     L4654                           ; 4643
        cmp     #$A0                            ; 4645
        bne     L4654                           ; 4647
        lda     #$9B                            ; 4649
        bne     L4654                           ; 464B
L464D:  jsr     L471F                           ; 464D
        bcc     L4625                           ; 4650
        lda     #$01                            ; 4652
L4654:  sta     L0006                           ; 4654
        bit     $6D                             ; 4656
        bvc     L4668                           ; 4658
        sec                                     ; 465A
        lda     $6B                             ; 465B
        sbc     $97                             ; 465D
        tax                                     ; 465F
        lda     $6C                             ; 4660
        sbc     $98                             ; 4662
        tay                                     ; 4664
        lda     L0006                           ; 4665
        rts                                     ; 4667

; ----------------------------------------------------------------------------
L4668:  ldy     #$FD                            ; 4668
        ldx     L0006                           ; 466A
L466C:  iny                                     ; 466C
        iny                                     ; 466D
        iny                                     ; 466E
        lda     ($6B),y                         ; 466F
        sta     $07                             ; 4671
        beq     L46CC                           ; 4673
        cmp     #$FF                            ; 4675
        bne     L467C                           ; 4677
        jmp     L4625                           ; 4679

; ----------------------------------------------------------------------------
L467C:  cmp     #$01                            ; 467C
        bne     L469D                           ; 467E
        txa                                     ; 4680
        sec                                     ; 4681
        sbc     #$B1                            ; 4682
        cmp     $F51F                           ; 4684
        bcs     L466C                           ; 4687
        stx     $4F                             ; 4689
        tax                                     ; 468B
        lda     $F50A,x                         ; 468C
        sta     L4698                           ; 468F
        ldx     $4F                             ; 4692
        lda     $6F                             ; 4694
        .byte   $2D                             ; 4696
        .byte   $4C                             ; 4697
L4698:  .byte   $FF                             ; 4698
        bne     L466C                           ; 4699
        beq     L46CC                           ; 469B
L469D:  cmp     #$02                            ; 469D
        bne     L46A7                           ; 469F
        cpx     #$01                            ; 46A1
        beq     L46CC                           ; 46A3
        bne     L466C                           ; 46A5
L46A7:  cmp     #$80                            ; 46A7
        beq     L466C                           ; 46A9
        cmp     #$81                            ; 46AB
        bne     L46B2                           ; 46AD
        iny                                     ; 46AF
        bne     L466C                           ; 46B0
L46B2:  eor     #$00                            ; 46B2
        bmi     L46C8                           ; 46B4
        iny                                     ; 46B6
        sec                                     ; 46B7
        sbc     #$81                            ; 46B8
        cmp     L0006                           ; 46BA
        bcs     L466C                           ; 46BC
        lda     ($6B),y                         ; 46BE
        ora     #$80                            ; 46C0
        cmp     L0006                           ; 46C2
        bcc     L466C                           ; 46C4
        bcs     L46CC                           ; 46C6
L46C8:  cmp     L0006                           ; 46C8
        bne     L466C                           ; 46CA
L46CC:  iny                                     ; 46CC
        lda     ($6B),y                         ; 46CD
        tax                                     ; 46CF
        iny                                     ; 46D0
        lda     ($6B),y                         ; 46D1
        tay                                     ; 46D3
        lda     $07                             ; 46D4
        cmp     #$01                            ; 46D6
        bne     L46E2                           ; 46D8
        lda     L0006                           ; 46DA
        sec                                     ; 46DC
        sbc     #$B1                            ; 46DD
        sta     $F506                           ; 46DF
L46E2:  lda     L0006                           ; 46E2
        rts                                     ; 46E4

; ----------------------------------------------------------------------------
L46E5:  .byte   $0C                             ; 46E5
        .byte   $0F                             ; 46E6
        ora     #$0E                            ; 46E7
L46E9:  sbc     ($FC),y                         ; 46E9
        ora     #$13                            ; 46EB
L46ED:  lsr     $46                             ; 46ED
        .byte   $47                             ; 46EF
        .byte   $47                             ; 46F0
        .byte   $FF                             ; 46F1
        .byte   $3F                             ; 46F2
        .byte   $F7                             ; 46F3
        inc     $6F86,x                         ; 46F4
        ora     #$BE                            ; 46F7
        .byte   $12                             ; 46F9
        ldx     $00                             ; 46FA
        .byte   $FF                             ; 46FC
        .byte   $3F                             ; 46FD
        .byte   $F7                             ; 46FE
        inc     $6F86,x                         ; 46FF
        ora     #$1E                            ; 4702
        sbc     #$A9                            ; 4704
        .byte   $D4                             ; 4706
        bmi     L4709                           ; 4707
L4709:  .byte   $F4                             ; 4709
        .byte   $22                             ; 470A
        adc     #$48                            ; 470B
        .byte   $3F                             ; 470D
        .byte   $E7                             ; 470E
        inc     $D0FF,x                         ; 470F
        brk                                     ; 4712
        .byte   $FF                             ; 4713
        .byte   $3F                             ; 4714
        .byte   $F7                             ; 4715
        inc     $6F86,x                         ; 4716
        asl     a                               ; 4719
        asl     $8811,x                         ; 471A
        .byte   $8B                             ; 471D
        brk                                     ; 471E
L471F:  jsr     L3843                           ; 471F
        jsr     L4BA7                           ; 4722
        jsr     L49DB                           ; 4725
        clc                                     ; 4728
        lda     $79                             ; 4729
        ora     L4C28                           ; 472B
        ora     L4C29                           ; 472E
        bne     L4749                           ; 4731
        lda     #$58                            ; 4733
        sta     L4C28                           ; 4735
        lda     #$02                            ; 4738
        sta     L4C29                           ; 473A
        inc     $F505                           ; 473D
        lda     $F505                           ; 4740
        and     #$1F                            ; 4743
        sta     $F505                           ; 4745
        sec                                     ; 4748
L4749:  rts                                     ; 4749

; ----------------------------------------------------------------------------
L474A:  ldx     #$57                            ; 474A
        ldy     #$47                            ; 474C
        jsr     L45C7                           ; 474E
        pha                                     ; 4751
        jsr     L2704                           ; 4752
        pla                                     ; 4755
        rts                                     ; 4756

; ----------------------------------------------------------------------------
        .byte   $04                             ; 4757
        .byte   $82                             ; 4758
        .byte   $9B                             ; 4759
        brk                                     ; 475A
        brk                                     ; 475B
        .byte   $FF                             ; 475C
L475D:  pla                                     ; 475D
        tax                                     ; 475E
        pla                                     ; 475F
        tay                                     ; 4760
        inx                                     ; 4761
        bne     L4765                           ; 4762
        iny                                     ; 4764
L4765:  jsr     L476C                           ; 4765
        clc                                     ; 4768
        jmp     (L486A)                         ; 4769

; ----------------------------------------------------------------------------
L476C:  stx     L486A                           ; 476C
        sty     L486B                           ; 476F
        ldx     #$00                            ; 4772
        stx     $5F                             ; 4774
        stx     $61                             ; 4776
L4778:  jsr     L47CE                           ; 4778
        beq     L47C5                           ; 477B
        bit     $F508                           ; 477D
        bmi     L4789                           ; 4780
        ora     #$80                            ; 4782
        sta     $F508                           ; 4784
        and     #$7F                            ; 4787
L4789:  cmp     #$AF                            ; 4789
        beq     L4797                           ; 478B
        cmp     #$DC                            ; 478D
        beq     L479A                           ; 478F
        jsr     L25B8                           ; 4791
        jmp     L4778                           ; 4794

; ----------------------------------------------------------------------------
L4797:  ldy     #$80                            ; 4797
        .byte   $2C                             ; 4799
L479A:  ldy     #$00                            ; 479A
        sta     L47B0                           ; 479C
        tya                                     ; 479F
        ldx     $F509                           ; 47A0
        beq     L47A7                           ; 47A3
        eor     #$80                            ; 47A5
L47A7:  sta     L47BC                           ; 47A7
L47AA:  jsr     L47CE                           ; 47AA
        beq     L47C5                           ; 47AD
        .byte   $C9                             ; 47AF
L47B0:  .byte   $AF                             ; 47B0
        beq     L4778                           ; 47B1
        cmp     #$DC                            ; 47B3
        beq     L479A                           ; 47B5
        cmp     #$AF                            ; 47B7
        beq     L4797                           ; 47B9
        .byte   $A0                             ; 47BB
L47BC:  brk                                     ; 47BC
        bpl     L47AA                           ; 47BD
        jsr     L25B8                           ; 47BF
        jmp     L47AA                           ; 47C2

; ----------------------------------------------------------------------------
L47C5:  ldx     L486A                           ; 47C5
        ldy     L486B                           ; 47C8
        rts                                     ; 47CB

; ----------------------------------------------------------------------------
L47CC:  ror     $61                             ; 47CC
L47CE:  jsr     L4857                           ; 47CE
        ora     #$00                            ; 47D1
        beq     L47F7                           ; 47D3
        cmp     #$1E                            ; 47D5
        bcc     L47E1                           ; 47D7
        beq     L47CC                           ; 47D9
        jsr     L4854                           ; 47DB
        sec                                     ; 47DE
        adc     #$1D                            ; 47DF
L47E1:  tax                                     ; 47E1
        lda     L47F7,x                         ; 47E2
        lsr     $61                             ; 47E5
        bit     $61                             ; 47E7
        bvc     L47F5                           ; 47E9
        cmp     #$E1                            ; 47EB
        bcc     L47F5                           ; 47ED
        cmp     #$FB                            ; 47EF
        bcs     L47F5                           ; 47F1
        and     #$DF                            ; 47F3
L47F5:  ora     #$00                            ; 47F5
L47F7:  rts                                     ; 47F7

; ----------------------------------------------------------------------------
        ldy     #$E1                            ; 47F8
        .byte   $E2                             ; 47FA
L47FB:  .byte   $E3                             ; 47FB
        cpx     $E5                             ; 47FC
        inc     $E7                             ; 47FE
        inx                                     ; 4800
        sbc     #$EB                            ; 4801
        cpx     $EEED                           ; 4803
        .byte   $EF                             ; 4806
        beq     L47FB                           ; 4807
        .byte   $F3                             ; 4809
        .byte   $F4                             ; 480A
        sbc     $F6,x                           ; 480B
        .byte   $F7                             ; 480D
        sbc     $A2AE,y                         ; 480E
        .byte   $A7                             ; 4811
        ldy     $8DA1                           ; 4812
        nop                                     ; 4815
        sbc     ($F8),y                         ; 4816
        .byte   $FA                             ; 4818
        bcs     L47CC                           ; 4819
        .byte   $B2                             ; 481B
        .byte   $B3                             ; 481C
        ldy     $B5,x                           ; 481D
        ldx     L00B7,y                         ; 481F
        clv                                     ; 4821
        lda     L3130,y                         ; 4822
        .byte   $32                             ; 4825
        .byte   $33                             ; 4826
        .byte   $34                             ; 4827
        and     $36,x                           ; 4828
        .byte   $37                             ; 482A
        sec                                     ; 482B
        and     L4241,y                         ; 482C
        .byte   $43                             ; 482F
        .byte   $44                             ; 4830
        eor     $46                             ; 4831
        .byte   $47                             ; 4833
        pha                                     ; 4834
        eor     #$4A                            ; 4835
        .byte   $4B                             ; 4837
        jmp     L4E4D                           ; 4838

; ----------------------------------------------------------------------------
        .byte   $4F                             ; 483B
        bvc     L488F                           ; 483C
        .byte   $52                             ; 483E
        .byte   $53                             ; 483F
        .byte   $54                             ; 4840
        eor     $56,x                           ; 4841
        .byte   $57                             ; 4843
        cli                                     ; 4844
        eor     $A85A,y                         ; 4845
L4848:  lda     #$AF                            ; 4848
        .byte   $DC                             ; 484A
        .byte   $A3                             ; 484B
        tax                                     ; 484C
        .byte   $BF                             ; 484D
        ldy     $BABE,x                         ; 484E
        .byte   $BB                             ; 4851
        .byte   $AD                             ; 4852
        .byte   $A5                             ; 4853
L4854:  ldy     #$06                            ; 4854
        .byte   $2C                             ; 4856
L4857:  ldy     #$05                            ; 4857
        lda     #$00                            ; 4859
        ldx     $5F                             ; 485B
L485D:  dex                                     ; 485D
        bmi     L4869                           ; 485E
L4860:  asl     $60                             ; 4860
        rol     a                               ; 4862
        dey                                     ; 4863
        bne     L485D                           ; 4864
        stx     $5F                             ; 4866
        rts                                     ; 4868

; ----------------------------------------------------------------------------
L4869:  .byte   $AE                             ; 4869
L486A:  .byte   $FF                             ; 486A
L486B:  .byte   $FF                             ; 486B
        stx     $60                             ; 486C
        ldx     #$07                            ; 486E
        inc     L486A                           ; 4870
        bne     L4860                           ; 4873
        inc     L486B                           ; 4875
        bne     L4860                           ; 4878
L487A:  ldy     #$00                            ; 487A
L487C:  stx     $7A                             ; 487C
        sty     $7B                             ; 487E
        ldx     #$04                            ; 4880
        lda     #$00                            ; 4882
        sta     $7C                             ; 4884
L4886:  sta     $7D                             ; 4886
        .byte   $2C                             ; 4888
L4889:  ldx     #$09                            ; 4889
        stx     $18                             ; 488B
L488D:  ldy     #$B0                            ; 488D
L488F:  sec                                     ; 488F
        lda     $7A                             ; 4890
        sbc     L48E0,x                         ; 4892
        sta     L48B2                           ; 4895
        lda     $7B                             ; 4898
        sbc     L48EA,x                         ; 489A
        sta     L48B6                           ; 489D
        lda     $7C                             ; 48A0
        sbc     L48F4,x                         ; 48A2
        sta     L48BA                           ; 48A5
        lda     $7D                             ; 48A8
        sbc     L48FE,x                         ; 48AA
        bcc     L48C0                           ; 48AD
        sta     $7D                             ; 48AF
        .byte   $A9                             ; 48B1
L48B2:  brk                                     ; 48B2
        sta     $7A                             ; 48B3
        .byte   $A9                             ; 48B5
L48B6:  brk                                     ; 48B6
        sta     $7B                             ; 48B7
        .byte   $A9                             ; 48B9
L48BA:  brk                                     ; 48BA
        sta     $7C                             ; 48BB
        iny                                     ; 48BD
        bne     L488F                           ; 48BE
L48C0:  txa                                     ; 48C0
        beq     L48D4                           ; 48C1
        cpy     #$B0                            ; 48C3
        beq     L48C9                           ; 48C5
        sty     $18                             ; 48C7
L48C9:  bit     $18                             ; 48C9
        bmi     L48D4                           ; 48CB
        bit     L48DF                           ; 48CD
        bpl     L48D8                           ; 48D0
        ldy     #$A0                            ; 48D2
L48D4:  tya                                     ; 48D4
        jsr     L25B8                           ; 48D5
L48D8:  dex                                     ; 48D8
        bpl     L488D                           ; 48D9
        lsr     L48DF                           ; 48DB
        rts                                     ; 48DE

; ----------------------------------------------------------------------------
L48DF:  brk                                     ; 48DF
L48E0:  ora     ($0A,x)                         ; 48E0
        .byte   $64                             ; 48E2
        inx                                     ; 48E3
        bpl     L4886                           ; 48E4
        rti                                     ; 48E6

; ----------------------------------------------------------------------------
        .byte   $80                             ; 48E7
        brk                                     ; 48E8
        brk                                     ; 48E9
L48EA:  brk                                     ; 48EA
        brk                                     ; 48EB
        brk                                     ; 48EC
        .byte   $03                             ; 48ED
        .byte   $27                             ; 48EE
        stx     $42                             ; 48EF
        stx     $E1,y                           ; 48F1
        dex                                     ; 48F3
L48F4:  brk                                     ; 48F4
        brk                                     ; 48F5
        brk                                     ; 48F6
        brk                                     ; 48F7
        brk                                     ; 48F8
        ora     ($0F,x)                         ; 48F9
        tya                                     ; 48FB
        sbc     $9A,x                           ; 48FC
L48FE:  brk                                     ; 48FE
        brk                                     ; 48FF
        brk                                     ; 4900
        brk                                     ; 4901
        brk                                     ; 4902
        brk                                     ; 4903
        brk                                     ; 4904
        brk                                     ; 4905
        ora     $3B                             ; 4906
L4908:  jsr     L25D9                           ; 4908
        lda     #$00                            ; 490B
        sta     L49B4                           ; 490D
        jsr     L4974                           ; 4910
L4913:  ldx     #$70                            ; 4913
        ldy     #$49                            ; 4915
        jsr     L45C7                           ; 4917
        cmp     #$AF                            ; 491A
        beq     L4913                           ; 491C
        cmp     #$DC                            ; 491E
        beq     L4913                           ; 4920
        ldx     L49B4                           ; 4922
        cmp     #$88                            ; 4925
        beq     L495E                           ; 4927
        cmp     #$8D                            ; 4929
        beq     L4951                           ; 492B
        cmp     #$9B                            ; 492D
        beq     L494C                           ; 492F
        cpx     L49B5                           ; 4931
        bcs     L4913                           ; 4934
        cmp     #$A0                            ; 4936
        bcc     L4913                           ; 4938
        .byte   $D0                             ; 493A
L493B:  .byte   $04                             ; 493B
        cpx     #$00                            ; 493C
        beq     L4913                           ; 493E
        sta     $F5C6,x                         ; 4940
        inc     L49B4                           ; 4943
        jsr     L4974                           ; 4946
        jmp     L4913                           ; 4949

; ----------------------------------------------------------------------------
L494C:  ldx     #$00                            ; 494C
        stx     L49B4                           ; 494E
L4951:  lda     #$00                            ; 4951
        sta     $F5C6,x                         ; 4953
        jsr     L4972                           ; 4956
        lda     #$8D                            ; 4959
        jmp     L25B8                           ; 495B

; ----------------------------------------------------------------------------
L495E:  cpx     #$00                            ; 495E
        beq     L4913                           ; 4960
        dec     L49B4                           ; 4962
        jsr     L4974                           ; 4965
        lda     #$A0                            ; 4968
        jsr     L2686                           ; 496A
        jmp     L4913                           ; 496D

; ----------------------------------------------------------------------------
        .byte   $C2                             ; 4970
        brk                                     ; 4971
L4972:  sec                                     ; 4972
        .byte   $24                             ; 4973
L4974:  clc                                     ; 4974
        php                                     ; 4975
        lda     $64                             ; 4976
        sec                                     ; 4978
        sbc     $62                             ; 4979
        sbc     #$02                            ; 497B
        pha                                     ; 497D
        cmp     #$10                            ; 497E
        bcc     L4984                           ; 4980
        lda     #$10                            ; 4982
L4984:  sta     L49B5                           ; 4984
        pla                                     ; 4987
        sec                                     ; 4988
        sbc     L49B5                           ; 4989
        lsr     a                               ; 498C
        clc                                     ; 498D
        adc     $62                             ; 498E
        sta     $1B                             ; 4990
        lda     #$BA                            ; 4992
        jsr     L2686                           ; 4994
        ldx     #$00                            ; 4997
        cpx     L49B4                           ; 4999
        bcs     L49AA                           ; 499C
L499E:  lda     $F5C6,x                         ; 499E
        jsr     L2686                           ; 49A1
        inx                                     ; 49A4
        cpx     L49B4                           ; 49A5
        bcc     L499E                           ; 49A8
L49AA:  plp                                     ; 49AA
        lda     #$A0                            ; 49AB
        bcs     L49B1                           ; 49AD
        lda     #$FE                            ; 49AF
L49B1:  jmp     L2686                           ; 49B1

; ----------------------------------------------------------------------------
L49B4:  brk                                     ; 49B4
L49B5:  brk                                     ; 49B5
L49B6:  ldx     $F506                           ; 49B6
        lda     $F50A,x                         ; 49B9
        sta     $50                             ; 49BC
        lda     #$00                            ; 49BE
        sta     $4F                             ; 49C0
L49C2:  ldy     #$FF                            ; 49C2
L49C4:  iny                                     ; 49C4
        lda     ($4F),y                         ; 49C5
        ora     #$80                            ; 49C7
        jsr     L25B8                           ; 49C9
        lda     ($4F),y                         ; 49CC
        bmi     L49C4                           ; 49CE
L49D0:  rts                                     ; 49D0

; ----------------------------------------------------------------------------
        ldx     #$06                            ; 49D1
        lda     #$00                            ; 49D3
L49D5:  sta     $F518,x                         ; 49D5
        dex                                     ; 49D8
        bpl     L49D5                           ; 49D9
L49DB:  lda     #$0B                            ; 49DB
        jsr     L3D13                           ; 49DD
        bcs     L49D0                           ; 49E0
        lda     $1B                             ; 49E2
        pha                                     ; 49E4
        lda     $1D                             ; 49E5
        pha                                     ; 49E7
        lda     $F506                           ; 49E8
        pha                                     ; 49EB
        jsr     L25C8                           ; 49EC
        ldx     #$06                            ; 49EF
L49F1:  ldy     $F518,x                         ; 49F1
        bmi     L4A04                           ; 49F4
        stx     $F506                           ; 49F6
        jsr     L4A14                           ; 49F9
        ldx     $F506                           ; 49FC
        lda     #$FF                            ; 49FF
        sta     $F518,x                         ; 4A01
L4A04:  dex                                     ; 4A04
        bpl     L49F1                           ; 4A05
        pla                                     ; 4A07
        sta     $F506                           ; 4A08
        pla                                     ; 4A0B
        sta     $1D                             ; 4A0C
        pla                                     ; 4A0E
        sta     $1B                             ; 4A0F
        jmp     L25CE                           ; 4A11

; ----------------------------------------------------------------------------
L4A14:  lda     #$10                            ; 4A14
        jsr     L27D7                           ; 4A16
        lda     $F506                           ; 4A19
        asl     a                               ; 4A1C
        asl     a                               ; 4A1D
        asl     a                               ; 4A1E
        asl     a                               ; 4A1F
        clc                                     ; 4A20
        adc     #$20                            ; 4A21
        sta     $1D                             ; 4A23
        lda     #$1B                            ; 4A25
        sta     $1B                             ; 4A27
        ldx     $F506                           ; 4A29
        lda     $F50A,x                         ; 4A2C
        sta     $50                             ; 4A2F
        lda     #$00                            ; 4A31
        sta     $4F                             ; 4A33
        lda     $F506                           ; 4A35
        cmp     $F51F                           ; 4A38
        bcc     L4A5B                           ; 4A3B
        lda     #$00                            ; 4A3D
        sta     $17                             ; 4A3F
        lda     $1D                             ; 4A41
        sta     L0010                           ; 4A43
        lda     #$1B                            ; 4A45
        sta     $0E                             ; 4A47
        .byte   $A9                             ; 4A49
L4A4A:  .byte   $27                             ; 4A4A
        sta     $12                             ; 4A4B
L4A4D:  jsr     L3F09                           ; 4A4D
        inc     L0010                           ; 4A50
        lda     L0010                           ; 4A52
        and     #$0F                            ; 4A54
        bne     L4A4D                           ; 4A56
        jmp     L27D5                           ; 4A58

; ----------------------------------------------------------------------------
L4A5B:  ldy     #$FF                            ; 4A5B
        ldx     #$0C                            ; 4A5D
L4A5F:  iny                                     ; 4A5F
        dex                                     ; 4A60
        lda     ($4F),y                         ; 4A61
        bmi     L4A5F                           ; 4A63
        txa                                     ; 4A65
        lsr     a                               ; 4A66
        adc     #$1B                            ; 4A67
        jsr     L4B0F                           ; 4A69
        jsr     L49B6                           ; 4A6C
        lda     #$27                            ; 4A6F
        jsr     L4B0F                           ; 4A71
        ldy     #$4C                            ; 4A74
        lda     ($4F),y                         ; 4A76
        sta     L0006                           ; 4A78
        ldx     #$03                            ; 4A7A
L4A7C:  lda     L4AEB,x                         ; 4A7C
        and     L0006                           ; 4A7F
        bne     L4ABE                           ; 4A81
        dex                                     ; 4A83
        bpl     L4A7C                           ; 4A84
        ldx     #$55                            ; 4A86
        ldy     #$14                            ; 4A88
        lda     #$08                            ; 4A8A
        jsr     L4B20                           ; 4A8C
        ldx     #$FF                            ; 4A8F
        ldy     #$18                            ; 4A91
        lda     #$0B                            ; 4A93
        jsr     L4B20                           ; 4A95
        ldx     #$AA                            ; 4A98
        ldy     #$1C                            ; 4A9A
        lda     #$0E                            ; 4A9C
        jsr     L4B20                           ; 4A9E
        lda     #$00                            ; 4AA1
        sta     $17                             ; 4AA3
        dec     L0010                           ; 4AA5
        lda     #$1B                            ; 4AA7
        sta     $0E                             ; 4AA9
        lda     #$27                            ; 4AAB
        sta     $12                             ; 4AAD
        jsr     L3F09                           ; 4AAF
        dec     L0010                           ; 4AB2
        dec     L0010                           ; 4AB4
        dec     L0010                           ; 4AB6
        jsr     L3F09                           ; 4AB8
        jmp     L27D5                           ; 4ABB

; ----------------------------------------------------------------------------
L4ABE:  clc                                     ; 4ABE
        lda     $1D                             ; 4ABF
        adc     #$08                            ; 4AC1
        sta     $1D                             ; 4AC3
        lda     #$1B                            ; 4AC5
        sta     $1B                             ; 4AC7
        txa                                     ; 4AC9
L4ACA:  pha                                     ; 4ACA
        lda     L4AEF,x                         ; 4ACB
        jsr     L4B0F                           ; 4ACE
        jsr     L475D                           ; 4AD1
        .byte   $54                             ; 4AD4
        .byte   $82                             ; 4AD5
        brk                                     ; 4AD6
        pla                                     ; 4AD7
        tax                                     ; 4AD8
        lda     L4AF3,x                         ; 4AD9
        ldy     L4AF7,x                         ; 4ADC
        tax                                     ; 4ADF
        jsr     L476C                           ; 4AE0
        lda     #$27                            ; 4AE3
        jsr     L4B0F                           ; 4AE5
        jmp     L27D5                           ; 4AE8

; ----------------------------------------------------------------------------
L4AEB:  .byte   $02                             ; 4AEB
        .byte   $04                             ; 4AEC
        .byte   $80                             ; 4AED
        .byte   $01                             ; 4AEE
L4AEF:  .byte   $1C                             ; 4AEF
        .byte   $1C                             ; 4AF0
        .byte   $1C                             ; 4AF1
        .byte   $1E                             ; 4AF2
L4AF3:  .byte   $FB                             ; 4AF3
        brk                                     ; 4AF4
        asl     $0B                             ; 4AF5
L4AF7:  lsr     a                               ; 4AF7
        .byte   $4B                             ; 4AF8
        .byte   $4B                             ; 4AF9
        .byte   $4B                             ; 4AFA
        .byte   $22                             ; 4AFB
        .byte   $44                             ; 4AFC
        .byte   $A7                             ; 4AFD
        clc                                     ; 4AFE
        ldy     #$83                            ; 4AFF
        cmp     $27,x                           ; 4B01
        clv                                     ; 4B03
        cmp     $00                             ; 4B04
        sty     $E8,x                           ; 4B06
        .byte   $E7                             ; 4B08
        clc                                     ; 4B09
        ldy     #$29                            ; 4B0A
        sty     $50                             ; 4B0C
        brk                                     ; 4B0E
L4B0F:  sec                                     ; 4B0F
        sbc     $1B                             ; 4B10
        bcc     L4B1F                           ; 4B12
        beq     L4B1F                           ; 4B14
        tax                                     ; 4B16
        lda     #$A0                            ; 4B17
L4B19:  jsr     L25B8                           ; 4B19
        dex                                     ; 4B1C
        bne     L4B19                           ; 4B1D
L4B1F:  rts                                     ; 4B1F

; ----------------------------------------------------------------------------
L4B20:  stx     $17                             ; 4B20
        clc                                     ; 4B22
        adc     $1D                             ; 4B23
        sta     L0010                           ; 4B25
        jsr     L4B6E                           ; 4B27
        beq     L4B48                           ; 4B2A
        iny                                     ; 4B2C
        tya                                     ; 4B2D
        pha                                     ; 4B2E
        lda     #$0B                            ; 4B2F
        sta     $82                             ; 4B31
        lda     #$00                            ; 4B33
        sta     $83                             ; 4B35
        jsr     L4302                           ; 4B37
        pla                                     ; 4B3A
        tay                                     ; 4B3B
        jsr     L4B6E                           ; 4B3C
        beq     L4B48                           ; 4B3F
        jsr     L4347                           ; 4B41
        inc     $7A                             ; 4B44
        lda     $7A                             ; 4B46
L4B48:  clc                                     ; 4B48
        adc     #$1B                            ; 4B49
        sta     $12                             ; 4B4B
        lda     #$1B                            ; 4B4D
        sta     $0E                             ; 4B4F
        jsr     L4B64                           ; 4B51
        ldx     $12                             ; 4B54
        cpx     #$27                            ; 4B56
        beq     L4B1F                           ; 4B58
        stx     $0E                             ; 4B5A
        ldx     #$27                            ; 4B5C
        stx     $12                             ; 4B5E
        lda     #$00                            ; 4B60
        sta     $17                             ; 4B62
L4B64:  inc     L0010                           ; 4B64
        jsr     L3F09                           ; 4B66
        dec     L0010                           ; 4B69
        jmp     L3F09                           ; 4B6B

; ----------------------------------------------------------------------------
L4B6E:  lda     ($4F),y                         ; 4B6E
        sta     $86                             ; 4B70
        iny                                     ; 4B72
        lda     ($4F),y                         ; 4B73
        sta     $87                             ; 4B75
        ora     $86                             ; 4B77
        rts                                     ; 4B79

; ----------------------------------------------------------------------------
L4B7A:  lda     L4C27                           ; 4B7A
        beq     L4B82                           ; 4B7D
        dec     L4C27                           ; 4B7F
L4B82:  lda     $79                             ; 4B82
        bne     L4BA6                           ; 4B84
        lda     L4C26                           ; 4B86
        beq     L4B8E                           ; 4B89
        dec     L4C26                           ; 4B8B
L4B8E:  lda     $F535                           ; 4B8E
        bne     L4BA6                           ; 4B91
        lda     L4C28                           ; 4B93
        ora     L4C29                           ; 4B96
        beq     L4BA6                           ; 4B99
        lda     L4C28                           ; 4B9B
        bne     L4BA3                           ; 4B9E
        dec     L4C29                           ; 4BA0
L4BA3:  dec     L4C28                           ; 4BA3
L4BA6:  rts                                     ; 4BA6

; ----------------------------------------------------------------------------
L4BA7:  lda     #$09                            ; 4BA7
        jsr     L3D13                           ; 4BA9
        bcs     L4BA6                           ; 4BAC
        ldx     #$00                            ; 4BAE
        jsr     L4BFD                           ; 4BB0
        bcs     L4BBD                           ; 4BB3
        beq     L4BBD                           ; 4BB5
        clc                                     ; 4BB7
        adc     #$09                            ; 4BB8
        jsr     L3E58                           ; 4BBA
L4BBD:  ldx     #$01                            ; 4BBD
        jsr     L4BFD                           ; 4BBF
        bcs     L4BCB                           ; 4BC2
        beq     L4BCB                           ; 4BC4
        lda     #$0E                            ; 4BC6
        jsr     L3E58                           ; 4BC8
L4BCB:  ldx     #$02                            ; 4BCB
        jsr     L4BFD                           ; 4BCD
        bcs     L4BD9                           ; 4BD0
        beq     L4BD9                           ; 4BD2
        lda     #$0F                            ; 4BD4
        jsr     L3E58                           ; 4BD6
L4BD9:  ldx     #$03                            ; 4BD9
        jsr     L4BFD                           ; 4BDB
        bcs     L4BFC                           ; 4BDE
        lda     L4C26                           ; 4BE0
        bne     L4BFC                           ; 4BE3
        lda     #$06                            ; 4BE5
        sta     L4C26                           ; 4BE7
L4BEA:  jsr     L4D4C                           ; 4BEA
        and     #$03                            ; 4BED
        clc                                     ; 4BEF
        adc     #$10                            ; 4BF0
        .byte   $C9                             ; 4BF2
L4BF3:  brk                                     ; 4BF3
        beq     L4BEA                           ; 4BF4
        sta     L4BF3                           ; 4BF6
        jmp     L3E58                           ; 4BF9

; ----------------------------------------------------------------------------
L4BFC:  rts                                     ; 4BFC

; ----------------------------------------------------------------------------
L4BFD:  lda     $F5BE,x                         ; 4BFD
        beq     L4C0A                           ; 4C00
        cmp     L4C22,x                         ; 4C02
        sta     L4C22,x                         ; 4C05
        clc                                     ; 4C08
        rts                                     ; 4C09

; ----------------------------------------------------------------------------
L4C0A:  lda     L4C22,x                         ; 4C0A
        bne     L4C11                           ; 4C0D
        sec                                     ; 4C0F
        rts                                     ; 4C10

; ----------------------------------------------------------------------------
L4C11:  lda     #$09                            ; 4C11
        jsr     L3E58                           ; 4C13
        ldx     #$03                            ; 4C16
        lda     #$00                            ; 4C18
L4C1A:  sta     L4C22,x                         ; 4C1A
        dex                                     ; 4C1D
        bpl     L4C1A                           ; 4C1E
        sec                                     ; 4C20
        rts                                     ; 4C21

; ----------------------------------------------------------------------------
L4C22:  brk                                     ; 4C22
        brk                                     ; 4C23
        brk                                     ; 4C24
        brk                                     ; 4C25
L4C26:  brk                                     ; 4C26
L4C27:  brk                                     ; 4C27
L4C28:  brk                                     ; 4C28
L4C29:  brk                                     ; 4C29
L4C2A:  sei                                     ; 4C2A
        lda     #$00                            ; 4C2B
        sta     $FF0A                           ; 4C2D
        rts                                     ; 4C30

; ----------------------------------------------------------------------------
L4C31:  ldx     #$FE                            ; 4C31
        stx     L4CF6                           ; 4C33
        ldx     #$07                            ; 4C36
L4C38:  lda     L4CF6                           ; 4C38
        jsr     L4D37                           ; 4C3B
        ora     L4C87,x                         ; 4C3E
        cmp     L4C8F,x                         ; 4C41
        bne     L4C4E                           ; 4C44
L4C46:  sec                                     ; 4C46
        rol     L4CF6                           ; 4C47
        dex                                     ; 4C4A
        bpl     L4C38                           ; 4C4B
        rts                                     ; 4C4D

; ----------------------------------------------------------------------------
L4C4E:  cmp     #$FF                            ; 4C4E
        bne     L4C57                           ; 4C50
        sta     L4C8F,x                         ; 4C52
        beq     L4C46                           ; 4C55
L4C57:  ldy     L4C8F,x                         ; 4C57
        cpy     #$FF                            ; 4C5A
        bne     L4C46                           ; 4C5C
        pha                                     ; 4C5E
        txa                                     ; 4C5F
        asl     a                               ; 4C60
        asl     a                               ; 4C61
        asl     a                               ; 4C62
        tay                                     ; 4C63
        pla                                     ; 4C64
        sta     L4C8F,x                         ; 4C65
        dey                                     ; 4C68
L4C69:  asl     a                               ; 4C69
        iny                                     ; 4C6A
        bcs     L4C69                           ; 4C6B
        lda     L4C97,y                         ; 4C6D
        bpl     L4C86                           ; 4C70
        inc     L4CF7                           ; 4C72
        ldx     L4CF7                           ; 4C75
        cpx     #$10                            ; 4C78
        bcc     L4C80                           ; 4C7A
        dex                                     ; 4C7C
        stx     L4CF7                           ; 4C7D
L4C80:  jsr     L4D07                           ; 4C80
        sta     L4CF7,x                         ; 4C83
L4C86:  rts                                     ; 4C86

; ----------------------------------------------------------------------------
L4C87:  asl     $00                             ; 4C87
        brk                                     ; 4C89
        brk                                     ; 4C8A
        brk                                     ; 4C8B
        brk                                     ; 4C8C
        .byte   $80                             ; 4C8D
        brk                                     ; 4C8E
L4C8F:  .byte   $FF                             ; 4C8F
        .byte   $FF                             ; 4C90
        .byte   $FF                             ; 4C91
        .byte   $FF                             ; 4C92
        .byte   $FF                             ; 4C93
        .byte   $FF                             ; 4C94
        .byte   $FF                             ; 4C95
        .byte   $FF                             ; 4C96
L4C97:  tya                                     ; 4C97
        sbc     ($00),y                         ; 4C98
        ldy     #$B2                            ; 4C9A
        brk                                     ; 4C9C
        brk                                     ; 4C9D
        lda     ($BF),y                         ; 4C9E
        .byte   $AB                             ; 4CA0
        lda     $959B,x                         ; 4CA1
        .byte   $BB                             ; 4CA4
        tax                                     ; 4CA5
        sta     L00AC,x                         ; 4CA6
        lda     $AEBA                           ; 4CA8
        dey                                     ; 4CAB
        cpx     $88F0                           ; 4CAC
        inc     $EBEF                           ; 4CAF
        sbc     $EAB0                           ; 4CB2
        sbc     #$B9                            ; 4CB5
        inc     $F5,x                           ; 4CB7
        inx                                     ; 4CB9
        .byte   $E2                             ; 4CBA
        clv                                     ; 4CBB
        .byte   $E7                             ; 4CBC
        sbc     $F8B7,y                         ; 4CBD
        .byte   $F4                             ; 4CC0
        inc     $E3                             ; 4CC1
        ldx     $E4,y                           ; 4CC3
        .byte   $F2                             ; 4CC5
        lda     $00,x                           ; 4CC6
        sbc     $F3                             ; 4CC8
        .byte   $FA                             ; 4CCA
        ldy     $E1,x                           ; 4CCB
        .byte   $F7                             ; 4CCD
        .byte   $B3                             ; 4CCE
        brk                                     ; 4CCF
        lda     $B3,x                           ; 4CD0
        lda     (L00B7),y                       ; 4CD2
        brk                                     ; 4CD4
        .byte   $8D                             ; 4CD5
        dey                                     ; 4CD6
L4CD7:  lda     $DA                             ; 4CD7
        bmi     L4CF5                           ; 4CD9
        lda     L4CF7                           ; 4CDB
        beq     L4CF5                           ; 4CDE
        lda     L4CF8                           ; 4CE0
        sta     $DA                             ; 4CE3
        ldx     #$00                            ; 4CE5
L4CE7:  lda     L4CF9,x                         ; 4CE7
        sta     L4CF8,x                         ; 4CEA
        inx                                     ; 4CED
        cpx     #$0E                            ; 4CEE
        bne     L4CE7                           ; 4CF0
        dec     L4CF7                           ; 4CF2
L4CF5:  rts                                     ; 4CF5

; ----------------------------------------------------------------------------
L4CF6:  .byte   $FE                             ; 4CF6
L4CF7:  brk                                     ; 4CF7
L4CF8:  brk                                     ; 4CF8
L4CF9:  brk                                     ; 4CF9
        brk                                     ; 4CFA
        brk                                     ; 4CFB
        brk                                     ; 4CFC
        brk                                     ; 4CFD
        brk                                     ; 4CFE
        brk                                     ; 4CFF
        brk                                     ; 4D00
        brk                                     ; 4D01
        brk                                     ; 4D02
        brk                                     ; 4D03
        brk                                     ; 4D04
        brk                                     ; 4D05
        brk                                     ; 4D06
L4D07:  pha                                     ; 4D07
        lda     #$FD                            ; 4D08
        jsr     L4D37                           ; 4D0A
L4D0D:  and     #$80                            ; 4D0D
        bne     L4D2C                           ; 4D0F
        pla                                     ; 4D11
        cmp     #$B1                            ; 4D12
        bcc     L4D24                           ; 4D14
        cmp     #$BA                            ; 4D16
        bcc     L4D25                           ; 4D18
        cmp     #$E1                            ; 4D1A
        bcc     L4D24                           ; 4D1C
        cmp     #$FB                            ; 4D1E
        bcs     L4D24                           ; 4D20
        and     #$DF                            ; 4D22
L4D24:  rts                                     ; 4D24

; ----------------------------------------------------------------------------
L4D25:  and     #$0F                            ; 4D25
        tay                                     ; 4D27
        lda     L4D2D,y                         ; 4D28
        rts                                     ; 4D2B

; ----------------------------------------------------------------------------
L4D2C:  pla                                     ; 4D2C
L4D2D:  rts                                     ; 4D2D

; ----------------------------------------------------------------------------
        lda     ($A2,x)                         ; 4D2E
        .byte   $A3                             ; 4D30
        ldy     $A5                             ; 4D31
        ldx     $A7                             ; 4D33
        tay                                     ; 4D35
        .byte   $A9                             ; 4D36
L4D37:  sta     $FD30                           ; 4D37
        sta     $FF08                           ; 4D3A
        lda     $FF08                           ; 4D3D
        rts                                     ; 4D40

; ----------------------------------------------------------------------------
L4D41:  lda     $DA                             ; 4D41
        bpl     L4D4B                           ; 4D43
        pha                                     ; 4D45
        lda     #$00                            ; 4D46
        sta     $DA                             ; 4D48
        pla                                     ; 4D4A
L4D4B:  rts                                     ; 4D4B

; ----------------------------------------------------------------------------
L4D4C:  .byte   $AD                             ; 4D4C
L4D4D:  lsr     $6D4D,x                         ; 4D4D
        ora     $65FF,x                         ; 4D50
        .byte   $DA                             ; 4D53
        adc     $FF00                           ; 4D54
        adc     $FF1E                           ; 4D57
        sta     L4D5E                           ; 4D5A
        rts                                     ; 4D5D

; ----------------------------------------------------------------------------
L4D5E:  brk                                     ; 4D5E
        brk                                     ; 4D5F
L4D60:  bit     $01                             ; 4D60
        bvc     L4D60                           ; 4D62
        sta     $FF                             ; 4D64
        lda     #$D2                            ; 4D66
        sta     $FF13                           ; 4D68
        ldy     #$04                            ; 4D6B
L4D6D:  nop                                     ; 4D6D
        nop                                     ; 4D6E
        nop                                     ; 4D6F
        lda     #$0A                            ; 4D70
        asl     $FF                             ; 4D72
        bcc     L4D78                           ; 4D74
        lda     #$0B                            ; 4D76
L4D78:  sta     $01                             ; 4D78
        nop                                     ; 4D7A
        nop                                     ; 4D7B
        nop                                     ; 4D7C
        nop                                     ; 4D7D
        lda     #$08                            ; 4D7E
        asl     $FF                             ; 4D80
        bcc     L4D86                           ; 4D82
        lda     #$09                            ; 4D84
L4D86:  sta     $01                             ; 4D86
        nop                                     ; 4D88
        nop                                     ; 4D89
        nop                                     ; 4D8A
        nop                                     ; 4D8B
        nop                                     ; 4D8C
        dey                                     ; 4D8D
        bne     L4D6D                           ; 4D8E
        lda     #$08                            ; 4D90
        sta     $01                             ; 4D92
        lda     #$D0                            ; 4D94
        sta     $FF13                           ; 4D96
        rts                                     ; 4D99

; ----------------------------------------------------------------------------
L4D9A:  bit     $01                             ; 4D9A
        bvc     L4D9A                           ; 4D9C
        lda     #$D2                            ; 4D9E
        sta     $FF13                           ; 4DA0
        ldy     #$04                            ; 4DA3
L4DA5:  lda     #$89                            ; 4DA5
        sta     $01                             ; 4DA7
        jsr     LFF99                           ; 4DA9
        lda     $01                             ; 4DAC
        and     #$40                            ; 4DAE
        cmp     #$40                            ; 4DB0
        rol     $FF                             ; 4DB2
        lda     #$88                            ; 4DB4
        sta     $01                             ; 4DB6
        jsr     LFF99                           ; 4DB8
        lda     $01                             ; 4DBB
        and     #$40                            ; 4DBD
        cmp     #$40                            ; 4DBF
        rol     $FF                             ; 4DC1
        dey                                     ; 4DC3
        bne     L4DA5                           ; 4DC4
        lda     #$89                            ; 4DC6
        sta     $01                             ; 4DC8
        jsr     LFF99                           ; 4DCA
        lda     #$08                            ; 4DCD
        sta     $01                             ; 4DCF
        lda     #$D0                            ; 4DD1
        sta     $FF13                           ; 4DD3
        lda     $FF                             ; 4DD6
        rts                                     ; 4DD8

; ----------------------------------------------------------------------------
        nop                                     ; 4DD9
        nop                                     ; 4DDA
        nop                                     ; 4DDB
        nop                                     ; 4DDC
        nop                                     ; 4DDD
        rts                                     ; 4DDE

; ----------------------------------------------------------------------------
        lda     $D8                             ; 4DDF
        sta     $FFFA                           ; 4DE1
        lda     $D9                             ; 4DE4
        sta     $FFF9                           ; 4DE6
        jsr     LFFAF                           ; 4DE9
        jmp     L3795                           ; 4DEC

; ----------------------------------------------------------------------------
        ldx     #$00                            ; 4DEF
L4DF1:  sec                                     ; 4DF1
        lda     $FFFA                           ; 4DF2
        sbc     L37DD,x                         ; 4DF5
        tay                                     ; 4DF8
        lda     $FFF9                           ; 4DF9
        sbc     #$00                            ; 4DFC
        bcc     L4E09                           ; 4DFE
        inx                                     ; 4E00
        sta     $FFF9                           ; 4E01
        sty     $FFFA                           ; 4E04
        bcs     L4DF1                           ; 4E07
L4E09:  inx                                     ; 4E09
        cpx     #$23                            ; 4E0A
        beq     L4E17                           ; 4E0C
        cpx     #$12                            ; 4E0E
        bcc     L4E13                           ; 4E10
        inx                                     ; 4E12
L4E13:  stx     $FFF9                           ; 4E13
        rts                                     ; 4E16

; ----------------------------------------------------------------------------
L4E17:  lda     #$12                            ; 4E17
        sta     $FFF9                           ; 4E19
        sec                                     ; 4E1C
        sbc     $FFFA                           ; 4E1D
        sta     $FFFA                           ; 4E20
        rts                                     ; 4E23

; ----------------------------------------------------------------------------
        lda     #$09                            ; 4E24
L4E26:  sta     $01                             ; 4E26
        lda     $D5                             ; 4E28
        jsr     LFF20                           ; 4E2A
        lda     $FFF9                           ; 4E2D
        jsr     LFF20                           ; 4E30
        lda     $FFFA                           ; 4E33
        jmp     LFF20                           ; 4E36

; ----------------------------------------------------------------------------
; Copies code from $5600 to $ff20
Copy_LoaderCode_To_FF20:
        lda     #$24                            ; 4E39
        cmp     $5600                           ; 4E3B
        beq     L4E51                           ; 4E3E
        sta     L4E26                           ; 4E40
        sta     L37D5                           ; 4E43
        ldx     #$7E                            ; 4E46
        lda     $5600,x                         ; 4E48
        .byte   $9D                             ; 4E4B
        rts                                     ; 4E4C

; ----------------------------------------------------------------------------
L4E4D:  eor     L10CA                           ; 4E4D
        .byte   $F7                             ; 4E50
L4E51:  ldx     #$00                            ; 4E51
        sei                                     ; 4E53
L4E54:  lda     L4D60,x                         ; 4E54
        sta     LFF20,x                         ; 4E57
        inx                                     ; 4E5A
        cpx     #$D9                            ; 4E5B
        bne     L4E54                           ; 4E5D
        lda     #$50                            ; 4E5F
        sta     LFFFC                           ; 4E61
        lda     #$06                            ; 4E64
        sta     $FFFD                           ; 4E66
        ldx     #$00                            ; 4E69
L4E6B:  lda     L4E80,x                         ; 4E6B
        sta     $0100,x                         ; 4E6E
        inx                                     ; 4E71
        cpx     #$A0                            ; 4E72
L4E74:  bne     L4E6B                           ; 4E74
        rts                                     ; 4E76

; ----------------------------------------------------------------------------
        brk                                     ; 4E77
        brk                                     ; 4E78
        brk                                     ; 4E79
        brk                                     ; 4E7A
        brk                                     ; 4E7B
        brk                                     ; 4E7C
        brk                                     ; 4E7D
        brk                                     ; 4E7E
        brk                                     ; 4E7F
L4E80:  brk                                     ; 4E80
        rti                                     ; 4E81

; ----------------------------------------------------------------------------
        .byte   $80                             ; 4E82
        cpy     #$00                            ; 4E83
        rti                                     ; 4E85

; ----------------------------------------------------------------------------
        .byte   $80                             ; 4E86
        cpy     #$00                            ; 4E87
        rti                                     ; 4E89

; ----------------------------------------------------------------------------
        .byte   $80                             ; 4E8A
        cpy     #$00                            ; 4E8B
        rti                                     ; 4E8D

; ----------------------------------------------------------------------------
        .byte   $80                             ; 4E8E
        cpy     #$00                            ; 4E8F
        rti                                     ; 4E91

; ----------------------------------------------------------------------------
        .byte   $80                             ; 4E92
        cpy     #$00                            ; 4E93
        rti                                     ; 4E95

; ----------------------------------------------------------------------------
        .byte   $80                             ; 4E96
        cpy     #$60                            ; 4E97
        adc     ($62,x)                         ; 4E99
        .byte   $63                             ; 4E9B
        adc     $66                             ; 4E9C
        .byte   $67                             ; 4E9E
        pla                                     ; 4E9F
        ror     a                               ; 4EA0
        .byte   $6B                             ; 4EA1
        jmp     (L6F6D)                         ; 4EA2

; ----------------------------------------------------------------------------
        bvs     L4F18                           ; 4EA5
        .byte   $72                             ; 4EA7
        .byte   $74                             ; 4EA8
        adc     $76,x                           ; 4EA9
        .byte   $77                             ; 4EAB
        adc     $7B7A,y                         ; 4EAC
        .byte   $7C                             ; 4EAF
        brk                                     ; 4EB0
        plp                                     ; 4EB1
        bvc     L4F2C                           ; 4EB2
        ldy     #$C8                            ; 4EB4
        beq     L4ED0                           ; 4EB6
        rti                                     ; 4EB8

; ----------------------------------------------------------------------------
        pla                                     ; 4EB9
        bcc     L4E74                           ; 4EBA
L4EBC:  cpx     #$08                            ; 4EBC
        bmi     L4F18                           ; 4EBE
        .byte   $80                             ; 4EC0
        tay                                     ; 4EC1
        bne     L4EBC                           ; 4EC2
        jsr     L7048                           ; 4EC4
        tya                                     ; 4EC7
        brk                                     ; 4EC8
        brk                                     ; 4EC9
        brk                                     ; 4ECA
        brk                                     ; 4ECB
        brk                                     ; 4ECC
        brk                                     ; 4ECD
        brk                                     ; 4ECE
        .byte   $01                             ; 4ECF
L4ED0:  ora     ($01,x)                         ; 4ED0
        ora     ($01,x)                         ; 4ED2
        ora     ($02,x)                         ; 4ED4
        .byte   $02                             ; 4ED6
        .byte   $02                             ; 4ED7
        .byte   $02                             ; 4ED8
        .byte   $02                             ; 4ED9
        .byte   $02                             ; 4EDA
        .byte   $02                             ; 4EDB
        .byte   $03                             ; 4EDC
        .byte   $03                             ; 4EDD
        .byte   $03                             ; 4EDE
        .byte   $03                             ; 4EDF
        lda     #$00                            ; 4EE0
        sta     $FF                             ; 4EE2
        txa                                     ; 4EE4
        asl     a                               ; 4EE5
        asl     a                               ; 4EE6
        asl     a                               ; 4EE7
        rol     $FF                             ; 4EE8
        sta     $D5                             ; 4EEA
        tya                                     ; 4EEC
        lsr     a                               ; 4EED
        lsr     a                               ; 4EEE
        lsr     a                               ; 4EEF
        tax                                     ; 4EF0
        clc                                     ; 4EF1
        tya                                     ; 4EF2
        and     #$07                            ; 4EF3
        ora     $D5                             ; 4EF5
        adc     $0100,x                         ; 4EF7
        tay                                     ; 4EFA
        lda     $FF                             ; 4EFB
        adc     $0118,x                         ; 4EFD
        rts                                     ; 4F00

; ----------------------------------------------------------------------------
        lda     #$00                            ; 4F01
        sta     $FF                             ; 4F03
        txa                                     ; 4F05
        asl     a                               ; 4F06
        asl     a                               ; 4F07
        asl     a                               ; 4F08
        rts                                     ; 4F09

; ----------------------------------------------------------------------------
        tya                                     ; 4F0A
        bit     $8A                             ; 4F0B
        lsr     a                               ; 4F0D
        lsr     a                               ; 4F0E
        lsr     a                               ; 4F0F
        lsr     a                               ; 4F10
        rts                                     ; 4F11

; ----------------------------------------------------------------------------
        txa                                     ; 4F12
        lsr     a                               ; 4F13
        lsr     a                               ; 4F14
        lsr     a                               ; 4F15
        lsr     a                               ; 4F16
        tay                                     ; 4F17
L4F18:  rts                                     ; 4F18

; ----------------------------------------------------------------------------
        sta     L26E1                           ; 4F19
        sta     L0539                           ; 4F1C
        rts                                     ; 4F1F

; ----------------------------------------------------------------------------
        brk                                     ; 4F20
        brk                                     ; 4F21
        brk                                     ; 4F22
        brk                                     ; 4F23
        brk                                     ; 4F24
        brk                                     ; 4F25
        brk                                     ; 4F26
        brk                                     ; 4F27
        brk                                     ; 4F28
        brk                                     ; 4F29
        brk                                     ; 4F2A
        brk                                     ; 4F2B
L4F2C:  brk                                     ; 4F2C
        brk                                     ; 4F2D
        brk                                     ; 4F2E
        brk                                     ; 4F2F
        brk                                     ; 4F30
        brk                                     ; 4F31
        brk                                     ; 4F32
        brk                                     ; 4F33
        brk                                     ; 4F34
        brk                                     ; 4F35
        brk                                     ; 4F36
        brk                                     ; 4F37
        brk                                     ; 4F38
        brk                                     ; 4F39
        brk                                     ; 4F3A
        brk                                     ; 4F3B
        brk                                     ; 4F3C
        brk                                     ; 4F3D
        brk                                     ; 4F3E
        brk                                     ; 4F3F
        brk                                     ; 4F40
        brk                                     ; 4F41
        brk                                     ; 4F42
        brk                                     ; 4F43
        brk                                     ; 4F44
        brk                                     ; 4F45
        brk                                     ; 4F46
        brk                                     ; 4F47
        brk                                     ; 4F48
        brk                                     ; 4F49
        brk                                     ; 4F4A
        brk                                     ; 4F4B
        brk                                     ; 4F4C
L4F4D:  brk                                     ; 4F4D
        brk                                     ; 4F4E
        brk                                     ; 4F4F
        brk                                     ; 4F50
        brk                                     ; 4F51
        brk                                     ; 4F52
        brk                                     ; 4F53
        brk                                     ; 4F54
        brk                                     ; 4F55
        brk                                     ; 4F56
        brk                                     ; 4F57
        brk                                     ; 4F58
        brk                                     ; 4F59
        brk                                     ; 4F5A
        brk                                     ; 4F5B
        brk                                     ; 4F5C
        brk                                     ; 4F5D
        brk                                     ; 4F5E
        brk                                     ; 4F5F
        brk                                     ; 4F60
        brk                                     ; 4F61
        brk                                     ; 4F62
        brk                                     ; 4F63
        brk                                     ; 4F64
        brk                                     ; 4F65
        brk                                     ; 4F66
        brk                                     ; 4F67
        brk                                     ; 4F68
        brk                                     ; 4F69
        brk                                     ; 4F6A
        brk                                     ; 4F6B
        brk                                     ; 4F6C
        brk                                     ; 4F6D
        brk                                     ; 4F6E
        brk                                     ; 4F6F
        brk                                     ; 4F70
        brk                                     ; 4F71
        brk                                     ; 4F72
        brk                                     ; 4F73
        brk                                     ; 4F74
        brk                                     ; 4F75
        brk                                     ; 4F76
        brk                                     ; 4F77
        brk                                     ; 4F78
        brk                                     ; 4F79
        brk                                     ; 4F7A
        brk                                     ; 4F7B
        brk                                     ; 4F7C
        brk                                     ; 4F7D
        brk                                     ; 4F7E
        brk                                     ; 4F7F
        brk                                     ; 4F80
        brk                                     ; 4F81
        brk                                     ; 4F82
        brk                                     ; 4F83
        brk                                     ; 4F84
        brk                                     ; 4F85
        brk                                     ; 4F86
        brk                                     ; 4F87
        brk                                     ; 4F88
        brk                                     ; 4F89
        brk                                     ; 4F8A
        brk                                     ; 4F8B
        brk                                     ; 4F8C
        brk                                     ; 4F8D
        brk                                     ; 4F8E
        brk                                     ; 4F8F
        brk                                     ; 4F90
        brk                                     ; 4F91
        brk                                     ; 4F92
        brk                                     ; 4F93
        brk                                     ; 4F94
        brk                                     ; 4F95
        brk                                     ; 4F96
        brk                                     ; 4F97
        brk                                     ; 4F98
        brk                                     ; 4F99
        brk                                     ; 4F9A
        brk                                     ; 4F9B
        brk                                     ; 4F9C
        brk                                     ; 4F9D
        brk                                     ; 4F9E
        brk                                     ; 4F9F
        brk                                     ; 4FA0
        brk                                     ; 4FA1
        brk                                     ; 4FA2
        brk                                     ; 4FA3
        brk                                     ; 4FA4
        brk                                     ; 4FA5
        brk                                     ; 4FA6
        brk                                     ; 4FA7
        brk                                     ; 4FA8
        brk                                     ; 4FA9
        brk                                     ; 4FAA
        brk                                     ; 4FAB
        brk                                     ; 4FAC
        brk                                     ; 4FAD
        brk                                     ; 4FAE
        brk                                     ; 4FAF
        brk                                     ; 4FB0
        brk                                     ; 4FB1
        brk                                     ; 4FB2
        brk                                     ; 4FB3
        brk                                     ; 4FB4
        brk                                     ; 4FB5
        brk                                     ; 4FB6
        brk                                     ; 4FB7
        brk                                     ; 4FB8
        brk                                     ; 4FB9
        brk                                     ; 4FBA
        brk                                     ; 4FBB
        brk                                     ; 4FBC
        brk                                     ; 4FBD
        brk                                     ; 4FBE
        brk                                     ; 4FBF
        brk                                     ; 4FC0
        brk                                     ; 4FC1
        brk                                     ; 4FC2
        brk                                     ; 4FC3
        brk                                     ; 4FC4
        brk                                     ; 4FC5
        brk                                     ; 4FC6
        brk                                     ; 4FC7
        brk                                     ; 4FC8
        brk                                     ; 4FC9
        brk                                     ; 4FCA
        brk                                     ; 4FCB
        brk                                     ; 4FCC
        brk                                     ; 4FCD
        brk                                     ; 4FCE
        brk                                     ; 4FCF
        brk                                     ; 4FD0
        brk                                     ; 4FD1
        brk                                     ; 4FD2
        brk                                     ; 4FD3
        brk                                     ; 4FD4
        brk                                     ; 4FD5
        brk                                     ; 4FD6
        brk                                     ; 4FD7
        brk                                     ; 4FD8
        brk                                     ; 4FD9
        brk                                     ; 4FDA
        brk                                     ; 4FDB
        brk                                     ; 4FDC
        brk                                     ; 4FDD
        brk                                     ; 4FDE
        brk                                     ; 4FDF
        brk                                     ; 4FE0
        brk                                     ; 4FE1
        brk                                     ; 4FE2
        brk                                     ; 4FE3
        brk                                     ; 4FE4
        brk                                     ; 4FE5
        brk                                     ; 4FE6
        brk                                     ; 4FE7
        brk                                     ; 4FE8
        brk                                     ; 4FE9
        brk                                     ; 4FEA
        brk                                     ; 4FEB
        brk                                     ; 4FEC
        brk                                     ; 4FED
        brk                                     ; 4FEE
        brk                                     ; 4FEF
        brk                                     ; 4FF0
        brk                                     ; 4FF1
        brk                                     ; 4FF2
        brk                                     ; 4FF3
        brk                                     ; 4FF4
        brk                                     ; 4FF5
        brk                                     ; 4FF6
        brk                                     ; 4FF7
        brk                                     ; 4FF8
        brk                                     ; 4FF9
        brk                                     ; 4FFA
        brk                                     ; 4FFB
        brk                                     ; 4FFC
        brk                                     ; 4FFD
        brk                                     ; 4FFE
        brk                                     ; 4FFF
        brk                                     ; 5000
        brk                                     ; 5001
        brk                                     ; 5002
        brk                                     ; 5003
        brk                                     ; 5004
        brk                                     ; 5005
        brk                                     ; 5006
        brk                                     ; 5007
        brk                                     ; 5008
        brk                                     ; 5009
        brk                                     ; 500A
        brk                                     ; 500B
        brk                                     ; 500C
        brk                                     ; 500D
        brk                                     ; 500E
        brk                                     ; 500F
        brk                                     ; 5010
        brk                                     ; 5011
        lda     $BDBD,x                         ; 5012
        lda     $BDBD,x                         ; 5015
        lda     $BDBD,x                         ; 5018
        lda     $BDBD,x                         ; 501B
        .byte   $BD                             ; 501E
        .byte   $BD                             ; 501F
