
KICKASS := ../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := 
EXOMIZERFLAGS := sfx 4112 -t 4 -n

SOURCES := turbo_outrun-tcbm.asm turbo_outrun-tcbmfast.asm

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d64)

.PHONY: all clean test love disasm

all: $(BINS) $(D64S)

boot.bin: turbo_outrun.d64
	c1541 -attach turbo_outrun.d64 -read turbo\ outrun turbo.bin
	echo "decompress"
	$(EXOMIZER) desfx turbo.bin -o boot.bin

disasm: boot.bin boot.info
	$(DA65) -i boot.info

%.prg: %.asm boot.bin
	$(JAVA) -jar $(KICKASS) $(KICKASSFLAGS) $< -o $@

%.d64: %.prg
	cp turbo_outrun.d64 $@
	$(EXOMIZER) $(EXOMIZERFLAGS) -o $*-exo.prg $<
	c1541 -attach $@ 8 -delete turbo\ outrun -write $*-exo.prg turbo\ outrun
	cp $@ ../

clean:
	-rm -f $(BINS) $(D64S) $(SOURCES:.asm=-exo.prg) *.sym turbo.bin boot.bin 

test: turbo_outrun-tcbm.d64
	$(XPLUS4) $(XPLUS4FLAGS) turbo_outrun-tcbm.d64

# a must!
love:
	@echo "Not war, eh?"
