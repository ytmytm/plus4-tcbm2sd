
KICKASS := ../../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := 
EXOMIZERFLAGS := sfx 5888 -t 4 -n

SOURCES := bardstale3-tcbmfast.asm

BOOTDISK := Bard\'s\ Tale\ III\ -\ Csory\ version\ -\ disk\ 1.d64

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d64)

.PHONY: all clean test love disasm

all: $(BINS) $(D64S)
	zip ../../Bards_Tale_III-tcbmfast.zip bardstale3-tcbmfast.d64 Bard\*disk\ [234].d64

boot.raw:
	c1541 -attach $(BOOTDISK) -read b\* boot.raw -bread 0113.bin 1 13 -bread 0112.bin 1 12

boot0.bin boot1.bin: boot.raw
	dd if=boot.raw of=boot0.bin bs=1 count=197
	dd if=boot.raw of=boot1.bin bs=1 skip=197
	dd if=boot.raw of=boot2.bin bs=1 skip=1310 count=1024

disasm: boot0.bin boot1.bin boot2.bin boot0.info boot1.info boot2.info
	$(DA65) -i boot0.info
	$(DA65) -i boot1.info
	$(DA65) -i boot2.info

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
