
; sample code to show how to load '$' (or any other file) with fastload protocol
; reading byte by byte, with minimal changes to the code that uses standard Kernal functions
; like OPEN/CHRIN/CLOSE
; by Maciej 'YTM/Elysium' Witkowiak <ytm@elysium.pl>, 2024-07-27

; tcb2m2sd detection code in t2s-detect.asm

SETLFS	= $ffba
SETNAM	= $ffbd
OPEN	= $ffc0
CHKIN	= $ffc6
CHRIN	= $ffcf
CLRCHN	= $ffcc
CLOSE	= $ffc3
READST	= $ffb7

; KERNAL routines without jumptable
ICLRCHN = $EF0C             ;ICLRCHN $FFCC
ISENDSA = $F005             ;SEND SA ; before TALK? and it's not TLKSA
ITALK = $EDFA               ;TALK
ITLKSA = $EE1A              ;TKSA

ST	= $90

; IO

aFEF0 = $FEF0              ; portA
aFEF1 = $FEF1              ; portB 1/0
aFEF2 = $FEF2              ; portC 7/6
aFEF3 = $FEF3              ; portA DDR

; tcbm2sd fast protocol
fast_oddeven    = $6a    ; =0 - wait for ACK low, set DAV high ; <>0 wait for ACK high, set DAV low
fast_temp       = $6b    ; temp storage
tcbm2sd_flag    = $6c    ; <>0 = TCBM2SD, 0=any other drive type (IEC or 1551)
vchrin_store    = $6d    ; temporary storage for CHRIN vector

VCHRIN  = $0322         ; CHRIN ($FFCF) vector

load_directory	
    sta ROM_SELECT
	cli
	
	lda #$01
	ldy #$00
	jsr SETLFS
	
	lda #$01
	ldx #<dirname
	ldy #>dirname
	jsr SETNAM

    ; TCBM2SD fastload or Kernal standard?
    lda tcbm2sd_flag
    beq load_directory_standard

    ; setup
    jsr CLRCHN

    lda #$60            ; SA for OPEN
    sta RAM_SA
    jsr ISENDSA         ; send filename with SA=$60

    lda CURRENT_DEVICE_NUMBER
    jsr ITALK
    lda #$70            ; fastload indicator - on channel 16 (treated as channel 0 = LOAD)
    jsr ITLKSA

    ; setup ports
    lda #0
    sta aFEF3           ; port A DDR = input first
    sta aFEF0           ; port A (to clear pullups?)
    sta aFEF2           ; DAV=0 - WE ARE READY
    sta fast_oddeven    ; =0 - wait for ACK low, set DAV high ; <>0 wait for ACK high, set DAV low

    ; our custom CHRIN vector
    lda VCHRIN
    sta vchrin_store
    lda VCHRIN+1
    sta vchrin_store+1
    lda #<load_directory_getbyte
    sta VCHRIN
    lda #>load_directory_getbyte
    sta VCHRIN+1
    jmp load_directory_common

load_directory_standard

	jsr OPEN
	
	lda ST
	cmp #$80
	bne _cont
	jmp load_directory_close
	
_cont	ldx #$01
	jsr CHKIN
	
load_directory_common

;	... common processing of incoming data stream
;	... all data read with CHRIN Kernal call
;

;---------------------------------------

load_directory_close
    lda tcbm2sd_flag
    beq load_directory_close_standard

    lda #$40                ;$40 = ACK (bit 6) to 1
    sta aFEF2
    sta ST                  ; clear status too

    ; restore standard CHRIN vector
    lda vchrin_store
    sta VCHRIN
    lda vchrin_store+1
    sta VCHRIN+1

    lda #$ff                ;port A to output (a bit delayed after ACK)
    sta aFEF3
    jmp load_directory_close_common

load_directory_close_standard
    jsr CLRCHN

    lda #$01
    jsr CLOSE

load_directory_close_common
    rts

;---------------------------------------

dirname	.text "$"

;---------------------------------------

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
