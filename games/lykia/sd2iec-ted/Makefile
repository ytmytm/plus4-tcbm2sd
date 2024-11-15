# need bash for echo -ne
SHELL=/bin/bash
KICKASS := ../../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := 
EXOMIZERFLAGS := sfx 4112 -t 4 -n

SOURCES := lykia_prologue-tcbm.asm

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d81)

.PHONY: all clean test love disasm files

all: $(BINS) $(D64S)

files: lykia_prologue.d81 lykia_disk1.d81 lykia_disk2.d81 lykia_disk3.d81 lykia_disk4.d81
	rm -rf files
	mkdir -p files/{prologue,disk1,disk2,disk3,disk4}
	cd files/prologue && c1541 -attach ../../lykia_prologue.d81 -extract && cd ../..
	cd files/disk1 && c1541 -attach ../../lykia_disk1.d81 -extract && cd ../..
	cd files/disk2 && c1541 -attach ../../lykia_disk2.d81 -extract && cd ../..
	cd files/disk3 && c1541 -attach ../../lykia_disk3.d81 -extract && cd ../..
	cd files/disk4 && c1541 -attach ../../lykia_disk4.d81 -extract && cd ../..

boot0.bin: lykia_prologue.d81
	c1541 -attach lykia_prologue.d81 8 -read \!\!entrance\!\! boot0
	$(EXOMIZER) desfx boot0 -o boot0.bin

boot1.bin: lykia_disk1.d81
	c1541 -attach lykia_disk1.d81 8 -read \!\!entrance\!\! boot1
	$(EXOMIZER) desfx boot1 -o boot1.bin

boot2.bin: lykia_disk2.d81
	c1541 -attach lykia_disk2.d81 8 -read \!\!entrance\!\! boot2
	$(EXOMIZER) desfx boot2 -o boot2.bin

boot3.bin: lykia_disk3.d81
	c1541 -attach lykia_disk3.d81 8 -read \!\!entrance\!\! boot3
	$(EXOMIZER) desfx boot3 -o boot3.bin

boot4.bin: lykia_disk4.d81
	c1541 -attach lykia_disk4.d81 8 -read \!\!entrance\!\! boot4
	$(EXOMIZER) desfx boot4 -o boot4.bin

disasm: boot0.bin boot1.bin boot2.bin boot3.bin boot4.bin boot.info
	mv boot0.bin boot.bin && $(DA65) -i boot.info && mv boot.s boot0.s
	mv boot1.bin boot.bin && $(DA65) -i boot.info && mv boot.s boot1.s
	mv boot2.bin boot.bin && $(DA65) -i boot.info && mv boot.s boot2.s
	mv boot3.bin boot.bin && $(DA65) -i boot.info && mv boot.s boot3.s
	mv boot4.bin boot.bin && $(DA65) -i boot.info && mv boot.s boot4.s

%.prg: %.asm boot0.bin boot1.bin boot2.bin boot3.bin boot4.bin
	$(JAVA) -jar $(KICKASS) $(KICKASSFLAGS) $< -o $@

%.d81: %.prg
	cp $(shell echo $@ | sed 's/-tcbm//') $@
	$(EXOMIZER) $(EXOMIZERFLAGS) -o $*-exo.prg $<
	c1541 -attach $@ 8 -delete \!\!entrance\!\! -validate -write $*-exo.prg \!\!entrance\!\!
#	cp $@ ../

clean:
	-rm -f $(BINS) $(D64S) $(SOURCES:.asm=-exo.prg) *.sym boot[0-4].bin

test: lykia_prologue-tcbm.d81
	echo "incomplete test version for emulators"
	c1541 -format lykia,ly d64 lykia_prologue-tcbm.d64 -write lykia_prologue-tcbm-exo.prg \!\!entrance\!\! \
		-write files/prologue/ag ag \
		-write files/prologue/ah ah \
		-write files/prologue/ai ai \
		-write files/prologue/aj aj \
		-write files/prologue/ak ak \
		-write files/prologue/al al \
		-write files/prologue/am am \
		-write files/prologue/an an \
		-write files/prologue/ao ao \
		-write files/prologue/ap ap \
		-write files/prologue/cg cg \
		-write files/prologue/ch ch \
		-write files/prologue/ci ci \
		-write files/prologue/cj cj \
		-write files/prologue/cm cm \
		-write files/prologue/cn cn \
		-write files/prologue/co co \
		-write files/prologue/cp cp \
		-write files/prologue/ad ad \
		-write files/prologue/ce ce \
		-write files/prologue/cf cf \
		-write files/prologue/bv bv \
		-write files/prologue/bs bs \
		-write files/prologue/br br \
		-write files/prologue/bu bu \
		-write files/prologue/bt bt \
		-write files/prologue/af af \
		-write files/prologue/bi bi \
		-write files/prologue/cw cw \
		-write files/prologue/av av \
		-write files/prologue/ay ay \
		-write files/prologue/ax ax \
		-write files/prologue/a_ a_ \
		-write files/prologue/a. a. \
		-write files/prologue/a[ a[ \
		-write files/prologue/a] a] \
		-write files/prologue/a\\ a\\ \
		-write files/prologue/a^ a^
	$(XPLUS4) $(XPLUS4FLAGS) lykia_prologue-tcbm.d64

# a must!
love:
	@echo "Not war, eh?"
