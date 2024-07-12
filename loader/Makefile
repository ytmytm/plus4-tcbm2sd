
KICKASS := tools/KickAss.jar
JAVA := java
XPLUS4 := xplus4

KICKASSLAGS := 

SOURCES := db12patch.asm

BINS := db12b.prg

.PHONY: all clean test love

$(BINS): $(SOURCES)
	$(JAVA) -jar $(KICKASS) $(SOURCES)

all: $(BINS)

clean:
	-rm $(BINS)

test:
	$(XPLUS4) $(BINS)

# a must!
love:
	@echo "Not war, eh?"

