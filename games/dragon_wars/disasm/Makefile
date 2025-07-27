
KICKASS := ../../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := 
EXOMIZERFLAGS := sfx 5888 -t 4 -n

SOURCES := bardstale3-tcbmfast.asm

BOOTDISK := dragon_wars_1.d64

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d64)

.PHONY: all clean test love disasm

#all: $(BINS) $(D64S)
#	zip ../../Bards_Tale_III-tcbmfast.zip bardstale3-tcbmfast.d64 Bard\*disk\ [234].d64

boot.raw:
	c1541 -attach $(BOOTDISK) -read dragon\ wars boot.raw -bread 1802.bin 18 2 -bread 1808.bin 18 8

boot0.bin boot1.bin boot2.bin boot3.bin: boot.raw
	# 0265 loader (autostart)
	dd if=boot.raw of=boot0.bin bs=1 skip=2 count=195
	# 1800 startup
	dd if=boot.raw of=boot1.bin bs=1 skip=197 count=251
	# 18FB -> C000-C400 startup
	dd if=boot.raw of=boot2.bin bs=1 skip=448 count=796
	# 1C17 (C31C) -> 5600-5700 sectorload # boot1:1047
	dd if=boot.raw of=boot3.bin bs=1 skip=1244
	# remaining files in bins/ extracted manually from YaPe

disasm: boot0.bin boot1.bin boot2.bin boot3.bin boot0.info boot1.info boot2.info boot3.info
	$(DA65) -i boot0.info
	$(DA65) -i boot1.info
	$(DA65) -i boot2.info
	$(DA65) -i boot3.info
	cd bins && $(DA65) -i titlepic1000.info && $(DA65) -i subs0500.info && $(DA65) -i util1000.info

%.prg: %.asm boot0.bin
	$(JAVA) -jar $(KICKASS) $(KICKASSFLAGS) $< -o $@

%.d64: %.prg
	$(EXOMIZER) $(EXOMIZERFLAGS) -o $*-exo.prg $<
	cp bardstale3-tcbm-tpl.d64 $@
	c1541 -attach $@ 8 -delete bardstale3-tcbm -write $*-exo.prg bardstale3-tcbm

clean:
	-rm -f $(BINS) $(D64S) $(SOURCES:.asm=-exo.prg) *.sym

test: bardstale3-tcbmfast.d64
	$(XPLUS4) $(XPLUS4FLAGS) $<

# a must!
love:
	@echo "Not war, eh?"
