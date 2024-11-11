
KICKASS := ../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := 
EXOMIZERFLAGS := sfx 4112 -t 4 -n

SOURCES := lemmings-tcbm.asm lemmings-tcbmfast.asm

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d64)

.PHONY: all clean test love disasm

all: $(BINS) $(D64S)

boot.bin: lemmings.d64
	c1541 -attach lemmings.d64 -read loader loader.bin
	echo "decompress"
	$(EXOMIZER) desfx loader.bin -o boot.bin

disasm: boot.bin boot.info
	$(DA65) -i boot.info

%.prg: %.asm boot.bin
	$(JAVA) -jar $(KICKASS) $(KICKASSFLAGS) $< -o $@

%.d64: %.prg
	cp lemmings.d64 $@
	$(EXOMIZER) $(EXOMIZERFLAGS) -o $*-exo.prg $<
	c1541 -attach $@ 8 -delete loader -write $*-exo.prg loader
	cp $@ ../

clean:
	-rm -f $(BINS) $(D64S) $(SOURCES:.asm=-exo.prg) *.sym loader.bin boot.bin

test: lemmings-tcbm.d64
	$(XPLUS4) $(XPLUS4FLAGS) lemmings-tcbm.d64

# a must!
love:
	@echo "Not war, eh?"
