# Variables
AS=ca65
LD=ld65
ASMFLAGS=-t none -I inc

# Define a list of targets
TARGETS=drv1551.prg geosboot.prg

# Default rule to build all targets
all: geostcbm.d64

%.o: %.s
	$(AS) $(ASMFLAGS) $< -o $@

%.prg: %.cfg %.o
	$(LD) -C $< -o $@ -m $*.map $*.o

# GEOS-TCBM disk
geos.prg: $(TARGETS) bin/geoskernal.8c00-8fff.prg bin/geoskernal.bf40-fcff.prg
	exomizer sfx 0x900 -s "lda #0 sta 65286" -t 4 -o "geos.prg" "geosboot.prg" "bin/geoskernal.8c00-8fff.prg" "drv1551.prg" "bin/geoskernal.bf40-fcff.prg"

geostcbm.d64: geos.prg bin/geos_3_53-clean.d64
	cp bin/geos_3_53-clean.d64 geostcbm.d64
	c1541 -attach geostcbm.d64 8 -write geos.prg 'geos' -write geosboot.prg 'geos boot'

# Clean rule to remove generated files
clean:
	rm -f $(TARGETS) *.o *.map geos.prg geostcbm.d64

# Declare these targets as phony (not file names)
.PHONY: all clean
