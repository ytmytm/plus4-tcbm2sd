
DIRS := \
	alpharay \
	giana_sisters \
	petsrescue \
	prince_of_persia \


.PHONY: all clean $(DIRS)

all: $(DIRS)

$(DIRS):
	$(MAKE) -C $@

clean:
	@for dir in $(DIRS); do \
	    $(MAKE) -C $$dir clean; \
	done
