
;; get a single byte from TCBM2SD using fast protocol
;; alternate between two dav/ack line states

load_directory_getbyte
    lda fast_oddeven
    bne _even
        eor #$01            ; flip status
        sta fast_oddeven
        lda aFEF2           ; wait for ACK low
        bmi *-3
        lda aFEF0           ; data
        sta fast_temp
        lda aFEF1           ; status
        and #%00000011
        sta ST
        lda #$40            ; DAV=1 confirm
_end
        sta aFEF2
        lda fast_temp
        rts

_even
        eor #$01            ; flip status
        sta fast_oddeven
        lda aFEF2           ; wait for ACK high
        bpl *-3
        lda aFEF0           ; data
        sta fast_temp
        lda aFEF1           ; status
        and #%00000011
        sta ST
        lda #$00            ; DAV=0 confirm
        beq _end
