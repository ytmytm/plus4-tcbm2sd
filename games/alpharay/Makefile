
KICKASS := ../../loader/tools/KickAss.jar
JAVA := java
EXOMIZER := exomizer
XPLUS4 := xplus4
DA65 := da65

KICKASSLAGS :=
XPLUS4FLAGS := 
EXOMIZERFLAGS := sfx 4112 -t 4 -n

SOURCES := alpharay-tcbm.asm

BINS := $(SOURCES:.asm=.prg)
D64S := $(SOURCES:.asm=.d81)

.PHONY: all clean test love disasm

all: $(BINS) $(D64S)

boot.bin: alpharay_iec.d81
	c1541 -attach alpharay_iec.d81 8 -read \!\!boot\!\! boot.raw
	$(EXOMIZER) desfx boot.raw -o boot.bin
	rm boot.raw

disasm: boot.bin boot.info
	$(DA65) -i boot.info

%.prg: %.asm boot.bin
	$(JAVA) -jar $(KICKASS) $(KICKASSFLAGS) $< -o $@

%.d81: %.prg
	$(EXOMIZER) $(EXOMIZERFLAGS) -o $*-exo.prg $<
	cp alpharay_iec.d81 $@
	c1541 -attach $@ 8 -delete \!\!boot\!\! -write $*-exo.prg boot
	cp $@ ../
#	echo "incomplete test version for emulators"
#	c1541 -format alpharay,ar d64 alpharay-tcbm.d64 -write $*-exo.prg boot \
#		-write files/cj cj \
#		-write files/ap ap \
#		-write files/ba ba \
#		-write files/bh bh \
#		-write files/ce ce \
#		-write files/bf bf \
#		-write files/cf cf \
#		-write files/be be \
#		-write files/ch ch \


clean:
	-rm -f $(BINS) $(D64S) $(SOURCES:.asm=-exo.prg) *.sym boot.bin

test: alpharay-tcbm.d81
	$(XPLUS4) $(XPLUS4FLAGS) alpharay-tcbm.d64

# a must!
love:
	@echo "Not war, eh?"
