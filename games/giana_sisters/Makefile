
KICKASS := ../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := -warp
EXOMIZERFLAGS := sfx 4112 -t 4 -n

SOURCES := giana_sisters-tcbm.asm giana_sisters-tcbmfast.asm

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d64)

.PHONY: all clean test love disasm

all: $(BINS) $(D64S)

giana_sisters.prg: giana_sisters.d64
	c1541 -attach giana_sisters.d64 8 -read giana\ sisters
	$(EXOMIZER) desfx -o $@ giana\ sisters
	rm giana\ sisters

disasm: giana_sisters.prg giana_sisters.info
	$(DA65) -i giana_sisters.info

%.prg: %.asm giana_sisters.prg
	$(JAVA) -jar $(KICKASS) $(KICKASSFLAGS) $< -o $@

%.d64: %.prg
	cp giana_sisters.d64 $@
	$(EXOMIZER) $(EXOMIZERFLAGS) -o $*-exo.prg $<
	c1541 -attach $@ 8 -delete giana\ sisters -write $*-exo.prg giana\ sisters
	cp $@ ../

clean:
	-rm -f $(BINS) $(D64S) $(SOURCES:.asm=-exo.prg) *.sym

test: giana_sisters-tcbm.d64
	$(XPLUS4) $(XPLUS4FLAGS) giana_sisters-tcbm.d64

# a must!
love:
	@echo "Not war, eh?"
