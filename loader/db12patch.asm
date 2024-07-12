
// Patch directory_browser_v1_2.prg for fastload protocol for tcbm2sd
// by Maciej 'YTM/Elysium' Witkowiak <ytm@elysium.pl>, 2024-07-12

.segmentdef Combined  [outPrg="db12b.prg", segments="Base,Patch1", allowOverlap]

.segment Base [start = $1001, max=$3000]
	.var data = LoadBinary("directory_browser_v1_2.prg", BF_C64FILE)
	.fill data.getSize(), data.get(i)

///////////////////////////////////////////

.var LORAM = $05F5

.segment Patch1 []
		.pc = $25e7 "Patch loader"

        lda #<LOADER_0600                       // source
        sta $D8
        lda #>LOADER_0600
        sta $D9
        lda #<LORAM                             // target
        sta $DA
        lda #>LORAM
        sta $DB
        ldx #<(LOADER_0600_END-LOADER_0600)     // length
        ldy #>(LOADER_0600_END-LOADER_0600)
        jsr $25c0                               // copying routine (just before this one)
        jmp LORAM                               // load and run

// 2601
LOADER_0600:
.pseudopc LORAM {
        sei
        sta $ff3e
        cli
        lda $d5
        cmp #$00
        bne L0607
        ldy #$01
        lda #$00
        jmp L060B
L0607:  ldy #$00
        lda #$01
L060B:  sta $da
        lda #$01
        ldx $d0
        jsr $ffba
        lda $d1
        ldx $d2
        ldy $d3
        jsr $ffbd
        lda #$00
        jsr $ff90
        lda #$00
        ldx $2b
        ldy $2c                                 // all this stuff doesn't have to be in loram
        jsr $ffd5
        stx $2d
        sty $2e
        jsr $d888
        lda #$ee
        sta $ff19
        lda #$f1
        sta $ff15
        lda #$c4
        sta $ff12
        lda #$d0
        sta $ff13
        lda #$90
        jsr $ffd2
        jsr $d88b
        lda #$00
        sta $ef
        lda $da
        beq L0659
        jsr $8818
L0659:  jsr $8bbe
        lda $d4
        cmp #$00
        bne L0665
        jmp $8bea
L0665:  jmp $867e
}
LOADER_0600_END:
