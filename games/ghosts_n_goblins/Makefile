
KICKASS := ../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := -warp
EXOMIZERFLAGS := sfx 4112 -t 4 -n

SOURCES := ghosts_n_goblins-tcbm.asm

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d64)

.PHONY: all clean test love disasm

all: $(BINS) $(D64S)

ghosts.prg: ghosts_n_goblins_arcade_version.d64
	c1541 -attach ghosts_n_goblins_arcade_version.d64 8 -read ghosts
	$(EXOMIZER) desfx -o $@ ghosts
	rm ghosts

%.prg: %.asm ghosts_n_goblins-tcbm.prg
	$(JAVA) -jar $(KICKASS) $(KICKASSFLAGS) $< -o $@

%.d64: %.prg
	cp ghosts_n_goblins_arcade_version.d64 $@
	$(EXOMIZER) $(EXOMIZERFLAGS) -o $*-exo.prg $<
	c1541 -attach $@ 8 -delete ghosts -write $*-exo.prg ghosts
	cp $@ ../

clean:
	-rm -f $(BINS) $(D64S) $(SOURCES:.asm=-exo.prg) *.sym

test: ghosts_n_goblins-tcbm.d64
	$(XPLUS4) $(XPLUS4FLAGS) ghosts_n_goblins-tcbm.d64

# a must!
love:
	@echo "Not war, eh?"
