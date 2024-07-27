
; Patch for Directory_browser_v1_2.prg for fastload protocol for tcbm2sd
; by Maciej 'YTM/Elysium' Witkowiak <ytm@elysium.pl>, 2024-07-12

; adapted from Warpload 1551 with ACK after each data read

RAM_VERFCK = $93            ;VERFCK  Flag:  0 = load,  1 = verify
tgt = $9D                   ; (2)
RAM_LA = $AC
RAM_SA = $AD
RAM_FA = $AE                ; FA      Current device number
RAM_MEMUSS = $B4            ; (2) ;MEMUSS  Load ram base
a05FF = $D8                 ; (1) temp storagefor load address flag, can be anywhere

; KERNAL routines without jumptable
ICLRCHN = $EF0C             ;ICLRCHN $FFCC
ISENDSA = $F005             ;SEND SA ; before TALK? and it's not TLKSA
ITALK = $EDFA               ;TALK
ITLKSA = $EE1A              ;TKSA

; IO

aFEF0 = $FEF0              ; portA
aFEF1 = $FEF1              ; portB 1/0
aFEF2 = $FEF2              ; portC 7/6
aFEF3 = $FEF3              ; portA DDR
aFF06 = $FF06              ; like $d011 for screen blank

        ;; the fastload part
        ;; prepare everything in the usual way (SETLFS, SETNAM, A/X/Y parameters for LOAD)
        ;; and jump here instead of LOAD

FastLoad
        sta RAM_VERFCK                              ; ;VERFCK  Flag:  0 = load,  1 = verify
        lda RAM_FA                                  ; remember device number in LA ;FA      Current device number
        sta RAM_LA                                  ; ;LA      Current logical fiie number

        jsr ICLRCHN                                 ; ;ICLRCHN $FFCC
        ldx RAM_SA                                  ; ;SA      Current seconda.y address
        stx a05FF                                   ; ;preserve SA (LOAD address parameter (set in $B4/B5 (RAM_MEMUSS) or from file))
        lda #$60
        sta RAM_SA                                  ; ;SA      Current seconda.y address
        jsr ISENDSA                                 ; ;SEND SA ; send name with SA=$60
        lda RAM_FA                                  ; ;FA      Current device number
        jsr ITALK                                   ; ;TALK
        lda #$70                                    ; ;SA      Fastload indicator - on channel 16 (treated as channel 0 = LOAD)
        jsr ITLKSA                                  ; ;TLKSA

        sei
        lda aFF06                                   ; ;preserve FF06 (like $D011, before blank)
        pha
        lda #0
        sta aFF06                                   ; ;like $D011, blank screen
        sta aFEF3                                   ; ;port A DDR = input first
        sta aFEF0                                   ; ;port A (to clear pullups?)
        sta aFEF2                                   ; ;DAV=0 - WE ARE READY

        bit aFEF2                                   ; ;wait for ACK low
        bmi *-3
        lda aFEF0                                   ; ;1st byte = load addr low  ; need to flip ACK after this
        sta tgt
        lda #$40                                    ; DAV=1 confirm
        sta aFEF2
        lda aFEF1                                   ; STATUS
        and #%00000011
        bne LOADEND                                 ; file not found

        bit aFEF2                                   ; ;wait for ACK high
        bpl *-3
        lda aFEF0                                   ; ;2nd byte = load addr high ; need to flip ACK after this
        sta tgt+1
        lda #$00                                    ; DAV=0 confirm
        sta aFEF2
        lda aFEF1                                   ; STATUS
        and #%00000011
        bne LOADEND                                 ; error

        lda a05FF                                   ; ;check if we load to load addr from file or from $b4/b5 (RAM_MEMUSS)
        bne LOADSTART
        lda RAM_MEMUSS
        sta tgt
        lda RAM_MEMUSS+1
        sta tgt+1

LOADSTART
        ldy #0
LOADLOOP
        lda aFEF2                                   ; ;wait for ACK low
        bmi *-3
;inc $FF19
        lda aFEF0
        sta (tgt),y
        iny
        ldx aFEF1                                   ; STATUS
        lda #$40                                    ; DAV=1 confirm
        sta aFEF2
        txa                                         ; EOI?
        and #%00000011
        bne LOADEND

        lda aFEF2                                   ; ;wait for DAV high
        bpl *-3
;inc $FF19
        lda aFEF0                                   ; XXX need to flip ACK after this
        sta (tgt),y
        iny
        ldx aFEF1                                   ; STATUS
        lda #$00                                    ; DAV=0 confirm
        sta aFEF2
        txa                                         ; EOI?
        and #%00000011
        bne LOADEND

        tya
        bne LOADLOOP
        inc tgt+1
        bne LOADLOOP

LOADEND
        lda #$40                                    ; ;$40 = ACK (bit 6) to 1
        sta aFEF2
        pla
        sta aFF06                                   ; ;restore FF06 (like $D011), turn off blank
        cli

        tya                                         ; adjust end address (Y was already increased so just take care about low byte)
        clc
        adc tgt
        sta tgt
        bcc LOADRET
        inc tgt+1

LOADRET
        lda #$ff                                    ; ;port A to output (a bit delayed after ACK)
        sta aFEF3

        ldx tgt
        ldy tgt+1                                   ; ;return end address+1 and C=0=no error
        clc                                         ; no error
        rts
