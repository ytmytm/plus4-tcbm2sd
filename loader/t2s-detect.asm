
;; detect tcbm2sd device from 'TCBM2SD' string existing in reset string

;; tcbm2sd_flag    .byte 1 ; <>0 = TCBM2SD, 0=any other drive (IEC or 1551)

;status_buffer = $0fc0 ; $0fc0 to make it visible in status line

detect_t2sd:
        sta ROM_SELECT
        cli

        lda #2	; name length
        ldx #<detect_t2sd_cmd	; name address low
        ldy #>detect_t2sd_cmd	; name address high
        jsr SETNAM

        lda #$0f    ; file number is command channel
        ldx current_drive_number     ; drive number
        tay         ; command channel
        jsr SETLFS

        jsr OPEN
        bcs detect_t2sd_2

        ldx #$0f    ; file number
        jsr CHKIN

        ldx #0
detect_t2sd_loop1   ; read status
        jsr READST
        bne detect_t2sd_2
        jsr CHRIN
        sta status_buffer,x ; message line
        inx
        cpx #40     ; one line at most
        bne detect_t2sd_loop1

detect_t2sd_2
        jsr CLRCHN
        lda #$0f    ; channel
        jsr CLOSE

        sei
        sta RAM_SELECT

        ; search for signature
        lda #<status_buffer
        sta $d0
        lda #>status_buffer
        sta $d1
        ldy #0      ; check start
        sty $d2
detect_t2sd_sigloop1
        ldy $d2
        ldx #0
detect_t2sd_sigloop2
        lda detect_t2sd_signature,x
        beq detect_t2sd_detected
        cmp ($d0),y
        bne detect_t2sd_signext
        iny
        inx
        bne detect_t2sd_sigloop2
detect_t2sd_detected
        ;; TCBM2SD detected
        lda #1
        sta tcbm2sd_flag
        rts

detect_t2sd_signext     ; next character
        inc $d2
        lda $d2
        cmp #40-7-5
        bne detect_t2sd_sigloop1
        ;; TCBM2SD not detected
        lda #0
        sta tcbm2sd_flag
        rts

detect_t2sd_cmd:
        .text "UI"

detect_t2sd_signature
        .text "TCBM2SD"
        .byte 0
