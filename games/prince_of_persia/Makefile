# need bash for echo -ne
SHELL=/bin/bash
KICKASS := ../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := 
EXOMIZERFLAGS := sfx 4112 -t 4 -n

SOURCES := prince-tcbm.asm prince-tcbmfast.asm

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d81)

.PHONY: all clean test love disasm files

all: $(BINS) $(D64S)

files: prince_of_persia.d64 prince_of_persia_2.d64
	rm -rf files
	mkdir files
	cd files && c1541 -attach ../prince_of_persia.d64 -extract && c1541 -attach ../prince_of_persia_2.d64 -extract

boot.bin: files
	echo "decompress"
	$(EXOMIZER) desfx files/prince -o prince.bin
#	echo "extract intro"
#	(echo -ne '\xfb\x0f\xa9\x00\x8d\x3f\xff'; dd if=prince.bin bs=1 skip=2 count=16643) > prince.intro
	echo "extract game"
	(echo -ne '\x01\x10'; dd if=prince.bin skip=16643 bs=1) > princeraw.bin
	echo "decompress"
	$(EXOMIZER) desfx princeraw.bin -o boot.bin

disasm: boot.bin boot.info
	$(DA65) -i boot.info

%.prg: %.asm boot.bin
	$(JAVA) -jar $(KICKASS) $(KICKASSFLAGS) $< -o $@

%.d81: %.prg
	$(EXOMIZER) $(EXOMIZERFLAGS) -o $*-exo.prg $<
	c1541 -format prince,pp d81 $@ -write $*-exo.prg boot \
		$(shell find files/ -type f -name '??' -exec basename {} \; | sort | xargs -I{} echo -write files/{} {})
	cp $@ ../

clean:
	-rm -f $(BINS) $(D64S) $(SOURCES:.asm=-exo.prg) *.sym prince.bin princeraw.bin boot.bin files/* prince-tcbm.d64 prince-tcbmfast.d64

test: prince-tcbm.d81
	echo "incomplete test version for emulators"
	c1541 -format prince,pp d64 prince-tcbm.d64 -write prince-tcbm-exo.prg boot \
		-write files/ci ci \
		-write files/pp pp
	$(XPLUS4) $(XPLUS4FLAGS) prince-tcbm.d64

# a must!
love:
	@echo "Not war, eh?"
