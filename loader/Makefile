
KICKASS := tools/KickAss.jar
JAVA := java
XPLUS4 := xplus4

KICKASSLAGS := 

SOURCES := db12patch.asm

BINS := db12b.prg

HEADER := ../tcbm2sd_arduino/tcbm2sd/db12b.h

.PHONY: all clean test love

all: $(BINS) $(HEADER)

$(BINS): $(SOURCES)
	$(JAVA) -jar $(KICKASS) $(SOURCES)

$(HEADER): $(BINS)
	xxd -i $(BINS) $(HEADER)

clean:
	-rm $(BINS) $(HEADER)

test:
	$(XPLUS4) $(BINS)

# a must!
love:
	@echo "Not war, eh?"

