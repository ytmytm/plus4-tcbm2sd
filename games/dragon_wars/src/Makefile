
KICKASS := ../../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := 
EXOMIZERFLAGS := sfx 21504 -t 4 -x1 -s"ldx \#0 stx 65286" -f"sta 65342"

SOURCES := dragon_wars-tcbmfast.asm

BOOTDISK := dragon_wars_1.d64

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d64)

.PHONY: all clean test love disasm

all: $(BINS) $(D64S)
	zip ../../Dragon_Wars-tcbmfast.zip dragon_wars-tcbmfast.d64 dragon_wars_[2345].d64

boot.raw:
	c1541 -attach $(BOOTDISK) -read dragon\ wars boot.raw -bread 1802.bin 18 2 -bread 1808.bin 18 8

boot2.bin boot3.bin: boot.raw
	# 0265 loader (autostart)
	#dd if=boot.raw of=boot0.bin bs=1 skip=2 count=195
	# 1800 startup
	#dd if=boot.raw of=boot1.bin bs=1 skip=197 count=251
	# 18FB -> C000-C400 startup
	dd if=boot.raw of=boot2.bin bs=1 skip=448 count=796
	# 1C17 (C31C) -> 5600-5700 sectorload # boot1:1047
	dd if=boot.raw of=boot3.bin bs=1 skip=1244
	# remaining files in bins/ extracted manually from YaPe

disasm: boot2.bin boot3.bin boot2.info boot3.info
	$(DA65) -i boot2.info
	$(DA65) -i boot3.info

%.prg: %.asm
	$(JAVA) -jar $(KICKASS) $(KICKASSFLAGS) $< -o $@

%.d64: %.prg
	$(EXOMIZER) $(EXOMIZERFLAGS) -o $*-exo.prg $<
	cp dragon_wars_1_freeblocks.d64 $@
	c1541 -attach $@ 8 -write $*-exo.prg dragon\ wars

clean:
	-rm -f $(BINS) $(D64S) $(SOURCES:.asm=-exo.prg) *.sym

test: dragon_wars-tcbmfast.d64
	$(XPLUS4) $(XPLUS4FLAGS) $<

# a must!
love:
	@echo "Not war, eh?"
